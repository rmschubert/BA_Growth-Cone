for (p in list("xtable", "icesTAF", "ggpubr", "dplyr", "ggplot2", "repr")){
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

data_file <- read.csv('annotation_comparison.csv')

Annotatoren <- c(rep('Annotator1', 66), rep('Annotator2', 66), rep('Annotator3', 66))
Präzision <- c(data_file$Precision)
Recall <- c(data_file$Recall)
JI <- c(data_file$Jac_Index)


df <- data.frame(Annotatoren, Präzision, Recall, JI)

b <- group_by(df, Annotatoren) %>%
  summarise(count = n(),
            Präzision = mean(Präzision2, na.rm = T),
            Recall = mean(Recall2, na.rm = T),
            JI = mean(JI1, na.rm = T),
            sd_prec = sd(Präzision2, na.rm = T),
            sd_rec = sd(Recall2, na.rm = T),
            sd_JI = sd(JI1, na.rm = T)
  )

print(xtable(b, type = "latex"),
      file = 'summary_annotations.tex')
