URL="https://raw.githubusercontent.com/cdown/sshrc/master/sshrc"
USER_PROGRAM="/usr/local/bin"

wget $URL &&
chmod +x sshrc &&
sudo mv sshrc $USER_PROGRAM
