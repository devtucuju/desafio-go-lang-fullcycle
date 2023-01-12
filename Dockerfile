# Specifies a parent image
FROM golang:alpine3.14 AS step1

# Creates an app directory to hold your app’s source code
WORKDIR /app

# Copies everything from your root directory into /app
COPY . .

RUN go mod init main

# Builds your app with optional configuration
# USE -ldflags='-s -w' to shrink the binary
# Fonte: https://words.filippo.io/shrink-your-go-binaries-with-this-one-weird-trick/
RUN GOOS=linux go build -o /app/main -ldflags='-s -w' .

FROM scratch AS final

WORKDIR /app

COPY --from=step1 /app .

EXPOSE 8080

ENTRYPOINT ["./main"]