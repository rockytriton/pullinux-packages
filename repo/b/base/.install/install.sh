RPART=$(mount|grep ' / '|cut -d' ' -f 1)

echo "Root partition: $RPART"

echo "$RPART	/	ext4	defaults	1	1" > /etc/fstab

echo "Set password for root user:"

passwd

echo "Creating default plx user..."

useradd -m plx

echo "Set password for plx user:"

passwd plx
