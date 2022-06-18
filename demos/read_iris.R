library(data.table)
library(RdelimitedPkg)
library(here)

current_dir <- here()

iris_file_path <- file.path(current_dir, "/demos/data/iris.csv")

if(!base::file.exists(iris_file_path)){
  stop("iris data csv file does not exist.")
}

IrisTextReader <- RdelimitedPkg::DelimitedFile$new(
  file_path = iris_file_path
)

data_dt <- IrisTextReader$read()

column_names <- IrisTextReader$names()

iris_summary <- IrisTextReader$numeric_summary(column_names[1:4])

sepal_min_max <- IrisTextReader$min_max(c("sepal_length", "sepal_width"))

all_min_max <- IrisTextReader$min_max(column_names[1:4])
