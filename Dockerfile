FROM inwt/r-shiny:4.2.3

ADD . .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    qpdf \
    pandoc \
    libmagick++-dev \
    && echo "options(repos = c(getOption('repos'), PANDORA = 'https://Pandora-IsoMemo.github.io/drat/'))" >> /usr/local/lib/R/etc/Rprofile.site \
    && installPackage

CMD ["Rscript", "-e", "library(MapR);startApplication(3838)"]
