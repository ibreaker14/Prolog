:- dynamic i_am_at/1, at/2, holding/1, locked/1, contents/2, time/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).
:- style_check(-singleton).

% places player at default location
i_am_at(beach).

/* connects rooms together*/
path(beach, s, ocean).
path(ocean, n, beach).

path(ocean, e, plane).
path(plane, w, ocean).

path(beach, n, forest).
path(forest, s, beach).

path(forest, e, waterfall).
path(waterfall, w, forest).

path(waterfall, n, cave).
path(cave, s, waterfall).

/* places objects at various places */
at(driftwood, beach).
at(rock, beach).
at(trees, forest).
at(survival_kit, plane).
at(axe, plane).
at(dead_bodies, plane).
at(leaves, forest).

/* places objects in containers */
contents(food, survival_kit).
contents(water, survival_kit).
contents(lighter, survival_kit).

/* prevents objects from being moved */
unmovable(trees).
unmovable(dead_bodies).

/* declares whether object can be eaten */
edible(food).
drinkable(water).
drinkable(waterfall).

/* descriptions for singular and plural forms of objects */
plural(trees).
plural(leaves).
plural(dead_bodies).

single(driftwood).
single(rock).
single(survival_kit).
single(water).
single(food).
single(lighter).
singlea(axe).

/* locks doors and objects */
locked(plane).
locked(survival_kit).

/* declares objects as containers */
container(survival_kit).

/* initial timer value */
time(1).

/* describes cases for opening doors or containers */
open(survival_kit) :-
    locked(survival_kit),
    retract(locked(survival_kit)),
    write('You have opened surival_kit.'), nl,
    write('You see: '), nl,
    list_contents(survival_kit),!,
    nl,!.

open(survival_kit) :- 
    !,nl.

open(_) :-
    write('You can''t open this'),!,nl.

/* increments timer */
increase_time :- 
    retract(time(X)),
    (X < 25 -> true; 
        X = 25 -> (write('The sky''s getting dark. It''s getting colder and colder...'),nl);
        (X > 25, X < 30) -> true;
        X = 30 -> (write('You had no source of warmth. You suffered from hypothermia and died.'),die)
        ),
    succ(X,X1),
    assertz(time(X1)),
    !,nl.

/* These rules describe how to pick up an object. */
take([]) :- write('done'),!,nl.

take([H|T]) :- 
    take(H), 
    take(T), !, fail, nl.

take([H|T]).

take(dead_bodies) :-
    write('That''s messed up. Why would you do that?'), !, nl.

take(X) :-
    unmovable(X),
    write('You can''t carry '), 
    write(X),
    write('.'),
    !,nl.

take(X) :-
        holding(X),
        write('You''re already holding it!'),
        !, nl.


take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('You took the '),
        write(X),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        nl.

take(X, Object) :-
    locked(Object),
    write(Object),
    write(' is closed/locked.')
    ,!,nl.

take(X, Object) :-
        retract(contents(X,survival_kit)),
        assert(holding(X)),
        write('You took the '),
        write(X), !, nl.

take(all,Object) :-
    container(Object),
    retract(contents(X,Object)),
    assert(holding(X)), nl, fail.

take(all,Object) :-
    container(Object),
    write('You have taken everything out of the '),
    write(Object),!,nl.

take(_,_) :-
    write('That isn''t possible.'),nl,!.

/* These rules describe how to put down an object. */

drop([]) :- write('done'),!,nl.

drop([H|T]) :- 
    drop(H), 
    drop(T), !, fail, nl.

drop([H|T]).

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('OK.'),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        locked(There),
        write('The '),
        write(There),
        write(' seems to be locked.'), nl,
        !, describe(There).

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        !, look,
        increase_time.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.

/* Fun stuff */
drink(waterfall) :-
    i_am_at(waterfall),
    write('refreshing'), !, nl.

drink(Item) :-
    holding(Item),
    retract(holding(Item)),
    drinkable(Item),
    write('You drank the '),
    write(Item),
    write('.'), !, nl.

drink(_) :-
    write('Nope.'), !, nl.

eat(Item) :-
    holding(Item),
    retract(holding(Item)),
    edible(Item),
    write('You ate the '),
    write(Item),
    write('.'), !, nl.

eat(_) :-
    write('Nope.'), !, nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

