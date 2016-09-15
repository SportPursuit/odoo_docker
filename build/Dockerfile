FROM debian:wheezy

ADD odoo/templates/sources.list /etc/apt/sources.list
RUN apt-get clean && apt-get update && apt-get install -y \
    build-essential libssl-dev libffi-dev python-dev python-pip sudo vim less rsyslog

RUN pip install ansible
COPY odoo /srv/
COPY repos.tar.gz /srv/
WORKDIR /srv
RUN ansible-playbook tasks/main.yml -i /dev/null -c local --extra-vars "env=cloud"

# Cleanup to reduce image size
RUN rm -rf /srv/*rm
RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["/etc/supervisor/odoo_init"]
