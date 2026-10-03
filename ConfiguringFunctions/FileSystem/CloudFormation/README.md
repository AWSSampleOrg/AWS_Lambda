# EFS on AL2023

https://docs.aws.amazon.com/linux/al2023/ug/efs.html

```sh
sudo dnf -y install amazon-efs-utils
sudo mkdir /mnt/efs # directory to mount
sudo chown ec2-user /mnt/efs
sudo mount -t efs <EFS DNS>:<absolute directory to be mounted on an EFS> /mnt/efs
```
