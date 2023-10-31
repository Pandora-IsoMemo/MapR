FROM inwt/r-shiny:4.2.3

ADD . .

RUN echo "options(repos = c(getOption('repos'), PANDORA = 'https://Pandora-IsoMemo.github.io/drat/'))" >> /usr/local/lib/R/etc/Rprofile.site \
  && installPackage

CMD ["Rscript", "-e", "library(MapR);startApplication(3838)"]
