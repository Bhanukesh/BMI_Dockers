# Use an official Go runtime as a parent image matching your Go version
FROM golang:1.22.5-alpine

# Update and secure the base image
RUN apk update && apk upgrade && \
    # Adding a security-focused package installation
    apk add --no-cache ca-certificates && \
    update-ca-certificates

# Set the working directory inside the container
WORKDIR /app

# Copy the local package files to the container's workspace.
# Prefer COPY over ADD for local files as it's more straightforward and does not include extra features of ADD we don't need
COPY . /app

# Download any necessary dependencies
# This ensures that dependencies are cached separately from build steps
RUN go mod download

# Build the application to run.
RUN go build -o main .

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Use an array form of CMD to avoid the shell form, which doesn't handle signals properly
CMD ["./main"]
