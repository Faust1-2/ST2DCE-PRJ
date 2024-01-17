FROM golang:latest

WORKDIR /app

COPY ./webapi ./

RUN go mod download

EXPOSE 8080

CMD ["go", "run", "main.go"]