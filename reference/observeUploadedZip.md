# Observer for zip upload

Observer to show and hide inputs based on the zip file content. If a
questionnaire is present, the variable selection inputs are hidden and
the questionnaire inputs are shown. If no questionnaire is present, the
variable selection inputs are shown and the questionnaire inputs are
hidden. The observer also extracts the questionnaire and image list from
the zip file. If existing, the observer extracts the notes and inputs
from the zip file.

## Usage

``` r
observeUploadedZip(
  input,
  output,
  session,
  uploaded_zip,
  image_list,
  questionnaire,
  uploaded_inputs,
  upload_description,
  id
)
```

## Arguments

- input:

  input object from server function

- output:

  output object from server function

- session:

  session from server function

- uploaded_zip:

  reactive value of uploaded zip file

- image_list:

  reactive value of image list

- questionnaire:

  reactive value of questionnaire

- uploaded_inputs:

  reactive value of uploaded inputs

- upload_description:

  reactive value of upload description

- id:

  module id
