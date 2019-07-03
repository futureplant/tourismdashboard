# load data
trip <- read.csv('data/tripadvisor.csv')
colnames(trip) <- c('name','reviews','visitors','website')
plot(trip$visitors~trip$website, col = trip$name)
linmod<-lm(trip$visitors~trip$website)
summary(linmod)
abline(linmod,add=T)
