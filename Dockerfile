FROM node:22-alpine
WORKDIR /app
ENV NOTE_STORAGE_PATH=/app/docs
RUN npm install -g markdown-editor-server
CMD ["markdown-editor-server"]