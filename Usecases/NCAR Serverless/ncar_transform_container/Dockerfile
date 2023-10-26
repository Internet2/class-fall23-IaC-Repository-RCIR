FROM mcr.microsoft.com/devcontainers/miniconda:0-3


RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt update
RUN apt install google-cloud-sdk vim -y

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml* .noenv.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n ncar_transform -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# RUN apt update
# RUN apt install -y libhdf5-serial-dev libhdf5-serial libhdf5-7 python-h5py libhdf5-dev hdf5-tools hdf5-helpers libhdf5-7-dbg
RUN userdel vscode
RUN useradd -ms /bin/bash ncar

# Set ncar user to automatically start with ncar_transform environment
RUN mkdir /home/ncar/scripts/
COPY *py /home/ncar/scripts/
COPY *sh /home/ncar/scripts

RUN chown -R ncar /home/ncar/scripts/
RUN chmod -R 755 /home/ncar/scripts

RUN mkdir /share
RUN chmod -R 777 /share

USER ncar
RUN /opt/conda/condabin/conda init bash
RUN /opt/conda/condabin/conda init zsh
RUN echo "conda activate ncar_transform" >> /home/ncar/.bashrc
RUN echo "conda activate ncar_transform" >> /home/ncar/.zshrc

WORKDIR /home/ncar/scripts/
ENTRYPOINT ["./process.bash"]