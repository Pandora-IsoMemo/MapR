#' UI function of actionButton
#'
#' @param id module id
#' @param label label
#' @param ... further arguments passed to input
actionButtonUI <- function(id, label, ...) {
  ns <- NS(id)
  shinyjs::disabled(actionButton(
    inputId = ns("button"),
    label = label,
    ...
  ))
}
