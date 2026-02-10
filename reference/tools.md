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
#> rasterize (uid:3aa792feef36)
#>   method : [max] 
#>   window : 1.00 
#>   res : 1.00 
#>   filter : [] 
#>   output : /tmp/Rtmph6wQu2/file243c58a604d4.tif 
#> -----------
#> 
#> NULL
pipeline <- algo1 + algo2
print(pipeline)
#> -----------
#> rasterize (uid:3aa792feef36)
#>   method : [max] 
#>   window : 1.00 
#>   res : 1.00 
#>   filter : [] 
#>   output : /tmp/Rtmph6wQu2/file243c58a604d4.tif 
#> -----------
#> rasterize (uid:a42373ecc31a)
#>   method : [min] 
#>   window : 4.00 
#>   res : 4.00 
#>   filter : [] 
#>   output : /tmp/Rtmph6wQu2/file243cbff5564.tif 
#> -----------
#> 
#> NULL
```
