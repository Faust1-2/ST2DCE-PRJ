docker build . -t jenkins
docker run -p 8085:8080 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home --name Jenkins jenkins