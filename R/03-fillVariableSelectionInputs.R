fillVariableSelectionInputs <- function(input, session, image_list) {
  # fill group input
  observe({
    choices <- unique(image_list()$Group)
    if (is.null(choices)) {
      choices <- ""
      placeholder <- "Please upload valid data"
    } else {
      placeholder <- "Please make a selection"
    }

    updateSelectizeInput(
      session = session,
      inputId = "group_name-selectize",
      choices = choices,
      selected = "",
      options = list(
        maxItems = 1,
        placeholder = placeholder
      )
    )
  }) %>%
    bindEvent(image_list(),
      ignoreNULL = FALSE,
      ignoreInit = TRUE
    )

  # fill variable input
  observe({
    updateSelectizeInput(
      session = session,
      inputId = "variable-selectize",
      choices = image_list()$Variable[image_list()$Group == input[["group_name-selectize"]]],
      selected = ""
    )
  }) %>%
    bindEvent(input[["group_name-selectize"]],
      ignoreNULL = FALSE,
      ignoreInit = TRUE
    )

  # fill measure input
  observe({
    updateSelectizeInput(
      session = session,
      inputId = "measure-selectize",
      choices = image_list()$Measure[image_list()$Group == input[["group_name-selectize"]] &
        image_list()$Variable == input[["variable-selectize"]]],
      selected = ""
    )
  }) %>%
    bindEvent(input[["variable-selectize"]],
      ignoreNULL = FALSE,
      ignoreInit = TRUE
    )

  # update time sliders
  observe({
    choices <- as.numeric(unlist(image_list()$x_display_value[image_list()$Group == input[["group_name-selectize"]] &
      image_list()$Variable == input[["variable-selectize"]] &
      image_list()$Measure == input[["measure-selectize"]]]))

    if (length(choices) == 1) choices <- c(choices, choices) # slider does not work for choices of length one

    shinyWidgets::updateSliderTextInput(
      session = session,
      inputId = "time-slider",
      choices = choices,
      selected = choices[1]
    )
    shinyWidgets::updateSliderTextInput(
      session = session,
      inputId = "time_range-slider",
      choices = choices,
      selected = c(min(choices), max(choices))
    )
  }) %>%
    bindEvent(input[["measure-selectize"]],
      ignoreNULL = FALSE,
      ignoreInit = TRUE
    )

  # update slider
  observe({
    if (input[["time_switch-buttons"]] == 1) {
      shinyjs::hide(id = "time_range-slider")
      shinyjs::show(
        id = "time-slider",
        anim = TRUE,
        animType = "fade",
        time = 1
      )
    } else {
      shinyjs::hide(id = "time-slider")
      shinyjs::show(
        id = "time_range-slider",
        anim = TRUE,
        animType = "fade",
        time = 1
      )
    }
  }) %>%
    bindEvent(input[["time_switch-buttons"]],
      ignoreInit = TRUE
    )
}
