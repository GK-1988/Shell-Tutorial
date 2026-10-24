#!/bin/bash

# Check AWS CLI
command -v aws >/dev/null 2>&1
VALIDATE $? "Checking AWS CLI"

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <instance-name1> <instance-name2> ..."
    exit 1
fi

for instance in "$@"
do
    echo "Processing instance: $instance"

    INSTANCE_ID=$(aws ec2 describe-instances \
        --filters \
        "Name=tag:Name,Values=$instance" \
        "Name=instance-state-name,Values=pending,running,stopping,stopped" \
        --query "Reservations[].Instances[].InstanceId" \
        --output text)

    if [ -z "$INSTANCE_ID" ] || [ "$INSTANCE_ID" = "None" ]; then
        echo "Instance $instance not found"
        continue
    fi

    echo "Instance Details:"

    aws ec2 describe-instances \
        --instance-ids "$INSTANCE_ID" \
        --query "Reservations[].Instances[].{
            Name:Tags[?Key=='Name']|[0].Value,
            ID:InstanceId,
            State:State.Name,
            PrivateIP:PrivateIpAddress
        }" \
        --output table

    read -p "Do you want to terminate $instance (yes/no)? " ANSWER

    if [ "$ANSWER" != "yes" ]; then
        echo "Skipping $instance"
        continue
    fi

    aws ec2 terminate-instances \
        --instance-ids "$INSTANCE_ID" >/dev/null 2>&1

    VALIDATE $? "Terminating $instance"

    echo "Waiting for instance to terminate..."

    aws ec2 wait instance-terminated \
        --instance-ids "$INSTANCE_ID"

    VALIDATE $? "$instance terminated completely"

    echo
done