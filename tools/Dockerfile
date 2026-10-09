# Build environment for tools/render-all.sh: Python packages, LibreOffice and fonts.
FROM python:3.13-slim

# Carlito and Caladea have the same metrics as Calibri and Cambria, so Word layouts don't shift in the PDF.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libreoffice-writer \
        fonts-crosextra-carlito fonts-crosextra-caladea fonts-liberation fonts-dejavu \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# LibreOffice needs a writable profile directory.
ENV HOME=/tmp
WORKDIR /work
