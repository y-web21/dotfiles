#!/usr/bin/env bash

if [ -e "$(which aws 2>/dev/null)" ]; then
  # aws cli v2
  alias aws_account_id='aws sts get-caller-identity --query ''\'Account'\'' --output text'

  # EC2
  alias ec2list='aws ec2 describe-instances --query '\''Reservations[].Instances[].{id:InstanceId, state:State.Name, ipv4:PublicIpAddress, name:Tags[?Key==`Name`].Value|[0]}'\'' --output'
  alias ec2stopall='aws ec2 describe-instances --query '\''Reservations[].Instances[].[InstanceId, State.Name]'\'' --output text | grep running | awk '\''{print $1}'\'' | xargs aws ec2 stop-instances --instance-ids'
  alias ec2start_by_tagname=aws-ec2-start-instances-by-tagname

  aws-ec2-start-instances-by-tagname() {
    aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, State.Name, Tags[?Key==`Name`].Value|[0]]' --output text | awk '$2 == "stopped"' | awk '($3 ~ /'${1}'/){print $1}' | xargs aws ec2 start-instances --instance-ids
  }

  # CloudFormation
  alias cfn_create='aws cloudformation create-stack --template-body file://$(pwd)/cloudformation.yaml --capabilities CAPABILITY_NAMED_IAM --stack-name '
  alias cfn_delete='aws cloudformation delete-stack --stack-name '
  alias cfn_stacklist='aws cloudformation list-stacks --query '\''StackSummaries[].[StackName, StackStatus]'\'' --output'

  # ssh ec2
  alias ec2ssh='ssh -oStrictHostKeyChecking=no -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}'
  alias eeee='echo ${CURRENT_SSH_PEM}'
  alias set-env-CURRENT_SSH_SERVER-ec2='export CURRENT_SSH_SERVER=$(ec2list text | grep running | awk '\''NR==1 {print $2}'\'') && echo set ${CURRENT_SSH_SERVER}'
fi


scp-from() {
  local src=$1
  local dst=${2:-./}
  cmd="scp -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}:${src} ${dst}"
  echo $cmd && $cmd
}
scp-to() {
  local src=$1
  local dst=${2:-\~}
  cmd="scp -i ${CURRENT_SSH_PEM} ${src} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}:${dst}"
  echo $cmd && $cmd
}
ec2sshrc() {
  ssh -oStrictHostKeyChecking=no -t -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER} 'bash --rcfile <(echo "'"$(cat ~/.sshrc)"'")'
}
print-ssh() {
  echo ssh -i ${CURRENT_SSH_PEM} ${CURRENT_SSH_USER}@${CURRENT_SSH_SERVER}
}

print-current-ssh-var() {
  echo 'CURRENT_SSH_PEM = '${CURRENT_SSH_PEM}
  echo 'CURRENT_SSH_USER = '${CURRENT_SSH_USER}
  echo 'CURRENT_SSH_SERVER = '${CURRENT_SSH_SERVER}
}

test ! -v CURRENT_SSH_PEM && CURRENT_SSH_PEM=
test ! -v CURRENT_SSH_USER && CURRENT_SSH_USER=ec2-user
test ! -v CURRENT_SSH_SERVER && export CURRENT_SSH_SERVER=127.0.0.1
if [ -n "$(which wslpath 2>/dev/null)" ]; then print-current-ssh-var; fi
