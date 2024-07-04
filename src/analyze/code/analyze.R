main <- function() {
  df <- readr::read_csv(basics$get_absolute_path("src/data/build_data/df.csv")) |>
    dplyr::rename(h = `...1`)
  p2var <- vars::VAR(df[, 2:7], p = 2)
  p12var <- vars::VAR(df[, 2:7], p = 12)
  irf_p2var <- vars::irf(p2var, impulse = c("FF"), boot = F, n.ahead = 24)
  irf_p12var <- vars::irf(p12var, impulse = c("FF"), boot = T, n.ahead = 24)
  plot_ir_p2var <- plot_irs(irf_p2var$irf$FF)
  ggplot2::ggsave(plot_ir_p2var, file = basics$get_absolute_path("src/analyze/output/irf.png"))
}

plot_line <- function(df, y) {
  plot <- ggplot2::ggplot(data = df, ggplot2::aes(y = !!as.name(y), x = h)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::ylab(y) +
    ggplot2::theme_bw()
  return(plot)
}

plot_irs <- function(matrix) {
  df <- tibble::as_tibble(matrix) |>
    dplyr::mutate(h = dplyr::row_number() - 1)
  IR_EM <- plot_line(df, "EM")
  IR_P <- plot_line(df, "P")
  IR_PCOM <- plot_line(df, "PCOM")
  IR_FF <- plot_line(df, "FF")
  IR_NBRX <- plot_line(df, "NBRX")
  IR_M2 <- plot_line(df, "M2")
  IR_COMPILE <- gridExtra::grid.arrange(IR_EM, IR_P,
    IR_PCOM,
    IR_FF,
    IR_NBRX,
    IR_M2,
    nrow = 3,
    bottom = gridtext::richtext_grob(text = '<span style="font-weight:bold">Impulse Rsponses to a shock in federal funds rate by VAR(2)</span>')
  )
  return(IR_COMPILE)
}



box::use(functions / basics)
main()
