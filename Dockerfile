# app/Dockerfile

FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/jibarons/qr_code_gen.git .

RUN pip install --upgrade pip

COPY app/requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt
COPY app/app.py .

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "app.py"] 
# "--server.port=8501", "--server.address=0.0.0.0"