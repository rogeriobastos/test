FROM golang:1.16-alpine
WORKDIR /go/src/app
COPY api/ .
RUN go build -o huskyci-api server.go

FROM alpine:3.14
RUN addgroup --system huskyci \
    && adduser --system --ingroup huskyci --no-create-home huskyci
USER huskyci
WORKDIR /app
COPY --from=0 /go/src/app/huskyci-api ./
EXPOSE 8888
CMD ["/app/huskyci-api"]
