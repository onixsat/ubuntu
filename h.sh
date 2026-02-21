!#/bin/bash

apt-get update

packages=( "curl" "python2.7" "git", "make", "openjdk-8-jre" )

for i in "${packages[@]}"
do
  if ! [ -x "$(command -v $i)" ]; then
    echo "--- installing $i ---"
    apt-get -y install $i
  else
    echo "--- $i already installed --- "
  fi
done
