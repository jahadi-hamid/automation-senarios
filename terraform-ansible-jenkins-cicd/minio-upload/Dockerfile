From python:latest
ENV PYTHONUNBUFFERED 1
RUN mkdir /minio_code
WORKDIR /minio_code
COPY . /minio_code/
RUN pip install -r requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8090"]
