friend(grizzly_bear).
friend(mooose).
friend(seal).
friend(zebra).

author(joanne).
author(lou).
author(ralph).
author(winnie).

adventure(circus).
adventure(rockband).
adventure(spaceship).
adventure(train).

solve :-
    
    friend(JoannesFriend), 
    friend(LousFriend), 
    friend(RalphsFriend), 
    friend(WinniesFriend),
    all_different([JoannesFriend, LousFriend, RalphsFriend, WinniesFriend]),
    
    adventure(JoannesAdventure), 
    adventure(LousAdventure), 
    adventure(RalphsAdventure), 
    adventure(WinniesAdventure),
    all_different([JoannesAdventure, LousAdventure, RalphsAdventure, WinniesAdventure]),
    
    Triples = [ [joanne, JoannesFriend, JoannesAdventure],
                [lou, LousFriend, LousAdventure],
                [ralph, RalphsFriend, RalphsAdventure],
                [winnie, WinniesFriend, WinniesAdventure]
                ],
                
     %% the seal isn't a creation of Joanne
     %% nor Lou
	\+ member([joanne, seal,_], Triples),
    \+ member([lou, seal, _], Triples),
    
     %% neither rode to the moon in spaceship 
     %% nor took a trip around the world in train
    \+ member([_, seal, spaceship], Triples),
    \+ member([_, seal, train,_],Triples),
    
     %% Joanne's imaginary friend who isn't a frizzly bear 
     %% went to the circus
    \+ member([joanne, grizzly_bear, _], Triples),
    member([joanne, _, circus], Triples),
    
     %% winnie's imaginary friend is a zebra
    member([winnie, zebra, _], Triples),

    %% the grizzly bear didn't board the spaceship to the moon
    \+ member([_,grizzly_bear,spaceship], Triples),
    

    tell(joanne, JoannesFriend, JoannesAdventure),
    tell(lou, LousFriend, LousAdventure),
    tell(ralph, RalphsFriend, RalphsAdventure),
    tell(winnie, WinniesFriend, WinniesAdventure).

all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(X, Y, Z) :-
    write(X),write('\''), write('s friend is a '), write(Y), write('. They went to the '), write(Z), write(' together.'), nl.