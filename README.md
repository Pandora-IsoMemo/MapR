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

Refer to the vignette for a description of the usage of the MapR package. You can find it in the
[documentation](https://pandora-isomemo.github.io/MapR/) of this package.

----

### Notes for developers

When adding information to _help_ sites, _docstrings_ or the _vignette_ of this package, please update documentation locally as follows:

```R
devtools::document() # or CTRL + SHIFT + D in RStudio
devtools::build_site()
```
