# /bin/sh

apk add --update curl jq
alias convert_report="jq -r '([.resource_changes[].change.actions?]|flatten)|{\"create\":(map(select(.==\"create\"))|length),\"update\":(map(select(.==\"update\"))|length),\"delete\":(map(select(.==\"delete\"))|length)}'"
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
install kubectl /usr/local/bin/ && rm kubectl
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
install aws-iam-authenticator /usr/local/bin/ && rm aws-iam-authenticator
terraform --version
export TF_VAR_environment=${PWD##*/}
cd ${TF_ROOT}
gitlab-terraform init
gitlab-terraform validate
tfsec --config-file .tfsec.yml . -f json | tee gl-sast-report.json