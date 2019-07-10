#!/bin/bash 
###################################################################################
#
# build_golden_ami.sh # Script responsible for creating golden images in aws 
#
# Authors	: Leandro Carneiro de Freitas <leandro.freitas@teravoz.com.br>
#
###################################################################################

# Vars

#            |  vpc-id  |  subnet-id  |    region    |      ami-id       |    tag cfengine    |     ami name     |
#
# ASTERISK_VG="vpc-a3c27edb subnet-1b9b6334 us-east-1 ami-05a36d3b9aa4a17ac ASTERISK\nASTERISK_NEW asterisk_teravoz"
# ASTERISK_SP="vpc-672da202 subnet-096a78d59cffec6fa sa-east-1 ami-05eaf9b21ed6dee3c ASTERISK\nASTERISK_NEW asterisk_teravoz"
# KAFKA_VG="vpc-a3c27edb subnet-914fdef5 us-east-1 ami-07b4156579ea1d7ba KAFKA kafka_teravoz"
KAFKA_VG="vpc-0d9a51e3c3529a0ef subnet-052e6d71121a57821 us-east-1 ami-07b4156579ea1d7ba KAFKA kafka_teravoz"

# Debug mode
test -n "$DEBUG" && set -x


# Function to set aws environment variables
envinronment_aws() {
	app=$1 && envinronment=$2

		if [ "$app" == "asterisk" ] && [ "$envinronment" == "vg" ]; then VARS=$ASTERISK_VG
		elif [ "$app" == "asterisk" ] && [ "$envinronment" == "sp" ]; then VARS=$ASTERISK_SP
		elif [ "$app" == "kafka" ] && [ "$envinronment" == "vg" ]; then VARS=$KAFKA_VG
		fi
}


# Function to create AMI AWS
create_ami() {
	app=$1 && \
	version=$2 && \
	vpc=$3 && \
	subnet=$4 && \
	region=$5 && \
	amiaws=$6 && \
	tag=$7 && \
	aminame=$8 && \
	pid=$$ && \
	versionapp="$aminame-$(date +"%Y-%m-%d")-$version"
	export AWS_PROFILE="default"

echo "{
	\"variables\": {
		\"aws_access_key\": \"\",
		\"aws_secret_key\": \"\"
	},

	\"builders\": [{
		\"vpc_id\": \"$vpc\",
		\"subnet_id\": \"$subnet\",
		\"type\": \"amazon-ebs\",
		\"access_key\": \"{{user \`aws_access_key\`}}\",
		\"secret_key\": \"{{user \`aws_secret_key\`}}\",
		\"region\": \"$region\",
		\"source_ami\": \"$amiaws\",
		\"instance_type\": \"t2.micro\",
		\"ssh_username\": \"ubuntu\",
		\"ami_name\": \"$versionapp\"
	}],

	\"provisioners\": [{
        \"type\": \"file\",
        \"destination\": \"/home/ubuntu\",
        \"source\": \"./install-scripts\"
	},
        {
		\"type\": \"shell\",
		\"script\": \"/tmp/$pid-install-script.sh\"
        }]

}" > /tmp/$pid-$app.json

echo "# \"Install packages\"

# Install packages kafka
sudo apt-get update && \
sudo apt-get upgrade -y && \
sudo apt-get install -y openjdk-8-jdk && \
sudo dpkg -i /home/ubuntu/install-scripts/kafka_2.12-2.1.1_amd64.deb && \
sudo apt-get install -f

# Copy confs default
sudo cp -pvr /home/ubuntu/install-scripts/data/zookeeper/myid /data/zookeeper/myid && \
sudo cp -pvr /home/ubuntu/install-scripts/etc/kafka/* /etc/kafka/ && \
sudo cp -pvr /home/ubuntu/install-scripts/etc/zookeeper/* /etc/zookeeper/ && \

cd /tmp" > /tmp/$pid-install-script.sh

# Build Image AWS
packer validate /tmp/$pid-$app.json && \
AMI=$(packer build /tmp/$pid-$app.json | tee /dev/tty | grep -E -o 'AMI: ami-\w+' | awk '{print $2}') && \

# Remove build files
rm -f /tmp/$pid-$app.json /tmp/$pid-install-script.sh

}

usage() {
echo "Help:

CREATE GOLDEN IMAGE AWS
+++++++++++++++++++++++
				         			PROJECT          VERSION     REGION    
				         			-------          -------     ------
create AMI aws: 		$0 -I [asterisk|kafka]  v01       [vg|sp]


"
exit 1
}

# Check if we have arguments 
# to the cli 
[[ ! -n $1 ]] && usage

# Start the program using 
# getops for the parameters
while getopts 'I:h' flag; do
	case "${flag}" in
		I)
			[[ $# -ne 4 ]] && usage && exit 1
			envinronment_aws $2 $4
			create_ami $2 $3 $VARS
		;;
		h) usage
		;;
	esac
done


