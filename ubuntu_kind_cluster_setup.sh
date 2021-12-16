# Install Docker
{
  sudo apt-get update
  sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release 
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >> /dev/null
  sudo apt-get update
  sudo apt-get -y install docker-ce docker-ce-cli containerd.io
  sudo docker run hello-world
  sudo service docker start
  sudo docker ps
} >> "docker_$(date +"%F %T").log"

# Install Kind
{
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
  sudo install -o root -g root -m 0755 kind /usr/bin/kind 
  sudo kind --version 
} >> "kind_$(date +"%F %T").log"

# Install Kubectl
{
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/bin/kubectl
  sudo kubectl version --client
} >> "kubectl_$(date +"%F %T").log"

# Install Git
sudo apt-get -y install git > "git_$(date +"%F %T").log"

# Create Cluster
{
  git clone https://github.com/MetaArivu/k8s-workshop.git
  sudo kind create cluster --config k8s-workshop/kind/1-clusters/epsilon-5.yaml
  sudo kind get clusters
  sudo kubectl cluster-info --context kind-epsilon-5
  sudo kind get nodes --name epsilon-5
  sudo kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
  sudo kubectl get all -A
} >> "cluster_$(date +"%F %T").log"

# Install Java
{
  sudo apt install -y openjdk-11-jre-headless
  java -version
} >> "java_$(date +"%F %T").log"

# Install helm
{
  curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
  sudo apt-get install -y apt-transport-https --yes
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt-get update
  sudo apt-get install helm
} >> "helm_$(date +"%F %T").log"

# Install Jenkins
{
  helm repo add jenkinsci https://charts.jenkins.io
  helm repo update
  helm search repo jenkinsci
  sudo mkdir /data
  sudo mkdir /data/jenkins-volume
  sudo kubectl apply --filename https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-volume.yaml
  sudo kubectl apply --filename https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml
} >> "jenkins_$(date +"%F %T").log"