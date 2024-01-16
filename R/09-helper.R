#' Reads image list from file and converts it into the needed data frame format
#'
#' @param file path to json file
#'
#' @return data frame with relevant elements from json
convertImageListToDataFrame <- function(file) {
  json_data <- rjson::fromJSON(file = file)

  # Initialize an empty list to store the extracted information
  result_list <- list()

  # Iterate over groups in selections
  for (i in seq_along(json_data$Selections)) {
    selection <- json_data$Selections[[i]]
    if (selection$Group == "") {
      shinyjs::alert(text = "Found a missing group name. Group was removed. Please check your json file.")
      next
    }

    # Iterate over variables in group
    for (j in seq_along(selection$Variable)) {
      variable <- selection$Variable[[j]]
      if (variable$Variable_name == "") {
        shinyjs::alert(text = "Found a missing variable name. Variable was removed. Please check your json file.")
        next
      }

      # Iterate over measures in variable
      for (k in seq_along(variable$Measure)) {
        measure <- variable$Measure[[k]]
        if (measure$Measure_name == "") {
          shinyjs::alert(text = "Found a missing measure name. Measure was removed. Please check your json file.")
          next
        }

        # Iterate over images in measure
        for (l in seq_along(measure$images)) {
          image <- measure$images[[l]]

          # Create a list with relevant information
          row_data <- list(
            Group_DOI = selection$Group_DOI,
            Group = selection$Group,
            Variable_DOI = variable$Variable_DOI,
            Variable = variable$Variable_name,
            Measure = measure$Measure_name,
            Measure_unit = measure$Measure_unit,
            x_display_value = image$x_display_value,
            file_type = image$file_type,
            location_type = image$location_type,
            address = image$address
          )

          # Append the list to the result list
          result_list <- c(result_list, list(row_data))
        }
      }
    }
  }

  if (length(result_list) == 0) {
    shinyjs::alert(text = "The file does not contain any valid cases.")
  }

  # Convert the list of lists into a dataframe
  result_df <- as.data.frame(do.call(rbind, result_list))
  result_df
}
