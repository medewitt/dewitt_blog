true_cases <- rpois(100, 5)

epi_convolve <- function(cases, pdf){
  
  convolved_cases <- vector()
  max_pdf <- length(pdf)
  for(s in seq_along(cases)){
    convolved_cases[s] <- cases[max(1, (s - max_pdf + 1)):s] %*%tail(pdf, min(max_pdf, s))
  }
  
  convolved_cases
}
out <- data.frame(reported = ceiling(epi_convolve(true_cases, pdf = c(.2,.2,.3,.2,.1))),
true_cases,
date = 1:100
)

library(ggplot2)
ggplot(out, aes(date))+
  geom_line(aes(y = true_cases))+
  geom_line(aes(y = reported_cases), color = "blue")
