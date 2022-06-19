library(data.table)
library(RdelimitedPkg)
library(here)

current_dir <- here()

iris_file_path <- file.path(current_dir, "/demos/data/iris.csv")

IrisTextReader <- RdelimitedPkg::DelimitedFile$new(
  file_path = iris_file_path
)

data_dt <- IrisTextReader$read()

column_names <- IrisTextReader$names()
column_types <- IrisTextReader$types()

iris_summary <- IrisTextReader$numeric_summary()

sepal_min_max <- IrisTextReader$min_max(c("sepal_length", "sepal_width"))

all_min_max <- IrisTextReader$min_max()
