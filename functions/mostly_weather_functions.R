combine_columns <- function(dataset, col1, col2, newColumn, separator = "-") {
  
  dataset[[newColumn]] <- paste(
    dataset[[col1]],
    dataset[[col2]],
    sep = separator
  )
  
  dataset <- dataset %>%
    select(-all_of(c(col1, col2)))
  
  return(dataset)
}

change_column_type <- function(dataset, column, newType) {
  
  converter <- switch(
    newType,
    "double" = as.double,
    "integer" = as.integer,
    "character" = as.character,
    "date" = as.Date,
    "yearmon" = function(x) zoo::as.yearmon(x, format = "%Y-%m"),
    stop("Unsupported data type")
  )
  
  dataset[[column]] <- converter(dataset[[column]])
  
  return(dataset)
}







read_clean_weather2 <- function(filepath) {
  
  dataset <- read_tsv(filepath, show_col_types = FALSE)
  
  dataset <- dataset %>%
    select(-any_of("...8"))
  
  dataset <- combine_columns(
    dataset, "yyyy", "mm", "year_month"
  )
  
  dataset <- change_column_type(
    dataset, "year_month", "yearmon"
  )

  columns_to_clean <- c(
    "tmax (degC)",
    "tmin (degC)",
    "af (days)",
    "rain (mm)",
    "sun (hours)"
  )
  
  for (column in columns_to_clean) {
    dataset <- remove_non_numeric_rows(dataset, column)
  }

  for (column in columns_to_clean) {
    dataset <- change_column_type(dataset, column, "double")
  }
  
  return(dataset)
}