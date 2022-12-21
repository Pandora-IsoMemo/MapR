library(shiny)

tagList(
  navbarPage(
    title = "MapR",
    theme = shinythemes::shinytheme("flatly"),
    position = "fixed-top",
    collapsible = TRUE,
    id = "tab",
    tabPanel(
      title = "Map",
      mapPanelUI(id = "mapPanel")
    )
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
)
)
