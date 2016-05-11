library(ggplot2)
library(gridExtra)


paper_range <- seq(from = 1, to = 10, by=0.2)
if_range <- seq(from = 1, to = 10, by=0.2)
autocite_mania <- c(F,T)
h_target <-10
n_sim <- 1
sd_citation <- 0
max_year <- 0
min_year <- 20

plotList <- list()
dataList <- list()

for(auto in autocite_mania){
  if_space <- data.frame(papers=numeric(), ifact=numeric(),years=numeric())
  for(pa in paper_range){
    for(ifa in if_range){
      
      message(paste("n papers = ",pa," / impact factor = ",ifa))
      # avg_paper_per_year <- pa
      # avg_IF <- ifa
      final <- data.frame(year=numeric(), papers=numeric(), cites=numeric(), h_index=numeric())
      
      for(j in 1:n_sim){
        papers <- data.frame(year=numeric(), ifact=numeric(), cites=numeric())
        evol <- data.frame(year=0, papers=0, cites=0, h_index=0)
        year <- 0
        h_current <- 0
        
        while(h_current < h_target && year < 80){
          current_year <- year
          year <- year+ (1/pa)
          # paper_per_year <- rnorm(1, mean = avg_paper_per_year, sd = sd_paper_per_year)
          
          # Add the new papers to the list
          for(i in 1:pa){
            year <- year+ (1/pa)
            if(ifact <= 0) ifact <- 0.1
            papers <- rbind(papers, data.frame(year=year, ifact=ifa, cites=0))
          }
          
          # Add the new citations to the papers
          for(i in 1:nrow(papers)){
            papers[i,3] <- ((current_year - papers[i,1]) * papers[i,2]) * (1 + (sd_citation * runif(1,-1,1)))
            if(auto){
              autocite <- nrow(papers[papers$year > papers$year[i],])
              papers$cites[i] <- papers$cites[i] + autocite
            }
          }
          
          
          # Compute the global metrix
          papers <- papers[order(papers$cites,decreasing = T),]
          k <- 1
          h_current <- 0
          for(k in 1:nrow(papers)){
            if(h_current < papers$cites[k]) h_current <- h_current+1
          }
          evol <- rbind(evol, data.frame(year=year, papers=nrow(papers), cites=sum(papers$cites), h_index=h_current))
        }
        final <- rbind(final, evol)
      }      
      year <- mean(final$year[final$h_index >= input$h_target])
      if_space <- rbind(if_space, data.frame(papers=pa, ifact=ifa,years=year))
      max_year <- max(max_year,max(if_space$years))
      min_year <- min(min_year,min(if_space$years))
    }
  }
  
  dataList[[length(dataList)+1]] <- if_space
}

write.csv(dataList[[1]], "data/data_sim_no_auto.csv")
write.csv(dataList[[2]], "data/data_sim_auto.csv")


rs1 <- read.csv("data/data_sim_no_auto.csv")
rs2 <- read.csv("data/data_sim_auto.csv")
max_year <- max(rs1$years, rs2$years)
min_year <- min(rs1$years, rs2$years)

dataList <- list(rs1, rs2)
# plots
plotList <- list()
for(i in 1:length(dataList)){
  rs <- dataList[[i]]
  rs <- rs[rs$papers >= 1,]
  names(rs) <- c("id","x", "y", "z")
  g <- ggplot(rs, aes(x, y, z = z)) + 
    geom_tile(aes(fill = z)) + stat_contour(colour="#00000050", bins=20) + 
    scale_fill_gradientn("Number of years",colours=rainbow(10),limits=c(min_year, max_year)) +
    #scale_fill_gradientn(colours=rainbow(10)) +
    theme_classic() +
    xlab("Number of papers / years") + 
    ylab("Number of citations / paper / years") 
  plotList[[length(plotList)+1]] <- g
}

rs <- dataList[[1]]
rs$years <- dataList[[1]]$years - dataList[[2]]$years
names(rs) <- c("id","x", "y", "z")
ggplot(rs, aes(x, y, z = z)) + 
  geom_tile(aes(fill = z)) + stat_contour(colour="#00000050", bins=20) + 
  scale_fill_gradientn("Number of gained years",colours=rainbow(10)) +
  #scale_fill_gradientn(colours=rainbow(5)) +
  theme_classic() +
  xlab("Number of papers / years") + 
  ylab("Number of citations / paper / years") 

plotList[[1]]
plotList[[2]]








