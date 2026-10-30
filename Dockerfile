FROM --platform=linux/amd64 python:3.15-slim

RUN apt-get update && \
    apt-get install -y \
    git \
    ca-certificates \
    curl \
    bash \
    gcc \
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade --break-system-packages \
    pip \
    setuptools \
    wheel \
    semgrep \
    pre-commit \
    && rm -fr /var/lib/apt/lists/*

RUN mkdir -p /wrk && \
    chown 2000:2000 /wrk && \
    addgroup --gid 2000 worker && \
    adduser --ingroup worker --uid 2000 --home /wrk/ --disabled-password --gecos "" --no-create-home worker

COPY --chown=2000:2000 --chmod=755 trivy_0.76.1_Linux-64bit.deb trivy_0.76.1_Linux-64bit.deb
RUN dpkg -i trivy_0.76.1_Linux-64bit.deb && \
    rm trivy_0.76.1_Linux-64bit.deb

COPY --chown=2000:2000 --chmod=755 cdxgen-linux-amd64 /usr/local/bin/cdxgen
COPY --chown=2000:2000 --chmod=755 gitleaks /usr/local/bin/gitleaks

USER 2000:2000

ENTRYPOINT [ "/bin/bash" ]
