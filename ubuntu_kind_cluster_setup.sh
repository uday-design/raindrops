# Install Docker
sudo apt-get update  > docker.log
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release  > docker.log
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg  > docker.log
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update > docker.log
sudo apt-get -y install docker-ce docker-ce-cli containerd.io > docker.log
sudo docker run hello-world > docker.log
sudo service docker start > docker.log
sudo docker ps > docker.log

# Install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 > kind.log
sudo install -o root -g root -m 0755 kind /usr/bin/kind > kind.log
sudo kind --version > kind.log

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > kubectl.log
sudo install -o root -g root -m 0755 kubectl /usr/bin/kubectl > kubectl.log
sudo kubectl version --client > kubectl.log

# Install Git
sudo apt-get -y install git > git.log

# Create Cluster
git clone https://github.com/MetaArivu/k8s-workshop.git > cluster.log
sudo kind create cluster --config k8s-workshop/kind/1-clusters/epsilon-5.yaml > cluster.log
sudo kind get clusters > cluster.log
sudo kubectl cluster-info --context kind-epsilon-5 > cluster.log
sudo kind get nodes --name epsilon-5 > cluster.log
sudo kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml > cluster.log
sudo kubectl get all -A > cluster.log
