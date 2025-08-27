# Ansible configuration

The provided playbook is essentially plug-and-play, but two things should be noted:

1. Variable `ecr_repository` should be set to the correct ECR repository name (e.g. `team2-accenture/ansibleing` for testing)
2. The playbook expects a properly configured AWS CLI `default` profile - if you see errors such as "Unable to locate credentials", check whether your main (`dev-mfa`) profile is set as default

In case playbook is run multiple times over the same Docker image, there will be multiple tags pointing to the same image on AWS due to matching SHA256 checksum, so it shouldn't matter at all
