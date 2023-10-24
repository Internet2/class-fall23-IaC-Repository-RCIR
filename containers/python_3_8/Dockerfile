# Use a more specific base image
FROM python:3.8-slim-buster

# Metadata as described in best practices
LABEL maintainer="your-email@example.com" \
      version="1.0" \
      description="Python 3.8 environment for research computing"

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create a dedicated user to run the app
RUN useradd -m myuser
USER myuser

# Set working directory
WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY --chown=myuser:myuser requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code and scripts
COPY --chown=myuser:myuser . .

# Command to run the application
CMD [ "python", "./your-daemon-or-script.py" ]
