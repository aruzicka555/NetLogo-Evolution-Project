breed [humans human] ;creates the human breed
breed [aliens alien] ;creates the alien breed
turtles-own [speed age intelligence fitness] ;sets some common traits that all breeds have
humans-own [survival] ;set a unique trait that only the humans have
aliens-own [hunting-skill] ;set a unique trait that only the aliens have

globals [
    total-humans-hunted ;sets up a global count for how many humans the aliens kill; to be used further down
    ]
    
to setup
  ca ;clears everything
  set total-humans-hunted 0 ;sets this global count at 0
  set-default-shape humans "person" ;gives humans the shape of a person
  set-default-shape aliens "bug" ;gives aliens the shape of a bug, for lack of a better model
  create-humans how-many-humans [ ;creates an amount of humans, based on how many the observer selects on the slider
    set color white ;creates humans that are all the color white
    setxy random-xcor random-ycor ;spawns humans at random areas across the plot
    set size 1 ;makes their size equal to 1 unit
    set speed random 5 ;sets each human's speed to be a random number between 1 and 5
    set intelligence random-normal 100 20 ;sets up a standard distribution of intelligence for each human with 100 being average with 20 points above and below being within the average. Humans are smarter than these aliens
    set survival random 10 ;sets each human's survival trait to be a random number between 1 and 10. Exceptional humans have great survival skills
    set age 1 ;each humans starts with the age of 1
    
  ]
  create-aliens how-many-aliens [ ;creates aliens based on how many are chosen in the slider
    set color blue ;each alien starts as blue
    setxy random-xcor random-ycor ;aliens spawn at random places across the plot
    set size 2 ;size of aliens is 2, larger than humans
    set intelligence random-normal 50 10 ;sets up standard distribution of intelligence for aliens, 50 being average with 10 points below and above being within the standard distribution. Aliens are not too bright in this model
    set speed random 10 ;sets speed of each alien to be a number between 1-10. Aliens are capable of being much faster than humans in this model
    set hunting-skill random 6 + 3 ;sets the base of each aliens hunting skill to be 3, plus a random number between 1-6. Aliens in this model are adapted to be very good at hunting at the start
    set age 1 ;each alien starts with age 1
    ]
  
  ;these two procedures (with the use of random and standard distributions and the random command) make sure each turtle has variation - an essential ingredient in evolution
  
  ask humans [set fitness humans-fitness] ;human fitness calculated at start from different procedure
  
  ask aliens [set fitness aliens-fitness] ;human fitness calculated at start from different procedure
  
  reset-ticks ;ticks are set to 0
end

to do-something
  if not any? aliens [stop] ;if all aliens in the model are dead, stop the procedure
  
  every 0.2 [ask humans [ ;every twentieth of a second, the model will execute this block of code asking aliens and humans to do something. This slows down the speed of the model so the user can follow it easier.
  move-humans ;calls to a procedure that has the humans move
  humans-age ;calls to a procedure that has the humans age
  humans-have-contest ;calls to a procedure that determines what humans live and die based on their fitness, which sets up differential survival in the population - another essential ingredient of evolution
  humans-reproduce] ;calls to a procedure that has the humans reproduce
  
  
  ask aliens [
  move-aliens ;calls to a procedure which moves the aliens
  aliens-age ;calls to a procedure which has the aliens age
  aliens-have-contest ;calls to a procedure which determines if an alien lives based on their fitness, adding to differential survival in the model
  hunt] ;calls to a procedure which has the aliens hunt humans, adding to differential survival in the model 
  
  tick] ;after all this code has been executed, one tick is added to the counter
end 

to hunt
  let hunted one-of humans-here ;"hunted" becomes one of the humans occupying the same patch as the alien
  if hunted != nobody ;if there is a human on this patch, execute the code below
  [ask hunted [die] ;the human dies off, again, differential survival
    set total-humans-hunted total-humans-hunted + 1 ;adds 1 to the global count of humans hunted
    hatch 1 [ ;once an alien kills a human, it uses its body to hatch an egg, yuck!
    set speed random-normal [speed] of myself std-dev-slider ;the new alien inherits the speed of the parent with variation, based on how large the standard deviation slider is set to. This sets up heredity, another essential part of evolution
    set intelligence random-normal[intelligence] of myself std-dev-slider ;intelligence of new alien is set to that of the parent with variation dependent on the slider
    set hunting-skill random-normal [hunting-skill] of myself std-dev-slider ;hunting-skill of new alien is set to that of parent, with variation dependent on slider
    set age 1 ;the new alien is set to age 1
    set color [color] of myself ;the new alien inherits the color of the alien
    set heading random 360 forward 1 * speed ;new alien splits off from parent
    ]]
  ;this procedure adds to all three ingredients of evolution
  ;when the alien reproduces, it is heredity: its offspring inherits its characteristics
  ;when the alien is born, it has some variation on the parent's characteristics depending on the slider, which is variability
  ;differential survival is seen in that a human is killed off by the alien
