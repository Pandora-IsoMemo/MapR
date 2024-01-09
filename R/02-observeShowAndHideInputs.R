#' Observer to show and hide inputs
#'
#' @param input input object from server function
#' @param output output object from server function
#' @param session session from server function
#' @param uploadedZip reactive value of uploaded zip file
#' @param image_list reactive value of image list
#' @param questionnaire reactive value of questionnaire
#' @param id module id
observeShowAndHideInputs <- function(input, output, session, uploadedZip, image_list, questionnaire, id) {
  # load inputs depending on content of zip file
  observe({
    # reset plot and image list (also resets inputs)
    output[["mainplot-plot"]] <- NULL
    image_list(NULL)

    req(length(uploadedZip()) > 0)
    datapath <- uploadedZip()[[1]]
    utils::unzip(datapath, exdir = tempdir()) # extract zip file to tempdir

    if ("questionnaire.json" %in% utils::unzip(datapath, list = TRUE)$Name) { # if questionnaire is present
      shinyjs::hide(id = "variable_selection_inputs") # hide variable selection inputs
      removeUI(selector = "#map_panel-questionnaire_inputs", immediate = TRUE) #  remove old questionnaire inputs
      questionnaire(rjson::fromJSON(file = paste0(tempdir(), "/questionnaire.json"))) # load new questionnaire
      createQuestionnaireInputs(id, questionnaire()) # create new questionnaire inputs
    } else { # if no questionnaire is present
      image_list(convertImageListToDataFrame(file = paste0(tempdir(), "/image_list.json"))) # fill image list
      shinyjs::show(
        id = "variable_selection_inputs",
        anim = TRUE,
        animType = "fade",
        time = 1
      ) # show variable selection inputs
      removeUI(selector = "#map_panel-questionnaire_inputs", immediate = TRUE) #  remove old questionnaire inputs
      questionnaire(NULL) # reset questionnaire
    }

    shinyjs::show(
      id = "display_plot-button",
      anim = TRUE,
      animType = "fade",
      time = 1
    )
  }) %>% bindEvent(uploadedZip(), ignoreInit = TRUE)
}
