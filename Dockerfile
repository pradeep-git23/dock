FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    apache2 \
    software-properties-common \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    libpq-dev \
    libcairo2 \
    libcairo2-dev \
    libapache2-mod-wsgi-py3 \
    apache2-dev \
    python3-pip


# Update alternatives for Python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Add DeadSnakes PPA repository
RUN add-apt-repository ppa:deadsnakes/ppa -y

# Install additional Python packages
RUN apt-get update && apt-get install -y \
    python3-dotenv
RUN apt-get install -y apache2
# Upgrade Google API Python client
RUN pip3 install --upgrade google-api-python-client

# Install Google Cloud libraries
RUN pip3 install google-cloud google-cloud-secret-manager

# Modify Needrestart configuration file
#RUN sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

# Enable WSGI module in Apache
RUN a2enmod wsgi

# Perform system update and upgrade
RUN apt-get update && apt-get upgrade -y

# Expose port 80 for Apache
EXPOSE 80

# Start Apache service
CMD ["apachectl", "-D", "FOREGROUND"]
