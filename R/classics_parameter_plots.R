for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

install.packages("scales")
library("scales")
library("ggpubr")

clas_file_normal <- read.csv('classics/parameter_stats.csv')
clas_file_inv <- read.csv('classics/parameter_stats_inv.csv')


df_normal_precision <- data.frame(type = clas_file_normal$Method,
                                  parameter = clas_file_normal$Parameter,
                                  precision = clas_file_normal$Precision)
df_normal_precision
df_N_prec_gamma <- subset(df_normal_precision, type %in% c("gamma", "gamma-med", "gamma-ots"))
df_N_prec_log <- subset(df_normal_precision, type %in% c("log", "log-med", "log-ots"))
df_N_prec_gamma

png("classic_precision_gamma.png",
    height = 1800, width = 1800, res = 290)
ggplot(df_N_prec_gamma, aes(x=parameter, y=precision, group=type, colour = type)) +
  theme_minimal()+
  geom_line(aes(colour = type), size=1.2)+
  geom_point(aes(shape=type), size=4)+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19), legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_N_prec_gamma$parameter,
                     labels = scientific(df_N_prec_gamma$parameter, digits = 2))+
  scale_y_continuous(name="Präzision", breaks = seq(0, 0.025, by = 0.005), limits = c(0, 0.025))
dev.off()

png("classic_precision_log.png",
    height = 1800, width = 1800, res = 290)  
ggplot(df_N_prec_log, aes(x=df_N_prec_log$parameter, y=df_N_prec_log$precision,
                          group=df_N_prec_log$type, colour = df_N_prec_log$type)) +
  theme_minimal()+
  geom_line(aes(colour = df_N_prec_log$type), size=1.2)+
  geom_point(aes(shape=df_N_prec_log$type), size=4)+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19),
        legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_N_prec_log$parameter,
                     labels = scientific(df_N_prec_log$parameter, digits = 2))+
  scale_y_continuous(name="Präzision", breaks = seq(0, 0.025, by = 0.005), limits = c(0, 0.025))
dev.off()

df_normal_recall <- data.frame(t = clas_file_normal$Method,
                               p = clas_file_normal$Parameter,
                               r = clas_file_normal$Recall)
df_N_rec_gamma <- subset(df_normal_recall, t %in% c("gamma", "gamma-med", "gamma-ots"))
df_N_rec_log <- subset(df_normal_recall, t %in% c("log", "log-med", "log-ots"))

png("classic_recall_gamma.png",
    height = 1800, width = 1800, res = 290)
ggplot(df_N_rec_gamma, aes(x=df_N_rec_gamma$p, y=df_N_rec_gamma$r, group=df_N_rec_gamma$t, colour = df_N_rec_gamma$t)) +
  theme_minimal()+
  geom_line(aes(colour = df_N_rec_gamma$t), size=1.2)+
  geom_point(aes(shape=df_N_rec_gamma$t), size=4)+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19),
        legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16), 
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_N_rec_gamma$p,
                     labels = scientific(df_N_rec_gamma$p, digits = 2))+
  scale_y_continuous(name="Recall", limits = c(0,1), breaks = seq(0, 1, by = 0.2))
dev.off()

png("classic_recall_log.png",
    height = 1800, width = 1800, res = 290)
ggplot(df_N_rec_log, aes(x=df_N_rec_log$p, y=df_N_rec_log$r,
                          group=df_N_rec_log$t, colour = df_N_rec_log$t)) +
  geom_line(aes(colour = df_N_rec_log$t), size=1.2)+
  geom_point(aes(shape=df_N_rec_log$t), size=4)+
  theme_minimal()+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19),
        legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16), 
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_N_rec_log$p,
                     labels = scientific(df_N_rec_log$p, digits = 2))+
  scale_y_continuous(name="Recall", limits = c(0,1), breaks = seq(0, 1, by = 0.2))
dev.off()


df_in_precision <- data.frame(ti = clas_file_inv$Method,
                              pi = clas_file_inv$Parameter,
                              pri = clas_file_inv$Precision)
