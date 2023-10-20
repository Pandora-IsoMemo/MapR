#' UI function of sliderInput
#'
#' @param id module id
#' @param label label
#' @param ... further arguments passed to input
#'
sliderInputUI <- function(id, label, ...) {
  ns <- NS(id)
  shinyWidgets::sliderTextInput(
    inputId = ns("slider"),
    label = label,
    choices = c(2010:2020),
    grid = TRUE,
    ...
  )
}
