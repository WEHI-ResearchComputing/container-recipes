FROM continuumio/miniconda3

RUN apt-get update && apt-get install libarchive13 -y
RUN conda install --override-channels -c conda-forge -c bioconda r-base=4.2.1 python=3.11.7 -y && conda clean -ay
RUN R -e "install.packages(c('Matrix', 'SuppDists'), repo='https://cloud.r-project.org/')"