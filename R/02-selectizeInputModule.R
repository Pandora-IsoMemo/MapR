#' UI function of selectizeInput
#'
#' @param id module id
#' @param label label
#' @param ... further arguments passed to input
#'
selectizeInputUI <- function(id, label, ...) {
  ns <- NS(id)
  selectizeInput(
    inputId = ns("selectize"),
    label = label,
    multiple = TRUE,
    options = list(
      maxItems = 1,
      placeholder = "Please make a selection"
    ),
    ...
  )
}
