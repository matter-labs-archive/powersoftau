FROM rust:latest
COPY . /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nano \
    sudo \
    sftp \
    lftp  

COPY tasks/cron-task /etc/crontabs/root

RUN apt-get update && apt-get -y install cron

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/hello-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log