end

to humans-have-contest
  ask humans [set fitness humans-fitness if fitness < 60 [die] ] ;fitness is calculated elsewhere in program - if below 60, that human dies
  ask humans [if speed < 0 [die]] ;if the humans speed is below 0, that human dies
  ask humans [if survival < 0 [die]] ;if the speed of the human is less than 0, it dies
  ask humans [if intelligence < 60 [die]] ;if the human is dumb, and happens to slip up somewhere as a result, it dies
  ask humans [if age > 50 [die]] ;if the age of the human is over 50, it dies
end

to-report aliens-fitness
  report 0 + speed + intelligence + hunting-skill ;fitness of alien is calculated by adding its traits
end

to-report humans-fitness
  report 0 + speed + intelligence + survival ;fitness of human calculated by adding its traits
end

to aliens-have-contest
  ask aliens [set fitness aliens-fitness if fitness < 45 [die] ] ;fitness calculated elsewhere in program, if below 60, that alien dies
  ask aliens [if speed < 0 [die]] ;if the speed of that alien is less than 0, it dies
  ask aliens [if hunting-skill < 0 [die]] ;if the hunting skill of the alien is less than 0, it dies
  ask aliens [if intelligence < 20 [die]] ;if the alien is too stupid (less than 20 intelligence) it dies
  ask aliens [if age > 30 [die]] ;if the alien is too old (over 30) it dies, aliens live less time than humans
  ;these two contest functions establish differential survival in the model. If the turtle is too slow, or dumb, or bad at surviving or hunting or is too old, it dies and does not reproduce
end

to move-humans ;procedure has humans move after turning left and right at random angles, based on their speed
  ask humans [
  right random 50
  left random 50
  forward 2 * (speed * 10) * 0.001] ;*0.001 added to slow it down a little
end

to move-aliens ;procedure has aliens move after turning left and right at random angles, based on their speed
  ask aliens [
  right random 50
  left random 50
  forward 2 * (speed * 10) * 0.001] ;*0.001 added to slow the model down
end

to humans-reproduce
  if random 100 > 85 [ ;if a human gets lucky based on if a random number between 1-100 is greater than 85, they reproduce
   
  hatch random 2 [ ;human reproduces either one or two young
    set speed random-normal [speed] of myself  std-dev-slider ;speed of new human set to speed of parent, with some variation
    set intelligence random-normal [intelligence] of myself std-dev-slider ;intelligence of new human set to intelligence of parent, with some variation
    set survival random-normal [survival] of myself std-dev-slider ;set survival skill of the new human to that of the parent, with variation
    set age 1 ;new human set to age 1
    set color [color] of myself ;color of new human is inherited from parent
    set heading random 360 fd 1 * speed ;child splits from parent
    ]]
  
  ;this procedure helps establish heredity and variability in the model
  ;the lucky human reproduces a baby with traits similar to its own, heredity
  ;the baby has some variation based on the slider setting, variability
end

to humans-age
  set age age + 1 ;humans take their age and add 1 to it each time this is called
end

to aliens-age
  set age age + 1 ;aliens take their age and add 1 to it each time this is called
end

to extinction-event
  ask turtles [if xcor + ycor > 25 and xcor + ycor < 45 [die]] ;a catastrophic event wipes out turtles near the middle
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
646
467
-1
-1
13.742
1
10
1
1
1
0
1
1
1
0
30
0
30
0
0
1
ticks
30.0

MONITOR
23
26
80
71
Humans
count humans
17
1
11

MONITOR
119
26
176
71
Aliens
count aliens
17
1
11

PLOT
-2
281
198
431
Avg. Alien Hunting Skill vs. Time
time
rate
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-0" 1.0 0 -16777216 true "" "if any? aliens [plotxy ticks mean [hunting-skill] of aliens]"

