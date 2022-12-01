is_debian() { grep '^NAME="Debian' /etc/os-release >/dev/null 2>&1; }
# is_debian_based() { grep '' /etc/os-release >/dev/null 2>&1; }

if is_debian; then

  sudo apt-get remove docker docker-engine docker.io containerd runc

  sudo apt-get update
  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  
  # version check for specified version installation
  # apt-cache madison docker-ce

  # sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io docker-compose-plugin

  sudo gpasswd -a $(whoami) docker
  sudo chgrp docker /var/run/docker.sock
  sudo service docker restart


fi
