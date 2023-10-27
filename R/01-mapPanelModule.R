#' UI function of mapPanel module
#'
#' @param id module id
#'
#' @importFrom stats setNames
#' @export
mapPanelUI <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      width = 2,
      fileInput(
        inputId = ns("file"),
        label = "Upload zip file",
        accept = ".zipm"
      ),
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
      plotUI(id = ns("mainplot"))
    )
  )
}


#' Server function of mapPanel module
#'
#' @param id module id
#' @export
mapPanelServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      image_list <- reactiveVal()
      # load zip file
      observe({
        datapath <- input[["file"]]$datapath
        if (substr(datapath, nchar(datapath) - 5 + 1, nchar(datapath)) != ".zipm") {
          shinyjs::alert("Only .zipm files are supported!")
        } else {
          utils::unzip(datapath, exdir = tempdir())
          image_list(convertJsonToDataFrame(file = paste0(tempdir(), "/image_list.json")))
        }
      }) %>% bindEvent(input[["file"]])

      # fill group input
      observe({
        choices <- unique(image_list()$Group)
        if(is.null(choices)){
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

      # show plot when button is clicked
      observe({
        address <- image_list()$address[image_list()$Group == input[["group_name-selectize"]] &
          image_list()$Variable == input[["variable-selectize"]] &
          image_list()$Measure == input[["measure-selectize"]] &
          image_list()$x_display_value == input[["time-slider"]]]

        file_type <- image_list()$file_type[image_list()$Group == input[["group_name-selectize"]] &
          image_list()$Variable == input[["variable-selectize"]] &
          image_list()$Measure == input[["measure-selectize"]] &
          image_list()$x_display_value == input[["time-slider"]]]

        # For file_type == "nc" variable name, measure and time is not included in the data path.
        # Therefore we use the values specified by the user.
        if (file_type == "nc") {
          variable <- input[["variable-selectize"]]
          measure <- input[["measure-selectize"]]
          time <- input[["time-slider"]]
        } else {
          variable <- NULL
          measure <- NULL
          time <- NULL
        }

        path <- paste0(tempdir(), "/data/", address)

        plotServer(
          id = "mainplot",
          path = path,
          file_type = file_type,
          variable = variable,
          measure = measure,
          time = time
        )
      }) %>%
        bindEvent(input[["display_plot-button"]],
          ignoreInit = TRUE
        )
    }
  )
}
