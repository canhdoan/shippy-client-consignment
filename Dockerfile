# Build image
FROM golang:alpine AS builder

RUN apk update \ 
    && apk upgrade \
    && apk add --no-cache git

RUN mkdir /app
WORKDIR /app

ENV GO111MODULE=on

COPY . .
RUN go mod download -x
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-cli-consignment .

# Run containter
FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app
ADD consignment.json /app/consignment.json
COPY --from=builder /app/shippy-cli-consignment .

CMD ["./shippy-cli-consignment"]
