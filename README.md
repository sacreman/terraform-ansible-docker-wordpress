# Instructions

Copy set-env.sh.example to set-env.sh and update with credentials. You also need terraform-inventory installed.

`./cloud-automation.sh hello-world dev 2 t2.micro`

To remove it all:

`./destroy.sh hello-world dev 2 t2.micro`

# Requirements:

Imagine you’re part of a team that is starting a blogging application that would eventually run on the cloud (let’s
assume it's AWS). The team has decided to use Wordpress to get a simple blog running as a start. Your team of developers
are going to be adding features to the blog. To help them speed their releases to Production, you want to template and
automate building EC2 servers and a suitable AWS infrastructure. You would be running all the different components as
Docker containers.

First, you create Amazon AWS resources in a repeatable manner, using input parameters that will take default value and
non-default values based on configuration file. We would like you to use Terraform in conjunction with Ansible to
achieve this.
While the developers are writing code, you want to allow them to deploy code themselves. They should be able to deploy
the blog app remotely using a simple command.

Here are the specs you want:

- OS: Ubuntu Server 14.04 64-bit
- App Server: Gunicorn/Nginx
- Python: 2.7
- Ansible
- Docker 1.10
- Wordpress official Docker image https://hub.docker.com/_/wordpress/

In developing the solution, use GitHub/BitBucket and try to keep a decent commit history of how you approached the
project.

# Deliverables:

(1) A GitHub repo with the Terraform configuration, Ansible playbook, Dockerfile, shell script(s) etc.
(2) A bash script that will:
- Launch the AWS infrastructure with EC2 servers.
- Begin the configuration management / bootstrapping of the server using Ansible.
- Finally start the blogging app as a Docker process.

DO NOT CHECK THIS INTO GITHUB WITH AWS KEYS.

Remember to use security groups to restrict port access. Prefix all of your AWS resources (when possible) with your
first name (example: firstname-lastname.domain.com).

We should be able to perform the following commands and then interact with a functioning app in the browser.

cloud-automation.sh <app> <environment> <num_servers> <server_size>
ex: cloud-automation.sh hello_world dev 2 t1.micro

This should return the IP address of the load-balanced Wordpress application, after which, we can open a browser to
http://33.33.33.10 and see the blog app come up!