tmpdir = paste0(tempdir(), "/testvpc")
if (!dir.exists(tmpdir)) dir.create(tmpdir)

# create a datset without lax
f = paste0(system.file(package="lasR"), "/extdata/bcts/")
f = list.files(f, pattern = "(?i)\\.la(s|z)$", full.names = TRUE)
z = file.copy(f, tmpdir)
f = list.files(tmpdir, pattern = "(?i)\\.la(s|z)$", full.names = TRUE)

test_that("vpc reader works",
{
  f = system.file("extdata", "bcts/bcts.vpc", package="lasR")
  pipeline = reader_las() + hulls()
  ans = exec(pipeline, on = f)

  expect_s3_class(ans, "sf")
  expect_equal(dim(ans), c(4L,1L))
  expect_equal(length(ans$geom[[1]]), 1L)
})

test_that("vpc writer works",
{
  o = tempfile(fileext = ".vpc")
  pipeline = reader_las() + write_vpc(o)
  ans = exec(pipeline, on = f)

  expect_true(file.exists(ans))

  ans = sf::st_read(ans, quiet = TRUE)
  expect_s3_class(ans, "sf")
  expect_equal(nrow(ans), 4L)
  expect_true(all(sf::st_geometry_type(ans) == rep("POLYGON", 4)))
  expect_equal(as.numeric(sf::st_bbox(ans)), c(-127.627836098, 50.665469135, -127.624899322, 50.675051675))
})

file.remove(f)

test_that("vpc reader fails",
{
  f = tempfile(fileext = ".vpc")
  file.create(f)
  pipeline = lasR:::nothing()
  expect_error(exec(pipeline, on = f), "JSON parsing error")
})

test_that("vpc writer fails without CRS",
{
  f = system.file("extdata", "nocrs.las", package="lasR")
  o = tempfile(fileext = ".vpc")

  pipeline = reader_las() + write_vpc(o)
  expect_error(exec(pipeline, on = f), "Invalid CRS. Cannot write a VPC file")

  pipeline = reader_las() + set_crs(32617) + write_vpc(o)
  expect_error(exec(pipeline, on = f), NA)
})

test_that("vpc writer uses GPS time",
{
  f <- system.file("extdata", "Topography.las", package="lasR")
  o = tempfile(fileext = ".vpc")

  pipeline = reader_las() + write_vpc(o)

  ans = exec(pipeline, on = f)
  ans = sf::st_read(ans, quiet = TRUE, stringsAsFactors = TRUE)

  date = ans$datetime
  attr(date, "tzone") <- "UTC"

  expect_equal(as.character(date), "2018-01-01")

  pipeline = reader_las() + write_vpc(o, use_gpstime = T)

  ans = exec(pipeline, on = f)
  ans = sf::st_read(ans, quiet = TRUE, stringsAsFactors = TRUE)

  date = ans$datetime
  attr(date, "tzone") <- "UTC"

  expect_equal(as.character(date), "2018-09-07")
})

test_that("vpc writer does not uses GPS time",
{
  f <- system.file("extdata", "Megaplot.las", package="lasR")
  o = tempfile(fileext = ".vpc")

  pipeline = reader_las() + write_vpc(o, use_gpstime = T)

  expect_error(exec(pipeline, on = f), NA)
})

