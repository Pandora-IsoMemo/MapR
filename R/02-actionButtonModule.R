#' UI function of actionButton
#'
#' @param id module id
#' @param label label
#' @param ... further arguments passed to input
actionButtonUI <- function(id, label, ...) {
  ns <- NS(id)
  actionButton(
    inputId = ns("button"),
    label = label,
    ...
  )
}
