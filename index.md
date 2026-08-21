# MapR

An App to display temporal and temperature graphical files for Isomemo.

## Access to online versions:

- [MAIN version](https://pandoraapp.earth/app/mapr)
- [BETA version](https://pandoraapp.earth/app/mapr-beta)

## Release notes:

- see `NEWS.md`

## How to use this Package

Refer to the
[vignette](https://pandora-isomemo.github.io/MapR/articles/how-to-use-MapR.html)
for a description of the usage of the MapR package. You can find it in
the [documentation](https://pandora-isomemo.github.io/MapR/) of this
package.

## Notes for developers

When adding information to the *help* sites, *docstrings* or the
*vignette* of this package, please update documentation locally as
follows. The documentation of the main branch is build automatically via
github action.

``` r

devtools::document() # or CTRL + SHIFT + D in RStudio
devtools::build_site()
```

When testing with a local docker container, please make sure to rebuild
the docker image after changes in the R code or dependencies. You can do
this from the root of the repository via:

``` bash
docker build -t mapr-app:latest .
```

or for a full rebuild without cache:

``` bash
docker build --no-cache -t mapr-app:latest .
```

After that, start the container as usual via:

``` bash
docker run -p 3838:3838 mapr-app:latest
```

and access the app in your browser at `http://localhost:3838/`. Stop the
container with `CTRL + C` in the terminal.

**Optional:**

Add `-it` for interactive mode, or `--rm` to remove the container after
stopping.