SLIDER
5
162
177
195
std-dev-slider
std-dev-slider
0
10
5
1
1
NIL
HORIZONTAL

BUTTON
85
82
205
115
NIL
do-something
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
5
83
71
116
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
4
204
179
237
how-many-humans
how-many-humans
70
90
80
1
1
NIL
HORIZONTAL

SLIDER
3
239
175
272
how-many-aliens
how-many-aliens
20
40
30
1
1
NIL
HORIZONTAL

PLOT
648
229
848
379
Avg. Human Survival vs time
time
rate
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-0" 1.0 0 -7500403 true "" "if any? humans [plotxy ticks mean [survival] of humans]"

PLOT
647
70
847
220
Humans Hunted Over Time
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks total-humans-hunted"

BUTTON
1
122
128
155
Exctinction Event
extinction-event
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
##Write-Up

This is a model that is meant to model the evolution of two species side by side when one species preys on the other. I based it on several different pre-existing models, including: bug-hunt-speeds, simple-evolution-toy, and the wolf-sheep-predation model in the Netlogo model library under Biology. I based this concept off the movie "Alien" where strong, fast, semi-intelligent aliens hunt humans and use their bodies to hatch their young. In this model, I utilize two different breeds of turtles (humans and aliens) and gave them traits they share, and one unique trait each. I utilize sliders for the observer to determine how many humans and aliens spawn at the start, and how much variation the observer wants between parent and children turtles. I utilize procedure calls from the do-something procedure to code further down for clarity. I made it so that each human and alien spawns with a random score for each of their traits, and then their fitness is calculated based upon their traits being added up. I had a call in the main-procedure to check and see which aliens and humans survive based on their fitness score. If it is too low, that individual alien or human dies off and does not get a chance to reproduce. Humans, by chance, will reproduce either one or two babies, if they get a high enough score on a random roll. Their children will inherit the same traits and scores as their parents, with variability based on what the slider number is set to. I also make humans and aliens wander around the area with forward commands, right random, and left random. If humans and an alien happen to be on the same square, one of the humans is picked and asked to die off (it is killed by the alien on the same square) and from that human's body, the alien reproduces a baby. The alien has to be able to catch a human to reproduce. This baby inherits the traits of its parent, with some variaton based on what the slider is set to. Every iteration, the aliens and humans age; and if they reach a certain age, they are asked to die off. The model has the aliens and humans move around, the aliens hunting the humans and reproducing, and the humans reproducing until all of the aliens die off (the humans would go on to reproduce forever and the model would never end). To slow down the speed of the model, I used an every 0.2 [] command. Three plots are utilized to show the average hunting-skill of the aliens over time, the average survival skill of the humans over time, and the amount of humans that are hunted by the aliens over time. Two monitors are used to show the amount of humans and aliens. There are three buttons: one sets up the program, and the other runs it forever until all the aliens die off. There is one last button: a button that wipes out a huge swath of the middle area, to represent an exctinction event. This could be anything from a meteor to an extreme drought in the area, to a war. Hit setup to get the model ready, set the sliders to the desired numbers, and then click do-something to run the model. Hit the extinction event button at your leisure to see what effect a catastrophic event will have on the population.

Evolution requires three essential ingredients: variation, heredity, and differential survival. This model demonstrates all three. For variation, each turtle starts off with a unique, random score on its traits. When the turtles reproduce, the children do not just inherit the traits of their parents - the traits are changed slightly from their parents depending on the score of the standard deviation slider. For heredity, occasionally the turtles reproduce. For the humans, they will reproduce either one or two young, based on if they get a good score on a random roll. They pass on their traits, and the score on these traits, to their children with some variation; they are "inherited". For the aliens, if they manage to kill a human, they spawn one child, who inherits the traits and scores on them (with some variation) from their parents. Finally, differential survival is demonstrated in several ways. First, there is a procedure which calculates the fitness of each human and alien based on the sum of the scores on their traits. If the score is too low, they die off. Also, when the turtles get too old, they are forced to die off. The aliens hunting humans is also an example of differential survival. If an alien can not catch a human and reproduce, they die off, and if a human gets caught by an alien, they die off. The final way differential survival is demonstrated is in the extinction event procedure, which kills off all the turtles unlucky enough to be in the way of an incoming meteor, or a drought, or by some other act of God. This model clearly demonstrated all three of the essential parts of evolution. See the code where I point out specific code which demonstrates these three ingredients with comments.

