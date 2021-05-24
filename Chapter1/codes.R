# Quiz 1
df <- data.frame(runif(3), runif(3))
names(df) <- c(1, 2)

# Quiz 2
x <- runif(1e6)
y <- list(x, x, x)

# Quiz 3
a <- c(1, 5, 3, 2)
b <- a
b[[1]] <- 10

# Sections
library(lobstr)
x <- c(1, 2, 3)
y <- x

obj_addr(x)
#> [1] "0x7fe11b31b1e8"
obj_addr(y)
#> [1] "0x7fe11b31b1e8"

mean
base::mean
get("mean")
evalq(mean)
match.fun("mean")

obj_addr(mean)
obj_addr(base::mean)
obj_addr(get("mean"))
obj_addr(evalq(mean))
obj_addr(match.fun("mean"))


# 'Copy on modify'
# tracemem()
x <- c(1, 2, 3)
cat(tracemem(x), "\n")
#> <0x7f80c0e0ffc8> 
y <- x
y[[3]] <- 4L
#> tracemem[0x7f80c0e0ffc8 -> 0x7f80c4427f40]: 
untracemem(x)

x <- c(1,2,3)
y <- x
x[[1]] = 2

# Data frames are list of numeric vectors
x <- c("a", "a", "abc", "d")

# Global string pool
ref(x, character = TRUE)
#> █ [1:0x7fe114251578] <chr> 
#> ├─[2:0x7fe10ead1648] <string: "a"> 
#> ├─[2:0x7fe10ead1648] 
#> ├─[3:0x7fe11b27d670] <string: "abc"> 
#> └─[4:0x7fe10eda4170] <string: "d">
x[1] = "c"
ref(x, character = TRUE)


x <- c(1, 2, 3)
tracemem(x)
x[[3]] <- 4

a <- 1:10
b <- list(a, a)
c <- list(b, a, 1:10)

x <- list(1:10)
x[[2]] <- x


# Alternative representation: ALTREP.
obj_size(1:3)
#> 680 B
obj_size(1:1e3)
#> 680 B
obj_size(1:1e6)
#> 680 B
obj_size(1:1e9)
#> 680 B

x <- 1:3
y <- 1:1e6

y <- rep(list(runif(1e4)), 100)

object.size(y)
#> 8005648 bytes
obj_size(y)
#> 80,896 B

funs <- list(mean, sd, var)
obj_size(funs)
#> 17,608 B


a <- runif(1e6)
obj_size(a)

b <- list(a, a)
obj_size(b)
obj_size(a, b)

b[[1]][[1]] <- 10
obj_size(b)
obj_size(a, b)

b[[2]][[1]] <- 10
obj_size(b)
obj_size(a, b)

# Why for loop is slow in r?
x <- data.frame(matrix(runif(5 * 1e4), ncol = 5))
medians <- vapply(x, median, numeric(1))

for (i in seq_along(medians)) {
  x[[i]] <- x[[i]] - medians[[i]]
}
y <- as.list(x)
cat(tracemem(y), "\n")
#> <0x7f80c5c3de20>

for (i in 1:5) {
  y[[i]] <- y[[i]] - medians[[i]]
}
#> tracemem[0x7f80c5c3de20 -> 0x7f80c48de210]: 


# Environments are always modified in place
e1 <- rlang::env(a = 1, b = 2, c = 3)
e2 <- e1
e1$c <- 4
e2$c
#> [1] 4
