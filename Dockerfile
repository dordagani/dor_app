FROM python:2.7
ADD . ./opt/
WORKDIR /opt/
EXPOSE 5000
#RUN pip install --upgrade pip
RUN pip install -r requirements.txt
#CMD ["python","hello.py"]
CMD ["py.test"]
