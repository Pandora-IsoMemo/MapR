FROM ghcr.io/pandora-isomemo/r-shiny:4.2.1

ADD . .

RUN installPackage

CMD ["Rscript", "-e", "library(MapR);startApplication(3838)"]
