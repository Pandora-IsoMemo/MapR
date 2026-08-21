library(shiny)
library(MapR)

tagList(
  navbarPage(
    header = shinyTools::includeShinyToolsCSS(),
    title = paste("MapR", packageVersion("MapR")),
    theme = shinythemes::shinytheme("flatly"),
    position = "fixed-top",
    collapsible = TRUE,
    id = "tab",
    tabPanel(
      title = "Map",
      MapR::mapPanelUI(id = "map_panel")
    )
  ),
  shinyTools::headerButtonsUI(id = "header", help_link = "https://pandora-isomemo.github.io/MapR/articles/how-to-use-MapR.html"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
),
shinyjs::useShinyjs()
)
