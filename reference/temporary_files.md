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
#> [1] "/tmp/RtmpSkJTUJ/file242c45f8d54a.shp"
templaz()
#> [1] "/tmp/RtmpSkJTUJ/file242c386a2b01.laz"
```
