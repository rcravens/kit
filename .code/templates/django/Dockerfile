############################## base_image ##############################
ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION:-3.9.19} AS base_image

RUN echo $PYTHON_VERSION

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update

RUN apt-get install -y libgdal-dev

RUN pip install --upgrade pip

RUN pip install Django nano

# CREATE CODE DIRECTORY
RUN mkdir -p /app/code

############################## dev ##############################
FROM base_image AS dev

ADD entry_point.sh /entry_point.sh
WORKDIR /app/code

############################## stage ##############################
FROM base_image AS stage

ADD entry_point.sh /entry_point.sh
WORKDIR /app/code

############################## prod ##############################
FROM base_image AS prod

ADD entry_point.sh /entry_point.sh
WORKDIR /app/code
