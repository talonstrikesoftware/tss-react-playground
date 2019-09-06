#tss-react-playground

**Solution:** tss-react-playground
**Original Source:** 

**Description:** This is a standalone image intended to be used to test out different ReactJS components/libraries and concepts. It adds the create-react-app builder to the image. 

**Last Updated:** 6 Sept 2019

## Notes


## Pre-installation
- None

## Installation/Configuration

#### Run the project-setup.sh script
```console
./project-setup.sh {project_directory_name} {project name}
```

#### Build and run the image
```bash
docker-compose build
docker-compose up -d
```

Note: At this point you can hit the image by going to localhost:3000

- Attach to the running image
In another window attach to the container

```console
  docker-compose exec node bash
```
Note: This will drop you into a bash shell in the container

* **Service name:** node

## Post Install Notes/FAQ
#### Things to know

