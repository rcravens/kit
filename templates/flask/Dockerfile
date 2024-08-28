############################## base_image ##############################
ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION:-3.9.19} AS base_image

RUN echo $PYTHON_VERSION

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update

RUN pip install --upgrade pip

RUN pip install flask

# CREATE CODE DIRECTORY
RUN mkdir -p /code

############################## dev ##############################
FROM base_image AS dev

WORKDIR /code


############################## stage ##############################
FROM base_image AS stage

WORKDIR /code


############################## prod ##############################
FROM base_image AS prod

WORKDIR /code