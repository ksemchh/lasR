#' Tools inherited from base R
#'
#' Tools inherited from base R
#'
#' @param x,e1,e2 lasR objects
#' @param ... lasR objects. Is equivalent to +
#' @examples
#' algo1 <- rasterize(1, "max")
#' algo2 <- rasterize(4, "min")
#' print(algo1)
#' pipeline <- algo1 + algo2
#' print(pipeline)
#' @name tools
#' @rdname tools
NULL

#' @rdname tools
#' @export
print.LASRalgorithm = function(x, ...)
{
  name <- x[["algoname"]]
  uuid <- x[["uid"]]
  args <- x[!names(x) %in% c( "uid", "algoname")]
  cat(name, " (uid:", substr(uuid, 0, 4), ")\n", sep = "")
  for (name in names(args))
  {
    if (name == "connect")
    {
      cat(" ", name, ": ")
      cat("uid:", x[[name]], "\n", sep = "")
    }
    else if (name == "files")
    {
      cat(" ", name, ": ")
      if (length(x[[name]]) > 5)
      {
        tmp = x[[name]][1:5]
        cat(basename(tmp), " (...)\n", sep = "")
      }
      else
      {
        cat(basename(x[[name]]), "\n", sep = "")
      }
    }
    else
    {
      cat(" ", name, ": ")
      if (is.call(x[[name]]))
        cat(deparse(x[[name]]), "\n", sep = "")
      else if (is.environment(x[[name]]))
        cat(utils::capture.output(print(x[[name]])), "\n")
      else if (is.function(x[[name]]))
        cat("<function>\n")
      else if (methods::is(x[[name]], "externalptr"))
        cat("<externalptr>\n")
      else if (is.list(x[[name]]))
        cat(names(x[[name]]), "\n")
      else
        cat(x[[name]], "\n", sep = " ")
    }
  }
}

#' @rdname tools
#' @export
print.LASRpipeline = function(x, ...)
{
  cat(" -----------\n")
  for (u in x) {
    print(u)
    cat("-----------\n")
  }
}

#' @rdname tools
#' @export
`+.LASRpipeline` <- function(e1, e2)
{
  if (!methods::is(e1, "LASRpipeline") || !methods::is(e2, "LASRpipeline"))
    stop("Both operands must be of class LASRalgorithm") # nocov

  ans <- c(e1, e2)
  class(ans) <- c("LASRpipeline", "list")
  return(ans)
}

#' @rdname tools
#' @export
`c.LASRpipeline` <- function(...)
{
  p <- list(...)
  p <- lapply(p, function(x) { class(x) <- "list" ; x })
  ans <- do.call(c, p)
  names(ans) <- make.names(names(ans), unique = TRUE)
  class(ans) <- c("LASRpipeline", "list")
  return(ans)
}

get_pipeline_info = function(pipeline)
{
  pipeline = list(processing = list(), pipeline = pipeline)
  json_file = write_json(pipeline)
  ans = .Call(`C_get_pipeline_info`, json_file)
  if (inherits(ans, "error")) { stop(ans) }
  return(ans)
}

is_indexed = function(files)
{
  ans = logical(length(files))
  for (i in seq_along(files))
  {
    file = files[i]
    indexed = .Call(`C_is_indexed`, file)
    if (inherits(ans, "error")) { stop(indexed) } # nocov
    ans[i] = indexed
  }

  return (ans)
}

address = function(x)
{
  .Call(`C_address`, x)
}

