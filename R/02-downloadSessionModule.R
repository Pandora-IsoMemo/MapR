#' Create Inputs for Variable Selection
#'
#' @param id id of module
downloadSessionUI <- function(id) {
  ns <- NS(id)
  tagList(
    shinyjs::hidden(
      div(
        id = ns("download_options"),
        hr(),
        checkboxInput(
          inputId = ns("download_inputs"),
          label = "Download all user inputs",
          value = FALSE
        )
      )
    ),
    conditionalPanel(
      ns = ns,
      condition = "input.download_inputs == true",
      downloadModelUI(
        id = ns("session_download"),
        label = "Download Inputs"
      )
    )
  )
}

downloadSessionServer <- function(input, output, session, uploaded_zip, upload_description) {
  # export inputs and all files
  downloadModelServer("session_download",
                      dat = reactive(NULL),
                      inputs = input,
                      model = reactive(NULL),
                      pathToOtherZip = reactive(uploaded_zip()[[1]]),
                      rPackageName = config()[["rPackageName"]],
                      defaultFileName = config()[["defaultFileName"]],
                      fileExtension = config()[["fileExtension"]],
                      modelNotes = upload_description,
                      triggerUpdate = reactive(TRUE),
                      onlySettings = TRUE)
}
