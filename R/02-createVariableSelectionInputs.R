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
              "Time data"
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
      fluidRow(
        column(6,
          align = "center",
          shinyjs::hidden(
            numericInput(
              inputId = ns("latitude"),
              label = "Latitude",
              value = 50.92,
              min = -90,
              max = 90
            )
          )
        ),
        column(6,
          align = "center",
          shinyjs::hidden(
            numericInput(
              inputId = ns("longitude"),
              label = "Longitude",
              value = 11.58,
              min = -180,
              max = 180
            )
          )
        )
      ),
      br(),
      fluidRow(
        column(12,
          align = "center",
          shinyjs::hidden(
            dataExportButton(
              id = ns("download")
            )
          )
        )
      )
    ))
  )
}
