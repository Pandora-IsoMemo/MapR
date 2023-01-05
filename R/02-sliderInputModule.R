#' UI function of sliderInput
#'
#' @param id module id
#' @param label label
#' @param ... further arguments passed to input
#'
sliderInputUI <- function(id, label, ...) {
  ns <- NS(id)
  sliderInput(
    inputId = ns("slider"),
    label = label,
    min = 2010,
    max = 2020,
    value = 2015,
    sep = ""
  )
}
