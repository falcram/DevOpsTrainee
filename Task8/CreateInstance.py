import boto3
import paramiko
from time import sleep
import os
from datetime import datetime, timedelta, UTC

INSTANCE_NAME = 'Python_created_instance'
REGION = 'us-east-1' 
AMI_ID = '' 
INSTANCE_TYPE = 't2.nano'
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
OLD_KEY_NAME = 'Trainee_key'
NEW_KEY_NAME = 'New_Trainee_key'
OLD_KEY_FILE_PATH=os.path.join(SCRIPT_DIR,f'{OLD_KEY_NAME}.pem')
NEW_KEY_FILE_PATH=os.path.join(SCRIPT_DIR,f'{NEW_KEY_NAME}.pem')
SECURITY_GROUP_ID = '' 
SUBNET_ID = ''

ec2 = boto3.client('ec2', region_name=REGION)
ec2_resource = boto3.resource('ec2', region_name=REGION)
cloudwatch = boto3.client('cloudwatch', region_name=REGION)

def create_ec2_instance():
    try:
        response = ec2.run_instances(
            ImageId=AMI_ID,
            InstanceType=INSTANCE_TYPE,
            KeyName=OLD_KEY_NAME,
            SecurityGroupIds=[SECURITY_GROUP_ID],
            SubnetId=SUBNET_ID,
            MinCount=1,
            MaxCount=1,
            TagSpecifications=[
                {
                    'ResourceType': 'instance',
                    'Tags': [
                        {
                            'Key': 'Name',
                            'Value': f'{INSTANCE_NAME}'
                        },
                    ]
                },
            ]
        )
        
        instance_id = response['Instances'][0]['InstanceId']
        print(f"Создан инстанс с ID: {instance_id}")
        
        waiter = ec2.get_waiter('instance_running')
        waiter.wait(InstanceIds=[instance_id])
        
        instance = ec2_resource.Instance(instance_id)
        instance.wait_until_running()
        instance.reload()
        public_ip = instance.public_ip_address
        
        print(f"Инстанс запущен. Public IP: {public_ip}")
        return instance_id, public_ip
    except Exception as e:
        print(f"Ошибка при создании инстанса: {e}")
        return None, None


def get_instance_info(instance_id):
    sleep(10)
    try:
        instance = ec2_resource.Instance(instance_id)
        #print(instance)
        metrics = cloudwatch.get_metric_statistics(
            Namespace='AWS/EC2',
            MetricName='CPUUtilization',
            Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
            StartTime=datetime.now(UTC) - timedelta(minutes=5),
            EndTime=datetime.now(UTC),
            Period=300,
            Statistics=['Average']
        )

        try:
            instance_types = ec2.describe_instance_types(InstanceTypes=[instance.instance_type])
            #print(instance_types)
            instance_specs = instance_types['InstanceTypes'][0]
            vcpus = instance_specs['VCpuInfo']['DefaultVCpus']
            ram_gib = round(instance_specs['MemoryInfo']['SizeInMiB'] / 1024, 1)
        except Exception as e:
            print(f"Ошибка при получении характеристик инстанса: {e}")
            vcpus = 'N/A'
            ram_gib = 'N/A'

        #print(metrics)
        #print(instance.volumes.all())
        volumes_info = []
        total_storage_gb = 0
        for volume in instance.volumes.all():
            #print(volume)
            volumes_info.append({
                'VolumeId': volume.id,
                'SizeGB': volume.size,
                'VolumeType': volume.volume_type,
                'Device': volume.attachments[0]['Device'] if volume.attachments else 'N/A'
            })
            total_storage_gb += volume.size
        for item in volumes_info:
            for key, value in item.items():
                print(f"{key}: {value}")
        info = {
            'InstanceId': instance_id,
            'PublicIP': instance.public_ip_address,
            'PrivateIP': instance.private_ip_address,
            'InstanceType': instance.instance_type,
            'ImageId': instance.image_id,
            'State': instance.state['Name'],
            'LaunchTime': instance.launch_time,
            'VPC': instance.vpc_id,
            'VCPUs': vcpus,
            'RAM': ram_gib,
            'Memory': total_storage_gb,
            'Subnet': instance.subnet_id,
            'SecurityGroups': [sg['GroupName'] for sg in instance.security_groups],
            'CPUUtilization': metrics['Datapoints'][0]['Average'] if metrics['Datapoints'] else 'No data'
        }
        
        print("\nИнформация об инстансе:")
        for key, value in info.items():
            print(f"{key}: {value}")
            
        return info
    except Exception as e:
        print(f"Ошибка при получении информации: {e}")
        return None
    
