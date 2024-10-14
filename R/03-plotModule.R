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
#' @param time time from user selection
#' @param title_format reactive list with title text and format arguments
plotServer <- function(id, path, file_type, title_format, variable = NULL, time = NULL) {
  moduleServer(
    id,
    function(input, output, session) {
      if (!file_type %in% c("png", "nc")) {
        shinyjs::alert("file_type specified in json must be png or nc")
      } else if (file_type == "png") {
        output$plot <- renderImage({
          temp_file <- addTitleToPNG(path, title_format = title_format)
          list(src = temp_file,
               contentType = "image/png",
               alt = "Plot")
        }, deleteFile = TRUE)
      } else if (file_type == "nc") {
        plot_data <- pastclim::region_slice(
          time_bp = time,
          bio_variables = variable,
          dataset = "custom",
          path_to_nc = path
        )
        output$plot <- renderPlot({
          terra::plot(plot_data)
          title(main = title_format[["text"]],
                col.main = title_format[["color"]],
                cex.main = title_format[["size"]] / 10)
        })
      }
    }
  )
}

#' Add title to PNG image
#'
#' @param path path to the image
#' @param title_format list with title text and format arguments
#'
addTitleToPNG <- function(path,
                          title_format) {
  # Read the original image
  img <- image_read(path)

  # Create an image with the title overlaid
  img_with_title <- image_annotate(
    img,
    text = title_format[["text"]],
    size = title_format[["size"]], # Font size for the title
    color = title_format[["color"]], # Text color
    gravity = "north", # Position the text at the top center
    location = "+0+20"      # Adjust vertical offset
  )

  # Save the new image to a temporary file
  temp_file <- tempfile(fileext = ".png")
  image_write(img_with_title, path = temp_file, format = "png")

  temp_file
}
