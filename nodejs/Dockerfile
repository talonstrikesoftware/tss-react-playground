FROM node:lts-jessie

LABEL maintainer="support@talonstrikesoftware.com"

RUN apt-get update -yqq
RUN apt-get install -yqq --no-install-recommends build-essential apt-transport-https vim

# yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

# add create-react-app
RUN yarn global add create-react-app

WORKDIR /usr/src/app

EXPOSE 3000

# Launch a shell
ENTRYPOINT ["/bin/bash"]
