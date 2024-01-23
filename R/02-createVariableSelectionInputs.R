#' Create Inputs for Variable Selection
#'
#' @param id id of module
createVariableSelectionInputs <- function(id) {
  ns <- NS(id)
  tagList(
    shinyjs::hidden(div(
      br(), br(),
      id = ns("variable_selection_inputs"),
      selectizeInputUI(
        id = ns("group_name"),
        label = "Group Name",
        choices = NULL
      ),
      selectizeInputUI(
        id = ns("variable"),
        label = "Variable",
        choices = NULL
      ),
      selectizeInputUI(
        id = ns("measure"),
        label = "Measure",
        choices = NULL
      ),
      br(),
      column(12,
        align = "center",
        radioButtonsUI(
          id = ns("time_switch"),
          choices = setNames(
            c(1, 2),
            c(
              "Single Map",
              "Time plot"
            )
          )
        )
      ),
      # slider years are currently hardcoded and will be replaced later
      sliderInputUI(
        id = ns("time"),
        label = "Time",
        selected = 2015
      ),
      # note: it is not possible to update a single value slider to range slider
      # therefore we create two different sliders and toggle them based on the time_switch selection
      shinyjs::hidden(
        sliderInputUI(
          id = ns("time_range"),
          label = "Time",
          selected = c(2015, 2017)
        )
      ),
    ))
  )
}
