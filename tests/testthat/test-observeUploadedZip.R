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

test_that("zip upload imports saved session inputs and notes", {
  shiny::testServer(server, {
    zip_file <- system.file(
      "app/exampleZip/mapR_test_session.mapr",
      package = "MapR",
      mustWork = TRUE
    )

    upload_zip(session, uploaded_zip, zip_file)

    expect_type(uploaded_inputs(), "list")
    expect_true("inputs" %in% names(uploaded_inputs()))
    expect_gt(length(uploaded_inputs()[["inputs"]]), 0)
    expect_false(is.null(upload_description()))
  })
})

test_that("zip upload without questionnaire creates an image list", {
  shiny::testServer(server, {
    zip_file <- system.file(
      "app/exampleZip/example_data.mapr",
      package = "MapR",
      mustWork = TRUE
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
    zip_file <- system.file(
      "app/exampleZip/example_data_questionnaire.mapr",
      package = "MapR",
      mustWork = TRUE
    )

    upload_zip(session, uploaded_zip, zip_file)

    expect_type(questionnaire(), "list")
    expect_true("Questions" %in% names(questionnaire()))
    expect_true("Plots" %in% names(questionnaire()))
    expect_gt(length(questionnaire()[["Questions"]]), 0)
  })
})