I created this model to answer a couple questions I had. First, I wanted to see what the effect of a smaller population of hunters which only prey upon the larger population of prey, and whose reproduction is tied to their hunting succes, would be. Second, I wanted to see how two species evolve alongside each other when one preys on the other and what their trait scores would look like over time. Finally, I wanted to see what effect a catastrophic event would have on the population. With this model, I was able to answer all of these question pretty well.

Using my model, I see that for a time the populations are pretty balanced. However, over time, the number of the hunters grows and they start drastically dwindling the population of the prey, until it gets to a point that it is hard for the hunters to find any prey and they start dying off, giving the prey a chance to reproduce and grow their numbers, at which point the hunters start getting more kills and raising their numbers again. And the cycle repeats. The population tends to fluctuate back and forth between these states over time. Occasionally, the hunters will manage to kill off all the prey and then will just wander around and then start dying off until none remain since they require prey to reproduce. Sometimes, the hunters have a hard time catching any prey and then they all die off as a result, and the prey goes on to reproduce and live happily ever after. This model helped my understanding of a population with a large amount of prey and a smaller amount of hunters.

Looking at the graphs on my model, I can see how the average score on a trait in a population evolves over time. The score seems to start off pretty stable, then rises slowly, and maintains that slow rise over a great deal of time until the population hits a point where there is an extreme shortage of members or they start dying off due to lack of food, and then the scores tend to dip for a little bit before recovering and rising steadily again. This is because, with less members, the scores for the average would be less variable and more uniform, skewing the average in a positive or negative way. So, it seems, evolution in a condition where there are two species, one hunter and one prey, continually evolves traits to be better and more adaptive over time. These trait scores have a net increase, with some minor setbacks, before rising and increasing again.

In my opinion, this model also answers my most burning question of all: how do catastrophic events effect evolution? After letting my model run for a few seconds, then hitting the extinction event button and wiping out the unluckiest turtles, I notice a few things. First, after an extinction event, the average score on certain traits seems to drop pretty steepily for awhile, before levelling off and then rising again. Second, the turtles move back and repopulate the disaster area quickly, but this is probably just due to the limitations of the model. If I made this disaster area less desireable in the code after an event, I would wager that the turtles would stay away for much longer. Third, the hunters do not get a chance to hunt as much prey for a time, but this is remedied quickly once the turtles have spread over the area again. I also saw that such an event can be catastrophic for the hunters. When a large population of their prey is wiped out (since that population is even larger), it is harder for them to wait out their prey to reproduce and spread out again before they can start hunting and reproducing again. It can also be a God-send for a dwindling population of prey if it wipes out a much larger population of hunters, giving them time and space to reproduce and spread out again. So, according to my model, it seems that the hunters are impacted the most by a catastrophic event while the prey can quickly reproduce and spread out again.

##Log: Day 1

Spent 10 minutes looking at bug-hunt and simple-evolution-toy models posted online to get ideas. Decided on creating a model similar to bug-hunt with alien turtles hunting human turtles instead of the user catching the ants manually. Spent 5 more minutes creating two separate breeds, humans and aliens, and creating traits they share and traits they do not share. Also created some globals. From ideas I got from the models, I created a simple setup procedure which clears all, sets default shape and colors. Spent 5 more minutes reading an e-mail from John, and took some of the commands he gave in the e-mail, like the set age and st-deviation slider codes; pasted them willy nilly into the code section. Sent off what I had to John for review. All in all: spent ~20 minutes on the project today.

##Log: Day 2
Received a response from John today. Spent 5 minutes going over what he sent and trying to understand it. Saved what he sent back to me. Spent about 15 minutes on my own toying with it, cut down some of the globals that I made, modified the setup button to use the sliders on the interface to determine how many of each species to spawn. Also added code that determines the size and color of the turtles. Modified the viewspace so the center was on a corner and only areas with both 0 or positive x and y coordinates could be viewed. Set the breeds up to spawn at random locations along this area. Spent about 20 minutes with John for help on the project. Asked him about ticks, how to graph things in the interface, how to make it so turtles spawn with random values for attributes, and how to have turtles hatch other turtles based on their age. I fixed a glitch that was going on with the graphing windows, it seems when John deleted some of the code for the first window that the second window also glitched up on a similar bit of code (the pen). I pointed this out to John and we debugged it. Today, I spent ~40 minutes on the project.

