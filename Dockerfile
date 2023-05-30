# # app/Dockerfile

# FROM python:3.11-slim

# WORKDIR /app

# RUN apt-get update && apt-get install -y \
#     build-essential \
#     curl \
#     software-properties-common \
#     git \
#     && rm -rf /var/lib/apt/lists/*

# RUN git clone https://github.com/jibarons/qr_code_gen.git .

# RUN pip install --upgrade pip

# COPY app/requirements.txt requirements.txt
# RUN python3 -m pip install -r requirements.txt
# COPY app/app.py .

# EXPOSE 8501

# HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

# ENTRYPOINT ["streamlit", "run", "app.py"] 
# # "--server.port=8501", "--server.address=0.0.0.0"

# Get a python image forn Docker hub (https://hub.docker.com/_/python)
FROM python:3.11-slim
# Set wd to /app (Note: Streamlit apps cannot be run from the root directory of Linux distributions. Your main script should live in a directory other than the root directory)
WORKDIR /app
# Install git so that we can clone the app code from a remote repo
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*
# Set address to the remote repo
RUN git clone https://github.com/jibarons/qr_code_gen.git .
# Upgrade pip to install dependencies
RUN pip install --upgrade pip
# Copy app/ dir into the container (This step i am not fully sure about it. I think i need it due to having the Dockerfile in different dir than the app.py inthe project tree)
COPY app/ .
#COPY app/requirements.txt requirements.txt
# install requirements
RUN python3 -m pip install -r requirements.txt
# Streamlits default port 
EXPOSE 8501
# Check port is active
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health
# Run the app. Need to provide relevant server adress
ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"] 