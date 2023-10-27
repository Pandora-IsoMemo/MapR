FROM ghcr.io/pandora-isomemo/base-image:latest

ADD . .

RUN installPackage

CMD ["Rscript", "-e", "devtools::install_version('pastclim', version = '1.2.3', repos = 'http://cran.us.r-project.org');library(MapR);startApplication(3838)"]
