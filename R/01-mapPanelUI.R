#' UI function of mapPanel module
#'
#' @param id
#'
mapPanelUI <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectInput(ns("select"),
        "select",
        choices = NULL
      )
    ),
    mainPanel(
      tags$h3("map placeholder")
    )
  )
}


#' Server function of mapPanel module
#'
#' @param id
#'
mapPanelServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

    }
  )
}