##Log: Day 3
Spent about 20 minutes taking a closer look at the attributes that the turtles spawn with, changing them around a little for the humans. Added the commands to spawn aliens with some attributes, gave aliens the potential to have more speed than humans as I plan to have them hunt by smell and have less of them at the start. Added a die command for turtles that are too old. Removed old-enough-to-reproduce as it was redundant with age attribute, and gave age the same commands. Changed set age one-of to either 1, 2, or 3 so I could easily set their ages age + 1 at the end of each tick in do-something. Changed parts in the code that referred to "baby", "adult", and "geezer" for age accordingly. Spent about 15 more minutes looking at the Netlogo dictionary, focusing on patch-related and agentset commands. Found "in-radius" and "is-agent?" to be interesting and potentially useful for when I have the aliens hunt the humans. Looked at patches because I want to be able to have the humans set patches different colors to represent their "scent" for a set amount of time so the aliens can track them. Also looked at turtle-related commands to see if there is anything I can use for fleeing or following. Face could be used to make humans face 180 away from aliens and run away.

Next I spent about 10 minutes making simple movement commands for the turtles to follow so they "wander" around the map. I also tried to make it so that patches set their color to green if any humans were near, to represent their scent. I used an example from the netlogo dictionary, however I keep getting an error. This is the code I tried: 
ask humans [
  ask patches in-radius 1
  [ set pcolor "green"]]
I fixed this by following the example on the dictionary more closely, by having the turtles have babies and set their color to the color of themselves, and then I changed the code to make it so it sets the pcolor to the color of myself of the human. This code worked, but now the patches just turn blue and hide the humans from view. I will have to fix this later

Next I tried to set the graphs up so they plot. I keep getting an error when I use what I found in the bug hunt model, which is plotxy ticks mean [speed] of bugs. To modify it, I just took put in the attribute I wanted and changed the name to humans or bugs. This keeps calling an error that I can not figure out though. I resolved the issue by changing up the order of the code in the setup command a little bit. It seemed the program was glitching on where the "reset-ticks" command was. When I had it right after "ca", it would bug. But when I placed it at the end of the setup command, the plots had no problem and started to plot correctly. Spent about 5 minutes on this.

Spent another 20 minutes trying to get it so that patches will set their color back to white if there were no humans nearby. I researched agentset and patch-related commands again and I tried this code:

ask patches [
  is-agent? [in-radius 1]
  [ask patches with false set pcolor "white"]]

However, I kept getting an error and this code would not work. I then studied the dictionary further, looking at commands like turtles-on, etc. I finally decided that it would be much simpler just to put "ask patches [set pcolor "white"] at the start of the do-something procedure and have the patches change their color later on in the code if there were humans near them. This worked, and now the patches reset their color to white every time I click the do-something button. In this time I also tested the program by running it a few times. Decided to make it so humans and aliens only hatch 1 baby instead of 2 because the population gets way too large in too short a time. I will probably change this later on when I get the particulars of the program smoothed out.

Spent 10 minutes toying with the ages for reproduction and death, to make it so that turtles do not reproduce so much and have more time where they do not reproduce. I changed the amount hatched because I kept getting an error because either aliens or humans would die off and the plot would glitch. Now I made it so aliens hatch 1 and humans can hatch between 0-2, depending and what random returns. I changed the age to increase only by 0.5 instead of 1 each tick, hopefully to draw out the life cycle of turtles and so they do not die or reproduce too much, to allow time for aliens to hunt. The program seems to lag due to the patches changing colors though.

Spent about 30 more minutes trying to figure out a way to have patches change color based on the humans being on them. I looked up things like turtles-here and turtles-on in the dictionary. First I tried some examples I saw in the dictionary that I modified,

ask patches [
  if humans-here = true
  [set pcolor "green"]]

But this code did nothing and did not even return an error. Then I tried a slightly different approach,

ask patches [
  if any? humans-on myself [
  set pcolor "green"]]

But this also returned an error. I then kept the patch color default as black since it seemed to be lagging the program, and changed the human color to white and aliens to green. Then I went back to trying to make the patches change color based on the humans around. This time I tried an approach with the turtles instead of patches. I took a moment to add some code that would create some turtles if for some reason all of one species died off. I went back to trying to get the patches to work, this time I tried the code:

