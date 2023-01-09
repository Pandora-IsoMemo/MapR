library(shiny)

tagList(
  navbarPage(
    title = paste("MapR", packageVersion("MapR")),
    theme = shinythemes::shinytheme("flatly"),
    position = "fixed-top",
    collapsible = TRUE,
    id = "tab",
    tabPanel(
      title = "Map",
      mapPanelUI(id = "map_panel")
    )
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
),
shinyjs::useShinyjs()
)
