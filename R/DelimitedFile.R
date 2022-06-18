library(R6)
library(data.table)

#' DelimitedFile class
#' Class provides convenience for reading and returning basic statistics of text separated rows of a delimited data file.
#'
#' @description  The class uses the data.table::fread to read text separated rows of a file. The class
#' provides public methods for returning per variable names/types,  descriptive statistics. Note that
#' the filename extension (such as .csv) is irrelevant. Separator detection is entirely
#' driven by the file contents.  Users are able to set their own separation character with the `sep` parameter.
#'
#' @import R6
#' @import data.table
#'
#' @author Rick Dean
#'
#' @export
DelimitedFile <- R6::R6Class(

  public = list(
    #' @field file_path A string that defines the full file path to a csv formatted file.
    file_path = NULL,

    #' @description Defines the classes' public fields
    #' @param file_path A string that defines the full file path to a csv formatted file.
    initialize = function(file_path = NULL) {
      self$file_path <- file_path
    },
    #' @description Read the csv file
    #' @param sep The separator between columns. Defaults to the character in the set [, `tab` | ; :].
    #'   Use NULL or "" to specify no separator; i.e. each line a single character column.
    #' @param header Does the first data line contain column names?
    #' @param na_strings A character vector of strings which are interpreted as `NA` values.
    #' @param stringsAsFactors If TRUE, convert all character columns to factors
    #' @param skip If 0 start on the first line and from there finds the first row with a consistent number of columns.
    #' @param select A vector of column names or numbers to keep, drop the rest.
    #' @param drop A vector of column names or numbers to drop.
    #' @param col_names A vector of optional names for the variables(columns).
    #' @param check_names If TRUE then the names of the variables are checked to ensure that they are syntactically valid names.
    #' @param fill If TRUE then in case the rows have unequal length, blank fields are implicitly filled.
    #' @param logical01 If TRUE a column containing only 0's and 1's will be read as logical, otherwise as integer.
    #'
    read = function(
      sep = "auto",
      header = "auto",
      na_strings = "NA",
      stringsAsFactors = FALSE,
      skip = 0,
      select = NULL,
      drop = NULL,
      col_names,
      check_names = FALSE,
      fill = FALSE,
      logical01 = FALSE
      ){
      if(is.null(self$file_path)){
        stop("A full file path to the csv must be defined in the class constructor.")
      }

      private$data_dt <- data.table::fread(
        file = self$file_path,
        sep = sep,
        header = header,
        na.strings = na_strings,
        stringsAsFactors = stringsAsFactors,
        skip = skip,
        select = select,
        drop = drop,
        col.names = col_names,
        check.names = check_names,
        fill = fill,
        logical01 = logical01
      )
      return(private$data_dt)
    },
    #' @description Return the column names of the data file.
    names = function(){
      return(base::colnames(private$data_dt))
    },
    #' @description Return the minimum and maximum values for a specific variable(column).
    #' @param columns The column names of interest for min/max values
    min_max = function(columns){
      return(list(
        "variable" = columns,
        "min" = sapply(private$data_dt[, ..columns], min),
        "max" = sapply(private$data_dt[, ..columns], max)
      ))
    },
    #' @description Return the numeric summary of the data file.
    #' @param columns The column names of interest to summarize
    numeric_summary = function(columns){
      return(lapply(private$data_dt[, ..columns], private$summarize))
    }
  ),
  private = list(
    data_dt = NULL,
    summarize = function(column){
      if(class(column) == "numeric"){
        return(
          list(
            "mean" = mean(column),
            "var" = var(column),
            "median" = median(column),
            "min" = min(column),
            "max" = max(column),
            "quantile_95" = quantile(column, 0.95, names = FALSE)
          )
        )
      }
    }
  )

)
