# MapR 25.04.0

## Updates
- reduce package size by adding example files to the `.Rbuildignore`
- remove warning from import module 

# MapR 24.10.0

## Updates
- mapr file extension is used instead of zipm
- labels for inputs have been updated

# MapR 24.6.0

## New Features
- option to download all user inputs together with the content of the zip files of all imported
  figures (#29)

# MapR 24.3.0

## Updates
- applying exportData module from shinyTools package, removing the code from this package

# MapR 24.2.1

## New Features
- display and download of time plot data

# MapR 24.2.0

## New Features
- adds header with Pandora, IsoMemo and help links

# MapR 24.1.2

## Bug Fixes
- apply most recent DataTools version to fix the broken path to the example zip files

# MapR 24.1.1

## New Features

Automation of Online Package Documentation via Github Action

# MapR 24.1.0

## New Features
- user can fill out questionnaires and images are displayed depending on the answers

# MapR 23.12.1

## New Features
- _Import from Pandora_: 
  - display of "About" information that is associated to a selected Pandora Repository

# MapR 23.11.0

## New Features
- option to add and format a plot title.

# MapR 23.10.1

## New Features
- option to upload zip files via the import module from `DataTools`. Enables access to 
  files from URL, Pandora Platform, local files, and online examples
- Example data is taken from:

    ```
    #> Documentation for the Beyer2020 dataset
    #> 
    #> Description:
    #> 
    #>      This dataset covers the last 120k years, at intervals of 1/2 k
    #>      years, and a resolution of 0.5 degrees in latitude and longitude.
    #> 
    #> Details:
    #> 
    #>      If you use this dataset, make sure to cite the original
    #>      publication:
    #> 
    #>      Beyer, R.M., Krapp, M. & Manica, A. High-resolution terrestrial
    #>      climate, bioclimate and vegetation for the last 120,000 years. Sci
    #>      Data 7, 236 (2020). doi:doi.org/10.1038/s41597-020-0552-1
    #>      <https://doi.org/doi.org/10.1038/s41597-020-0552-1>
    #> 
    #>      The version included in 'pastclim' has the ice sheets masked, as
    #>      well as internal seas (Black and Caspian Sea) removed. The latter
    #>      are based on:
    #> 
    #>      <https://www.marineregions.org/gazetteer.php?p=details&id=4278>
    #> 
    #>      <https://www.marineregions.org/gazetteer.php?p=details&id=4282>
    #> 
    #>      As there is no reconstruction of their depth through time, modern
    #>      outlines were used for all time steps.
    #> 
    #>      Also, for bio15, the coefficient of variation was computed after
    #>      adding one to monthly estimates, and it was multiplied by 100
    #>      following <https://pubs.usgs.gov/ds/691/ds691.pdf>
    #> 
    #>      Changelog
    #> 
    #>      v1.1.0 Added monthly variables. Files can be downloaded from:
    #>      <https://zenodo.org/deposit/7062281>
    #> 
    #>      v1.0.0 Remove ice sheets and internal seas, and use correct
    #>      formula for bio15. Files can be downloaded from:
    #>      doi:doi.org/10.6084/m9.figshare.19723405.v1
    #>      <https://doi.org/doi.org/10.6084/m9.figshare.19723405.v1>
    ```
