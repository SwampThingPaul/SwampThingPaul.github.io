
#GIS Libraries
library(rgdal)
library(rgeos)
library(mapmisc)

# Spatial projection for geogrpahical data
GDA94=CRS("+init=epsg:28354 +units=m")

gis.path="D:/GIS" #change for you computer, makes sure to leave the path "open" as in don't have a "/" at the end.
plot.path="D:/plots/" #change for you computer

#Data can be found at
# https://swampthingecology.org/files/examples/ExamplShapefiles.zip
# it will auto-download.

# Read shapefiles 
cma=readOGR(gis.path,"cma")
hydro.poly=readOGR(gis.path,"hydro")
wq.sites=readOGR(gis.path,"wq_sites")

# If you need to transform the project or datum of the shapefiles you can use
# spTransform()
# an example would be spTransform(cma, GDA94)

# If you want a png
png(filename=paste0(plot.path,"Example_map.png"),width=5,height=4,units="in",res=200,type="windows",bg="white")
# If you want a tiff
#tiff(filename=paste0(plot.path,"Example_map.tiff"),width=5,height=4,units="in",res=200,bg="white")
par(mar=c(0.1,0.1,0.1,0.1),oma=c(0.1,0.1,0.1,0.1))
plot(cma)
plot(hydro.poly,col="dodgerblue1",border="dodgerblue",add=T)
plot(wq.sites,add=T,pch=21,cex=1.25,bg="indianred1")
scaleBar(GDA94,"bottomleft",bty="n",cex=0.75,seg.len=4);#adds scale bar and north arrow.
box(lwd=1)
dev.off()


#If you want to interactively look at the spatial data you an use tmap
# or if you perfer the ggplot type syntax tmap is a good option
library(tmap)
tmap_mode("view")
tm_shape(wq.sites)+tm_dots(col="red")

# To generate a map in tmap you can check out this link below. 
# I put together a blog post sometime last year.
# https://swampthingecology.org/blog/mapping-in-rstats/

