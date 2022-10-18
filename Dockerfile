# Build an image that can do training and inference in SageMaker
FROM python:3.9.15

LABEL org.opencontainers.image.authors="raymond_harris@ssg.gov.sg"

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         nginx \
         ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

#Install packages inside requirements 
#Pip install packages without saving cache to save image space, optimizing start up time
COPY ml_based/requirements.txt requirements.txt
RUN pip --no-cache-dir install -U -r requirements.txt

RUN python -m spacy download en_core_web_lg

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYCODE=TRUE
ENV PATH="/opt/program:${PATH}"

COPY ml_based /opt/program
WORKDIR /opt/program
