# Odoo Docker

## Working
* [x] Gunicorn
* [ ] Connectors (untested, no reason it shouldnt)
* [ ] Crons (untested, no reason it shouldnt)

## Improvements
* Splitting the process in 2 so that we have one ansible playbook that builds a docker base image ( all system packages installed ) and the other for building releases.
 * Currently it takes about 5 minutes to do a full build. Most of the time is taken up by install apt packages
* Mounting /var/log/odoo into the container so the logs get written onto the host filesystem and we can continue to use logstash, logrotate etc


## Setup
1. Clone all the odoo repos into one directory ( odoo, sportpursuit-odoo-modules and mr config; odoo directory needs to be cloned into 'sp_odoo' )
2. checkout ansible branch 'odoo_docker'
3. In the same directory as the parent odoo directory: git clone https://github.com/SportPursuit/odoo_docker.git && cd odoo_docker
4. cd build && sh build_repos.sh
5. Because docker doesnt follow symlinks and we need ansible to provision the image, we need to copy the relevant directories into the build directory
 * cp -R ~/sportpursuit/sportpursuit.ansible/playbooks/roles/app/odoo_docker odoo
 * cp -R ~/sportpursuit/sportpursuit.ansible/playbooks/vars_files/environment odoo/environment
 * cp -R ~/sportpursuit/sportpursuit.ansible/playbooks/vars_files/erp odoo/vars
6. docker build -t odoo:cloud .


## Deploying
###local
1. cd /tmp
2. docker save -o cloud.tar odoo:cloud
3. scp cloud-odoo:/tmp

###remote
1. cd /tmp
2. docker load -i cloud.tar


## Running
* sudo docker run -it -p 8070:8069 -e "ODOO=frontend" odoo:cloud
 * There is a script that we run on startup which chooses which services to run and this is controlled by the ODOO env variable. Can be one of: frontend/backend
 * -p 8070:8069 maps port 8070 on the host to 8069 in the container
