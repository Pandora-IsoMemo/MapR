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
      questionnaire <- reactiveVal()

      # load zip file
      uploadedZip <- importDataServer("file_import",
        defaultSource = "file",
        importType = "zip",
        fileExtension = "zipm",
        mainFolder = "exampleZip"
      )

      # load inputs depending on content of zip file
      observe({
        # reset plot and image list (also resets inputs)
        output[["mainplot-plot"]] <- NULL
        image_list(NULL)

        req(length(uploadedZip()) > 0)
        datapath <- uploadedZip()[[1]]
        utils::unzip(datapath, exdir = tempdir()) # extract zip file to tempdir

        if ("questionnaire.json" %in% utils::unzip(datapath, list = TRUE)$Name) { # if questionnaire is present
          shinyjs::hide(id = "variable_selection_inputs") # hide variable selection inputs
          removeUI(selector = "#map_panel-questionnaire_inputs", immediate = TRUE) #  remove old questionnaire inputs
          questionnaire(rjson::fromJSON(file = paste0(tempdir(), "/questionnaire.json"))) # load new questionnaire
          createQuestionnaireInputs(id, questionnaire()) # create new questionnaire inputs
        } else { # if no questionnaire is present
          image_list(convertImageListToDataFrame(file = paste0(tempdir(), "/image_list.json"))) # fill image list
          shinyjs::show(
            id = "variable_selection_inputs",
            anim = TRUE,
            animType = "fade",
            time = 1
          ) # show variable selection inputs
          removeUI(selector = "#map_panel-questionnaire_inputs", immediate = TRUE) #  remove old questionnaire inputs
          questionnaire(NULL) # reset questionnaire
        }

        shinyjs::show(
          id = "display_plot-button",
          anim = TRUE,
          animType = "fade",
          time = 1
        )
      }) %>% bindEvent(uploadedZip())

      # fill inputs based on uploaded image list
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
