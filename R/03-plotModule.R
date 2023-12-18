#' UI function of plot module
#'
#' @param id id of the module
plotUI <- function(id) {
  ns <- NS(id)
  plotOutput(ns("plot"), height = "800px", width = "80%")
}


#' Server function of plot module
#'
#' @param id id of the module
#' @param path path to the file
#' @param file_type file type of file
#' @param variable variable from user selection
#' @param measure measure from user selection
#' @param time time from user selection
plotServer <- function(id, path, file_type, variable=NULL, measure=NULL, time=NULL) {
  moduleServer(
    id,
    function(input, output, session) {
      if(!file_type %in% c("png","nc")){
        DataTools::tryCatchWithWarningsAndErrors(expr = warning(""),
                                                 warningTitle = "file_type must be png or nc")
      } else if(file_type == "png"){
      output$plot <- renderImage(
        {
          list(src = path, contentType = "image/png", alt = "Plot")
        },
        deleteFile = FALSE
      )
      } else if(file_type == "nc"){
        plot_data <- pastclim::region_slice(
          time_bp = time,
          bio_variables = variable,
          dataset = "custom",
          path_to_nc = path
        )
        output$plot <- renderPlot(
          terra::plot(plot_data)
        )
      }
    }
  )
}
