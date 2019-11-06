FROM frolvlad/alpine-python-machinelearning:latest

RUN pip install --upgrade pip

WORKDIR /app

COPY static static/
COPY templates templates/
COPY sentiment.tsv sentiment.tsv
COPY app.py app.py
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN python -m nltk.downloader punkt
EXPOSE 4000

ENTRYPOINT  ["python"]

CMD ["app.py"]
