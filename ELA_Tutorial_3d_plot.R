unavailable <- setdiff(c("mgcv","plotly"), rownames(installed.packages()))
install.packages(unavailable)
library(mgcv)
library(plotly)

df = read.csv(file="rELA/data/sample_rep_table.csv")
dim(df)[[1]]
number_of_samples <- dim(df)[[1]]/8

df$color <-  rep(hcl.colors(number_of_samples, "Spectral"), 8)

size_of_numbers = 30
ss1_color_no_index = 102# Select ID of Stable State1 
ss2_color_no_index = 113# Select ID of Stable State2
ss3_color_no_index = 148# Select ID of Stable State1 
ss4_color_no_index = 128# Select ID of Stable State2

ss1_name= "SS1: O1t"
ss2_name = "SS2: O9x"
ss3_name= "SS3: 1uV"
ss4_name = "SS4: EWB"

number_of_replicates=8
X_axis_label = 'PC1'
Y_axis_label = 'PC2'
Z_axis_label = 'Energy'

energy_cut=0
energy_cut_max=20
energy_cut_min = -60

## -- Surface slope
mod <- gam(Energy ~ te(rel.MDS1, k=number_of_replicates) + te(rel.MDS2, k=number_of_replicates) + ti(rel.MDS1, rel.MDS2, k=number_of_replicates), data=df)

mds1.seq <- seq(min(df$rel.MDS1, na.rm=TRUE), max(df$rel.MDS1, na.rm=TRUE), length=number_of_samples)
mds2.seq <- seq(min(df$rel.MDS2, na.rm=TRUE), max(df$rel.MDS2, na.rm=TRUE), length=number_of_samples)

predfun <- function(x,y){
  newdat <- data.frame(rel.MDS1 = x, rel.MDS2=y)
  predict(mod, newdata=newdat)
}
fit <- outer(mds1.seq, mds2.seq, Vectorize(predfun))
dim(fit)
# restrict the plot
if (energy_cut == 1) {
  fit[fit > energy_cut_max] <- energy_cut_max
  fit[fit < -energy_cut_min] <- -energy_cut_min
}
###
## -- Plotly
cs <- scales::rescale(quantile(fit, probs=seq(0,1,0.25)), to=c(0,1))

names(cs) <-NULL
frame6 <- plot_ly(data=df, x = ~rel.MDS1, y= ~rel.MDS2, z= ~Energy) %>% 
  add_trace(data=df, x = ~rel.MDS1, y= ~rel.MDS2, z= ~Energy,
            type = "scatter3d", mode = "markers",
            marker = list(color = ~as.numeric(df$time),
                          colorscale = list(seq(0,1, length=number_of_replicates), 
                                            c('firebrick', 'orange', 'khaki', 'greenyellow', 
                                              'limegreen', 'dodgerblue', 'darkslateblue', 'darkslateblue')),
                          #color ='orange', 
                          size=5, legendgrouptitle=list(text='Energy', font='Arial'),
                          line=list(width=1,color='black')),
            name="Samples",
            opacity = 1)  %>% 
  add_trace(data=df[df$time==ss1_color_no_index,], x = ~rel.MDS1, y= ~rel.MDS2, z= ~Energy,
            #text =c(1:number_of_replicates), mode = "text",
            text =rep(c("v"),each=number_of_replicates), mode = "text",
            textfont = list(size=size_of_numbers, color='red'),
            name=ss1_name,
            opacity = 1) %>%   
  add_trace(data=df[df$time==ss2_color_no_index,], x = ~rel.MDS1, y= ~rel.MDS2, z= ~Energy,
            #text =c(1:number_of_replicates), mode = "text",
            text =rep(c("v"),each=number_of_replicates), mode = "text",
            textfont = list(size=size_of_numbers, color='turquoise'),
            name=ss2_name,
            opacity = 1) %>%
  add_trace(data=df[df$time==ss3_color_no_index,], x = ~rel.MDS1, y= ~rel.MDS2, z= ~Energy,
            #text =c(1:number_of_replicates), mode = "text",
            text =rep(c("v"),each=number_of_replicates), mode = "text",
            textfont = list(size=size_of_numbers, color='blue'),
            name=ss3_name,
            opacity = 1) %>%  
  add_trace(data=df[df$time==ss4_color_no_index,], x = ~rel.MDS1, y= ~rel.MDS2, z= ~Energy,
            #text =c(1:number_of_replicates), mode = "text",
            text =rep(c("v"),each=number_of_replicates), mode = "text",
            textfont = list(size=size_of_numbers, color='black'),
            name=ss4_name,
            opacity = 1) %>%  
  add_trace(data = df, x = ~mds1.seq, y = ~mds2.seq, z = ~fit,
            type = "surface", showscale = TRUE,
            hidesurface = FALSE, opacity = 0.7,
            colorscale = list(
              cs,
              c('blue', 'lightblue', 'slategray', 'tan', 'indianred')
            ),
            contours = list(
              z = list(
                show = TRUE,
                start = min(t(fit)),
                end = max(t(fit)),
                usecolormap = TRUE,
                size = 0.7,
                width = 3
              )
            )
  )%>% 
  layout( scene = list(xaxis = list(title = X_axis_label, showticklabels=F,nticks=10, linewidth=7, gridwidth=3),
                       yaxis = list(title = Y_axis_label, showticklabels=F, nticks=10, linewidth=7, gridwidth =3),
                       zaxis = list(title = Z_axis_label, showticklabels=F, nticks=10, linewidth=7, gridwidth =3),
                       aspectratio = list(x = .9, y = .9, z = 0.5),
                       font='Arial') )	

frame6




