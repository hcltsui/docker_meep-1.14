FROM ubuntu:18.04

LABEL description="meep dependencies"
LABEL harminv.version="1.4.1"
LABEL libctl.verison="4.5.0"
LABEL h5utils.version="1.13.1"
LABEL libGDSII.version="0.21"
LABEL nlopt.version="2.6.2"
LABEL mpb.version="1.10.0"
LABEL meep.version="1.14.0"

RUN apt-get update && apt-get -y install \
    build-essential         \
    gfortran                \
    libblas-dev             \
    liblapack-dev           \
    libgmp-dev              \
    swig                    \
    libgsl-dev              \
    autoconf                \
    pkg-config              \
    libpng-dev              \
    git                     \
    guile-2.0-dev           \
    libfftw3-dev            \
    libhdf5-openmpi-dev     \
    hdf5-tools              \
    libpython3-dev          \
    python3-pip             \
    cmake                   \
	libmatheval-dev			\
	wget

RUN cd tmp && \
	git clone https://github.com/NanoComp/harminv.git && cd harminv && \
	bash autogen.sh --enable-shared && make && make install && cd .. && rm -rf harminv &&\
	git clone https://github.com/NanoComp/libctl.git && cd libctl && \
	bash autogen.sh --enable-shared && make && make install && cd .. && rm -rf libctl && \
	git clone https://github.com/NanoComp/h5utils.git && cd h5utils && \
	bash autogen.sh CC=mpicc LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi -Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi" CPPFLAGS="-I/usr/local/include -I/usr/include/hdf5/openmpi" && \
	make && make install && cd .. && rm -rf h5utils &&\
	git clone http://github.com/HomerReid/libGDSII && cd libGDSII && \
	bash autogen.sh --enable-shared && make && make install && cd .. && rm -rf libGDSII && \
	git clone https://github.com/stevengj/nlopt.git && cd nlopt && \
	cmake -DPYTHON_EXECUTABLE=/usr/bin/python3 && make && make install && cd .. && rm -rf nlopt && cd /

ENV HDF5_MPI="ON"

RUN pip3 install --user --no-cache-dir mpi4py \
	Cython==0.29.16 \
	--no-binary=h5py h5py \
	autograd \
	scipy \
	matplotlib>3.0.0 \
	ffmpeg 

RUN cd tmp && \
	git clone https://github.com/NanoComp/mpb.git && cd mpb && \
	bash autogen.sh --enable-shared CC=mpicc LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi -Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi" CPPFLAGS="-I/usr/local/include -I/usr/include/hdf5/openmpi" --with-hermitian-eps && \
	make && make install && cd .. && rm -rf mpb && \
	wget https://github.com/NanoComp/meep/archive/v1.14.0.tar.gz && \
	tar -xvzf v1.14.0.tar.gz && rm v1.14.0.tar.gz && cd meep-1.14.0 && \
	bash autogen.sh --enable-shared --with-mpi --with-openmp PYTHON=python3 LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi -Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi" CPPFLAGS="-I/usr/local/include -I/usr/include/hdf5/openmpi" && \
	make && make install && cd .. && rm -rf meep-1.14.0 && \
	cd / && mkdir /usr/meep

ENV PYTHONPATH=/usr/local/lib/python3.6/site-packages:/usr/local/lib/python3/dist-packages

CMD ["bash"]