export HISTFILESIZE=10000000
export HISTSIZE="INFINITE"
export PATH=/Users/jeffrey.glade/Library/Python/2.7/lib/python/site-packages:/Users/jeffrey.glade/git/devco-infra:$PATH
eval "$(rbenv init -)"
alias ll="ls -la"
alias k="kubectl"
source /Users/jeffrey.glade/git/devco-infra/aws_on.include
source <(kubectl completion bash)
export HISTTIMEFORMAT="%m/%d/%y %T "
export HELM_CONFIG_HOME=~/git/helm-config
export ANSIBLE_REPO=/Users/jeffrey.glade/git/devco-ansible-playbooks
export KOPS_FEATURE_FLAGS="+DrainAndValidateRollingUpdate"

function wp() {
  if [[ $1 ]]; then
    watch -n1 "kubectl get pods -o wide | grep $1"
  else
    watch -n1 "kubectl get pods -o wide"
  fi
}

kssh () {
    POD=$1
    NAMESPACE=${2:+"--namespace ${2}"}
    search_command="kubectl get pods $POD $NAMESPACE -o jsonpath='{.status.hostIP}'"
    ip=$(eval $search_command)
    if [ $? -ne '0' ]
    then
        echo "No hostIP found."
        return 1
    fi
    echo "ssh ${ip}"
    ssh $ip
}

BLUE="\[\033[01;34m\]"
YELLOW="\[\e[1;33m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
PURPLE="\[\033[0;35m\]"
NC='\033[0m' # No Color
setcolor() {
  CONTEXT="$(kubectl config current-context)"
  CURRENT_CONTEXT_COLOR=$NC
  if [ -n "$CONTEXT" ]; then
    case "$CONTEXT" in
      *stage*)
        echo "${RED}k8s: ${CONTEXT}"
        ;;
      *prod*)
        echo "${RED}k8s: ${CONTEXT}"
        ;;
      *qa*)
        echo "${YELLOW}k8s: ${CONTEXT}"
        ;;
      *dev*)
        echo "${YELLOW}k8s: ${CONTEXT}"
        ;;
      *demo*)
	echo "${YELLOW}k8s: ${CONTEXT}"
	;;
      *siteops*)
        echo "${GREEN}k8s: ${CONTEXT}"
        ;;
      *)
	echo "${RED}k8s: ${CONTEXT}"
	;;
    esac
  fi
}
export PROMPT_COMMAND='PS1="$(setcolor)  ${PURPLE}AWS: $AWS_PROFILE   ${BLUE}\w${NC}\n> "'

ctx () {
  context=$1
  if [ -z "$context" ] ; then
    echo "USAGE: ctx <context-name>"
    echo "Available contexts: "
    kubectl config get-contexts
  else
    kubectl config use-context $context
  fi
}
