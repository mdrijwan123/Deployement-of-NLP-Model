FROM python:3.6-alpine

RUN adduser -D spam_classifier && \
    adduser spam_classifier tty

WORKDIR /home/spam_classifier
COPY requirements.txt requirements.txt
RUN python -m venv venv && \
    venv/bin/pip install --no-cache-dir --upgrade pip && \
    venv/bin/pip install --no-cache-dir -r requirements.txt && \
    venv/bin/python -m nltk.downloader -d /home/spam_classifier/venv/nltk_data punkt && \
    venv/bin/python -m nltk.downloader -d /home/spam_classifier/venv/nltk_data stopwords

RUN apk del .build-dependency

COPY static static/
COPY templates template/
COPY app.py app.py

EXPOSE 4000
ENTRYPOINT ["python3"]
CMD ["app.py"]
