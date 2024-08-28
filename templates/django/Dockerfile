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

WORKDIR /app/code
#ENTRYPOINT ["python3"]
#CMD ["manage.py", "runserver", "0.0.0.0:8000"]
############################## stage ##############################
FROM base_image AS stage

WORKDIR /app
COPY requirements.txt /app
RUN pip3 install -r requirements.txt --no-cache-dir

ENTRYPOINT ["python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]


############################## prod ##############################
FROM base_image AS prod

WORKDIR /app
COPY requirements.txt /app
RUN pip3 install -r requirements.txt --no-cache-dir
COPY . /app
ENTRYPOINT ["python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