ask patches [
  if any? humans-on neighbors [
  set pcolor ["green"]]

But I keep getting an RGB error. I will set this aside for now and send an e-mail to John and ask if he knows of a way I can do it. I spent some time fooling around with how much the aliens and humans move forward as well, in an effort to try to get the program to a point that I can set the do-something button to forever and have the turtles move around at a speed that the viewer can witness. Also got rid of two unnecessary global variables.

I spent about an hour and 50 minutes on my project today.

##Log: Day 4

Today, I first spent five minutes reading and implementing what Mr. Balwit suggested in an e-mail. His code to set patches to green if humans were on them worked. I added some code after that myself which made the patches set their color back to black if there were no humans near them. I also created some new procedures that I will code later on when I beef up the program some more.

Spent another 25 minutes running the program and playing with it. I still do not like how fast the agents move. I tried setting it so that they move forward 0.001 * their speed but this just made them spin in circles. Also looked at the bug hunt model, and found an interesting command: every. I encased everything in the do-something procedure in every 0.03 and cleaned up my code a little by making it call procedures throughout the program instead of having all the code cluttered in the do-something procedure, making it easier to read. Even with this every command and having the turtles move approximately the same speed as the turtles in the bug-hunt model, I still seem to be having trouble with the turtles just spinning in circles and not really getting anywhere. I tried increasing the amount forward they move, and changing the heading. When I got rid of the set heading random, they seemed to be moving at a reasonable pace. I'll have to try something else than the set heading random 360 command. I will use a makeshift set heading random 60 command for the time being.

Spent an hour trying to make it so the aliens will face green patches and move towards them, in a procedure called hunt. First I tried,

  ask aliens [
    if any? patches with [pcolor green]] in-radius 3
    [face patch
      fd (speed * 10) * 0.001]]

But I got an error with this. Next I tried making a patches-own variable called "smell" and having the patches set their smell attribute to 1 if they are green, but I could not get this to work either. I went back to researching turtle and patch commands in the dictionary and got an idea to just try what I did to make the patches set their color back to black. For some reason, it will not work just as well with "if any? humans" instead of "if not any? humans". I scrapped the smell attribute idea when I came across an entry in the dictionary that was helpful. I went back to my previous idea with having the aliens face the patch, but this time made it so they will face it if [color = green]. This seems to work, but now I have trouble making the aliens face the patches.

Next I went back to the smell idea since it looks like a similar concept worked in the model where the ants follow a "scent" to get food. I tried 

  ask patches [
    if color = green
    [set smell smell + 1]]

But it looks like I can not use color that way. I also tried,

ask patches [
  if humans-here = true
  [set smell smell + 1]]

And this seemed to work! But now the patches are not actually setting their smell correctly. Next I moved on and tried to see if I could get the aliens to face these patches based on smell. I also tried making it so that they face the humans directly but that didn't work either,

  ask aliens [
    if any? patches with [smell = 1] in-radius 5
    [face human-here]]

I can not figure this out so I sent an e-mail off to Mr. Balwit to see if he could offer any insight.

Got a response from Mr. Balwit. Spent 25 minutes trying to figure out his example and to use something from it. I had a hard time understanding it, and kept getting errors when I put it into netlogo, so I'm going to send him another response. Finally just plugged some numbers into the model that he sent me, and it worked. It does have one agent move towards another. But I'm not sure if it would work in the same context as the model I am using. Some interesting commands from his model include "list", and "let" I spent some time research these. As a result, I tried,

  ask aliens [
    face [one-of [list humans]]]

but I got an error on this too. I will ask Mr. Balwit again for more help. I also changed around how much the humans and aliens reproduce so they do not die off so easily.

After waiting awhile for a response from Mr. Balwit, I decided that I would make my model so the species don't get hunted but instead just wander around and there will be a "contest" every once in awhile to see who survives and who does not. If I get an e-mail from Mr. Balwit later or tomorrow I will try to finish my original idea.

Spent 10 minutes modifying the program so that aliens also have a square around them as the humans do, and made it red. I changed it's name to "sight-range". I also changed the speed of the model a little, to try and find a speed that would work better for it.

Spent 30 minutes looking at the simple-evolution toy model to get an idea for a fitness function. Found an interesting command, "report", and I researched it in the Netlogo dictionary. I also looked at another model in the netlogo model library and found a good way to make it so the turtles can turn and move without spinning in circles. This model was the Wolf-Sheep Predation model under biology. This model also showed me how to make it so I can have one breed hunt another. So I will retry my original idea, but not have the aliens face and move towards the humans, and only kill them if they are on the same patch. I also used a different command to make them spawn in random areas. I changed the size of the spatial area and the size of the patches as well. I tinkered with the speed and amount of young the turtles hatch as well to try and find a balance.

