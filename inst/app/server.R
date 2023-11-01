
shinyServer(function(input, output, session) {
  options(shiny.maxRequestSize = 400*1024^2)
  mapPanelServer(id = "map_panel")

})
