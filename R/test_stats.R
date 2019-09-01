for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

library("icesTAF")
library("ggpubr")
library("xtable")

test_data <- data.frame(read.csv('test/all_stats.csv'))

test_data$Filter <- as.factor(test_data$Filter)
test_data$Nr <- as.factor(test_data$Nr)
test_data$Epochen <- as.factor(test_data$Epochen)


test_precision.aov <- aov(Präzision ~ Annotator + Typ + Filter + Epochen + 
                       GAN + Nr + Epochen:Filter + GAN:Filter, data = test_data)
summary.aov(test_precision.aov)

### Interaction-plots

png("filter_epochs.png", height = 1800, width = 1800, res = 300)
test_data %>% 
  ggplot() +
  aes(x = Epochen, color = Filter, group = Filter, y = Präzision, shape = Filter) +
  stat_summary(fun.y = mean, geom = "point", size = 3) +
  stat_summary(fun.y = mean, geom = "line", size = 1.5) + 
  theme_minimal() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(face = "bold", hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.text = element_text(face="bold", size = 16),
        legend.title = element_blank(),
        legend.position = "top")
dev.off()

png("filter_gan.png", height = 1800, width = 1800, res = 300)
test_data %>% 
  ggplot() +
  aes(x = Filter, color = GAN, group = GAN, y = Präzision, shape = GAN) +
  stat_summary(fun.y = mean, geom = "point", size = 3) +
  stat_summary(fun.y = mean, geom = "line", size = 1.5) + 
  theme_minimal() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(face = "bold", hjust = 1, size = 16),
        axis.text.y = element_text(face = "bold", size = 16),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.text = element_text(face="bold", size = 16),
        legend.title = element_blank(),
        legend.position = "top")
dev.off()


print(xtable(summary.aov(test_precision.aov), type = "latex"),
      file = "precision.tex")

pdf("Annotator.pdf")
tuk <- TukeyHSD(test_precision.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Filter.pdf")
tuk <- TukeyHSD(test_precision.aov, which = "Filter")
psig=as.numeric(apply(tuk$`Filter`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Filter_GAN.pdf")
tuk <- TukeyHSD(test_precision.aov, which = "Filter:GAN")
psig=as.numeric(apply(tuk$`Filter:GAN`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter:GAN`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

#######  Recall

test_recall.aov <- aov(Recall ~ Annotator + Typ + Filter + Epochen + 
                         GAN + Nr + Epochen:Filter + GAN:Filter, data = test_data)
summary.aov(test_recall.aov)
print(xtable(summary.aov(test_recall.aov), type = "latex"),
      file = "recall.tex")

pdf("Filter_Epochen_Recall.pdf")
tuk <- TukeyHSD(test_recall.aov, which = "Filter:Epochen")
psig=as.numeric(apply(tuk$`Filter:Epochen`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter:Epochen`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Annotator_Recall.pdf")
tuk <- TukeyHSD(test_recall.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Epochen_Recall.pdf")
tuk <- TukeyHSD(test_recall.aov, which = "Epochen")
psig=as.numeric(apply(tuk$`Epochen`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Epochen`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Filter_GAN_Recall.pdf")
tuk <- TukeyHSD(test_recall.aov, which = "Filter:GAN")
psig=as.numeric(apply(tuk$`Filter:GAN`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter:GAN`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

######### Jaccard-Index

test_ji.aov <- aov(JI ~ Annotator + Typ + Filter + Epochen + 
                     GAN + Nr + Epochen:Filter + GAN:Filter, data = test_data)
summary.aov(test_ji.aov)
print(xtable(summary.aov(test_ji.aov), type = "latex"),
      file = "ji.tex")

pdf("Filter_Epochen_JI.pdf")
tuk <- TukeyHSD(test_ji.aov, which = "Filter:Epochen")
psig=as.numeric(apply(tuk$`Filter:Epochen`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter:Epochen`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Annotator_JI.pdf")
tuk <- TukeyHSD(test_ji.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Epochen_JI.pdf")
tuk <- TukeyHSD(test_ji.aov, which = "Epochen")
psig=as.numeric(apply(tuk$`Epochen`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Epochen`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Filter_GAN_JI.pdf")
tuk <- TukeyHSD(test_ji.aov, which = "Filter:GAN")
psig=as.numeric(apply(tuk$`Filter:GAN`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter:GAN`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Filter_JI.pdf")
tuk <- TukeyHSD(test_ji.aov, which = "Filter")
psig=as.numeric(apply(tuk$`Filter`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

######## MSD

test_msd.aov <- aov(MSD ~ Annotator + Typ + Filter + Epochen + 
                  GAN + Nr + Epochen:Filter + GAN:Filter, data = test_data)
summary.aov(test_msd.aov)
print(xtable(summary.aov(test_msd.aov), type = "latex"),
      file = "msd.tex")

pdf("Filter_Epochen_MSD.pdf")
tuk <- TukeyHSD(test_msd.aov, which = "Filter:Epochen")
psig=as.numeric(apply(tuk$`Filter:Epochen`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter:Epochen`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Annotator_MSD.pdf")
tuk <- TukeyHSD(test_msd.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Epochen_MSD.pdf")
tuk <- TukeyHSD(test_msd.aov, which = "Epochen")
psig=as.numeric(apply(tuk$`Epochen`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Epochen`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Filter_MSD.pdf")
tuk <- TukeyHSD(test_msd.aov, which = "Filter")
psig=as.numeric(apply(tuk$`Filter`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.3,10.5,3.8,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Filter`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()
