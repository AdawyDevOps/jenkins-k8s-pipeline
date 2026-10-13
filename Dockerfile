FROM python:3.9-slim

WORKDIR /app

COPY req.txt .
RUN pip install --no-cache-dir -r req.txt

COPY Python.py .

EXPOSE 5000

CMD ["python", "Python.py"]
