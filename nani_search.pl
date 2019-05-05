#!/usr/bin/env swipl

:- dynamic
  here/1,
  location/2,
  have/1,
  turned_off/1,
  move_count/1.

:- initialization(main, main).

main:-
  nani_search.

nani_search:-
  write('Your persona as the adventurer is that of a three year'),nl,
  write('old.  The Nani is your security blanket.  It is getting'),nl,
  write('late and you''re tired, but you can''t go to sleep'),nl,
  write('without your Nani.  Your mission is to find the Nani.'),nl, nl,
  write('You control the game by using simple English commands'),nl,
  write('expressing the action you wish to take.  You can go to'),nl,
  write('other rooms, look at your surroundings, look in things'),nl,
  write('take things, drop things, eat things, inventory the'),nl,
  write('things you have, and turn things on and off.'),nl, nl,
  write('Hit any key to continue.'),get0(_),
  write('Type "quit" if you give up.'),nl, nl, write('Enjoy the hunt.'),nl,
  look,
  command_loop.


% Initial assertions
room(kitchen).
room(cellar).
room(office).
room(hall).
room(bedroom).
room('dining room').

location(computer, office).
location(desk, office).
location(flashlight, desk).
location(envelope, desk).
location(stamp, envelope).
location(key, envelope).
location(apple, kitchen).
location(broccoli, kitchen).
location(crackers, kitchen).
location('washing machine', cellar).
location(nani, 'washing machine').

door(kitchen, cellar).
door(kitchen, office).
door(office, hall).
door(hall,'dining room').
door(bedroom, hall).
door('dining room', kitchen).

connect(X, Y):-
  door(X, Y).
connect(X, Y):-
  door(Y, X).

edible(apple).
edible(crackers).

tastes_yucky(brocolli).

turned_off(flashlight).
here(kitchen).

move_count(0).

% read a line of words from the user

read_list(L) :-
  write('> '),
  read_line(CL),
  wordlist(L,CL,[]), !.
read_line(L) :-
  get0(C),
  buildlist(C,L).
buildlist(10,[]) :- !.
buildlist(C,[C|X]) :-
  get0(C2),
  buildlist(C2,X).
wordlist([X|Y]) --> word(X), whitespace, wordlist(Y).
wordlist([X]) --> whitespace, wordlist(X).
wordlist([X]) --> word(X).
wordlist([X]) --> word(X), whitespace.
word(W) --> charlist(X), {name(W,X)}.
charlist([X|Y]) --> chr(X), charlist(Y).
charlist([X]) --> chr(X).
chr(X) --> [X],{ X>=48 }.
whitespace --> whsp, whitespace.
whitespace --> whsp.
whsp --> [X], { X<48 }.


% NLP
det([the|X]- X).
det([a|X]-X).
det([an|X]-X).

verb(look, [look|X]-X).
verb(look, [look,around|X]-X).
verb(inventory, [inventory|X]-X).
verb(end, [end|X]-X).
verb(end, [quit|X]-X).
verb(end, [good,bye|X]-X).

verb(place, goto, [go,to|X]-X).
verb(place, goto, [go|X]-X).
verb(place, goto, [move,to|X]-X).
verb(place, goto, [X|Y]-[X|Y]):-room(X).
verb(place, goto, ['dining room'|Y]-['dining room'|Y]).

verb(thing, take, [take|X]-X).
verb(thing, put, [drop|X]-X).
verb(thing, put, [put|X]-X).
verb(thing, turn_on, [turn,on|X]-X).
verb(thing, turn_off, [turn,off|X]-X).
verb(thing, look_in, [look,in|X]-X).
verb(thing, look_in, [look,inside|X]-X).

noun(place, Place, [Place|X]-X):- room(Place).
noun(place, 'dining room', [dining,room|X]-X).

noun(thing, Thing, [Thing|X]-X):- location(Thing, _).
noun(thing, Thing, [Thing|X]-X):- have(Thing).
noun(thing, 'washing machine', [washing,machine|X]-X).

object(Type, Object, S1-S3):-
  det(S1-S2),
  noun(Type, Object, S2-S3).
object(Type, Object, S1-S2):-
  noun(Type, Object, S1-S2).

get_command(C) :-
  read_list(L),
  command(CL,L),
  C =..  CL,
  !.
get_command(_) :-
  write('I do not understand'), nl, fail.

command([V,O], InList) :-
  verb(Object_Type, V, InList-S1),
  object(Object_Type, O, S1-[]).
