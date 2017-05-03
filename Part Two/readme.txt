Stranded by Mingtau Li, 011110539

synopsis: Stranded is a text-adventure game written in Prolog in which the player is a lone survivor of plane trash. The player needs to find a way off an island before he/she freezes to death in the harsh cold night.

To run the game: 
?- ['adventure'].  or  ?- consult('adventure').

To start the game: 
?- start.

To see the list of instructions: 
?- instructions.

Some important commands: 
?- n. s. e. w.					--> go north, south, east, or west
?- inventory.  or  ?- i.      	--> lists objects in your inventory
?- look.					 	--> desribes your immediate surroundings
?- describe(Something).		    --> describes anything in your line of sight (could be place or thing)
?- take(Object).				--> stores object into inventory
?- take(List[]).				--> stores a list of objects into inventory
?- take(Object, Container).		--> take object out of containers 
?- take(all, Container).		--> take all objects out of a container
?- drop(Object).				--> put down an object somewhere
?- drop(List[]).				--> put down a list of objects
?- open(Object).				--> opens a door or container
?- combine(Object1, Object2).	--> combines 2 objects together
?- break(Object).				--> break an object
?- break(Object, With).			--> break object with another object
?- chop(Object, With).			--> chops an object with something else
?- chop(Object).				--> chops an object assuming you have something to chop with
?- light(Object, With).			--> lights up something with something else
?- light(Object).				--> lights up something assuming you have something to light with
?- eat(Something).				--> player eats something
?- drink(Something).			--> player drinks something
?- halt.


This game features 4 things:
* Locked door -> The airplane that crashed is half-submerged in water. The only way to get inside is to break the cockpit windshield with a rock.
* Hidden Object -> a surivival kit inside the plane also needs to be opened in order for its content to be revealed.
* Incomplete Objeect -> The player needs to combine 2 sources of wood together (driftwood and branches) in order to make a big enough woodpile for a fire.
* Limited Resources -> Player needs to build a fire on the beach to attract the attention of a plane before time runs out.

To win the game: 
Player must find a way to light a pile of wood on fire on the beach to attract the attention of a passing plane. If player fails to do this by the time the timer runs out, he/she dies.
