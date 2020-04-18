# !/usr/bin/Rscript

# Final Project- Creating a Professional 3-D Figure Using GGplot within R
# Contributors- Tori Coutts, Kaitlyn Murphy, and Megan Roberts

# This script will be used after starting up the R atmosphere in which GGplot will be ran.

# Sets current working directory to where R will be ran and graphs will be saved
setwd("/Users/Desktop")

# Installing GGplot, if needed
print("Do you have GGplot previously installed? (Y/N)") response
if($response="Y") {continue} else {install.packages('ggplot2')}

# if(condition1 && condition2) { expression }

# Starting up GGplot
library(ggplot2)

# Reading the CSV file and making sure R uploaded it correctly
datum=read.csv(file.choose())
head (datum)

#if($barpng) {code for bar graph saved as png} else {continue}
#if($bartiff) {code for bar graph saved as tiff} else {continue}

# Choosing the plotting and output type
print("1-1 Bar Graph/PNG")
print("1-2 Bar Graph/Tiff")
print("1-3 Bar Graph/JPEG")
print("2-1 Point Graph/PNG")
print("2-2 Point Graph/Tiff")
print("2-3 Point Graph/JPEG")
print("3-1 Line Graph/PNG")
print("3-2 Line Graph/Tiff")
print("3-3 Line Graph/JPEG")
print("Enter plot type preference: ") plotnumber
if (plotnumber="1-1") {#go to bar graph script with PNG output}
if (plotnumber="1-2") {#go to bar graph script with Tiff output}
if (plotnumber="1-3") {#go to bar graph script with JPEG output}

if (plotnumber="2-1") {#Begin by running a basic linear mixed-effects model and call on the summary to see the results.
#Here I am analyzing the log of hatchling mass to hatchling snout-vent length (SVL).
  
resultshatchmass=lme(log(MASS)~log(SVL),data=datum,random=~1|MOM,na.action=na.omit)

#Next, we need to convert these values into residuals that we can plot. Do this first by creating a new dataset (datum4)
datum4 <- datum[complete.cases(datum[,"MASS"]),]

#Next, add a column wihtin the dataset that is the residuals of the linear mixed-effects model. 
datum4$resids <- resid(resultshatchmass)

#Check out a very basic boxplot of these data.
plot(resids~EGGMASS,datum4)

#Now let's graph this with GGPLOT! I will be making three graphs in one figure. 

#Create the varibale that will be section (A) in our figure.

bodycondition <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=resids), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=resids), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling body condition") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black"))

#Now, let's create section (B) for our figure! Again, begin by calling on the tiff function
#Here we are plotting hatchling mass against eff mass
  
hatchlingmass <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=MASS), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=MASS), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling mass (g)") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black")) 
  
#Lastly, make section (C) of our figure! This will show hatchling snout-vent length (SVL). 
  
hatchlingsvl <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=SVL), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=SVL), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling SVL (mm)") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black")) 
  
#To combine them all to 1 figure, follow this script below.
  
hatchlingmass1 <- arrangeGrob(hatchlingmass, top = textGrob("a)", x = unit(0.10, "npc")
                                                 , y = unit(0, "npc"), just=c("left","top"),
                                                 gp=gpar(col="black", fontsize=15)))
  
hatchlingsvl1 <- arrangeGrob(hatchlingsvl, top = textGrob("b)", x = unit(0.10, "npc")
                                                 , y = unit(0, "npc"), just=c("left","top"),
                                                 gp=gpar(col="black", fontsize=15)))
  
bodycondition1 <- arrangeGrob(bodycondition, top = textGrob("c)", x = unit(0.10, "npc")
                                                  , y   = unit(0, "npc"), just=c("left","top"),
                                                  gp=gpar(col="black", fontsize=15)))
  
jpeg("Figure1.jpeg", width = 4, height = 6, units = 'in', res = 300)

#Arrange them in the figure using this command.
grid.arrange(hatchlingmass1, hatchlingsvl1, bodycondition1, ncol = 1)
  
#Run dev.off, and check out the cool figure in your working directory.
dev.off()
  }

if (plotnumber="2-2") {#Begin by running a basic linear mixed-effects model and call on the summary to see the results.
#Here I am analyzing the log of hatchling mass to hatchling snout-vent length (SVL).
  
resultshatchmass=lme(log(MASS)~log(SVL),data=datum,random=~1|MOM,na.action=na.omit)

#Next, we need to convert these values into residuals that we can plot. Do this first by creating a new dataset (datum4)
datum4 <- datum[complete.cases(datum[,"MASS"]),]

#Next, add a column wihtin the dataset that is the residuals of the linear mixed-effects model. 
datum4$resids <- resid(resultshatchmass)

#Check out a very basic boxplot of these data.
plot(resids~EGGMASS,datum4)

#Now let's graph this with GGPLOT! I will be making three graphs in one figure. 

#Create the varibale that will be section (A) in our figure.

bodycondition <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=resids), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=resids), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling body condition") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black"))

