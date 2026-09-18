Hi Bogdan,

Thanks for this submission, there is some excellent work here. I like that you included your previous work in the comments - it helps me see how you're getting on a little better than if you just submit final answers. 

A couple of minor points:

Unlike some other languages, we (mostly) don't need a formal print statement in R. For the most part, print() is automatically called when we run code in the Console. I tend to only use a print() call when I'm writing functions (or loops) and need to to some debugging. There are more formal options for this but I tend to find print() quicker and easier to code up. 
I like your final plot but we could do a couple of small things to give it a slightly different look. For example:
ggplot(diamonds_sample, aes(x=carat, y=price)) +
  geom_hex() +
  scale_fill_viridis_c() +
  facet_wrap(.~cut, nrow = 1) +
  theme(legend.position = "bottom")

Please do let me know if you've got any questions or queries. All the best. 

Andrew