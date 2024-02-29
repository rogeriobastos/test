FROM golang:1.16-alpine
WORKDIR /go/src/app
COPY . .
RUN cd cmd && go build -o huskyci-client main.go

FROM alpine:latest
RUN apk add --no-cache ca-certificates
RUN addgroup --system huskyci \
    && adduser --system --ingroup huskyci --no-create-home huskyci
USER huskyci
WORKDIR /app
COPY --from=0 /go/src/app/cmd/huskyci-client ./
CMD ["/app/huskyci-client"]
