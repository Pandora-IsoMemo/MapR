#' Start Application
#'
#' @param port port
#'
#' @export
startApplication <- function(port = 4242) {
  shiny::runApp(
    system.file("app", package = "MapR"),
    port = port,
    host = "0.0.0.0"
  )
}
