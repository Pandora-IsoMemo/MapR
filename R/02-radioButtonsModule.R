#' UI function of radioButtons
#'
#' @param id module id
#' @param ... further arguments passed to input
#' @param choices choices for radioButtons
#'
radioButtonsUI <- function(id, choices, ...) {
  ns <- NS(id)
  radioButtons(
    inputId = ns("buttons"),
    label = NULL,
    choices = choices,
    inline = TRUE
  )
}
