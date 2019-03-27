FROM rust:latest
MAINTAINER alex@gnosis.pm


RUN apt-get update && apt-get -y install cron
RUN apt-get -y install lftp
RUN apt-get -y install nano

COPY . ./app

# Add crontab file in the cron directory
ADD tasks/cron-task /etc/cron.d/hello-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log