# h-index simulator


## How to run it


Run the following command in your R console:

	library(shiny)
	shiny::runGitHub("guillaumelobet/h-index-simulator", "guillaumelobet") 


## How it works


The simulator in itself is quite simple and needs only a couple of inputs:

- the average number of paper you publish per year + the standard deviation
- the average impact factor of the journal you publish in + the standard deviation
- the target h-index (in my case, it will be 10)
- the starting year (the date of your first paper)

Then the simulator follows a couple of simple rules:

- as long as our h-index is below the target, keep publishing
- publish n papers per year
	- n is picked from a normal distribution, with the *mean* and *standard deviation* defined by the parameters
- for each paper, assign an impact factor (IF)
	- this IF is picked from a normal distribution, with the *mean* and *standard deviation* defined by the parameters
- compute the number of citation for each papers (based on its age and the impact factor of the journal)
- compute the h-index. If it is below the target, keep publishing

So, the simulator is quite simple and follows a couple of basic rules. It certainly has many drawbacks and could be improved. But I figured it would be enough for what I wanted to do. 