FROM node:10.19.0 as build

WORKDIR /var/www/sentimeter

#1 Install OS Libraries dependencies, if needed
# PUT HERE



#2 Install App Dependencies

# COPY package.json .


COPY sentimeter-frontend .

RUN npm install



#3 Compile/transpile & package



RUN npm run build

RUN yarn 

RUN yarn build:staging




FROM nginx:latest as runtime

WORKDIR /usr/share/nginx/html

COPY nginx/ /etc/nginx/conf.d/

#4 Copy artifact - static website

COPY --from=build /var/www/sentimeter/build .

#5 entrypoint/cmd already comes with base image (nginx or apache)