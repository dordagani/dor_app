FROM python:2.7
ADD . ./code/
WORKDIR /code/
EXPOSE 5000
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
CMD ["python","hello.py"]