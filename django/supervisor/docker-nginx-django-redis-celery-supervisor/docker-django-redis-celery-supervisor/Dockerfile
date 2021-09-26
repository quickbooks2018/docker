FROM python:3.7-alpine as cloudgeeks

WORKDIR /app

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY supervisord.conf /etc/supervisord.conf

RUN apk add --update --no-cache postgresql-client jpeg-dev supervisor nginx
RUN apk add --update --no-cache --virtual .tmp-build-deps \ 
    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

ENV USER=app
ENV UID=12345
ENV GID=23456

RUN addgroup -S "${USER}" && adduser --disabled-password -S "${USER}" -G "${USER}" --no-create-home --uid "$UID" "$USER"
RUN chown -R "${USER}":"${USER}" /app


FROM cloudgeeks as runtime
COPY ./app /app
RUN chown -R "${USER}":"${USER}" /app
COPY app.sh /app/app.sh
RUN  chmod +x /app/app.sh
COPY celery.conf /etc/supervisor/conf.d/celery.conf
COPY celery_beat.conf /etc/supervisor/conf.d/celery_beat.conf
COPY supervisord.conf /etc/supervisord.conf

# Switch to app user
EXPOSE 8000
USER app
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
