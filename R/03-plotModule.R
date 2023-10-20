plotUI <- function(id) {
  ns <- NS(id)
  imageOutput(ns("plot"))
}


plotServer <- function(id, path) {
  moduleServer(
    id,
    function(input, output, session) {
      output$plot <- renderImage(
        {
          list(src = path, contentType = "image/png", alt = "Plot")
        },
        deleteFile = FALSE
      )
    }
  )
}
