server <- function(input, output, session) {
  uploaded_zip <- shiny::reactiveVal(character())
  image_list <- shiny::reactiveVal()
  questionnaire <- shiny::reactiveVal()
  uploaded_inputs <- shiny::reactiveVal()
  upload_description <- shiny::reactiveVal()

  observeUploadedZip(
    input = input,
    output = output,
    session = session,
    uploaded_zip = uploaded_zip,
    image_list = image_list,
    questionnaire = questionnaire,
    uploaded_inputs = uploaded_inputs,
    upload_description = upload_description,
    id = "map_panel"
  )
}

upload_zip <- function(session, uploaded_zip, zip_file) {
  session$flushReact()
  uploaded_zip(zip_file)
  session$flushReact()
}

create_mapr_zip <- function(files) {
  bundle_dir <- tempfile("mapr-upload-")
  dir.create(bundle_dir)

  for (file_name in names(files)) {
    file_path <- file.path(bundle_dir, file_name)
    dir.create(dirname(file_path), recursive = TRUE, showWarnings = FALSE)

    if (identical(file_name, "inputs.rds")) {
      saveRDS(files[[file_name]], file_path)
    } else {
      writeLines(files[[file_name]], file_path)
    }
  }

  zip_file <- tempfile(fileext = ".mapr")
  old_wd <- setwd(bundle_dir)
  on.exit(setwd(old_wd), add = TRUE)
  utils::zip(zipfile = zip_file, files = list.files(recursive = TRUE), flags = "-r9Xq")

  zip_file
}

saved_inputs <- list(
  data = NULL,
  inputs = list(
    `group_name-selectize` = "Test Group",
    `variable-selectize` = "Test Variable",
    `measure-selectize` = "Mean",
    `title-text` = "Imported title"
  ),
  model = NULL,
  version = "MapR test"
)

image_list_json <- '{
  "Selections": [
    {
      "Group_DOI": "group-doi",
      "Group": "Test Group",
      "Variable": [
        {
          "Variable_DOI": "variable-doi",
          "Variable_name": "Test Variable",
          "Measure": [
            {
              "Measure_name": "Mean",
              "Measure_unit": "unit",
              "images": [
                {
                  "x_display_value": "1000",
                  "file_type": "png",
                  "location_type": "local",
                  "address": "data/test.png"
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}'

questionnaire_json <- '{
  "Questions": [
    {
      "Question_ID": 1,
      "Question": "Choose an option:",
      "Type": "multiple choice",
      "Answers": ["Option A", "Option B"],
      "Fill_Value": "Option A"
    }
  ],
  "Plots": [
    {
      "Title": "Test plot",
      "Address": "data/test.png",
      "File_type": "png",
      "Answers": [
        {
          "Question": 1,
          "Answer": "Option A",
          "Type": "=="
        }
      ]
    }
  ]
}'

test_that("zip upload imports saved session inputs and notes", {
  shiny::testServer(server, {
    zip_file <- create_mapr_zip(
      list(
        "image_list.json" = image_list_json,
        "inputs.rds" = saved_inputs,
        "README.txt" = "Imported notes"
      )
    )

    upload_zip(session, uploaded_zip, zip_file)

    expect_type(uploaded_inputs(), "list")
    expect_true("inputs" %in% names(uploaded_inputs()))
    expect_gt(length(uploaded_inputs()[["inputs"]]), 0)
    expect_equal(upload_description(), "Imported notes")
  })
})

test_that("zip upload without questionnaire creates an image list", {
  shiny::testServer(server, {
    zip_file <- create_mapr_zip(
      list(
        "image_list.json" = image_list_json,
        "inputs.rds" = saved_inputs,
        "README.txt" = "Imported notes"
      )
    )

    upload_zip(session, uploaded_zip, zip_file)

    expect_s3_class(image_list(), "data.frame")
    expect_gt(nrow(image_list()), 0)
    expect_true(all(c("Group", "Variable", "Measure", "address") %in% names(image_list())))
    expect_null(questionnaire())
  })
})

test_that("zip upload with questionnaire loads questionnaire data", {
  shiny::testServer(server, {
    zip_file <- create_mapr_zip(
      list(
        "questionnaire.json" = questionnaire_json,
        "inputs.rds" = saved_inputs,
        "README.txt" = "Imported notes"
      )
    )

    upload_zip(session, uploaded_zip, zip_file)

    expect_type(questionnaire(), "list")
    expect_true("Questions" %in% names(questionnaire()))
    expect_true("Plots" %in% names(questionnaire()))
    expect_gt(length(questionnaire()[["Questions"]]), 0)
  })
})