FROM frolvlad/alpine-python-machinelearning:latest

RUN pip install --upgrade pip

WORKDIR /app

COPY . /app
RUN pip install -r requirements.txt
RUN python -m nltk.downloader punkt
EXPOSE 4000

ENTRYPOINT  ["python"]

CMD ["app.py"]
