# Stage 1: Build Python environment
FROM python:3.9.19-alpine3.19 AS builder

WORKDIR /app/backend

COPY . /app/backend
# COPY . .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Stage 2: Create production image
FROM python:3.9.19-alpine3.19

WORKDIR /app/backend

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /app/backend /app/backend
VOLUME /app/backend

EXPOSE 8000

CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]
