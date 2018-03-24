FROM python:alpine
WORKDIR /vaping/plugins
RUN apk add --no-cache --virtual .build-deps gcc musl-dev \
    && apk add --no-cache fping \
    && pip install --no-cache-dir vaping prometheus_client \
    && apk del .build-deps
COPY prometheus.py .
EXPOSE 9099/tcp
CMD [ "vaping", "--debug", "--home", "/vaping", "start", "-d" ]