df_in_prec_gamma <- subset(df_in_precision, ti %in% c("gamma", "gamma-med", "gamma-ots"))
df_in_prec_log <- subset(df_in_precision, ti %in% c("log", "log-med", "log-ots"))

png("classic_precision_gamma_inv.png",
    height = 1800, width = 1800, res = 290)
ggplot(df_in_prec_gamma, aes(x=df_in_prec_gamma$pi, y=df_in_prec_gamma$pri, group=df_in_prec_gamma$ti,
                            colour = df_in_prec_gamma$ti)) +
  theme_minimal()+
  geom_line(aes(colour = df_in_prec_gamma$ti), size=1.2)+
  geom_point(aes(shape=df_in_prec_gamma$ti), size=4)+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19), legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_in_prec_gamma$pi,
                     labels = scientific(df_in_prec_gamma$pi, digits = 2))+
  scale_y_continuous(name="Präzision", breaks = seq(0, 0.1, by = 0.025), limits = c(0, 0.1))
dev.off()

png("classic_precision_log_inv.png",
    height = 1800, width = 1800, res = 290)
ggplot(df_in_prec_log, aes(x=df_in_prec_log$pi, y=df_in_prec_log$pri, group=df_in_prec_log$ti,
                            colour = df_in_prec_log$ti)) +
  theme_minimal()+
  geom_line(aes(colour = df_in_prec_log$ti), size=1.2)+
  geom_point(aes(shape=df_in_prec_log$ti), size=4)+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19), legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_in_prec_log$pi,
                     labels = scientific(df_in_prec_log$pi, digits = 2))+
  scale_y_continuous(name="Präzision", breaks = seq(0, 0.1, by = 0.025), limits = c(0, 0.1))
dev.off()

df_in_recall <- data.frame(tir = clas_file_inv$Method,
                              pir = clas_file_inv$Parameter,
                              prir = clas_file_inv$Recall)
df_in_rec_gamma <- subset(df_in_recall, tir %in% c("gamma", "gamma-med", "gamma-ots"))
df_in_rec_log <- subset(df_in_recall, tir %in% c("log", "log-med", "log-ots"))

png("classic_recall_log_inv.png",
    height = 1800, width = 1800, res = 290)
ggplot(df_in_rec_gamma, aes(x=df_in_rec_log$pir, y=df_in_rec_log$prir, group=df_in_rec_log$tir,
                            colour = df_in_rec_log$tir)) +
  theme_minimal()+
  geom_line(aes(colour = df_in_rec_log$tir), size=1.2)+
  geom_point(aes(shape=df_in_rec_log$tir), size=4)+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19), legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_in_rec_log$pir,
                     labels = scientific(df_in_rec_log$pir, digits = 2))+
  scale_y_continuous(name="Recall", breaks = seq(0, 1, by = 0.25), limits = c(0, 1))
dev.off()

png("classic_recall_gamma_inv.png",
    height = 1800, width = 1800, res = 290)
ggplot(df_in_rec_log, aes(x=df_in_rec_gamma$pir, y=df_in_rec_gamma$prir, group=df_in_rec_gamma$tir,
                            colour = df_in_rec_gamma$tir)) +
  theme_minimal()+
  geom_line(aes(colour = df_in_rec_gamma$tir), size=1.2)+
  geom_point(aes(shape=df_in_rec_gamma$tir), size=4)+
  theme(legend.position="top", legend.text = element_text(face="bold", size = 19), legend.title = element_blank(),
        axis.text.x = element_text(face = "bold", angle = 60, hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_text(face = "bold", size = 19),
        axis.title.y = element_text(face = "bold", size = 19),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_x_continuous(name="Parameter", breaks = df_in_rec_gamma$pir,
                     labels = scientific(df_in_rec_gamma$pir, digits = 2))+
  scale_y_continuous(name="Recall", breaks = seq(0, 1, by = 0.25), limits = c(0, 1))
dev.off()
