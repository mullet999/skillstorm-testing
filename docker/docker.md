To create the Docker image from the Dockerfile, run the following command:
docker build -t my-dev-env:1.0 .

This will build the Docker image and tag it with the name "my-dev-env:1.0".
This command needs to be run in the same directory as the Dockerfile.


Once this has been built, you can run the following command to create a container from the image:
docker run --rm -it my-dev-env:1.0 bash

This will create a container from the image and run a bash shell within it.
This container will be deleted after the bash shell is closed.

Create a .env file in the same directory as the container will be ran and add any environment variables you want to pass to the container.

Run the following command to run the container using a .env file  and mount the current directory as a volume:
docker run --rm -it --env-file .env -v $(pwd):/app my-dev-env:1.0 bash

