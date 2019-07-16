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
KAFKA_VG="vpc-0d9a51e3c3529a0ef subnet-052e6d71121a57821 us-east-1 ami-07b4156579ea1d7ba KAFKA kafka-teravoz"

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
          \"type\": \"shell\",
          \"inline\": [
              \"sleep 5\",
              \"sudo apt-get install -y software-properties-common\",
              \"sudo apt-add-repository -y --update ppa:ansible/ansible\",
              \"sudo apt-get update\",
              \"sudo apt-get -y install ansible\"
          ]
      },
      {
          \"type\": \"file\",
          \"source\": \"./ansible\",
          \"destination\": \"/home/ubuntu/\"
      },  
      {
          \"type\": \"ansible-local\",
          \"playbook_file\": \"./ansible/$app.yml\"
      }
  	]
}" > /tmp/$pid-$app.json

#		  \"extra_arguments\": [ \"-vvvv\" ],


# Build Image AWS
packer validate /tmp/$pid-$app.json && \
AMI=$(packer build /tmp/$pid-$app.json | tee /dev/tty | grep -E -o 'AMI: ami-\w+' | awk '{print $2}') && \

# Remove build files
rm -f /tmp/$pid-$app.json

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


