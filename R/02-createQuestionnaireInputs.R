#' Create Inputs for Questionnaire
#'
#' @param id id of module
#' @param questions list of questions from json
createQuestionnaireInputs <- function(id, questions) {
  ns <- NS(id)
  inputList <- tagList()
  for (i in seq_along(questions$Questions)) {
    if (questions$Questions[[i]]$Type == "multiple choice") {
      label <- questions$Questions[[i]]$Question
      choices <- questions$Questions[[i]]$Answers
      inputList[[i]] <- radioButtons(
        inputId = ns(paste0("question_", i)),
        choices = choices,
        label = label,
      )
    } else if (questions$Questions[[i]]$Type == "numeric") {
      label <- questions$Questions[[i]]$Question
      inputList[[i]] <- numericInput(
        inputId = ns(paste0("question_", i)),
        label = label,
        value = 0
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
