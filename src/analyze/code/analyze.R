main <- function() {
  df <- readr::read_csv(basics$get_absolute_path("src/data/build_data/df.csv")) |>
    dplyr::rename(h = `...1`)
  p2var <- vars::VAR(df[, 2:7], p = 2)
  p12var <- vars::VAR(df[, 2:7], p = 12)
  irf_p2var <- vars::irf(p2var, impulse = c("FF"), boot = FALSE, n.ahead = 24)
  irf_p12var <- vars::irf(p12var, impulse = c("FF"), boot = TRUE, n.ahead = 24)
  df_irs <- combine_matrix(model_name_list = list("var2", "var12"), irf_p2var$irf$FF, irf_p12var$irf$FF)
  plots_irs <- plot_irs(df_irs)
  ggplot2::ggsave(
    filename = basics$get_absolute_path("src/analyze/output/irf.png"),
    plot = plots_irs,
    device = "png"
  )
}


combine_matrix <- function(model_name_list, ...) {
  bindrows <- get("bind_rows", asNamespace("dplyr"))
  df_list <- list(...) |>
    purrr::imap(function(x, idx) {
      df <- tibble::as_tibble(x) |>
        dplyr::mutate(model = as.character(model_name_list[idx]))
      return(df)
    })
  bind_df <- do.call("bindrows", df_list)
  return(bind_df)
}

plot_irs <- function(df) {
  h_length <- length(df$model) / length(unique(df$model))
  df <- df |> dplyr::mutate(h = dplyr::if_else(dplyr::row_number() > h_length,
    dplyr::row_number() - h_length - 1,
    dplyr::row_number() - 1
  ))
  IR_EM <- plot_line(df, "EM")
  IR_P <- plot_line(df, "P")
  IR_PCOM <- plot_line(df, "PCOM")
  IR_FF <- plot_line(df, "FF")
  IR_NBRX <- plot_line(df, "NBRX")
  IR_M2 <- plot_line(df, "M2")
  IR_COMPILE <- compile_plots(
    "Impulse Response to a Shock of Federal Funds Rate in VAR(2) and VAR(12)",
    IR_EM,
    IR_P,
    IR_PCOM,
    IR_FF,
    IR_NBRX,
    IR_M2
  )
  return(IR_COMPILE)
}


plot_line <- function(df, y) {
  plot <- ggplot2::ggplot(data = df, ggplot2::aes(y = !!as.name(y), x = h, colour = model)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::ylab(y) +
    ggthemes::theme_tufte()
  return(plot)
}


compile_plots <- function(title, ...) {
  grid_arrange <- get("grid.arrange", asNamespace("gridExtra"))
  plots <- list(...)
  n <- length(plots)
  ncol <- floor(sqrt(n))
  compiled_plot <- do.call("grid_arrange", c(plots, ncol = ncol, bottom = title))
  return(compiled_plot)
}



box::use(functions / basics)
main()
