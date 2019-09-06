#!/bin/bash
if [[ $# -ne 2 ]] ; then
    echo 'Usage ./project-setup.sh {project directory} {project name}'
    exit 1
fi
set -e

# copy everything to the project dir
cp -r * $1

mv $1/env.template $1/.env

if [[ "$OSTYPE" == "linux-gnu" ]]; then
   sed -i '' -e "s/PROJECT_DIRECTORY_NAME/$2/g"  $1/.env
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # have to do it this way because of mac OSX, will need to adjust for different OS's
    sed -i '' -e "s/PROJECT_DIRECTORY_NAME/$2/g"  $1/.env
else
    sed -i '' -e "s/PROJECT_DIRECTORY_NAME/$2/g"  $1/.env
fi

# cleanup
rm $1/README.md
rm $1/project-setup.sh

echo 'Next steps:'
echo "cd $1"
echo "docker-compose up -d"
echo "docker-compose exec node bash"
echo "npx create-react-app {app name}"
