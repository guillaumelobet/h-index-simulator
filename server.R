
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

#    input <- data.frame(avg_paper_per_year = 4, sd_paper_per_year=2, h_target=10,
 #                       avg_IF=7, sd_IF=1, n_sim=10, year_start=2011)
    
    h_target <-input$h_target
    avg_paper_per_year <- input$avg_paper_per_year
    sd_paper_per_year <- input$sd_paper_per_year
    avg_IF <- input$avg_IF
    sd_IF <- input$sd_IF
    final <- data.frame(year=numeric(), papers=numeric(), cites=numeric(), h_index=numeric())
    
    for(j in 1:input$n_sim){
      papers <- data.frame(year=numeric(), ifact=numeric(), cites=numeric())
      evol <- data.frame(year=0, papers=0, cites=0, h_index=0)
      year <- 0
      h_current <- 0
      
      while(h_current < h_target){
        year <- year+1
        paper_per_year <- rnorm(1, mean = avg_paper_per_year, sd = sd_paper_per_year)
        
        # Add the new papers to the list
        for(i in 1:paper_per_year){
          ifact <- rnorm(1, mean = avg_IF, sd = sd_IF)
          papers <- rbind(papers, data.frame(year=year, ifact=ifact, cites=0))
        }
        
        # Add the new citations to the papers
        for(i in 1:nrow(papers)){
          papers$cites[i] <- (year - papers$year[i]) * papers$ifact[i]
          if(input$autocite){
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
    
    final$year <- final$year + input$year_start
    
    year <- mean(final$year[final$h_index >= input$h_target])
    
    plot_papers <- ggplot(data=final, aes(x=year, y=papers)) +
      geom_point() +
      stat_smooth() +
      geom_vline(xintercept=year, colour="red") +
      ylab("Total number of papers") +
      xlab("Year") +
      theme_classic()
    
    plot_h <- ggplot(data=final, aes(x=year, y=h_index)) +
      geom_point() +
      stat_smooth() +
      geom_hline(yintercept=h_target, colour="red") +
      geom_vline(xintercept=year, colour="red") +
      ylab("h-index") +
      xlab("Year") +
      theme_classic() 
    
    plot_cites <- ggplot(data=final, aes(x=year, y=cites)) +
      geom_point() +
      stat_smooth() +
      geom_vline(xintercept=year, colour="red") +
      ylab("Total number of citations") +
      xlab("Year") +
      theme_classic()
    
    answer <- paste("h-index of ",h_target)
    answer2 <- paste(" expected to be reached in ",round(year), sep="")
    
    df <- data.frame()
    text_plot <- ggplot(df) + geom_point() + xlim(0, 10) + ylim(0, 100) + theme_minimal() +
      theme(line = element_blank(), text = element_blank(), line = element_blank(), title = element_blank()) + 
      annotate("text", x = 5, y = 35, label = answer)+
      annotate("text", x = 5, y = 25, label = answer2)
    
    grid.arrange(plot_h, plot_cites, plot_papers, text_plot, nrow = 2)
  })

})
