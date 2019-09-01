for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

library("ggpubr")

con_n <- read.csv("consens/No-Gan/normal/mean_all.csv")
con_i <- read.csv("consens/No-Gan/inverted/mean_all.csv")
con_n_gan <- read.csv("consens/GAN/normal/mean_all.csv")
con_i_gan <- read.csv("consens/GAN/inverted/mean_all.csv")

stats_normal <- data.frame(means = c(con_n$Precision_M, con_n$Recall_M, con_n_gan$Precision_M, con_n_gan$Recall_M),
                     p_std = c(con_n$Precision_S, con_n$Recall_S, con_n_gan$Precision_S, con_n_gan$Recall_S),
                     names = c('AE', 'AE', 'GAN', 'GAN'),
                     Messgröße=rep(c("Präzision", "Recall"),2))

png("normal_consens_bar.png",
    height = 1400, width = 2000, res = 300)
ggplot(stats_normal, aes(x=names, y=means, fill=Messgröße))+
  geom_bar(stat = "identity", position = position_dodge(0.8),
           width = .7)+
  geom_text(
    aes(label = means, group = Messgröße),
    position = position_dodge(0.8),
    vjust = -0.4, hjust=1.1, size = 4
  ) +
  coord_cartesian(ylim=c(0, 1)) +
  geom_errorbar(aes(ymin=means-p_std,
                    ymax=means+p_std),
                width=.2, position = position_dodge(0.8)) +
  theme_classic2() + labs(title = "Durchschnitt von Präzision und Recall der Vorhersagen") +
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"),
        axis.text.y = element_text(size = 12, face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
  )
dev.off()

stats_inverted <- data.frame(i_means = c(con_i$Precision_M, con_i$Recall_M, con_i_gan$Precision_M, con_i_gan$Recall_M),
                     i_p_std = c(con_i$Precision_S, con_i$Recall_S, con_i_gan$Precision_S, con_i_gan$Recall_S),
                     i_names = c('AE', 'AE', 'GAN', 'GAN'),
                     i_Messgröße=rep(c("Präzision", "Recall"),2))

png("inverted_consens_bar.png",
    height = 1400, width = 2000, res = 300)
ggplot(stats_inverted, aes(x=i_names, y=i_means, fill=i_Messgröße))+
  geom_bar(stat = "identity", position = position_dodge(0.8),
           width = .7)+
  geom_text(
    aes(label = i_means, group = i_Messgröße),
    position = position_dodge(0.8),
    vjust = -0.4, hjust=1.2, size = 4
  ) +
  coord_cartesian(ylim=c(0, 1)) +
  geom_errorbar(aes(ymin=i_means-i_p_std,
                    ymax=i_means+i_p_std),
                width=.2, position = position_dodge(0.8)) +
  theme_classic2() +
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(face = "bold"),
        axis.text.x = element_text(size = 12, face = "bold"),
        axis.text.y = element_text(size = 12, face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
  )
dev.off()