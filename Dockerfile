FROM golang:alpine as builder

RUN apk add --no-cache git
WORKDIR /src
COPY . /src
RUN set -eux; \
    \
    go env; \
    go mod download; \
    buildflags="-X 'main.BuildTime=`date`' -X 'main.GitHead=`git rev-parse --short HEAD`' -X 'main.GoVersion=$(go version)'"; \
    go build -ldflags "$buildflags" -o wechat-work-message-push-go; \
    ./wechat-work-message-push-go -v

FROM alpine:latest
RUN apk update && apk add --no-cache ca-certificates tzdata
ADD https://github.com/cloverzrg/file/raw/master/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /src/wechat-work-message-push-go /app/wechat-work-message-push-go
EXPOSE 80
ENV Token my_token
ENV DefaultReceiverUserId 13800138000
ENV WechatWorkCorpId ww741038v8sa88hv36d
ENV WechatWorkCorpSecret USVdvsa_ad2k34jk232kjn-asfefeawf_waeasdf-ase
ENV WechatWorkAgentId 1000001
ENV GrafanaWebhookUser admin
ENV GrafanaWebhookPassword admin
CMD ["/app/wechat-work-message-push-go"]