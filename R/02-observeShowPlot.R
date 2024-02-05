#' Observer to show plot when display button is clicked
#'
#' @param input input object from server function
#' @param output output object from server function
#' @param session session from server function
#' @param image_list reactive image list
#' @param questionnaire reactive questionnaire
observeShowPlot <- function(input, output, session, image_list, questionnaire) {
  observe({
    shinyjs::show(id = "title-options", anim = TRUE)
    shinyjs::show(id = "plot_title", anim = TRUE)
    shinyjs::hide(id = "maintable-table")
    shinyjs::show(id = "mainplot-plot")

    if (!is.null(image_list())) {
      imageInfos <- prepareImageListImage(input = input, image_list = image_list)
    } else {
      imageInfos <- prepareQuestionnaireImage(input = input, questionnaire = questionnaire)
    }

    if (!is.null(imageInfos)) {
      plotServer(
        id = "mainplot",
        path = paste0(tempdir(), "/data/", imageInfos$address),
        file_type = imageInfos$file_type,
        variable = imageInfos$variable,
        time = imageInfos$time
      )

      updateTextInput(
        session = session,
        inputId = "title-text",
        value = imageInfos$title
      )
    }
  }) %>%
    bindEvent(input[["display_plot-button"]],
      ignoreInit = TRUE
    )
}


#' Prepare infos for image from image list
#'
#' @param input input object from server function
#' @param image_list reactive image list
prepareImageListImage <- function(input, image_list) {
  group <- input[["group_name-selectize"]]
  variable <- input[["variable-selectize"]]
  measure <- input[["measure-selectize"]]
  time <- input[["time-slider"]]

  address <- image_list()$address[image_list()$Group == group &
    image_list()$Variable == variable &
    image_list()$Measure == measure &
    image_list()$x_display_value == time]

  file_type <- image_list()$file_type[image_list()$Group == group &
    image_list()$Variable == variable &
    image_list()$Measure == measure &
    image_list()$x_display_value == time]

  unit <- image_list()$Measure_unit[image_list()$Group == group &
    image_list()$Variable == variable &
    image_list()$Measure == measure &
    image_list()$x_display_value == time]

  title <- paste0(variable, " - ", unit, " - ", measure)

  list(
    group = group,
    variable = variable,
    measure = measure,
    time = time,
    address = address,
    file_type = file_type,
    unit = unit,
    title = title
  )
}

#' Prepare infos for image from questionnaire
#'
#' @param input input object from server function
#' @param questionnaire reactive questionnaire
prepareQuestionnaireImage <- function(input, questionnaire) {
  # Iterate over questions to get ids of question inputs
  inputs <- lapply(questionnaire()$Questions, function(question) {
    input[[paste0("question_", question$Question_ID)]]
  })
  imageInfos <- lapply(questionnaire()$Plots, function(plot) {
    # Check if length of questions (inputs) is equal to length of required answers
    if (length(plot$Answers) != length(inputs)) {
      shinyjs::alert("Number of questions and answers in questionnaire does not match")
    }
    # Check if all answers are true
    allTrue <- all(unlist(lapply(plot$Answers, function(answers) {
      input <- ifelse(is.numeric(inputs[[answers$Question]]), inputs[[answers$Question]], paste0("'", inputs[[answers$Question]], "'"))
      answer <- ifelse(is.numeric(answers$Answer), answers$Answer, paste0("'", answers$Answer, "'"))
      condition <- paste0(input, answers$Type, answer)
      result <- eval(parse(text = condition))
      # print(paste0(condition, " is ", result))
      result
    })))

    if (allTrue) {
      list(
        variable = plot$Variable_name,
        time = as.numeric(plot$x_display_value),
        address = plot$Address,
        file_type = plot$File_type,
        title = plot$Title
      )
    } else {
      NULL
    }
  })

  # Check if no plot or more than one plot matches the criteria
  nNotNull <- sum(!sapply(imageInfos, is.null))
  if (nNotNull == 0) {
    shinyjs::alert("No plot matches the criteria")
  } else if (nNotNull > 1) {
    shinyjs::alert("More than one plot matches the criteria")
  } else {
    imageInfos[!sapply(imageInfos, is.null)][[1]]
  }
}