def change_instance_key(public_ip):
    try:
        print(f"\nМеняем ключ с {OLD_KEY_NAME} на {NEW_KEY_NAME}...")
        
        if not os.path.exists(OLD_KEY_FILE_PATH):
            print(f"Файл ключа {OLD_KEY_NAME}.pem не найден")
            return False
            
        if not os.path.exists(NEW_KEY_FILE_PATH):
            print(f"Файл ключа {NEW_KEY_NAME}.pem не найден")
            return False

        if not os.path.exists(f'{NEW_KEY_FILE_PATH}.pub'):
            os.system(f'ssh-keygen -y -f {NEW_KEY_FILE_PATH} > {NEW_KEY_FILE_PATH}.pub')
        
        with open(f'{NEW_KEY_NAME}.pem.pub', 'r') as f:
            new_key_content = f.read().strip()
        
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        print(f"Подключаемся к {public_ip} с ключом {OLD_KEY_NAME}...")
        ssh.connect(public_ip, username='ubuntu', key_filename=OLD_KEY_FILE_PATH)
        print("Удачное подключение")
        stdin, stdout, stderr = ssh.exec_command(f'echo "{new_key_content}" >> ~/.ssh/authorized_keys')
        if stderr.read():
            print("Ошибка при добавлении нового ключа")
            return False
        
        ssh.close()
        print("Новый ключ добавлен в authorized_keys")
        
        print(f"Проверяем подключение с ключом {NEW_KEY_NAME}...")
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(public_ip, username='ubuntu', key_filename=NEW_KEY_FILE_PATH)
        stdin, stdout, stderr = ssh.exec_command('whoami')
        print(f"Результат команды whoami: {stdout.read().decode().strip()}")
        ssh.close()
        print("Подключение по новому ключу успешно!")
        
        print("Удаляем старый ключ из authorized_keys...")
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(public_ip, username='ubuntu', key_filename=NEW_KEY_FILE_PATH)
        ssh.exec_command(f"sed -i '/{OLD_KEY_NAME}/d' ~/.ssh/authorized_keys")
        ssh.close()
        print("Старый ключ удален")
        
        return True
    except Exception as e:
        print(f"Ошибка при смене ключа: {e}")
        return False

def terminate_instance(instance_id):
    try:
        ec2.terminate_instances(InstanceIds=[instance_id])
        print(f"\nИнстанс {instance_id} помечен на удаление...")
        
        waiter = ec2.get_waiter('instance_terminated')
        waiter.wait(InstanceIds=[instance_id])
        print(f"Инстанс {instance_id} успешно удален")
        return True
    except Exception as e:
        print(f"Ошибка при удалении инстанса: {e}")
        return False

def main():
    instance_id, public_ip = create_ec2_instance()
    if not instance_id:
        return
    
    next = input("Получить информацию об инстансе: 1)ДА 2)НЕТ ")
    if next=="1" or next.upper == "ДА":
        print("="*50,"INSTANCE INFO","="*50,sep="\n")
        instance_info = get_instance_info(instance_id)
        print("="*50)
    
    next = input("Сменить ключ: 1)ДА 2)НЕТ ")
    if next=="1" or next.upper == "ДА":
        if public_ip:
            success = change_instance_key(public_ip)
            if not success:
                print("Не удалось сменить ключ")
   
    
    next = input("Удалить инстанс: 1)ДА 2)НЕТ ")
    if next=="1" or next.upper == "ДА":
        terminate_instance(instance_id)

if __name__ == '__main__':
    main()