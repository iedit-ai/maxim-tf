# Use an official TensorFlow GPU image as the base image
FROM tensorflow/tensorflow:latest-gpu

# Set the working directory
WORKDIR /root/legacy_code/

# Copy the contents into the container
COPY . .

# Install Conda and create a Conda environment with Python 3.10
RUN apt-get update && apt-get install --no-install-recommends -y wget bash build-essential gcc && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    /opt/conda/bin/conda create -y --name maxim python=3.10 && \
    /opt/conda/bin/conda run -n maxim pip install -r requirements.txt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up the environment
RUN echo "/opt/conda/bin/conda init bash" >> ~/.bashrc && \
    echo "conda activate maxim" >> ~/.bashrc && \
    echo "Complete Setup of Maxim tf model!"

# Expose any necessary ports
EXPOSE 8080

# Set the default command to bash (or your desired script)
CMD ["/bin/bash"]
