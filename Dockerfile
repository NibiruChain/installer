FROM golang:alpine AS builder
WORKDIR /src/app/
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o=/usr/local/bin/installer main.go

FROM gcr.io/distroless/base
COPY --from=builder /usr/local/bin /usr/local/bin
USER nonroot:nonroot
ENTRYPOINT [ "/usr/local/bin/installer" ]