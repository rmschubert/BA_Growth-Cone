for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

data_file <- read.csv('annotation_comparison.csv')

Annotatoren <- c(rep('Annotator1', 66), rep('Annotator2', 66), rep('Annotator3', 66))
Pr�zision <- c(data_file$Precision)
Recall <- c(data_file$Recall)
JI <- c(data_file$Jac_Index)


df <- data.frame(Annotatoren, Pr�zision, Recall, JI)

b <- group_by(df, Annotatoren) %>%
  summarise(count = n(),
            Pr�zision = mean(Pr�zision, na.rm = T),
            Recall = mean(Recall, na.rm = T),
            JI = mean(JI, na.rm = T),
            sd_prec = sd(Pr�zision, na.rm = T),
            sd_rec = sd(Recall, na.rm = T),
            sd_JI = sd(JI, na.rm = T)
  )

print(xtable(b, type = "latex"),
      file = 'summary_annotations.tex')
