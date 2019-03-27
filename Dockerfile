FROM rust:latest
MAINTAINER alex@gnosis.pm

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get update && apt-get -y install cron
RUN apt-get -y install lftp
RUN apt-get -y install nano

WORKDIR /app

COPY src/. src/.
COPY Cargo.toml .
COPY Cargo.lock .
RUN cargo build

EXPOSE 22

COPY . .

# Add crontab file in the cron directory
ADD tasks/cron-task /etc/cron.d/hello-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

RUN touch /app/config/lastestContributionDate.txt

RUN 1 > config/lastestContributionDate.txt

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
#RUN ls
#RUN bash scripts/initial_setup_constrained.sh 