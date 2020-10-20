FROM ubuntu:18.04

LABEL description="meep with openblas"
LABEL harminv.version="1.4.1"
LABEL libctl.verison="4.5.0"
LABEL h5utils.version="1.13.1"
LABEL libGDSII.version="0.21"
LABEL nlopt.version="2.6.2"
LABEL mpb.version="1.10.0"
LABEL meep.version="1.14.0"

RUN apt-get update && apt-get -y install \
    build-essential \
    gfortran \
	libopenblas-dev \
    libgmp-dev \
    swig \
    libgsl-dev \
    autoconf \
    pkg-config \
    libpng-dev \
    guile-2.0-dev \
    libfftw3-dev \
    libhdf5-openmpi-dev \
    hdf5-tools \
    libpython3-dev \
    python3-pip \
    cmake \
	libmatheval-dev \
	ssh \
	wget && \
	cd tmp && \
	wget -O- https://github.com/NanoComp/harminv/releases/download/v1.4.1/harminv-1.4.1.tar.gz | tar -xz && cd harminv-1.4.1 && \
	./configure --enable-shared && make && make install && cd /tmp && rm -rf harminv-1.4.1 &&\
	wget -O- https://github.com/NanoComp/libctl/releases/download/v4.5.0/libctl-4.5.0.tar.gz | tar -xz && cd libctl-4.5.0 && \
	./configure --enable-shared && make && make install && cd /tmp && rm -rf libctl-4.5.0 && \
	wget -O- https://github.com/NanoComp/h5utils/releases/download/1.13.1/h5utils-1.13.1.tar.gz | tar -xz && cd h5utils-1.13.1 && \
	./configure CC=mpicc LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi -Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi" CPPFLAGS="-I/usr/local/include -I/usr/include/hdf5/openmpi" && \
	make && make install && cd /tmp && rm -rf h5utils-1.13.1 &&\
	wget -O- https://github.com/HomerReid/libGDSII/releases/download/v0.21/libgdsii-0.21.tar.gz | tar -xz && cd libgdsii-0.21 && \
	./configure --enable-shared && make && make install && cd /tmp && rm -rf libgdsii-0.21 && \
	wget -O- https://github.com/stevengj/nlopt/archive/v2.6.2.tar.gz | tar -xz && cd nlopt-2.6.2 && \
	cmake -DPYTHON_EXECUTABLE=/usr/bin/python3 && make && make install && cd /tmp && rm -rf nlopt-2.6.2 && cd /

ENV HDF5_MPI="ON"

RUN pip3 install --user --no-cache-dir mpi4py \
	Cython==0.29.16 \
	--no-binary=h5py h5py \
	autograd \
	scipy \
	matplotlib>3.0.0 \
	ffmpeg && \
	cd tmp && \
	wget -O- https://github.com/NanoComp/mpb/releases/download/v1.10.0/mpb-1.10.0.tar.gz | tar -xz && cd mpb-1.10.0 && \
	./configure --enable-shared CC=mpicc LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi -Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi" CPPFLAGS="-I/usr/local/include -I/usr/include/hdf5/openmpi" --with-hermitian-eps && \
	make && make install && cd /tmp && rm -rf mpb-1.10.0 && \
	wget -O- https://github.com/NanoComp/meep/releases/download/v1.14.0/meep-1.14.tar.gz | tar -xz && cd meep-1.14 && \
	./configure --enable-shared --with-mpi --with-openmp PYTHON=python3 LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi -Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi" CPPFLAGS="-I/usr/local/include -I/usr/include/hdf5/openmpi" && \
	make && make install && cd /tmp && rm -rf meep-1.14 && \
	cd / && mkdir /usr/meep

ENV PYTHONPATH=/usr/local/lib/python3.6/site-packages:/usr/local/lib/python3/dist-packages

CMD ["bash"]