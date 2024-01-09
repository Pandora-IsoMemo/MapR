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
      importDataUI(ns("file_import"), label = "Import ZIP file"),
      createVariableSelectionInputs(id),
      br(),
      fluidRow(
        column(12,
          align = "center",
          shinyjs::hidden(
            actionButtonUI(
              id = ns("display_plot"),
              label = "Display plot"
            )
          )
        )
      ),
      textFormatUI(ns("title"), label = "Title"),
    ),
    mainPanel(
      width = 10,
      fluidRow(
        column(12,
          align = "center",
          uiOutput(outputId = ns("plot_title"))
        )
      ),
      fluidRow(
        column(12,
          align = "center",
          plotUI(id = ns("mainplot"))
        )
      )
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
      questionnaire <- reactiveVal()

      # Load zip file
      uploadedZip <- importDataServer("file_import",
        importType = "zip",
        defaultSource = config()[["defaultSource"]],
        ckanFileTypes = config()[["ckanFileTypes"]],
        fileExtension = config()[["fileExtension"]],
        mainFolder = config()[["mainFolder"]],
        rPackageName = config()[["rPackageName"]]
        # expectedFileInZip = config()[["expectedFileInZip"]] # currently image list is not required if a questionnaire.json is included
      )

      # Show and hide inputs depending on image_list or questionnaire being available
      observeShowAndHideInputs(
        input = input,
        output = output,
        session = session,
        uploadedZip = uploadedZip,
        image_list = image_list,
        questionnaire = questionnaire,
        id = id
      )

      # Fill inputs based on uploaded image list (if image list is available)
      fillVariableSelectionInputs(input, session, image_list)

      # enable / disable actionButton
      # observe({
      #   if (!is.null(input[["group_name-selectize"]]) &&
      #     !is.null(input[["variable-selectize"]]) &&
      #     !is.null(input[["measure-selectize"]])) {
      #     shinyjs::enable(id = "display_plot-button")
      #   } else {
      #     shinyjs::disable(id = "display_plot-button")
      #   }
      # })

      # Show plot and plot formatting options when button is clicked
      observeShowPlot(
        input = input,
        output = output,
        session = session,
        image_list = image_list,
        questionnaire = questionnaire
      )

      # Plot Title
      output$plot_title <- renderUI({
        text <- input[["title-text"]]
        col <- input[["title-color"]]
        fontsize <- paste0(input[["title-fontsize"]], "px")
        style <- paste("font-size: ", fontsize, ";", "color: ", col, ";", sep = "")
        HTML(paste("<span style='", style, "'>", text, "</span>"))
      }) %>%
        bindEvent(
          c(
            input[["display_plot-button"]],
            input[["title-text"]],
            input[["title-fontsize"]],
            input[["title-color"]]
          ),
          ignoreInit = TRUE
        )
    }
  )
}
