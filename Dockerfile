FROM ubuntu:latest

# Update apt-get list, install Python, and install other appropriate dependencies
RUN apt-get update
RUN apt-get install cron
RUN apt-get install -y python3 python3-distutils python3-pip python3-apt
RUN pip3 install pyserial PyYAML

# Copy necessary files to local docker container environment
ADD crontab /etc/cron.d/simple-cron
COPY utils.py .
COPY config.yaml .
COPY sdi_12_data_collector.py .
COPY sdi_12_data_collector.sh .
COPY sdi_12_initialization.py .

# Create necessary files and directories inside docker container
RUN touch /var/log/cron.log
RUN mkdir -p /Data
RUN mkdir -p /Data/logs

# Establish correct permissions for files
RUN chmod 0644 /etc/cron.d/simple-cron
RUN chmod +x /sdi_12_data_collector.py
RUN chmod +x /sdi_12_data_collector.sh

# Run the command on container startup
CMD cron \
    && ./sdi_12_data_collector.sh
