#' Observer for zip upload
#'
#' Observer to show and hide inputs based on the zip file content. If a questionnaire is present,
#' the variable selection inputs are hidden and the questionnaire inputs are shown. If no
#' questionnaire is present, the variable selection inputs are shown and the questionnaire inputs
#' are hidden. The observer also extracts the questionnaire and image list from the zip file.
#' If existing, the observer extracts the notes and inputs from the zip file.
#'
#' @param input input object from server function
#' @param output output object from server function
#' @param session session from server function
#' @param uploaded_zip reactive value of uploaded zip file
#' @param image_list reactive value of image list
#' @param questionnaire reactive value of questionnaire
#' @param uploaded_inputs reactive value of uploaded inputs
#' @param upload_description reactive value of upload description
#' @param id module id
observeUploadedZip <- function(input,
                               output,
                               session,
                               uploaded_zip,
                               image_list,
                               questionnaire,
                               uploaded_inputs,
                               upload_description,
                               id) {
  # load inputs depending on content of zip file
  observe({
    logDebug("observeUploadedZip: Observe uploaded_zip triggered.")
    # reset plot and image list (also resets inputs)
    output[["mainplot-plot"]] <- NULL
    image_list(NULL)

    req(length(uploaded_zip()) > 0)
    datapath <- uploaded_zip()[[1]]
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

    # extract inputs from zip file if they exist
    upload_description(extractNotes(tempdir()))
    uploaded_inputs(extractObjectFromFile(tempdir(), what = "inputs"))

  }) %>% bindEvent(uploaded_zip(), ignoreInit = TRUE)

  observe({
    req(!is.null(uploaded_inputs()[["inputs"]]))
    logDebug("observeUploadedZip: Send uploaded_inputs.")
    new_inputs <- uploaded_inputs()[["inputs"]]

    ## update inputs ----
    inputIDs <- names(new_inputs)
    inputIDs <- inputIDs[inputIDs %in% names(input)]

    for (i in 1:length(inputIDs)) {
      session$sendInputMessage(inputIDs[i],  list(value = new_inputs[[inputIDs[i]]]) )
    }
  }) %>% bindEvent(uploaded_inputs())
}
