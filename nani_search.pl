:- dynamic
  here/1,
  location/2,
  have/1,
  turned_off/1,
  move_count/1.

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

location_s(object(candle, red, small, 1), kitchen).
location_s(object(apple, red, small, 1), kitchen).
location_s(object(apple, green, small, 1), kitchen).
location_s(object(table, blue, big, 50), kitchen).

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

command_loop:-
  repeat,
  write("Welcome to Nani Search:"),nl,
  read(X),
  write(">nani> "),
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
 X > 20,
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

do(end):-
  true,
  !.

do(turn_on):-
  turn_on,
  !.

do(turn_off):-
  turn_off,
  !.

do(_):-
  write('Invalid command').

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
