FROM rust:1.33-slim
MAINTAINER alex@gnosis.pm

WORKDIR /app

# Install system libs
RUN apt-get update && apt-get install -y --no-install-recommends \
 				lftp \
				curl \
				openssh-server \
				xxd

RUN rm -rf /var/lib/apt/lists/*

#Build rust libraries
COPY Cargo.toml  ./
RUN mkdir src && touch src/lib.rs && cargo build

# Copy project files into Docker
COPY src/. src/.

#PID file for storage of cron-pids
#and create config file for validation script
#and create .ssh folder for storage of ssh keys
RUN touch /root/forever.pid \
	&& mkdir /app/config \
	&& mkdir /root/.ssh

#COPY scripts to docker
COPY scripts/build_all.sh scripts/build_all.sh

# Build project
RUN sh scripts/build_all.sh

#COPY other files
COPY test/. test/.
COPY variables.sh ./
COPY scripts/. scripts/.



# Signal handling for PID1 https://github.com/krallin/tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

#support for sftp
EXPOSE 22

# Run the command on container startup
ENTRYPOINT ["/tini", "--"]
