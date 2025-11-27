#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-019ecaf22c9101836"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z02643283SYC8C4HUQCUK"
DOMAIN_NAME="vinnimakeovers.online"

SUCCESS_COUNT=0
FAIL_COUNT=0
FAILED_INSTANCES=()

for instance in "${INSTANCES[@]}"
do
    echo "Launching $instance..."
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id $AMI_ID \
        --instance-type t3.micro \
        --security-group-ids $SG_ID \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
        --query "Instances[0].InstanceId" --output text)

    if [ -z "$INSTANCE_ID" ] || [ "$INSTANCE_ID" == "None" ]; then
        echo "❌ Failed to launch $instance"
        FAIL_COUNT=$((FAIL_COUNT+1))
        FAILED_INSTANCES+=("$instance")
        continue
    fi

    # Wait until running
    aws ec2 wait instance-running --instance-ids $INSTANCE_ID

    if [ "$instance" != "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
            --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
        RECORD_NAME="$instance.$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
            --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
        RECORD_NAME="$DOMAIN_NAME"
    fi

    echo "✅ $instance IP address: $IP"

    aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONE_ID \
        --change-batch "{
            \"Comment\": \"Creating or Updating record set\",
            \"Changes\": [{
                \"Action\": \"UPSERT\",
                \"ResourceRecordSet\": {
                    \"Name\": \"$RECORD_NAME\",
                    \"Type\": \"A\",
                    \"TTL\": 60,
                    \"ResourceRecords\": [{\"Value\": \"$IP\"}]
                }
            }]
        }"

    SUCCESS_COUNT=$((SUCCESS_COUNT+1))
done

echo "-----------------------------------"
echo "Summary:"
echo "✅ Successful launches: $SUCCESS_COUNT"
echo "❌ Failed launches: $FAIL_COUNT"
if [ $FAIL_COUNT -gt 0 ]; then
    echo "Failed instances: ${FAILED_INSTANCES[@]}"
fi
echo "-----------------------------------"
