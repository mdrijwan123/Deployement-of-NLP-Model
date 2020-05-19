FROM frolvlad/alpine-python-machinelearning:latest

RUN pip install --upgrade pip

WORKDIR /app

COPY . /app
RUN apk add build-base
RUN apk add --no-cache --virtual .build-deps g++ python3-dev libffi-dev openssl-dev && \
    apk add --no-cache --update python3 && \
    pip3 install --upgrade pip setuptools
RUN pip install -r requirements.txt
RUN python -m nltk.downloader punkt
EXPOSE 4000

ENTRYPOINT  ["python"]

CMD ["app.py"]
