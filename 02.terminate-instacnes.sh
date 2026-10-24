#!/bin/bash

aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,Tags[?Key=='Name'].Value|[0],State.Name]" \
  --output table

read -p "Enter Instance ID: " INSTANCE_ID

NAME=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].Tags[?Key=='Name'].Value|[0]" \
  --output text)

read -p "Terminate $NAME ($INSTANCE_ID)? (yes/no): " CONFIRM

if [ "$CONFIRM" == "yes" ]; then
    aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" >/dev/null
    echo "$NAME ($INSTANCE_ID) terminated successfully"
else
    echo "Cancelled"
fi