Next, I spent about 40 minutes looking further at the wolf-sheep predation model and seeing if there was anything else I could use. I found the way the model reproduces the wolves and sheep interesting, so I will use the random float "throwing the dice" to determine if the humans will reproduce. I think I will make it so whenever an alien kills a human, it hatches another alien, just to spice things up a bit. Also reorganized and modified the code a little bit. In the course of my modification, it seems that the human population is decimated after one click of the button, but anything past that it seems to work fine. I tried changing the starting ages, but that didn't work. I tried reorganizing the procedures that are called in the do-something function, but that didn't work either. Going back and reviewing the order the procedures were called however, it was because I never asked the aliens to reproduce, which threw the whole thing out of whack. This had some problems too though. I looked at the wolf-sheep predation model and found what I was doing wrong. I was telling all of the original aliens to die with the way I had my code set up, so I changed the aliens-old-die and humans-old-die procedures to have if age = x [die] instead and this worked.

I then moved on to try and make a fitness function. I spent about 20 minutes trying to make this fitness function and to get the model running smoothly. I removed the sight procedure as it was lagging the model and did not serve a specific purpose. Got the model moving at an acceptable speed and the fitness function at an acceptable state for now.

I spent about 15 minutes trying to make a function where the aliens will kill the humans in the same patch. I looked again at the wolf sheep predation model for inspiration. I took the general idea of that code and added a little bit more of my own to make it so when an alien kills a human, it hatches one alien. This is the code I came up with,

  let hunted one-of humans-here
  if hunted != nobody
  [ask hunted [die]
  set total-humans-hunted total-humans-hunted + 1
    hatch 1 [
    set speed random-normal [speed] of myself std-dev-slider
    set intelligence random-normal[intelligence] of myself std-dev-slider
    set hunting-skill random-normal [hunting-skill] of myself std-dev-slider
    set age 1
    set color [color] of myself
    set heading random 360
  ]]

And it turns beautifully.

However, I am still having trouble with a large amount of humans and aliens dying in the first iteration. I spent about 25 minutes trying to debug this. First I tried making it so that aliens and humans start with a fitness rating, as I thought maybe it was killing them off when their fitness was 0 at the start. This was not the problem. Making the fitness function less restrictive seemed to help a little, but there are still some mysterious deaths, even when the turtle has a high enough fitness and other attributes to survive. I moved on for a little bit to try and get it to monitor the amount of humans hunted. First I tried to run the program for a little and type show total-humans-hunted. This showed a real number and that it was being counted. The problem had to be with the code in the monitor then. I tried doing show total-humans-hunted but that did not work either. I looked up the command "count" that I was using for the monitor and found that it counts agentsets, not globals. To remedy this problem, I looked to the bug-hunt-speeds model for inspiration. I decided to make it a plot instead of a monitor, and used the code:

plotxy ticks total-humans-hunted

And now it plots how many humans are hunted over time.

Next, I wanted to make it so that humans could survive being killed by an alien if their survival was high enough. I decided to make heavy use of procedure calls to do this and to modify the hunt procedure a little. I spent about 15 minutes creating and modifying code for this. The first thing I tried, for both hunt and check-survival procedures was,

to hunt
  let hunted one-of humans-here
  if hunted != nobody
  [ask hunted [check-survival]]

end

to check-survival
  if survival > hunting-skill [ask myself [die]]
  if survival < hunting-skill [ask hunted [die]]
    set total-humans-hunted total-humans-hunted + 1
    hatch 1 [
    set speed random-normal [speed] of myself std-dev-slider
    set intelligence random-normal[intelligence] of myself std-dev-slider
    set hunting-skill random-normal [hunting-skill] of myself std-dev-slider
    set age 1
    set color [color] of myself
    set heading random 360
  ]]
end

But this brought up an error about nothing named "hunted" being defined in the second procedure. This pretty much dashed any hopes of making this a procedure call, so I decided to try and combine the two. 

