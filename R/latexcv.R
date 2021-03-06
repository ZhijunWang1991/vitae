#' @rdname cv_formats
#'
#' @export
latexcv <- function(..., theme = c("classic", "modern", "rows", "sidebar", "two_column")) {
  theme <- match.arg(theme)
  if(theme != "classic"){
    stop("Only the classic theme is currently supported.")
  }
  template <- system.file("rmarkdown", "templates", "latexcv",
                          "resources", theme, "main.tex",
                          package = "vitae"
  )
  set_entry_formats(latexcv_cv_entries)
  copy_supporting_files("latexcv")
  cv_document(..., template = template)
}

latexcv_cv_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      glue_alt("\\cvevent{<<when>>}{<<what>>}{<<with>>}{\\empty}{\\empty}"),
      collapse = "\n"
    )
  },
  detailed = function(what, when, with, where, why){
    why <- lapply(why, function(x) {
      if(length(x) == 0) return("\\empty")
      paste(c(
        "\\begin{minipage}{0.7\\textwidth}%",
        "\\begin{itemize}%",
        paste0("\\item ", x, "%"),
        "\\end{itemize}%",
        "\\end{minipage}"
      ), collapse = "\n")
    })
    where <- ifelse(where == "", "\\empty", paste("-", where))

    paste(
      glue_alt("\\cvevent{<<when>>}{<<what>>}{<<with>><<where>>}{<<why>>}"),
      collapse = "\n"
    )
  }
)
