#' Create Inputs for Questionnaire
#'
#' @param id id of module
#' @param questions list of questions from json
#' @param questionnaire_inputs list of questionnaire inputs
createQuestionnaireInputs <- function(id, questions, questionnaire_inputs) {
  ns <- NS(id)
  inputList <- tagList()
  for (i in seq_along(questions$Questions)) {
    if (questions$Questions[[i]]$Type == "multiple choice") {
      label <- questions$Questions[[i]]$Question
      choices <- questions$Questions[[i]]$Answers
      loaded_input <- questionnaire_inputs[grep(i, names(questionnaire_inputs), value = TRUE)]
      if(!is.null(loaded_input) && length(loaded_input) > 0){
        selected <- loaded_input
      } else {
        selected <- questions$Questions[[i]]$Fill_Value
      }
      inputList[[i]] <- radioButtons(
        inputId = ns(paste0("question_", i)),
        choices = choices,
        label = label,
        selected = selected
      )
    } else if (questions$Questions[[i]]$Type == "numeric") {
      label <- questions$Questions[[i]]$Question
      loaded_input <- questionnaire_inputs[grep(i, names(questionnaire_inputs), value = TRUE)]
      if(!is.null(loaded_input)){
        value <- loaded_input
      } else {
        value <- questions$Questions[[i]]$Fill_Value
      }
      inputList[[i]] <- numericInput(
        inputId = ns(paste0("question_", i)),
        label = label,
        value = value
      )
    } else {
      shinyjs::alert(text = "Found a missing question type. Question was removed. Please check your json file.")
      next
    }
  }
  insertUI(
    selector = "#map_panel-file_import-openPopup",
    where = "afterEnd",
    ui = tagList(
      div(
        id = ns("questionnaire_inputs"),
        br(),
        br(),
        inputList
      )
    ),
    immediate = TRUE
  )
}
