#!/bin/bash

echo "Available Instances:"
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,Tags[?Key=='Name'].Value|[0],State.Name]" \
  --output table

echo
read -p "Enter Instance ID to terminate: " INSTANCE_ID

read -p "Are you sure? (yes/no): " CONFIRM

if [ "$CONFIRM" == "yes" ]; then
    aws ec2 terminate-instances \
      --instance-ids "$INSTANCE_ID" \
      --query "TerminatingInstances[*].[InstanceId,CurrentState.Name]" \
      --output table

    echo "Instance $INSTANCE_ID terminated successfully"
else
    echo "Termination cancelled"
fi