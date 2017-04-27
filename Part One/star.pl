object(balloon).
object(clothesline).
object(frisbee).
object(water_tower).

ms(barrada).
ms(gort).
mr(klatu).
mr(nikto).

day(tuesday).
day(wednesday).
day(thursday).
day(friday).

solve :-
    
    object(BarradaObject), 
    object(GortObject), 
    object(KlatuObject), 
    object(NiktoObject),
    all_different([BarradaObject, GortObject, KlatuObject, NiktoObject]),
    
    day(BarradaDay),
    day(GortDay),
    day(KlatuDay), 
    day(NiktoDay),
    all_different([BarradaDay, GortDay, KlatuDay, NiktoDay]),
    
    Triples = [ [barrada, BarradaObject, BarradaDay],
                [gort, GortObject, GortDay],
                [klatu, KlatuObject, KlatuDay],
                [nikto, NiktoObject, NiktoDay]
                ],

    %% klatu made his sighting at some point earlier in the week than the one who saw the balloon
    %% but at some point later in the week than the
    %% one who spotted the frisbee 
    %% who isn't Ms. Gort
    \+(member([klatu, balloon, _], Triples)),
    \+(member([klatu, frisbee, _], Triples)),
    \+(member([gort, frisbee, _], Triples)),
    before([klatu, _, _], [_, balloon, _], Triples),
    after([klatu, _, _], [_, frisbee, _], Triples),

    %% friday's sighting was made by either Barrada 
    %% or the one who saw the clothesline 
    %% or BOTH
    (
        member([barrada, _,friday], Triples);
        member([_,clothesline, friday], Triples)
    ),

    % nikto did not make his sighting on tuesday
    \+(member([nikto, _, tuesday], Triples)),

    % klatu's object wasn't the water tower
    \+(member([klatu, water_tower, _], Triples)),  

    tell(barrada, BarradaObject, BarradaDay),
    tell(gort, GortObject, GortDay),
    tell(klatu, KlatuObject, KlatuDay),
    tell(nikto, NiktoObject, NiktoDay).

all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

%% tells whether or not X happened before Y
before(X, _, [X | _]).
before(_, Y, [Y | _]) :- !, fail.
before(X, Y, [_ | T]) :- before(X, Y, T). 

%% tells whether or not X happened after Y
after(_, X, [X | _]).
after(Y, _, [Y | _]) :- !, fail.
after(X, Y, [H | _]) :- after(X, Y, H).

tell(X, Y, Z) :-
    ((mr(X);
    write('Ms.'), write(X), write(' saw a '), write(Y), write(' on '), write(Z), write('.'), nl),
    (ms(X);
    write('Mr.'), write(X), write(' saw a '), write(Y), write(' on '), write(Z), write('.'), nl)).
