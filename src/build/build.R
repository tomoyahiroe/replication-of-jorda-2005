# cleaning data
main <- function() {
  df <- readr::read_csv("src/data/raw_data/evnew.csv", col_names = c("EM", "P", "PCOM", "FF", "NBRX", "M2"))

  write.csv(df, basics$get_absolute_path("src/data/build_data/df.csv"))
}

box::use(functions/basics)
main()
