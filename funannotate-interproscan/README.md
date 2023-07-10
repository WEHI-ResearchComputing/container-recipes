# Funannotate + Interproscan

Container which has both funannotate and interproscan installed. This container was created as the current interproscan doesn't work on old OSes like Centos 7.

The uncompressed docker image is huge (~45G) as it contains all the databases needed for funannotate and interproscan. Thanks to xz compression of `mksquashfs`, the apptainer image is about 10G.

## Run

### Docker

`docker run -v $(pwd):/work edoyango/interproscan-funannotate funannotate iprscan --iprscan_path /opt/interproscan/interproscan.sh -m local <other args>`

### Apptainer

`apptainer run -B $(pwd) docker://edoyango/interproscan-funannotate funannotate iprscan --iprscan_path /opt/interproscan/interposcan.sh -m local <other args>`
