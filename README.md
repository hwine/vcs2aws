Ansible playbooks for managing vcs-sync in AWS.

Please see [Github Wiki](https://github.com/ffledgling/vcs2aws/wiki) for info.

Useful links
- AWS AMI: <http://aws.amazon.com/amazon-linux-ami/>
- Ansible + Block Storage: <http://docs.ansible.com/ec2_vol_module.html>
- Ansible + EC2: <http://docs.ansible.com/ec2_module.html>
- Ansible + AWS in general: <http://docs.ansible.com/list_of_cloud_modules.html>
- AWS EBS: <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-add-volume-to-instance.html>

File tree
```
Explanations for non-obvious directories inline.
    .
    ├── config.yml
    ├── files # Directory with files to copy over to remote machines
    │   ├── bash_profile
    │   ├── legacy_crontab
    │   └── ssh_config
    ├── group_vars # variables for ansible scripts
    │   └── all
    ├── legacy_software.playbook.yml
    ├── mapping.playbook.yml
    ├── provision_instances.playbook.yml
    ├── README.md
    └── TODO.mkd

2 directories, 10 files
```
