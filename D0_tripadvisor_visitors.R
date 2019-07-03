###########################################################################################################################################
## Script that tests the predicitive power of tripadvisor reviews on visitor numbers as described in paragraph 3.3.3 of the report        #
##    Input is a CSV file with manually counted reviews and retrieved visitor numbers for a sample of musea in Amsterdam                  #
##    Output is a PNG file of the graph explaining the predictive power of tripadvisor reviews                                            #
###########################################################################################################################################


# Libraries
library(ggplot2)


# Load data
trip <- read.csv('data/tripadvisor_musea.csv', header = F)
names(trip) <- c('name','reviews_2017','visitors_2017')


# Exploration
hist(trip$reviews_2017, breaks = 'FD')
hist(trip$visitors_2017)
plot(trip$visitors_2017~trip$reviews_2017)
# with(trip, text(trip$visitors_2017, labels = trip$name, pos = 4))


# Linear model
linmod <- lm(trip$visitors_2017~trip$reviews_2017)
summary(linmod)
abline(linmod)
linmod$coefficients


# Scientific plot
ggplot(data = trip, aes(x = reviews_2017, y = visitors_2017)) +
  geom_point()+ geom_abline(slope = linmod$coefficients[2], intercept = linmod$coefficients[1]) +
  ggtitle('Predictive ability of Tripadvisor reviews for visitors', subtitle = 'Museums of Amsterdam') +
  xlab('Number of reviews on tripadvisor in 2017') + ylab('Number of visitors in 2017')+
  geom_text(x = 8000, y = 300000, label ='F = 36.04, p = 0.0002017')

ggsave(filename = 'images/tripadvisor_predictivepower.png')
