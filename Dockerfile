FROM inwt/r-shiny:4.2.3

ADD . .

RUN installPackage \
  && echo "options(repos = c(getOption('repos'), PANDORA = 'https://Pandora-IsoMemo.github.io/drat/'))" >> /usr/local/lib/R/etc/Rprofile.site

CMD ["Rscript", "-e", "library(MapR);startApplication(3838)"]
