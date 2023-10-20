#' UI function of mapPanel module
#'
#' @param id module id
#'
#' @importFrom stats setNames
#'
mapPanelUI <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectizeInputUI(
        id = ns("group_name"),
        label = "Group Name",
        choices = unique(image_list$Group),
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
        value = 2015
      ),
      # note: it is not possible to update a single value slider to range slider
      # therefore we create two different sliders and toggle them based on the time_switch selection
      shinyjs::hidden(
        sliderInputUI(
          id = ns("time_range"),
          label = "Time",
          value = c(2015, 2017)
        )
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
          choices <- image_list$Variable[image_list$Group == input[["group_name-selectize"]]]
        } else {
          choices <- ""
        }
        updateSelectizeInput(
          session = session,
          inputId = "variable-selectize",
          choices = choices,
          selected = ""
        )
      }) %>%
        bindEvent(input[["group_name-selectize"]],
          ignoreNULL = FALSE,
          ignoreInit = TRUE
        )

      # fill measure input
      observe({
        if (!is.null(input[["variable-selectize"]])) {
          choices <- image_list$Measure[image_list$Group == input[["group_name-selectize"]] &
            image_list$Variable == input[["variable-selectize"]]]
        } else {
          choices <- ""
        }
        updateSelectizeInput(
          session = session,
          inputId = "measure-selectize",
          choices = choices,
          selected = ""
        )
      }) %>%
        bindEvent(input[["variable-selectize"]],
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
