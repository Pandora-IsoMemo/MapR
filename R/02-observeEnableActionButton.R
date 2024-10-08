#' Enables or disables the action button depending on the availability of the input variables
#'
#' @param input input object from server function
#' @param image_list reactive image list
#' @param questionnaire reactive questionnaire
observeEnableActionButton <- function(input, image_list, questionnaire) {
  observe({
    if (!is.null(image_list())) { # in case image_list is available
      shinyjs::show(
        id = "download_options",
        anim = TRUE,
        animType = "fade",
        time = 1
      )

      if (input[["time_switch-buttons"]] == 1) {
        shinyjs::hide(id = "display_table-button")
        shinyjs::hide(id = "latitude")
        shinyjs::hide(id = "longitude")
        shinyjs::hide(id = "download-export")
        shinyjs::show(
          id = "display_plot-button",
          anim = TRUE,
          animType = "fade",
          time = 1
        )
      } else {
        shinyjs::hide(id = "display_plot-button")
        shinyjs::show(
          id = "display_table-button",
          anim = TRUE,
          animType = "fade",
          time = 1
        )
        shinyjs::show(
          id = "latitude",
          anim = TRUE,
          animType = "fade",
          time = 1
        )
        shinyjs::show(
          id = "longitude",
          anim = TRUE,
          animType = "fade",
          time = 1
        )
      }
      if (!is.null(input[["group_name-selectize"]]) &&
        !is.null(input[["variable-selectize"]]) &&
        !is.null(input[["measure-selectize"]])) {
        shinyjs::enable(id = "display_plot-button")
        shinyjs::enable(id = "display_table-button")
      } else {
        shinyjs::disable(id = "display_plot-button")
        shinyjs::disable(id = "display_table-button")
      }
    } else if (!is.null(questionnaire())) { # in case questionnaire is available
      shinyjs::hide(id = "display_table-button")
      shinyjs::show(
        id = "display_plot-button",
        anim = TRUE,
        animType = "fade",
        time = 1
      )
      inputsFilled <- sapply(1:length(questionnaire()$Questions), function(x) (!is.null(input[[paste0("question_", x)]]) && !is.na(input[[paste0("question_", x)]])))
      if (all(inputsFilled)) {
        shinyjs::enable(id = "display_plot-button")
      } else {
        shinyjs::disable(id = "display_plot-button")
      }
    }
  })
}
