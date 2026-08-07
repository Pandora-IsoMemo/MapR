FROM inwt/r-shiny:4.4.3

RUN Rscript -e "remotes::install_github(c('r-lib/httr2@v1.2.3', 'tidyverse/ellmer@v0.4.1'))"

COPY . .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    qpdf \
    pandoc \
    libmagick++-dev \
    && echo "options(repos = c(getOption('repos'), PANDORA = 'https://Pandora-IsoMemo.github.io/drat/'))" >> /usr/local/lib/R/etc/Rprofile.site \
    && installPackage

CMD ["Rscript", "-e", "library(MapR);startApplication(3838)"]
