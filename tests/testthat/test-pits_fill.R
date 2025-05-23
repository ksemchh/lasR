test_that("pits filling works (no streaming)",
{
  f <- system.file("extdata", "MixedConifer.las", package="lasR")

  chm = chm()
  pit = pit_fill(chm)

  ans <- exec(chm + pit, on = f)
  chm <- ans[[1]]
  sto <- ans[[2]]

  expect_s4_class(sto, "SpatRaster")
  expect_equal(terra::res(sto), c(1,1))
  expect_equal(dim(sto), c(90L,90L,1L))
  expect_equal(mean(sto[], na.rm = T), 15.1813, tolerance = 1e-6)
  expect_equal(sum(is.na(sto[])), 557L)
  expect_equal(unname(unlist(sto[c(1000L,5000L,10000L)])), c(5.9, 16.98625, NA_real_),  tolerance = 1e-6)
})

test_that("pits filling works with multiple files",
{
  f <- system.file("extdata", "bcts/", package="lasR")
  f = list.files(f, full.names = TRUE, pattern = "\\.laz")
  f = f[1:2]

  reader <- reader_las(filter = keep_first())
  tri <- triangulate()
  chm <- rasterize(0.25, tri)
  pit <- pit_fill(chm)
  u <- exec(reader + tri + chm + pit, on = f)
  chm <- u[[1]]
  sto <- u[[2]]

  #bb = terra::ext(885100, 885200,629600, 629700)
  #tmp = terra::crop(c(chm, sto), bb)
  #terra::plot(tmp, col = lidR::height.colors(25))

  expect_s4_class(chm, "SpatRaster")
  expect_s4_class(sto, "SpatRaster")
  expect_equal(terra::res(chm), c(0.25,0.25))
  expect_equal(terra::res(sto), c(0.25,0.25))
  expect_equal(dim(chm), c(2172L,780L,1L))
  expect_equal(dim(sto), c(2172L,780L,1L))
  #expect_equal(names(chm), "")
  #expect_equal(names(sto), "")
  expect_equal(mean(chm[], na.rm = T), 334.9628, tolerance = 1e-6)
  expect_equal(mean(sto[], na.rm = T), 334.9952, tolerance = 1e-6)
  expect_equal(sum(is.na(chm[])), 81390L)
  expect_equal(sum(is.na(sto[])), 88555L)
  expect_equal(unname(unlist(chm[c(1000L,5000L,10000L)])), c(342.0760, 332.4262, 343.9529),  tolerance = 1e-6)
  expect_equal(unname(unlist(sto[c(1000L,5000L,10000L)])), c(342.0760, 332.4262, 345.6226),  tolerance = 1e-6)
})


