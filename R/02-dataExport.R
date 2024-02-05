#' UI function of data export button
#'
#' @param id id of module
#' @param title title of button
dataExportButton <- function(id, title = "Export Data") {
  ns <- NS(id)
  actionButton(ns("export"), title)
}

#' Server function of data export module
#'
#' @param input input object from server function
#' @param output output object from server function
#' @param session session from server function
#' @param df data frame to be exported
#' @param filename name of file
dataExport <- function(input, output, session, df, filename = "data") {
  observe({
    showModal(modalDialog(
      "Export Data",
      easyClose = TRUE,
      footer = modalButton("OK"),
      selectInput(
        session$ns("exportType"),
        "File type",
        choices = c("csv", "xlsx", "json"),
        selected = "xlsx"
      ),
      conditionalPanel(
        condition = "input['exportType'] == 'csv'",
        ns = session$ns,
        div(
          style = "display: inline-block;horizontal-align:top; width: 80px;",
          textInput(session$ns("colseparator"), "column separator:", value = ",")
        ),
        div(
          style = "display: inline-block;horizontal-align:top; width: 80px;",
          textInput(session$ns("decseparator"), "decimal separator:", value = ".")
        ),
        br(),
        br()
      ),
      downloadButton(session$ns("exportExecute"), "Export")
    ))
  }) %>% bindEvent(input[["download-export"]], ignoreInit = TRUE)

  output$exportExecute <- downloadHandler(
    filename = function() {
      exportFilename(filename, input$exportType)
    },
    content = function(file) {
      switch(input$exportType,
        csv = exportCSV(file, df(), input$colseparator, input$decseparator),
        xlsx = exportXLSX(file, df()),
        json = exportJSON(file, df())
      )
    }
  )
}

#' Filename of Export
#'
#' @param fileending character csv or xlsx
#' @param filename name of file
exportFilename <- function(filename = "isotopeData", fileending) {
  paste(filename, fileending, sep = ".")
}

#' Export to csv
#'
#' @param file filename
#' @param dat data.frame
#' @param colseparator column seperator
#' @param decseparator decimal seperator
exportCSV <- function(file, dat, colseparator, decseparator) {
  write.table(
    x = dat, file = file, sep = colseparator,
    dec = decseparator, row.names = FALSE
  )
}

#' Export to xlsx
#'
#' @param file filename
#' @param dat data.frame
exportXLSX <- function(file, dat) {
  openxlsx::write.xlsx(dat, file)
}

#' Export to json
#'
#' @param file filename
#' @param dat data.frame
exportJSON <- function(file, dat) {
  json <- rjson::toJSON(dat)
  write(json, file)
}
