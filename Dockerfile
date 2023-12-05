FROM continuumio/miniconda3:latest AS conda_stage

# Install necessary system packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget bash build-essential gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y --no-install-recommends \
    libcudnn8=8.*-1+cuda11.0 \
    libcudnn8-dev=8.*-1+cuda11.0 \
    && rm -rf /var/lib/apt/lists/*
    
# Install Conda
RUN conda install -y conda

FROM tensorflow/tensorflow:latest-gpu

# Copy Conda from the conda_stage
COPY --from=conda_stage /opt/conda /opt/conda

# Set the working directory
WORKDIR /root/legacy_code/

# Copy contents into the container
COPY . .

# Create a Conda environment and install Python dependencies
RUN /opt/conda/bin/conda create -y --name maxim python=3.10 && \
    /opt/conda/bin/conda run -n maxim pip install -r requirements.txt

# Set up the environment
RUN echo "/opt/conda/bin/conda init bash" >> ~/.bashrc && \
    echo "conda activate maxim" >> ~/.bashrc && \
    echo "Complete Setup of Maxim tf model!"

# Expose any necessary ports
EXPOSE 8080

# Set the default command to bash (or your desired script)
CMD ["/bin/bash"]
