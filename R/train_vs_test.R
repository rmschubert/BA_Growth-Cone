for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

train_data <- data.frame(read.csv('train/all_stats.csv'))
test_data <- data.frame(read.csv('test/all_stats.csv'))

test_data$Filter <- as.factor(test_data$Filter)
test_data$Nr <- as.factor(test_data$Nr)
test_data$Epochen <- as.factor(test_data$Epochen)
train_data$Filter <- as.factor(train$Filter)
train_data$Nr <- as.factor(train$Nr)
train_data$Epochen <- as.factor(train$Epochen)

test_means <- aggregate(cbind(Präzision, Recall, JI, MSD) ~ Typ + Filter + Epochen + GAN, data = test_data, mean)
train_means <- aggregate(cbind(Präzision, Recall, JI, MSD) ~ Typ + Filter + Epochen + GAN, data = train_data, mean)

make_plots <- function(data_frame, variant){
  library("icesTAF")
  library("ggpubr")
  
  scaleFUN <- function(x) sprintf("%.2f", x)
  
  for (gan in levels(data_frame$GAN)) {
    for (typ in levels(data_frame$Typ)) {
      print(gan)
      tmp_frame <-
        data_frame[data_frame$GAN == gan,]
      frame <- 
        tmp_frame[tmp_frame$Typ == typ,]
      
      if (gan == 'yes') {
        g <- 'GAN'
      } else{
        g <- 'No-GAN'
      }
      
      fp <- file.path(variant, g, typ)
      mkdir(fp)
      
      
      for (measure in c('Präzision', 'Recall', 'JI', 'MSD')) {
        
        max_measure <- max(frame[, which(names(frame) == measure)])
        if (max_measure < 1){
          lim <- max_measure + 0.1
          b <- seq(0, lim, 0.1)
        } else if (max_measure == 1){
          lim <- max_measure
          b <- seq(0, max_measure, 0.1)
        } else {
          if (max_measure > 10){
            k <- 5
          } else {
            k <- 1
          }
          dist <- max_measure%%5
          lim <- max_measure - dist + 5
          b <- seq(0, lim, k)
        }
        
        png(
          file.path(fp, paste(measure, '.png', sep = "")),
          height = 1800,
          width = 1800,
          res = 300
        )
        print({
          frame %>%
          ggplot() +
          aes(
            x = Epochen,
            color = Filter,
            group = Filter,
            y = frame[, which(names(frame) == measure)],
            shape = Filter
          ) +
          stat_summary(fun.y = mean,
                       geom = "point",
                       size = 3) +
          stat_summary(fun.y = mean,
                       geom = "line",
                       size = 1.5) +
            scale_y_continuous(name = measure,
                               breaks = b,
                               limits = c(0, lim),
                               labels = scaleFUN)+
          theme_minimal() +
          theme(
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.text.x = element_text(
              face = "bold",
              hjust = 1,
              size = 16
            ),
            axis.text.y = element_text(face = "bold", size = 16),
            axis.title.x = element_blank(),
            axis.title.y = element_text(face = "bold", size = 17.5),
            legend.text = element_text(face = "bold", size = 16),
            legend.title = element_blank(),
            legend.position = "top"
          )
        })
        dev.off()
      }
    }
  }
}

make_plots(data_frame = test_means, variant = 'test')
make_plots(data_frame = train_means, variant = 'train')

make_dif_plots <- function(test_frame, train_frame){
  library("icesTAF")
  library("ggpubr")
  
  scaleFUN <- function(x) sprintf("%.2f", x)
  
  for (gan in levels(test_frame$GAN)) {
    for (typ in levels(test_frame$Typ)) {
      print(gan)
      tmp_test <-
        test_frame[test_frame$GAN == gan,]
      frame_test <- 
        tmp_test[tmp_test$Typ == typ,]
      
      tmp_train <-
        train_frame[train_frame$GAN == gan,]
      frame_train <-
        tmp_train[tmp_train$Typ == typ,]
      
      M <- merge(frame_test,frame_train,by=c("Filter", "Epochen", "GAN", "Typ"))
      
      diff <- M[,grepl("*\\.x$", names(M))] - M[,grepl("*\\.y$",names(M))]
      diff_frame <- cbind(M[, c(1:4)],diff)
      
      colnames(diff_frame) <- gsub('.x', '', names(diff_frame))
      
      if (gan == 'yes') {
        g <- 'GAN'
      } else{
        g <- 'No-GAN'
      }
      
      fp <- file.path('diff_plots', g, typ)
      mkdir(fp)
      
      
      for (measure in c('Präzision', 'Recall', 'JI', 'MSD')) {
        
        max_measure <- max(diff_frame[, which(names(diff_frame) == measure)])
        min_measure <- min(diff_frame[, which(names(diff_frame) == measure)])
        
        if (min_measure >= -1){
          u_m <- min_measure - 1 + abs(min_measure)
        } else {
          u_m <- -(abs(min_measure) - abs(min_measure)%%5 + 5)
        }
        
        if (max_measure < 1){
          lim <- max_measure + 0.1
          b <- seq(u_m, lim, 0.1)
        } else if (max_measure == 1){
          lim <- max_measure
          b <- seq(u_m, max_measure, 0.1)
        } else {
          if (max_measure > 10){
            k <- 5
          } else {
            k <- 1
          }
          dist <- max_measure%%5
          lim <- max_measure - dist + 5
          b <- seq(u_m, lim, k)
        }

        png(
          file.path(fp, paste(measure, '.png', sep = "")),
          height = 1800,
          width = 1800,
          res = 300
        )
        print({
          diff_frame %>%
            ggplot() +
            aes(
              x = Epochen,
              color = Filter,
              group = Filter,
              y = diff_frame[, which(names(diff_frame) == measure)],
              shape = Filter
            ) +
            stat_summary(fun.y = mean,
                         geom = "point",
                         size = 3) +
            stat_summary(fun.y = mean,
                         geom = "line",
                         size = 1.5) +
            scale_y_continuous(name = measure,
                               breaks = b,
                               limits = c(u_m, lim),
                               labels = scaleFUN)+
            theme_minimal() +
            theme(
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.text.x = element_text(
                face = "bold",
                hjust = 1,
                size = 16
              ),
              axis.text.y = element_text(face = "bold", size = 16),
              axis.title.x = element_blank(),
              axis.title.y = element_text(face = "bold", size = 17.5),
              legend.text = element_text(face = "bold", size = 16),
              legend.title = element_blank(),
              legend.position = "top"
            )
        })
        dev.off()
      }
    }
  }
}

make_dif_plots(test_means, train_means)

make_tables <- function(data_frame){
  library("icesTAF")
  library("xtable")
  
  for (gan in levels(data_frame$GAN)) {
    for (typ in levels(data_frame$Typ)) {
      tmp_frame <-
        data_frame[data_frame$GAN == gan,]
      frame <- 
        tmp_frame[tmp_frame$Typ == typ,]
      frame <-
        frame[, -which(names(frame) == 'Typ')]
      frame <-
        aggregate(frame[c('Präzision', 'Recall', 'JI', 'MSD')],
                  by = frame['Filter'],
                  FUN=mean)
      
      fp <- file.path('test_summary')
      mkdir(fp)
      
      print(xtable(frame, type = "latex"),
            file = file.path(fp, paste(paste(gan, typ, sep = "_"), '.tex', sep = "")))
    }
  }
}

make_tables(test_means)




  