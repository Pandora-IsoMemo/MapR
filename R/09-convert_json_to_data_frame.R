#' Reads json from file and converts it into the needed data frame format
#'
#' @param file path to json file
#'
#' @return data frame with relevant elements from json
convert_json_to_data_frame <- function(file){
  json_data <- rjson::fromJSON(file=file)

  # Initialize an empty list to store the extracted information
  result_list <- list()

  # Iterate over groups in selections
  for (i in seq_along(json_data$Selections)) {
    selection <- json_data$Selections[[i]]

    # Iterate over variables in group
    for (j in seq_along(selection$Variable)) {
      variable <- selection$Variable[[j]]

      # Iterate over measures in variable
      for (k in seq_along(variable$Measure)) {
        measure <- variable$Measure[[k]]

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
            x__sequence_value = image$x__sequence_value,
            x__display_value = image$x__display_value,
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

  # Convert the list of lists into a dataframe
  result_df <- as.data.frame(do.call(rbind, result_list))
  result_df
}
