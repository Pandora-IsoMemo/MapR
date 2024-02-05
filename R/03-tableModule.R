#' UI function of table module
#'
#' @param id id of module
tableUI <- function(id) {
  ns <- NS(id)
  DT::dataTableOutput(ns("table"), height = "800px", width = "80%")
}


#' Server function of table module
#'
#' @param id id of module
#' @param df data frame to be displayed in table
tableServer <- function(id, df) {
  moduleServer(
    id,
    function(input, output, session) {
      output$table <- DT::renderDataTable({
        DT::datatable(df,
          rownames = FALSE,
          # escape = FALSE,
          # filter = "top",
          style = "bootstrap",
          options = list(
            pageLength = 25
          ),
          selection = list(mode = "single", target = "cell")
        )
      })
    }
  )
}

#' Observer to show table when display button is clicked
#'
#' @param input input object from server function
#' @param output output object from server function
#' @param session session from server function
#' @param image_list reactive image list
#' @param table_data reactive table data
observeShowTable <- function(input, output, session, image_list, table_data) {
  observe({
    shinyjs::hide(id = "title-options")
    shinyjs::hide(id = "plot_title")
    shinyjs::hide(id = "mainplot-plot")
    shinyjs::show(id = "maintable-table")
    shinyjs::show(
      id = "download-export",
      anim = TRUE,
      animType = "fade",
      time = 1
    )
    imageInfos <- prepareImageListImage(input = input, image_list = image_list)
    locations <- data.frame(latitude = input[["latitude"]], longitude = input[["longitude"]])
    path <- paste0(tempdir(), "/data/", imageInfos$address)
    if (imageInfos$file_type[[1]] != "nc") {
      shinyjs::alert("file_type specified in json must be nc for time plot.")
    } else {
      df <- pastclim::location_series(
        x = locations,
        bio_variables = imageInfos$variable,
        dataset = "custom",
        path_to_nc = path
      )
      # Not sure if time column is always called time_bp. If not we need a different approach for filtering.
      df <- df[df$time_bp >= min(input[["time_range-slider"]]) &
         df$time_bp <= max(input[["time_range-slider"]]), ]
      df$name <- NULL
      table_data(df)
      tableServer(
        id = "maintable",
        df = df
      )
    }
  }) %>%
    bindEvent(input[["display_table-button"]],
      ignoreInit = TRUE
    )
}
