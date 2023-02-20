docker run -it --name elasticluster \
           --rm --env-file $PWD/env \
           -d -v $HOME/.ssh:/home/user/.ssh \
           -v $PWD/assets/elasticluster/storage:/home/user/.elasticluster/storage \
           elasticluster
