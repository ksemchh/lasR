# Temporary files

Convenient functions to create temporary file with a given extension.

## Usage

``` r
temptif()

tempgpkg()

tempshp()

templas()

templaz()
```

## Value

string. Path to a temporary file.

## Examples

``` r
tempshp()
#> [1] "/tmp/RtmpVHpaiM/file23eacf22920.shp"
templaz()
#> [1] "/tmp/RtmpVHpaiM/file23ea4ccdee63.laz"
```
