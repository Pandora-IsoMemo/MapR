plotUI <- function(id) {
  ns <- NS(id)
  plotOutput(ns("plot"))
}


plotServer <- function(id, path, file_type, variable=NULL, measure=NULL, time=NULL) {
  moduleServer(
    id,
    function(input, output, session) {
      if(file_type == "png"){
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
