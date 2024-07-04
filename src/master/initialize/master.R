main <- function() {
  source("renv/activate.R")
  renv::restore()
  options(box.path = here::here("src/master/"))

  set_error_to_english()
  prepare_japanese()
}

set_error_to_english <- function() {
  Sys.setenv(LANG = "en_US.UTF-8")
}

prepare_japanese <- function() {
  ## Loading Google fonts (https://fonts.google.com/)
  sysfonts::font_add_google("Gochi Hand", "gochi")
  sysfonts::font_add_google("Schoolbell", "bell")

  ## Automatically use showtext to render text
  showtext::showtext_auto()
}

main()
