FROM python:3.9.5-alpine3.12
COPY . /owm
WORKDIR /owm
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN python3 -m pip install --upgrade pip
RUN pip3 install -r requirements.txt
RUN chmod +x gunicorn.sh
CMD ["./gunicorn.sh"]
