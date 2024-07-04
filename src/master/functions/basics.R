#' @export
get_absolute_path <- function(path) {
  ## recieve a path from repository root, and return the absolute path
  #
  # @var path string
  # @return string
  ##
  return(here::here(path))
}
