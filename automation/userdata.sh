#!/bin/bash -xe",

apt-get update
# create an asible user and give it sudo ALL access",
useradd -m ansible
echo 'ansible ALL = NOPASSWD : ALL' >> /etc/sudoers

su ansible -s /bin/bash -lc 'echo "alias python=python3" >> /home/ansible/.profile'
su ansible -s /bin/bash -lc 'echo "export PATH=$PATH:/usr/local/bin:/home/ansible/.local/bin" >> /home/ansible/.profile'


# set up SSH access to the system for ansible",
su ansible -s /bin/bash -lc 'mkdir /home/ansible/.ssh'
chmod 700 /home/ansible/.ssh
su ansible -s /bin/bash -lc 'echo ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwKOJjZz6893D9MnWgtJsKo4yeoGS7yEhEZuZdWVYZHK407MTR7FenzSdYCnBCaH5ul2AlVsos2fNUL52ewbJSjiCJkeOAH0d1XQlCU/PdOCSfI/vUwxPyU4nL1apEtZSiz9/KEh3w9F/vVXOvSHdRcX3NZxYCa8ffq0PIyUGL2affNbaHfJwSainnVhEekni83X8HiQs+XYmmltBpXTBoFtHrdITjB33rnRRzb3G9r0Qh8HUsKKV81WCkQvLTVTt6gWtLFsh+6ExL6VZGvkh3JkvS9Hg/GugAU4YYoGQhsTUnHGYKD/f/xvLhaOxh1EDL9gfv3FRtQZJCYZ7MZi8n ansible@involta'' > /home/ansible/.ssh/authorized_keys'
chmod 600 /home/ansible/.ssh/authorized_keys

# install ansible binaries",
su ansible -s /bin/bash -lc 'curl -O https://bootstrap.pypa.io/get-pip.py'
su ansible -s /bin/bash -lc 'python3 get-pip.py'
su ansible -s /bin/bash -lc 'pip3 install ansible'
su ansible -s /bin/bash -lc 'pip3 install boto3'

apt-get install -y awscli

# Get the playbook for this particular server from S3",
su ansible -s /bin/bash -lc 'aws s3 sync s3://involta-sandbox-k8s/ /home/ansible/'

# run the playbook
su ansible -s /bin/bash -lc 'ansible-playbook --connection=local --extra-vars \"abc=123\" --inventory 127.0.0.1, /home/ansible/automation/master/master.yml'


