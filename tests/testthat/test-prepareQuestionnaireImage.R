server <- function(input, output, session) {
  questionnaire <- reactiveVal(list(Questions = list(list(
    Question_ID = 1, Question = "Choose an option:",
    Type = "multiple choice", Answers = c("Option A", "Option B")
  ), list(
    Question_ID = 2, Question = "This is a question. Please enter a value:",
    Type = "numeric", Answers = list()
  ), list(
    Question_ID = 3,
    Question = "This is another question. Please enter a value:",
    Type = "numeric", Answers = list()
  )), Plots = list(list(
    Title = "This is an example plot title",
    Address = "forest_cover/forest_cover/mean/1000.png", File_type = "png",
    Answers = list(
      list(Question = 1, Answer = "Option A", Type = "=="),
      list(Question = 2, Answer = 30, Type = ">"), list(
        Question = 3,
        Answer = 1000, Type = "<"
      )
    )
  ), list(
    Title = "This is an example plot title",
    Address = "NETCDF_Group/example_climate_v1.3.0.nc", File_type = "nc",
    Variable_name = "BIO1", x_display_value = "-20000", Answers = list(
      list(Question = 1, Answer = "Option B", Type = "=="),
      list(Question = 2, Answer = 0, Type = "=="), list(
        Question = 3,
        Answer = 1, Type = "=="
      )
    )
  ))))
}

testServer(server, {
  # CASE A: No matching image. Return NULL
  session$setInputs(
    question_1 = "Option A",
    question_2 = 0,
    question_3 = 0
  )
  imageInfos <- prepareQuestionnaireImage(input = input, questionnaire = questionnaire)
  expect_equal(imageInfos, NULL)

  # CASE B: One image correct
  session$setInputs(
    question_1 = "Option B",
    question_2 = 0,
    question_3 = 1
  )
  imageInfos <- prepareQuestionnaireImage(input = input, questionnaire = questionnaire)
  expect_equal(length(imageInfos), 5)
  expect_equal(imageInfos$file_type, "nc")
})
