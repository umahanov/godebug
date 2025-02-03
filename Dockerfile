# Use the official Golang image as the base image
FROM golang:1.22

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files
COPY go.mod ./

# Download and install dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Install Delve debugger
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Build the Go app
RUN go build -gcflags="all=-N -l" -o main .

# Expose the application port
EXPOSE 8080

# Expose the debug port
EXPOSE 40000

# Command to run the application with Delve for debugging
CMD ["dlv", "exec", "./main", "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient", "--continue"]
