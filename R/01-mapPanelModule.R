#' UI function of mapPanel module
#'
#' @param id module id
#'
mapPanelUI <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectizeInputUI(
        id = ns("group_name"),
        label = "Group Name",
        choices = unique(image_list$Group_name),
        selected = NULL
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
          choices = c(
            "Single Map",
            "Time plot"
          )
        )
      ),
      sliderInputUI(
        id = ns("time"),
        label = "Time"
      ),
      br(),
      fluidRow(
        column(12,
          align = "center",
          actionButtonUI(
            id = ns("display_plot"),
            label = "Display plot"
          )
        )
      )
    ),
    mainPanel(
      tags$h3("map placeholder")
    )
  )
}


#' Server function of mapPanel module
#'
#' @param id module id
#'
mapPanelServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      # fill variable input
      observe({
        if (!is.null(input[["group_name-selectize"]])) {
          choices <- image_list$Variable[image_list$Group_name == input[["group_name-selectize"]]]
        } else {
          choices <- NULL
        }
        updateSelectizeInput(
          session = session,
          inputId = "variable-selectize",
          choices = choices,
          selected = NULL
        )
      }) %>%
        bindEvent(input[["group_name-selectize"]])

      # fill measure input
      observe({
        if (!is.null(input[["variable-selectize"]])) {
          choices <- image_list$Measure[image_list$Group_name == input[["group_name-selectize"]] &
            image_list$Variable == input[["variable-selectize"]]]
        } else {
          choices <- NULL
        }
        updateSelectizeInput(
          session = session,
          inputId = "measure-selectize",
          choices = choices,
          selected = NULL
        )
      }) %>%
        bindEvent(input[["variable-selectize"]])


      # enable / disable actionButton
      observe({
        if (!is.null(input[["group_name-selectize"]]) &&
          !is.null(input[["variable-selectize"]]) &&
          !is.null(input[["measure-selectize"]])) {
          shinyjs::enable(id = "display_plot-button")
        } else {
          shinyjs::disable(id = "display_plot-button")
        }
      })
    }
  )
}
