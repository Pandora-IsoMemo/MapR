FROM ghcr.io/pandora-isomemo/base-image:latest

ADD . .

RUN installPackage

CMD ["Rscript", "-e", "library(MapR);library(shiny);MapR::startApplication(3838)"]
