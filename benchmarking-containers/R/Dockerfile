FROM continuumio/miniconda3

RUN conda install r-base=4.2.1 python=3.11.7 && conda clean -a
RUN R -e "install.packages(c('Matrix', 'SuppDists'), repo='https://cloud.r-project.org/')"