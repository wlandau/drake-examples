# Fixed-Choice Design Simulation 

Networks are a ubiquitous part of social interaction. When examining such social structures, researchers are often faced a variety of design decisions that can influence the inferences drawn from the "true" network or data-generating process of interest. One of these decisions occurs when designing and implementing network instruments (i.e. surveys given to an individual within the network meant to capture information about that actor's social interactions with other people in the network). 

In large networks, such that a given actor may interact with a large number of other actors, some network instruments may ask a respondent about _every other person_ in the network. These situations have the potential to induce survey fatigue and/or survey exhaustion. To circumvent this issue, network scientists will leverage a "fixed-choice design" (Holland and Leinhard, 1973) where each actor is only asked about their top _n_ interactions. This survey design creates fixed choice effects. As [Kossinets (2008)](https://arxiv.org/pdf/cond-mat/0306335.pdf) notes:

> Fixed choice nominations can easily lead to a non-random missing data pattern. For instance, certain actors may possess some great personal qualities and hence would be present on the “best friends” lists of many other actors. That is, popular individuals who have more contacts may be more likely to be nominated by their contacts (Feld,1991; Newman, 2003).

And ultimately poses the question:

> What effect will this have on the structural properties of the truncated graph?

The purpose of this small simulation is to examine how a FCD might influence the recovered network structure of a random graph when the a) size of the network, b) probability of edge formation, and c) fixed choice size are manipulated.

