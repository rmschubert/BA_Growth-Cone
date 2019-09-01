for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

library("ggpubr")
library("dplyr")
library("ggplot2")
library("xtable")
library("repr")

data_file <- read.csv('annotation_comparision.csv')

Annotatoren <- c(rep('Annotator1', 66), rep('Annotator2', 66), rep('Annotator3', 66))
Präzision <- c(data_file$Precision)
df <- data.frame(Annotatoren, Präzision)

png("precision_Annos_box.png",
    height = 1600, width = 1800, res = 300)
ggboxplot(df, x = "Annotatoren", y = "Präzision",
          color = "Annotatoren", palette =  c("red", "green", "blue"),
          order = c("Annotator1", "Annotator2", "Annotator3"),
          ylab = "Präzision", xlab = "Annotatoren")+
  scale_y_continuous(limits = c(0,1)) +
  font("ylab", size = 18, face = "bold") +
  font("xy.text", face = "bold", size = 16) + 
  font("legend.text", face = "bold", size = 16) + 
  rremove("legend.title") + rremove("xlab")
dev.off()

precision.aov <- aov(Präzision ~ Annotatoren, data = df)
summary.aov(precision.aov)
print(xtable(summary.aov(precision.aov), type = "latex"),
      file = file.path(tables, "anova_precision_annos.tex"))

pdf('precision_tukey_annos.pdf', height = 6, width = 7, units = "in")
posthoc_precision <- TukeyHSD(precision.aov)
plot(posthoc_precision)
dev.off()

Recall <- c(data_file$Recall)
df2 <- data.frame(Annotatoren, Recall)


png("recall_Annos_box.png",
    height = 1600, width = 1800, res = 300)
ggboxplot(df2, x = "Annotatoren", y = "Recall",
          color = "Annotatoren", palette =  c("red", "green", "blue"),
          order = c("Annotator1", "Annotator2", "Annotator3"),
          ylab = "Recall", xlab = "Annotatoren") +
  scale_y_continuous(limits = c(0,1)) +
  font("ylab", size = 18, face = "bold") +
  font("xy.text", face = "bold", size = 16) + 
  font("legend.text", face = "bold", size = 16) + 
  rremove("legend.title") + rremove("xlab")
dev.off()

recall.aov <- aov(Recall ~ Annotatoren, data = df2)
plot(Recall ~ Annotatoren, data = df2)
summary.aov(recall.aov)
print(xtable(summary.aov(recall.aov), type = "latex"),
      file = file.path(tables, "anova_recall_annos.tex"))

pdf('precision_tukey_annos.pdf', height = 6, width = 7, units = "in")
plot(TukeyHSD(recall.aov))
dev.off()


df3 <- data.frame(Annotatoren, Präzision, Recall)

b <- group_by(df3, Annotatoren) %>%
      summarise(count = n(),
            Präzision = mean(Präzision, na.rm = TRUE),
            Recall = mean(Recall, na.rm = TRUE),
            sd_prec = sd(Präzision, na.rm = T),
            sd_rec = sd(Recall, na.rm = T)
      )
b
k3 <- data.frame(Annotatoren=rep(c("Annotator1", "Annotator2", "Annotator3"), each=2),
                 Messgröße=rep(c("Präzision", "Recall"),3),
                 Durchschnitt=c(0.584, 0.801, 0.543,
                         0.816, 0.541, 0.836),
                 StdAbweichung=c(0.185, 0.157, 0.211, 0.157,
                                 0.183, 0.160))
k3

png("prec_rec_Annos_bar.png",
    height = 1400, width = 2000, res = 300)
ggplot(k3, aes(x=Annotatoren, y=Durchschnitt, fill=Messgröße))+
  geom_bar(stat = "identity", position = position_dodge(0.8),
                  width = .7)+
  geom_text(
  aes(label = Durchschnitt, group = Messgröße),
  position = position_dodge(0.8),
  vjust = -0.4, hjust=1.1, size = 4
  ) +
  coord_cartesian(ylim=c(0, 1)) +
  geom_errorbar(aes(ymin=Durchschnitt-StdAbweichung,
                           ymax=Durchschnitt+StdAbweichung),
                       width=.2, position = position_dodge(0.8)) +
  theme_classic2() + labs(title = "Durchschnitt von Präzision und Recall der Annotatoren") +
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"),
        axis.text.y = element_text(size = 12, face = "bold"),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        )
dev.off()
print(c)

