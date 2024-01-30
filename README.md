# MapR
An App to display temporal and temperature graphical files for Isomemo.

## Access to online versions:
- [MAIN version](https://pandoraapp.earth/app/mapr) 
- [BETA versions](https://pandoraapp.earth/app/mapr-beta)

## Release notes:
- see `NEWS.md`

## How to use this Package

Refer to the [vignette](https://pandora-isomemo.github.io/MapR/articles/how-to-use-MapR.html) 
for a description of the usage of the MapR package. You can find it in the 
[documentation](https://pandora-isomemo.github.io/MapR/) of this package.

----

## Notes for developers

When adding information to the _help_ sites, _docstrings_ or the _vignette_ of this 
package, please update documentation locally as follows. The documentation of
the main branch is build automatically via github action.

```R
devtools::document() # or CTRL + SHIFT + D in RStudio
devtools::build_site()
```