list_contents(Object) :-
    contents(X,Object),
    tab(2),
    write(X),nl,fail.

list_contents(Object):-
    nl,!.

notice_objects_at(Place) :-
        (
            i_am_at(ocean);
            i_am_at(plane)
        ),
        at(X, Place),
        locked(plane),
        write('It''s hard to see inside'), nl,
        !.

notice_objects_at(Place) :-
        at(X, Place),
        plural(X),
        write('There are '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(Place) :-
        at(X, Place),
        single(X),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(Place) :-
        at(X, Place),
        singlea(X),
        write('There is an '), write(X), write(' here.'), nl,
        fail.


notice_objects_at(_).

/* Lists inventory */
inventory:-
  holding(X), 
  write('You have: '),nl,
  inventory_list.

inventory:-
  nl, write('You aren''t carrying anything.'),nl.

inventory_list:-
  holding(X),
  tab(2),write(X),nl,
  fail.
inventory_list.

/* This rule tells how to win. */
win :- 
    nl,write('Congratulations! You won the game!'),nl,
    write('Enter "halt" command to exit game').

/* This rule tells how to die. */

die :-
    finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */
finish :-
        nl,
        write('Game Over. Enter the "halt" command to quit.'),
        nl.


/* This rule just writes out game instructions. */
instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                       -- to start the game.'), nl,
        write('look.                        -- to look around you again.'), nl,
        write('describe(Location).          -- to describe your current location or adjoining location.'), nl,
        write('n.  s.  e.  w.               -- to go in that direction.'), nl,
        write('take(Object).                -- to pick up an object.'), nl,
        write('take(List[]).                -- to pick up a list of objects.'), nl,
        write('take(Object, Container).     -- to take object out of a container.'), nl,
        write('take(all, Container).        -- to take out all of container''s contents.'), nl,
        write('drop(Object).                -- to put down an object.'), nl,
        write('drop(List[]).                -- to put down a list of objects.'), nl,
        write('open(Object).                -- to open a door or container.'), nl,
        write('break(Object).               -- to break an object.'), nl,
        write('break(Object, With).         -- to break an object using something else.'), nl,
        write('chop(Object).                -- to chop an object assuming you are in possession of something to chop with.'), nl,
        write('chop(Object, With).          -- to chop an object using something else.'), nl,
        write('combine(Item1, Item2).       -- to combine 2 items together.'), nl,
        write('light(Something, With).      -- to light something with something else.'), nl,
        write('light(Something).            -- to light something up assuming you already have something else to light it with.'), nl,
        write('instructions.                -- to see this message again.'), nl,
        write('halt.                        -- to end the game and quit.'), nl,
        nl.

/* intro to the game*/
intro :-
    nl,
    write('Welcome to Stranded the Game! Find your way out off the island'),nl,
    write('where you were stranded at after you survived from a plane crash.'), nl,
    nl.

/* This rule prints out instructions and tells where you are. */
start :-
    intro,
    instructions,
    look.

/* These rules dictate how user breaks things */
break(Object) :-
    ((Object = plane; 
        Object = cockpit; 
        Object = window; 
        Object = windshield) ->  
    locked(plane), write('That is one sturdy windshield')), !, nl.

break(leaves) :-
    write('You tore some leaves apart.'),!,nl.

break(driftwood) :-
    write('Ouch! You didn''t break the driftwood, it broke you'),!,nl.

break(branches) :-
    (holding(branches);(i_am_at(forest),at(branches,forest)) -> write('Snap!')),
    !,nl.
    
break(_) :-
    write('I don''t think you can break that.'),!,nl.

break(Object,rock) :-
        holding(rock),
        ((Object = plane; 
        Object = cockpit; 
        Object = window; 
        Object = windshield) ->  
            locked(plane), 
            write('You threw rock through the cockpit window and broke it.'),
            write(' Looks like you''re finally able to enter the plane.'), 
            retract(locked(plane)), 
            retract(holding(rock)), 
            assert(at(rock,plane))), !, nl.

break(Object,rock) :-
       holding(rock),
       ((Object = plane; 
        Object = cockpit; 
        Object = window; 
        Object = windshield) ->  
        write('It''s already broken.')), !, nl.

break(Object,axe) :-
    holding(axe),
    at(branches, forest),
       (Object = branches ->  
        write('You chopped the branches.')), !, nl.

break(Object,axe) :-
    holding(axe),
       ((Object = tree; Object = trees) ->  
        write('You chopped some branches off the tree.'),
            assert(at(branches,forest)),
            assert(plural(branches))), !, nl, look.

break(Object,axe) :-
    holding(axe),
    write('Why???'),!,nl.

break(Object,Object2) :-
    write('You do not have a '),
    write(Object2),!,nl.

break(_,_) :-
    write('I don''t think you can break that.'),!,nl.

chop(Object, axe) :- 
    break(Object,axe), !,nl.

chop(_,_) :-
    write('What do you think you''re doing?'),!,nl.

chop(X) :-
    holding(axe),
    chop(X,axe),!,nl.

chop(_) :-
    write('With what?'),! ,nl.

/* These rules dictate how objects are combined together */

combine(Item1, Item2) :- 
    i_am_at(X),
    (at(branches,X); holding(branches)),
    (at(driftwood,X); holding(driftwood)),
    (retract(at(branches,X));
    retract(holding(branches))),
    (retract(at(driftwood,X));
    retract(holding(driftwood))),
    assert(holding(woodpile)),
    assert(single(woodpile)),
    (((Item1 = branches, Item2 = driftwood);(Item1 = driftwood, Item2 = branches)) -> 
        write('You combined the items together to create a woodpile. Check your inventory.')),!, nl.

combine(Item1,Item2) :-
    i_am_at(X),
    (at(driftwood,X); holding(driftwood)),
    (at(leaves,X); holding(leaves)),
    (((Item1 = leaves, Item2 = driftwood);(Item1 = driftwood, Item2 = leaves)) -> 
        (write('You threw some leaves at the driftwood.'))),!, nl.

combine(Item1,Item2) :-
    i_am_at(X),
    (at(branches,X); holding(branches)),
    (at(leaves,X); holding(leaves)),
    (((Item1 = leaves, Item2 = branches);(Item1 = branches, Item2 = leaves)) -> 
        (write('You threw some leaves at the branches.'))),!, nl.

combine(Item1,Item2) :-
    (((Item1 = lighter, Item2 = woodpile);(Item1 = woodpile, Item2 = lighter)) -> 
       light(woodpile,lighter)).

combine(Item1,Item2) :-
    (((Item1 = lighter, Item2 = branches);(Item1 = branches, Item2 = lighter)) -> 
       light(branches,lighter)).

combine(Item1,Item2) :-
    (((Item1 = lighter, Item2 = leaves);(Item1 = leaves, Item2 = lighter)) -> 
       light(leaves,lighter)).

combine(Item1,Item2) :-
    (((Item1 = lighter, Item2 = trees);(Item1 = trees, Item2 = lighter)) -> 
       light(trees,lighter)).

combine(Item1,Item2) :-
    (((Item1 = lighter, Item2 = woodpile);(Item1 = woodpile, Item2 = lighter)) -> 
       light(woodpile,lighter)).

combine(_,_) :- 
    write('I don''t think you can do that.'),!,nl.

/* These rules dictate what happens when player lights fires */
light(Item) :-
    holding(lighter),
    light(Item,lighter),!,nl.

light(_) :-
    write('With what?'), !, nl.

light(branches,lighter) :-
    i_am_at(X),
    holding(lighter),
    (retract(at(branches,X));
    retract(holding(branches))),
    write('You lit the branches on fire, but it didn''t last very long.'),!,nl.

light(leaves,lighter) :-
    i_am_at(X),
    holding(lighter),
    (retract(at(leaves,X));
    retract(holding(leaves))),
    write('You lit some leaves on fire, but it didn''t last very long.'),!,nl.

light(driftwood,lighter) :-
    i_am_at(X),
    holding(lighter),
    (holding(driftwood);at(driftwood,X)),
    write('hmm... it seems to be missing something...'),!,nl.

light(trees,lighter) :-
    i_am_at(forest),
    holding(lighter),
    write('You started a forest fire. You died in your creation.'), die.

light(woodpile, lighter) :-
    i_am_at(X),
    holding(lighter),
    (holding(woodpile);at(woodpile,X)),
    (
        (X = beach -> (write('You started a huge bonfire at the beach.'), nl, write('A plane passing by saw your fire and came down to help.'), nl, write('You have been saved.'), nl, win));
        (X = ocean -> (write('What do you think you''re doing?'), nl));
        (X = plane -> (write('The plane fills with smoke.'), nl, write('Weak and unable to see through the smoke, you suffocated and died.'),nl, die));
        (X = forest -> (write('What have you done?!? You have just started a forest fire!'), nl, write(' You killed yourself along with all the animals living on the island.'), nl,die));
        (X = waterfall -> (write('Please don''t.'),nl));
        (X = cave -> (write('The cave filled up with intense black smoke.'), nl, write('You slipped and broke your ankle. Unable to get out, you suffocated and died.'),nl, die))
   )
    ,!,nl.
    


light(_,_)  :- 
    write('You can''t do that here'),!,nl.

/* These rules describe the various rooms as well as objects.  Depending on
   circumstances, a room may have more than one description. */

describe(beach) :- 
    (
        i_am_at(beach);
        i_am_at(ocean);
        i_am_at(forest)
    ),
    write('You are the lone survivor of an airplane crash.'), nl,
    write('You seem to be stranded on the beach of an unknown island.'), nl,
    write('To the south is the ocean.'), nl,
    write('You also see a forest to your north.'), nl,
    write('You are all alone.'), nl.

describe(ocean) :- 
    (
        i_am_at(ocean);
        i_am_at(beach);
        i_am_at(plane)
    ),
    write('You are in the ocean.'), nl,
    write('The beach is to the north.'), nl,
    write('The crashed plane is on your east.'), !, nl.

describe(forest) :-
    (
        i_am_at(forest);
        i_am_at(beach);
        i_am_at(waterfall)
    ),
    write('You are in a forest full of trees.'), nl,
    write('There is a waterfall on your east.'), nl,
    write('The beach is on your south.'), !, nl.

describe(waterfall) :- 
    (
        i_am_at(waterfall);
        i_am_at(cave);
        i_am_at(forest)
    ),
    write('You are at a refreshing waterfall.'), nl,
    write('There is a forest on your west.'), nl,
    write('There see something behind the waterfall on your north'), !, nl.

describe(cave) :- 
    (
        i_am_at(cave);
        i_am_at(waterfall)
    ),
    write('You seem to be in a natural bat cave behind a waterfall.'), nl,
    write('It''s hard to see. It''s too dark.'), !, nl.

describe(plane) :- 
    (
        i_am_at(plane);
        i_am_at(ocean)
    ),
    locked(plane),
    write('Most of the plane seems to be underwater. The doors seem to be'), nl,
    write('jammed shut. The cockpit seems to be above the water though.'), !, nl.

describe(plane) :- 
    (
        i_am_at(plane);
        i_am_at(ocean)
    ),
    write('You see the bodies of all the dead passengers floating around'), nl,
    write('in the half-submerged cabin. As you rummage through the cockpit, you '), nl,
    write('find a survival_kit and an axe.'), nl,
    write(''),!,nl.
    
describe(cockpit) :-
    (
        i_am_at(plane);
        i_am_at(ocean)
    ),
    locked(plane),
    write('A cockpit protected by thick glass'), !, nl.

describe(cockpit) :-
    (
        i_am_at(plane);
        i_am_at(ocean)
    ),
    locked(plane),
    write('A broken cockpit shattered by a rock.'), !, nl.

describe(dead_bodies) :-
    write('The sight of rotting bodies makes you gag.'), !, nl.

describe(trees) :-
    write('Just some regular trees.'), !, nl.

describe(driftwood) :-
    write('You see nothing of interest about this driftwood.'), !, nl.

describe(rock) :-
    i_am_at(plane),
    write('The rock you just threw into the plane.'), !, nl.

describe(rock) :-
    write('A heavy rock with a smooth surface weathered by sand and seawater.'), !, nl.

describe(axe) :-
    write('A sharp axe used for chopping stuff.'), !, nl.

describe(survival_kit) :-
    locked(survival_kit),
    write('A survival kit found on the plane.'), !, nl.

describe(survival_kit) :-
    write('You see'), nl,
    list_contents(survival_kit),
    write('inside'),!, nl.

describe(_) :-
    write('can''t describe what you don''t see.'), !, nl.



