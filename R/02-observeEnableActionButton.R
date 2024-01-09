#' Enables or disables the action button depending on the availability of the input variables
#'
#' @param input input object from server function
#' @param image_list reactive image list
#' @param questionnaire reactive questionnaire
observeEnableActionButton <- function(input, image_list, questionnaire) {
observe({
  if(!is.null(image_list())){ # in case image_list is available
    if (!is.null(input[["group_name-selectize"]]) &&
        !is.null(input[["variable-selectize"]]) &&
        !is.null(input[["measure-selectize"]])) {
      shinyjs::enable(id = "display_plot-button")
    } else {
      shinyjs::disable(id = "display_plot-button")
    }
  } else { # in case questionnaire is available
    inputsFilled <- sapply(1:length(questionnaire()$Questions), function(x) (!is.null(input[[paste0("question_", x)]]) && !is.na(input[[paste0("question_", x)]])))
    if(all(inputsFilled)){
      shinyjs::enable(id = "display_plot-button")
    } else {
      shinyjs::disable(id = "display_plot-button")
    }

  }
})
}
