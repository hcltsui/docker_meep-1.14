# Running meep on Docker
Running MIT Electromagnetic Equation Propagation (MEEP) on Docker

#### Build 
run `docker build -t meep-1.14 .` in the directory containing the `Dockerfile`

#### Run
link the current directory with the working directory `/usr/meep` in docker container and run interactively
```
docker run -it -v ${PWD}:/usr/meep meep-1.14 /bin/bash
```

#### Save
save docker image
```
docker save -o meep-1.14.tar meep-1.14
```

#### Load
load docker image 
```
docker load -i meep-1.14.tar
```

#### Version
harminv-1.4.1

libctl-4.5.0

h5utils-1.13.1

libGDSII-0.21

nlopt-2.6.2

mpb-1.10.0

meep-1.14.0

#### Reference
1. https://meep.readthedocs.io/en/latest/
