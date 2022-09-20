FROM continuumio/miniconda3:latest
RUN apt update
RUN apt install make automake gcc g++ subversion -y
RUN pip install mlflow boto3
COPY scripts/entrypoint.sh /entrypoint.sh
EXPOSE 80
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]