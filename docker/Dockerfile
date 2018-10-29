ARG NODE_VERSION=6
FROM node:${NODE_VERSION}

RUN apt update && apt upgrade -y && apt install -y nginx
RUN apt install sudo

# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red

# User data directory, contains flows, config and nodes.
RUN mkdir /data
RUN mkdir -p /var/lib/nginx/body

WORKDIR /usr/src/node-red

# Add node-red user so we aren't running as root.
RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red
RUN chown -R node-red. /var/lib/nginx
RUN chown -R node-red. /var/log/nginx
RUN chmod 777 /run
RUN mkdir /log && chmod 777 /log && touch /log/restore-log && chown -R node-red:node-red /log

USER node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
RUN npm install

# User configuration directory volume
EXPOSE 8080

# Environment variable holding file path for flows configuration
ADD evb_flow.json.template /usr/src/node-red/evb_flow.json.template
ADD run.sh /usr/src/node-red/run.sh
ADD nginx.conf /etc/nginx/nginx.conf
ENV FLOWS=/data/evb_flow.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules

CMD ["bash", "run.sh"]

#CMD ["npm", "start", "--", "--userDir", "/data"]
