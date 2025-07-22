#cloud-config
hostname: bastion-host
packages:
  - htop
  - tmux
  - awscli
  - telnet

runcmd:
  - yum update -y
  - systemctl enable sshd
  - systemctl start sshd
  - echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
  - echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
  - systemctl restart sshd

