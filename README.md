# MapR
An App to display temporal and temperature graphical files for Isomemo.

### Access to online versions:
- MAIN versions:
  - https://pandoraapp.earth/app/mapr 
- BETA versions:
  - https://pandoraapp.earth/app/mapr-beta

### Release notes:
- see `NEWS.md`

## How to use this Package

Refer to the vignette for a description of the usage of the MapR package.

----

### Notes for developers

When adding information to _help_ sites, _docstrings_ or the _vignette_ of this package, 
please update documentation locally as follows:

devtools::document() # or CTRL + SHIFT + D in RStudio
devtools::build_site()

----

### Notes for developers

When adding information to _help_ sites or the _vignette_ of this package, please update the static HTML documentation with `devtools::build_site()`, and push all changes.
