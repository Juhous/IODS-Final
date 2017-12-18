multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

summaryKable <- function(dataFrame) {
  require(dplyr)
  require(stringr)
  vect <- sapply(dataFrame, function(x) {
    if(!is.factor(x)) { 
      a <- c(quantile(x, probs = c(0,0.25,0.5), na.rm = T), 
             mean(x, na.rm = T),
             quantile(x, probs = c(0.75,1), na.rm = T)) %>% 
        formatC(format = "f", digits = 3) %>% 
        unname() 
    }
    
    if(is.factor(x)) {
      a <- sapply(1:5, function(y) 
            sum(x == levels(x)[y]) %>% 
            paste(levels(x)[y],. , sep = ":\ ")) 
      a <- c("Levels", a) %>% str_replace_all("NA: NA", "--")
    }
    
    return(a)
  })
  row.names(vect) <- c("Min", "1st Q", "Median", "Mean", "3rd Q", "Max")
  return(vect)
}
# 
# scaler <- function(x) {
#   x <- scale(x)
#   attributes(x) <- NULL
#   return(x)
# }