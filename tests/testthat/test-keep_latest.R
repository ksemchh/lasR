test_that("keep_latest keeps the most recent acquisition where two overlap",
{
  f <- system.file("extdata", "Megaplot.las", package = "lasR")
  ext <- c(684766, 5017773, 684994, 5018008)
  third <- (ext[3] - ext[1]) / 3

  # an older acquisition over the left two thirds and a newer one over the right two thirds,
  # so they overlap in the middle third
  old <- tempfile(fileext = ".las")
  exec(reader_rectangles(ext[1], ext[2], ext[1] + 2 * third, ext[4]) +
       edit_attribute(attribute = "gpstime", value = 100) + write_las(old), on = f, noread = TRUE)

  new <- tempfile(fileext = ".las")
  exec(reader_rectangles(ext[1] + third, ext[2], ext[3], ext[4]) +
       edit_attribute(attribute = "gpstime", value = 200) + write_las(new), on = f, noread = TRUE)

  query <- reader_rectangles(ext[1], ext[2], ext[3], ext[4])
  merged <- exec(query + summarise(), on = c(old, new))
  kept <- exec(query + keep_latest(res = 2, window = 10) + summarise(), on = c(old, new))
  whole <- exec(reader_las() + summarise(), on = f)

  # merging the two counts the overlap twice; keeping the latest brings it back to one cover
  expect_gt(merged$npoints, whole$npoints)
  expect_equal(kept$npoints, whole$npoints, tolerance = 0.001)
})

test_that("keep_latest leaves an acquisition that is alone on its ground",
{
  f <- system.file("extdata", "Megaplot.las", package = "lasR")

  before <- exec(reader_las() + summarise(), on = f)
  after <- exec(reader_las() + keep_latest(res = 2, window = 10) + summarise(), on = f)

  expect_equal(after$npoints, before$npoints)
})
