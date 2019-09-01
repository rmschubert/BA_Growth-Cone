for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}


all_data <- data.frame(read.csv('classics/all_stats.csv'))


library("icesTAF")
library("ggpubr")
library("xtable")

### Interaction-plots

png("annos_type.png", height = 1800, width = 1800, res = 300)
all_data %>% 
  ggplot() +
  aes(x = Annotator, color = Typ, group = Typ, y = Präzision, shape = Typ) +
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

png("annos_method.png", height = 1800, width = 1800, res = 300)
all_data %>% 
  ggplot() +
  aes(x = Annotator, color = Methode, group = Methode, y = Präzision, shape = Methode) +
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

png("type_method.png", height = 1800, width = 1800, res = 300)
all_data %>% 
  ggplot() +
  aes(x = Typ, color = Methode, group = Methode, y = Präzision, shape = Methode) +
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

### anova

precision.aov <- aov(Präzision ~ Annotator*Methode*Typ, data = all_data)
summary.aov(precision.aov)
print(xtable(summary.aov(precision.aov), type = "latex"),
      file = "precision.tex")

pdf("Annotator.pdf")
tuk <- TukeyHSD(precision.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,9,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Methode.pdf")
tuk <- TukeyHSD(precision.aov, which = "Methode")
psig=as.numeric(apply(tuk$`Methode`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,10,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Methode`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Annotator_Typ.pdf")
tuk <- TukeyHSD(precision.aov, which = "Annotator:Typ")
psig=as.numeric(apply(tuk$`Annotator:Typ`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,14,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator:Typ`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Methode_Typ.pdf")
tuk <- TukeyHSD(precision.aov, which = "Methode:Typ")
psig=as.numeric(apply(tuk$`Methode:Typ`[,2:3],1,prod)>=0)+1
op=par(mar=c(1.9,15.5,1.9,1))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Methode:Typ`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

recall.aov <- aov(Recall ~ Annotator*Methode*Typ, data = all_data)
summary.aov(recall.aov)
print(xtable(summary.aov(recall.aov), type = "latex"),
      file = "recall.tex")

pdf("Annotator_Recall.pdf")
tuk <- TukeyHSD(recall.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,9,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Methode_Typ_Recall.pdf")
tuk <- TukeyHSD(recall.aov, which = "Methode:Typ")
psig=as.numeric(apply(tuk$`Methode:Typ`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,15,2.5,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Methode:Typ`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

ji.aov <- aov(JI ~ Annotator*Methode*Typ, data = all_data)
summary.aov(ji.aov)
print(xtable(summary.aov(ji.aov), type = "latex"),
      file = "ji.tex")

pdf("Methode_Typ_JI.pdf")
tuk <- TukeyHSD(ji.aov, which = "Methode:Typ")
psig=as.numeric(apply(tuk$`Methode:Typ`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,15,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Methode:Typ`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Annotator_JI.pdf")
tuk <- TukeyHSD(ji.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,9,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Methode_JI.pdf")
tuk <- TukeyHSD(ji.aov, which = "Methode")
psig=as.numeric(apply(tuk$`Methode`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,9,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Methode`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

msd.aov <- aov(MSD ~ Annotator*Methode*Typ, data = all_data)
summary.aov(msd.aov)
print(xtable(summary.aov(msd.aov), type = "latex"),
      file = "msd.tex")

pdf("Annotator_MSD.pdf")
tuk <- TukeyHSD(msd.aov, which = "Annotator")
psig=as.numeric(apply(tuk$`Annotator`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,9,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Annotator_Typ_MSD.pdf")
tuk <- TukeyHSD(msd.aov, which = "Annotator:Typ")
psig=as.numeric(apply(tuk$`Annotator:Typ`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,12,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Annotator:Typ`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

pdf("Methode_Typ_MSD.pdf")
tuk <- TukeyHSD(msd.aov, which = "Methode:Typ")
psig=as.numeric(apply(tuk$`Methode:Typ`[,2:3],1,prod)>=0)+1
op=par(mar=c(4.2,15,3.8,2))
plot(tuk,col=psig,yaxt="n")
for (j in 1:length(psig)){
  axis(2,at=j,labels=rownames(tuk$`Methode:Typ`)[length(psig)-j+1],
       las=1,cex.axis=.8,col.axis=psig[length(psig)-j+1])
}
par(op)
dev.off()

data_sub1 <- all_data[all_data$Typ == 'inverted',]

inv.means <- aggregate(data_sub1[c('Präzision', 'Recall', 'JI', 'MSD')],
                       by = data_sub1['Methode'],
                       FUN=mean)
inv.means
inv.sd <- aggregate(data_sub1[c('Präzision', 'Recall', 'JI', 'MSD')],
                    by = data_sub1['Methode'],
                    FUN=sd)

rename <- function(df){
  c <- 0
  for (i in 1:length(names(df))){
    if (names(df)[i] == 'Methode'){
      next
    } else{
      names(df)[i] <- paste(names(df)[i], ".sd")
    }
    
  }
  return(df)
}

inv.sd <- rename(inv.sd)
inv.all <- merge(inv.means, inv.sd)

print(xtable(inv.all, type = "latex"),
      file = "inverted_methods.tex")

data_sub2 <- all_data[all_data$Typ == 'normal',]
norm.means <- aggregate(data_sub2[c('Präzision', 'Recall', 'JI', 'MSD')],
                        by = data_sub1['Methode'],
                        FUN=mean)
norm.sd <- aggregate(data_sub2[c('Präzision', 'Recall', 'JI', 'MSD')],
                     by = data_sub1['Methode'],
                     FUN=sd)

norm.sd <- rename(norm.sd)
norm.all <- merge(norm.means, norm.sd)

print(xtable(norm.all, type = "latex"),
      file = "normal_methods.tex")
