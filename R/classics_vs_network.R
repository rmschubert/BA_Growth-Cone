for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

library("icesTAF")
library("ggpubr")

test_data <- data.frame(read.csv('test/all_stats.csv'))
class_data <- data.frame(read.csv('classics/all_stats.csv'))


test_data$Filter <- as.factor(test_data$Filter)
test_data$Nr <- as.factor(test_data$Nr)
test_data$Epochen <- as.factor(test_data$Epochen)

test_means <- aggregate(cbind(Präzision, Recall, JI, MSD) ~ Typ + Filter + Epochen + GAN, data = test_data, mean)
class_means <- aggregate(cbind(Präzision, Recall, JI, MSD) ~ Methode + Typ, data = class_data, mean)

plot_data <- data.frame(means = 
                      c(max(test_means$Präzision),
                        max(class_means$Präzision),
                        max(test_means$Recall),
                        max(class_means$Recall),
                        max(test_means$JI),
                        max(class_means$JI),
                        min(test_means$MSD),
                        min(class_means$MSD)),
           names = c("Netzwerk", "Klassisch"),
           Messgröße=c(rep("Präzision", 2), rep("Recall", 2), rep("JI", 2), rep("MSD", 2)))

scaleFUN <- function(x) sprintf("%.2f", x)


png('classics_vs_network.png', height = 1800, width = 1800, res = 300)
ggplot(plot_data, aes(x=names, y=means, fill=Messgröße), yaxt="n")+
  geom_bar(stat = "identity", position = position_dodge(0.8),
           width = .7)+
  geom_text(
    aes(label = scaleFUN(means), group = Messgröße),
    position = position_dodge(0.8),
    vjust = -0.4, hjust=0.9, size = 4.5
  ) +
  theme_pubclean() +
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"),
        axis.title.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank()
  )
dev.off()
