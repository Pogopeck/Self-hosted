# Self-hosted

docker run -d -p 8083:80 github-runner
docker save -o github-runner.tar github-runner:latest
gzip github-runner.tar
python3 -m http.server 8000 -- start a HTTP server 

scp github-runner.tar.gz nsstools@de6723yr:/home/nsstools/CRAMER