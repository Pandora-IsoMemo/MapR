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
      importDataUI(ns("file_import"), label = "Load MapR file"),
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
          ),
          shinyjs::hidden(
            actionButtonUI(
              id = ns("display_table"),
              label = "Display time data"
            )
          )
        )
      ),
      textFormatUI(ns("title"), label = "Title"),
      downloadSessionUI(id)
    ),
    mainPanel(
      width = 10,
      fluidRow(
        column(12,
          align = "left",
          plotUI(id = ns("mainplot")),
          tableUI(id = ns("maintable"))
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
      table_data <- reactiveVal()
      uploaded_inputs <- reactiveVal()
      upload_description <- reactiveVal()

      # Load zip file
      uploaded_zip <- importDataServer("file_import",
        importType = "zip",
        defaultSource = config()[["defaultSource"]],
        ckanFileTypes = config()[["ckanFileTypes"]],
        fileExtension = config()[["fileExtension"]],
        options = importOptions(rPackageName = config()[["rPackageName"]])
        # expectedFileInZip = config()[["expectedFileInZip"]] # currently image list is not required if a questionnaire.json is included
      )

      # Show and hide inputs depending on image_list or questionnaire being available
      # extract image list and questionnaire from zip file if they exist
      # extract inputs and description from zip file if they exist
      observeUploadedZip(
        input = input,
        output = output,
        session = session,
        uploaded_zip = uploaded_zip,
        image_list = image_list,
        questionnaire = questionnaire,
        uploaded_inputs = uploaded_inputs,
        upload_description = upload_description,
        id = id
      )

      # Fill inputs based on uploaded image list (if image list is available)
      fillVariableSelectionInputs(input, session, image_list, uploaded_inputs)

      # Enable / disable actionButton
      observeEnableActionButton(input, image_list, questionnaire)

      # setup download of a session
      downloadSessionServer(input, output, session, uploaded_zip, upload_description)

      title_format <- reactiveValues()

      observe({
        title_format[["text"]] <- input[["title-text"]]
        title_format[["color"]] <- input[["title-color"]]
        title_format[["size"]] <- input[["title-fontsize"]]
      })

      # Show plot and plot formatting options when button is clicked
      observeShowPlot(
        input = input,
        output = output,
        session = session,
        image_list = image_list,
        questionnaire = questionnaire,
        title_format = title_format
      )

      observeShowTable(
        input = input,
        output = output,
        session = session,
        image_list = image_list,
        table_data = table_data,
        title_format = title_format
      )

      dataExportServer(
        id = "download",
        dataFun = reactive({
          function() table_data()
        }),
        filename = "data"
      )
    }
  )
}
