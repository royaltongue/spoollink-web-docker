FROM python:3.14-slim

LABEL Description="SpoolLink Web inside a Docker container"
LABEL ECCM-Github="https://github.com/paxx12-snapmaker-u1/spool-link-apps"

ARG REPO_URL=https://github.com/paxx12-snapmaker-u1/spool-link-apps.git
ARG REPO_BRANCH=main

ENV PYTHONUNBUFFERED=1
ENV PORT=8443

# Install everything required by web-app/run.sh
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        openssl \
    && rm -rf /var/lib/apt/lists/*

# Download SpoolLink
RUN git clone --depth 1 --branch ${REPO_BRANCH} ${REPO_URL} /opt/spool-link-apps

WORKDIR /opt/spool-link-apps/web-app

# Match run.sh's directory structure
RUN mkdir -p tmp

EXPOSE 8443

CMD ["sh", "-c", "\
    if [ -f tmp/server.pem ] && [ -f tmp/server.key ]; then \
        echo 'Using existing SSL certificates: tmp/server.pem, tmp/server.key'; \
    else \
        echo 'Generating self-signed SSL certificate...'; \
        openssl req -new -x509 \
            -keyout tmp/server.key \
            -out tmp/server.pem \
            -days 365 \
            -nodes \
            -subj '/C=US/ST=State/L=City/O=Organization/CN=localhost'; \
    fi && \
    echo '' && \
    echo \"Starting HTTPS server on https://0.0.0.0:${PORT}/\" && \
    echo '' && \
    python3 -m http.server ${PORT} \
        --directory public \
        --bind 0.0.0.0 \
        --tls-cert tmp/server.pem \
        --tls-key tmp/server.key \
"]
