# Self-Healing Infrastructure

**Objective**
Automatically detect downtime of a core service (NGINX) and recover it without manual intervention, demonstrating automated remediation in a cloud-native DevOps environment.

**Tools & Technologies Used**
Amazon Linux 2023 (on AWS EC2)
Docker & Docker Compose: Containerize NGINX, Prometheus, Alertmanager, and Blackbox Exporter
Prometheus: Monitors service health via Blackbox HTTP probes
Alertmanager: Receives and manages alerts from Prometheus
Ansible: Automates service remediation (restart)
Shell scripting: Polls Alertmanager for active alerts and triggers Ansible playbook

**Architecture Implemented**
NGINX web server is deployed as a Docker container.
Prometheus scrapes NGINX health using Blackbox Exporter (i.e., basic HTTP probe).
Alertmanager is configured to receive alerts from Prometheus when NGINX fails.
A monitoring script (monitor_alerts.sh) polls Alertmanager for active "NginxDown" alerts.
When an alert is found, the script automatically triggers an Ansible playbook that restarts NGINX (if stopped or failed).
The whole solution is version-controlled in GitHub, and tested end-to-end with actual failure and recovery.

**Key Steps Completed**
Deployed AWS EC2 with Amazon Linux, installed Docker, Ansible, and Git.
Cloned and organized a GitHub repository with clear folder structure for configs and automation.
Set up Docker Compose to deploy NGINX, Prometheus, Alertmanager, and Blackbox Exporter on the instance.
Configured Prometheus with Blackbox to probe NGINX HTTP health, not /metrics.
Created and validated alert rules to fire when NGINX is unreachable.
Connected Prometheus and Alertmanager so alerts appear and propagate.
Developed and ran a monitoring script to poll Alertmanager and run the Ansible playbook for self-healing.
Wrote the Ansible playbook to restart (or re-create) the NGINX Docker container as soon as alerts trigger.
Tested the full system by stopping NGINX and observing automatic recovery, confirmed by logs, docker ps, and monitoring dashboards.

**Result/Outcome**
The system detects when NGINX is down in seconds.
An alert fires, is routed to Alertmanager, and triggers an automated response.
Ansible playbook restores NGINX with zero manual effort.
All project components, scripts, and configs are tracked in GitHub for repeatability and team sharing.
You now have a production-grade pattern for self-healing infrastructure — ideal for DevOps, SRE, and cloud-native automation learning or demonstrations.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**Project Overview**
>>Architecture: Blackbox/Node Exporter → Prometheus → Alertmanager → Webhook Script → Ansible → Restart Service (NGINX)
>>Goal: Prometheus detects failures → Alertmanager triggers webhook → Webhook triggers Ansible automation → The EC2 instance self-heals (service restarts automatically)

#create aws environment
launch amazon linux ec2 instance and allow inbound ports in security groups for 22 (SSH), 9090 (Prometheus), 9093 (Alertmanager), and 8080/8082 (NGINX)

>>Run all commands from /home/ec2-user/folder-name

#install dependencies
sudo dnf update -y
sudo dnf install -y git jq python3-pip

sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker

(Docker Compose v2 setup)
sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

sudo pip3 install ansible
ansible --version

>>Configure Prometheus in prometheus/prometheus.yml and prometheus/alerts.yml
>>Configure Alertmanager in alertmanager/config.yml
>>Write Ansible Playbook in ansible/playbook.yml
>>Monitoring and Auto-Heal Script in scripts/monitor_alerts.sh & chmod +x scripts/monitor_alerts.sh (Make it executable)
>>Docker Compose File in docker-compose.yml & run → sudo docker compose up -d
>>requirements.txt (For Python and Ansible dependencies)
>>Run the Self-Healing Monitor → nohup bash scripts/monitor_alerts.sh & (runs in background)
>>Check Logs for Recovery Evidence View monitor script output → cat nohup.out / to See script logs: tail -f nohup.out

#Verify services:
Prometheus: http://<EC2-IP>:9090 (Status > Targets)
Alertmanager: http://<EC2-IP>:9093
NGINX: http://<EC2-IP>:8082

#Test the System by Stopping the NGINX container: docker stop nginx and run docker ps (verify nginx is down)
Within 30 seconds: Prometheus detects NGINX is down → Alertmanager sends a webhook → The script runs Ansible → Docker restarts NGINX automatically
>>Check: docker ps (The NGINX container will be running again — confirming the self-healing is successful)