I moved on for a bit to try and debug a problem I noticed that aliens and humans were not dying due to old age. I spent about 10 minutes on this. First I tried just getting rid of the aliens-old-die and humans-old-die procedures and combining them into the have-contest procedures and changing it so if their age is > x then they die. For some reason this killed off all of the humans right away when I tried running the do-something button. This makes me think there is something wrong with the way the turtles reproduce and age. I modified the humans-age and aliens-age procedures by removing the ask turtles and brackets and now the turtles age as expected and die as they are supposed to. I increased the age that each alien and human dies at quite a bit to allow for a little more time for them to live, since they were dying off too fast.

After this, I moved on to try making it so humans could kill aliens if their survival skill was high enough and would still be killed if it was low enough. I spent about 25 minutes trying to make this code. I tried,


to hunt
  let hunted one-of humans-here
  if hunted != nobody
  [ask hunted [
      if survival < 10 [
        ask self [die]
   set total-aliens-killed total-aliens-killed + 1]
      if survival > 10 [
        ask hunted [die]
   set total-humans-hunted total-humans-hunted + 1
    hatch 1 [
    set speed random-normal [speed] of myself std-dev-slider
    set intelligence random-normal[intelligence] of myself std-dev-slider
    set hunting-skill random-normal [hunting-skill] of myself std-dev-slider
    set age 1
    set color [color] of myself
    set heading random 360]]]]
end

This ran, but it did nothing. I also tried,


to hunt
  let hunted one-of humans-here
  if hunted != nobody
  [ask hunted [
      if survival < 10 [
        ask self [die]
   set total-aliens-killed total-aliens-killed + 1]]]
      
   [ask hunted [
       if survival > 10 [
       ask hunted [die]
   set total-humans-hunted total-humans-hunted + 1]
    
    hatch 1 [
    set speed random-normal [speed] of myself std-dev-slider
    set intelligence random-normal[intelligence] of myself std-dev-slider
    set hunting-skill random-normal [hunting-skill] of myself std-dev-slider
    set age 1
    set color [color] of myself
    set heading random 360]]]
  
end

But I kept getting an error on it as well. I decided to scrap this and just go back to my original code which worked and did not make the humans survival conditional on their survival skill.

Then I went back to tinkering with the model to get a good speed and flow down. I spent about 20 minutes tinkering with speeds, reproduction rates, how much each turtle moves forward, and the max and min amounts of each turtle that can spawn at the start. I found that the problem was that my fitness function was killing off almost half of the initial populations because they did not spawn with high enough attributes. It seemed the humans were being killed off so fast because the aliens were killing them, not because of the fitness function as I set it to 0 and many still died off. I finally found a somewhat decent flow for the program and left it at that for the time being.

Next I wanted to create a random, freak accident that would have a profound impact on the spatial area. I will call this an extinction event, and make it a procedure the observer can activate while the program is running. I spent about 15 minutes creating and tinkering with my options. I decided on, from prior experience with modifying the simple-evolution model, that I wanted to have something happen based on the area the turtles are occupying. I decided on this code,

to extinction-event
  ask turtles [if xcor + ycor > 25 and xcor + ycor < 45 [die]]
end

To make it so that all the turtles near the middle area will be wiped out. This could be anything from a meteor to sudden lack of food.

It bothered me that the model would bring up an error message everytime one of the breeds died off (because the plots were set up in a way that required at least one of each breed to keep plotting). So, I tried coding the plots so that they would stop plotting once the breed died off. The code:

if any? aliens [plotxy ticks mean [hunting-skill] of aliens]

and:

if any? humans [plotxy ticks mean [survival] of humans]

Worked. I also made it so the do-something procedure would stop once all the aliens were dead. I decided to do this because if I had it stop when all turtles were dead, it would never stop because sometimes the humans would survive and then go on to reproduce forever. However, if only aliens were left over, they would eventually die off because they needed to kill humans to reproduce. It took me about five minutes to find good code for this.

Today, I spent about five hours and 45 minutes on my project.

##Day 5

I took some time to put comments in my code to show what each line does; this took me about 40 minutes to get detailed comments in the code; I also spent some of that time tinkering with the fitness and reproduction procedures to make them more like what you might see in real life.

After this, I did my write up. This took me about an hour and 10 minutes to do my write up, check it for errors, and then go through my log and write up to check for errors again.

At this point, I finished my projtect.

I spent an hour and 50 minutes on my project today.

In total, I spent 10 hours and 25 minutes on this project.

I really enjoyed this project and I am glad that I am more adept at Netlogo now and that I can use it in the future!

Thanks, Mr. Balwit!

-Austen Ruzicka
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
