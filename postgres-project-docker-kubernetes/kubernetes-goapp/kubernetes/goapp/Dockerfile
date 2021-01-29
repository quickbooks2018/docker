FROM golang:latest

# Set the Current Working Directory inside the container
WORKDIR /usr/src/goapp

# Copy everything from the current directory to the PWD (Present Working Directory) inside the container
COPY web.go /usr/src/goapp/web.go


# This container exposes port 8080 to the outside world
EXPOSE 3000

# Run the executable
CMD ["go","run","web.go"]