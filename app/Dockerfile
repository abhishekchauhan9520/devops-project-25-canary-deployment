FROM python:3.12-alpine
WORKDIR /app
COPY server.py /app/server.py
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PORT=8080
EXPOSE 8080
USER 65532:65532
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD wget -q -O - http://127.0.0.1:8080/healthz || exit 1
ENTRYPOINT ["python", "/app/server.py"]