#Now, let's create section (B) for our figure! Again, begin by calling on the tiff function
#Here we are plotting hatchling mass against eff mass
  
hatchlingmass <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=MASS), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=MASS), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling mass (g)") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black")) 
  
#Lastly, make section (C) of our figure! This will show hatchling snout-vent length (SVL). 
  
hatchlingsvl <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=SVL), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=SVL), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling SVL (mm)") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black")) 
  
#To combine them all to 1 figure, follow this script below.
  
hatchlingmass1 <- arrangeGrob(hatchlingmass, top = textGrob("a)", x = unit(0.10, "npc")
                                                 , y = unit(0, "npc"), just=c("left","top"),
                                                 gp=gpar(col="black", fontsize=15)))
  
hatchlingsvl1 <- arrangeGrob(hatchlingsvl, top = textGrob("b)", x = unit(0.10, "npc")
                                                 , y = unit(0, "npc"), just=c("left","top"),
                                                 gp=gpar(col="black", fontsize=15)))
  
bodycondition1 <- arrangeGrob(bodycondition, top = textGrob("c)", x = unit(0.10, "npc")
                                                  , y   = unit(0, "npc"), just=c("left","top"),
                                                  gp=gpar(col="black", fontsize=15)))
  
tiff("Figure1.tiff", width = 4, height = 6, units = 'in', res = 300)
  
#Arrange them in the figure using this command.
grid.arrange(hatchlingmass1, hatchlingsvl1, bodycondition1, ncol = 1)
  
#Run dev.off, and check out the cool figure in your working directory.
dev.off()
}

if (plotnumber="2-3") {#Begin by running a basic linear mixed-effects model and call on the summary to see the results.
#Here I am analyzing the log of hatchling mass to hatchling snout-vent length (SVL).
  
resultshatchmass=lme(log(MASS)~log(SVL),data=datum,random=~1|MOM,na.action=na.omit)

#Next, we need to convert these values into residuals that we can plot. Do this first by creating a new dataset (datum4)
datum4 <- datum[complete.cases(datum[,"MASS"]),]

#Next, add a column wihtin the dataset that is the residuals of the linear mixed-effects model. 
datum4$resids <- resid(resultshatchmass)

#Check out a very basic boxplot of these data.
plot(resids~EGGMASS,datum4)

#Now let's graph this with GGPLOT! I will be making three graphs in one figure. 

#Create the varibale that will be section (A) in our figure.

bodycondition <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=resids), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=resids), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling body condition") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black"))

#Now, let's create section (B) for our figure! Again, begin by calling on the tiff function
#Here we are plotting hatchling mass against eff mass
  
hatchlingmass <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=MASS), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=MASS), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling mass (g)") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black")) 
  
#Lastly, make section (C) of our figure! This will show hatchling snout-vent length (SVL). 
  
hatchlingsvl <- ggplot() +
    geom_point(data=datum4, aes(x=EGGMASS, y=SVL), shape=1) +
    geom_smooth(data=datum4, aes(x=EGGMASS, y=SVL), method=lm,se=FALSE, color="black") +
    theme_classic() +
    labs(title="", x="Egg mass (g) at oviposition", y="Hatchling SVL (mm)") +
    scale_x_continuous(breaks=seq(0.85,1.25,0.05), limits=c(0.85,1.25)) +
    theme(axis.title.x = element_text(size=10,vjust=0),
          axis.text.x  = element_text(size=8,color="black"),
          axis.title.y = element_text(size=10,vjust=3),
          axis.text.y  = element_text(size=8,color="black")) 
  
#To combine them all to 1 figure, follow this script below.
  
hatchlingmass1 <- arrangeGrob(hatchlingmass, top = textGrob("a)", x = unit(0.10, "npc")
                                                 , y = unit(0, "npc"), just=c("left","top"),
                                                 gp=gpar(col="black", fontsize=15)))
  
hatchlingsvl1 <- arrangeGrob(hatchlingsvl, top = textGrob("b)", x = unit(0.10, "npc")
                                                 , y = unit(0, "npc"), just=c("left","top"),
                                                 gp=gpar(col="black", fontsize=15)))
  
bodycondition1 <- arrangeGrob(bodycondition, top = textGrob("c)", x = unit(0.10, "npc")
                                                  , y   = unit(0, "npc"), just=c("left","top"),
                                                  gp=gpar(col="black", fontsize=15)))
  
jpeg("Figure1.jpeg", width = 4, height = 6, units = 'in', res = 300)
  
#Arrange them in the figure using this command.
grid.arrange(hatchlingmass1, hatchlingsvl1, bodycondition1, ncol = 1)
  
#Run dev.off, and check out the cool figure in your working directory.
dev.off()
}

if (plotnumber="3-1") {#go to line graph script with PNG output}
if (plotnumber="3-2") {#go to line graph script with Tiff output}
if (plotnumber="3-3") {#go to line graph script with JPEG output}
