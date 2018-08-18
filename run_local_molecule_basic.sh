# https://molecule.readthedocs.io/en/latest/examples.html#docker
# https://hub.docker.com/r/fminzoni/molecule/
# install docker (sudo pip install docker) / if some error appears try with docker-py
# install ansible
# run from repository role
docker run --rm -it --privileged=True \
    -v "$(pwd)":/tmp/$(basename "${PWD}"):ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -w /tmp/$(basename "${PWD}") \
    retr0h/molecule:latest \
    sudo molecule --debug syntax

docker run --rm -it --privileged=True \
    -v "$(pwd)":/tmp/$(basename "${PWD}"):ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -w /tmp/$(basename "${PWD}") \
    retr0h/molecule:latest \
    sudo molecule --debug create


docker run --rm -it --privileged=True \
    -v "$(pwd)":/tmp/$(basename "${PWD}"):ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -w /tmp/$(basename "${PWD}") \
    retr0h/molecule:latest \
    sudo molecule converge
