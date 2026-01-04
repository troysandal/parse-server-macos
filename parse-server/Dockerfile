FROM node:20-bullseye

# Install global Parse tools
RUN npm install -g parse-server parse-dashboard

WORKDIR /app

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose Parse Server + Dashboard port
EXPOSE 1337
EXPOSE 4040
EXPOSE 9229

CMD ["/start.sh"]
