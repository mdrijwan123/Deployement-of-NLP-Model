# We are using an image which have all the ML packages
FROM frolvlad/alpine-python-machinelearning:latest

RUN pip install --upgrade pip

WORKDIR /app

# Copy the code to the working space
COPY . /app

# Adding necessary plugins
RUN apk add build-base
RUN apk add --no-cache --virtual .build-deps g++ python3-dev libffi-dev openssl-dev && \
    pip3 install --upgrade pip setuptools

# Installing requirements.txt
RUN pip3 install -r requirements.txt

# Installing punkt used in our code
RUN python -c "import nltk; nltk.download('punkt')"

# Exposing the port
EXPOSE 4000

# Initializing python entrypoint and use app.py \
# in cmd to run our application
ENTRYPOINT  ["python"]

CMD ["app.py"]