#!/bin/bash
while true; do
  ALERT=$(curl -s http://localhost:9093/api/v2/alerts | jq '.[] | select(.labels.alertname=="NginxDown")')
  if [ ! -z "$ALERT" ]; then
    echo "[ALERT DETECTED] Running Ansible recovery..."
    ansible-playbook /home/ec2-user/Ansible-Prometheus-AlertManager/ansible/playbook.yml
  fi
  sleep 10
done

