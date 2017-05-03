# CECS 424 Sp2017 - Assignment #4
CECS 424 Prolog

Author: Mingtau Li, 
SID: 011110539

---
## Part One: Dell Logic Puzzles
### Content:
#### 1. tie.pl
This program solves the dell logic puzzle "It's a Tie":
> Four colleagues recently got into a discussion about some of the flamboyant pat-terns showing up on neckties these days. As a joke, each man arrived at work the next day sporting the most ridiculous tie he could find (no two men wore ties with the same pattern—one tie was decorated with smiling cupids). None of the men had to venture outside of his own closet, as each had received at least one such tie from a different relative! From the following clues, can you match each man with the pattern on his flamboyant tie, as well as determine the relative who presented each man with his tie? 
> * The tie with the grinning leprechauns wasn't a present from a daughter. 
> * Mr. Crow's tie features neither the dancing rein-deer nor the yellow happy faces. 
> * Mr. Speigler's tie wasn't a present from his uncle. 
> * The tie with the yellow happy faces wasn't a gift from a sister. 
> * Mr. Evans and Mr. Speigler own the tie with the grinning leprechauns and the tie that was a present from a father-in-law, in some order. 
> * Mr. Hurley received his flamboyant tie from his sister. 

##### To run: 
````
?- ['tie'].
?- solve.
````

#### 2. friends.pl
This program solves the dell logic puzzle "Imaginary Friends":
> Grantville's local library recently sponsored a writing contest for young children in the community. Each of four con-testants (including Ralph) took on the task of bring-ing to life an imaginary friend in a short story. Each child selected a different type of animal (including a moose) to personify, and each described a different adventure involving this new friend (one story de-scribed how an imaginary friend had formed a rock band). From the following clues, can you match each young author with his or her imaginary friend and determine the adventure the two had together? 
> * The seal (who isn't the creation of either Joanne or Lou) neither rode to the moon in a spaceship nor took a trip around the world on a magic train. 
> * Joanne's imaginary friend (who isn't the grizzly bear) went to the circus. 
> * Winnie's imaginary friend is a zebra. 
> * The grizzly bear didn't board the spaceship to the moon. 

##### To run: 
````
?- ['friends'].
?- solve.
````

#### 3. star.pl
This program solves the dell logic puzzle "Star Tricked":
> Last week, four UFO enthusiasts made sightings of unidentified flying objects in their neighborhood. Each of the four reported his or her sighting on a different day, and soon the neighborhood was abuzz with rumors of little green men. By the weekend, though, the government stepped in and was able to give each person a different, plausible explanation of what he or she had "really" seen. Can you deterine the day (Tuesday through Friday) each person sighted a UFO, as well as the object that it turned out to be?
> * Mr. Klatu made his sighting at some point earlier in the week than the one who saw the balloon, but at some point later in the week than the one who spotted the Frisbee (who isn't Mr. Gort). 
> * Friday's sighting was made by either Mr. Barrada or the one who saw the clothesline (or both).
> * Mr. Nikto did not make his sighting on Tuesday.
> * Mr. Klatu isn't the one whose object turned out to be a water tower.

##### To run: 
````
?- ['star'].
?- solve.
````
#### 4. queries.txt
A list of queries needed in order to run programs

---


## Part Two: Prolog Adventure Game
Stranded by Mingtau Li, 011110539

synopsis: Stranded is a text-adventure game written in Prolog in which the player is a lone survivor of plane trash. The player needs to find a way off an island before he/she freezes to death in the harsh cold night.

#### To run the game: 
````
?- ['adventure'].
````
or 
````
?- consult('adventure').
````
#### To start the game: 
````
?- start.
````

#### To see the list of instructions: 
````
?- instructions.
````

#### Some important commands: 
````
?- n. s. e. w.				%% go north, south, east, or west
?- inventory.  or  ?- i.		%% lists objects in your inventory
?- look.				%% desribes your immediate surroundings
?- describe(Something).			%% describes anything in your line of sight (could be place or thing)
?- take(Object).			%% stores object into inventory
?- take(List[]).			%% stores a list of objects into inventory
?- take(Object, Container).		%% take object out of containers 
?- take(all, Container).		%% take all objects out of a container
?- drop(Object).			%% put down an object somewhere
?- drop(List[]).			%% put down a list of objects
?- open(Object).			%% opens a door or container
?- combine(Object1, Object2).		%% combines 2 objects together
?- break(Object).			%% break an object
?- break(Object, With).			%% break object with another object
?- chop(Object, With).			%% chops an object with something else
?- chop(Object).			%% chops an object assuming you have something to chop with
?- light(Object, With).			%% lights up something with something else
?- light(Object).			%% lights up something assuming you have something to light with
?- eat(Something).			%% player eats something
?- drink(Something).			%% player drinks something
?- halt.
````
#### Screenshot
![alt text](Part%20Two/2017-05-02_23h15_45.png "Screenshot")

#### This game features 4 things:
* Locked door -> The airplane that crashed is half-submerged in water. The only way to get inside is to break the cockpit windshield with a rock.
* Hidden Object -> a surivival kit inside the plane also needs to be opened in order for its content to be revealed.
* Incomplete Objeect -> The player needs to combine 2 sources of wood together (driftwood and branches) in order to make a big enough woodpile for a fire.
* Limited Resources -> Player needs to build a fire on the beach to attract the attention of a plane before time runs out.

#### To win the game: 
Player must find a way to attract the attention of a passing plane. If player fails to do this by the time the timer runs out, he/she dies.