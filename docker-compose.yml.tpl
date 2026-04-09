services:
  redis:
    container_name: redis-{{ site_name }}
    image: redis:{{ app_version | default:"8.6" }}-alpine
    restart: always
    env_file:
      - .env
    command:
      - redis-server
      - --appendonly
      - "yes"
      - --requirepass
      - ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    ports:
      - "127.0.0.1:{{ ports.redis }}:6379"
    healthcheck:
      test: ["CMD-SHELL", "redis-cli -a \"${REDIS_PASSWORD}\" ping | grep PONG"]
      interval: 10s
      timeout: 5s
      retries: 6
      start_period: 20s
    networks:
      - {{ network_name }}

volumes:
  redis_data:

networks:
  {{ network_name }}:
    driver: bridge
