#' UI function of textFormat module
#'
#' @param id module id
#' @param label label
#' @param ... further arguments passed to input
#'
textFormatUI <- function(id, label, ...) {
  ns <- NS(id)
  shiny::tagList(
    shinyjs::hidden(
      div(
        id = ns("options"),
        hr(),
        textInput(inputId = ns("text"), label = paste0(label, " Text"), value = ""),
        fluidRow(
          column(
            6,
            numericInput(inputId = ns("fontsize"), label = paste0(label, " Font Size"), value = 20, min = 5),
          ),
          column(
            6,
            colourpicker::colourInput(
              inputId = ns("color"),
              label = paste0(label, " Color"),
              value = "#666666",
              showColour = "background",
              palette = "limited"
            )
          )
        )
      )
    )
  )
}