command([V], InList):-
  verb(V, InList-[]).

% UI
command_loop:-
  repeat,
  get_command(X),
  puzzle(X),
  do(X),nl,
  increment_move,
  end_condition(X).

increment_move:-
  move_count(X),
  X1 is X + 1,
  retract(move_count(X)),
  assert(move_count(X1)).

end_condition(_):-
  have(nani),
  write('Congratulations').

end_condition(end):-
  true.

end_condition(_):-
 move_count(X),
 X > 25,
 write('You were too noisy. Your parents woke up and put you to bed without Nani :('),
 !.

do(goto(X)):-
  goto(X),
  !.

do(go(X)):-
  go(X),
  !.

do(inventory):-
  inventory,
  !.

do(look):-
  look,
  !.

do(look_in(X)):-
  look_in(X),
  !.

do(take(X)):-
  take(X),
  !.

do(put(X)):-
  put(X),
  !.

do(end):-
  true,
  !.

do(turn_on(_)):-
  turn_on,
  !.

do(turn_off(_)):-
  turn_off,
  !.

do(_):-
  write('Invalid command').

% Internal Commands

list_things(Place):-
  location(X, Place),
  tab(2),
  write(X),
  nl,
  fail.
list_things(_):-
  true, !.
:- op(35, fx, list_things).

list_connections(Place):-
  connect(X, Place),
  tab(2),
  write(X),
  nl,
  fail.
list_connections(_):-
  true, !.
:- op(35, fx, list_connections).

look:-
  here(Place),
  write('You are in the '), write(Place),nl,
  write('You can see:'), nl,
  list_things(Place),
  write('You can go to'), nl,
  list_connections(Place).

look_in(Place):-
  list_things(Place).
:- op(35, fx, look_in).

goto(Place):-
  can_go(Place),
  move(Place),
  look.
:- op(35, fx, goto).

go(Place):-
  goto(Place).
:- op(35, fx, go).

can_go(Place):-
  here(X),
  connect(X, Place),
  !.

can_go(_):-
  write('You can not get there from here'),nl,
  fail.
:- op(35, fx, can_go).

move(Place):-
  retract(here(_)),
  asserta(here(Place)).

:- op(35, fx, move).

take(Thing):-
  can_take(Thing),
  take_object(Thing),
  !.
:- op(35, fx, take).

can_take(Thing):-
  here(Place),
  is_contained(Thing, Place).
can_take(Thing):-
  write('There is no '),
  write(Thing),
  write(' here'),
  nl, fail.

put(Thing):-
  have(Thing),
  retract(have(Thing)),
  here(Place),
  assert(location(Thing, Place)),
  write('All good'), nl,
  true.

:- op(35, fx, put).

take_object(Thing):-
  retract(location(Thing, _)),
  asserta(have(Thing)),
  write('taken'), nl,
  true.

inventory:-
  have(_),
  write('You have following objects: '),nl,
  list_inventory,
  !.
inventory:-
  write('You have nothing on ya'),
  true,
  !.

list_inventory:-
  have(X),
  tab(2),
  write(X),
  nl,
  fail.
list_inventory:-
  true, !.

turn_on:-
  turned_off(flashlight),
  retract(turned_off(flashlight)),
  write('Flashlish was turned on'),
  true, !.
turn_on:-
  write('Flashlish is already turned on'),
  true.

turn_off:-
  turned_off(flashlight),
  write('Flashlish is already turned off'),
  true, !.

turn_off:-
  assert(turned_off(flashlight)),
  write('Flashlish was turned off'),
  true.

is_in(Thing, Place):-
  location(Thing, Place).
:- op(35, yfx, is_in).

is_contained(Thing, Place):-
  location(Thing, Place).

is_contained(Thing, Place):-
  location(X, Place),
  is_contained(Thing, X).

puzzle(go(cellar)):-
  !,
  puzzle(goto(cellar)).

puzzle(go(bedroom)):-
  !,
  puzzle(goto(bedroom)).

puzzle(goto(cellar)):-
  have(flashlight),
  not(turned_off(flashlight)),
  !.
puzzle(goto(cellar)):-
  write("Afraid of the dark"),nl,
  !,
  fail.
puzzle(goto(bedroom)):-
  write("You can't go to bedroom. You're risking to wake up mommy and daddy."),nl,
  !,
  fail.

puzzle(_):-
  true.


:- op(35, yfx, is_contained).
