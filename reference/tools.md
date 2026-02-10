# Tools inherited from base R

Tools inherited from base R

## Usage

``` r
# S3 method for class 'PipelinePtr'
print(x, ...)

# S3 method for class 'PipelinePtr'
e1 + e2

# S3 method for class 'PipelinePtr'
x[[i, ...]]
```

## Arguments

- x, e1, e2:

  lasR objects

- ...:

  lasR objects. Is equivalent to +

- i:

  index

## Examples

``` r
algo1 <- rasterize(1, "max")
algo2 <- rasterize(4, "min")
print(algo1)
#> -----------
#> rasterize (uid:9c8b74d083a8)
#>   method : [max] 
#>   window : 1.00 
#>   res : 1.00 
#>   filter : [] 
#>   output : /tmp/Rtmp2NZf4a/file243c17d335f1.tif 
#> -----------
#> 
#> NULL
pipeline <- algo1 + algo2
print(pipeline)
#> -----------
#> rasterize (uid:9c8b74d083a8)
#>   method : [max] 
#>   window : 1.00 
#>   res : 1.00 
#>   filter : [] 
#>   output : /tmp/Rtmp2NZf4a/file243c17d335f1.tif 
#> -----------
#> rasterize (uid:6c18a58c239f)
#>   method : [min] 
#>   window : 4.00 
#>   res : 4.00 
#>   filter : [] 
#>   output : /tmp/Rtmp2NZf4a/file243c462fcda0.tif 
#> -----------
#> 
#> NULL
```
