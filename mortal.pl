mortal(X) :- person(X).

person(socrates).
person(plato).
person(zeno).
person(aristotle).

mortal_report() :-
  write('Mortals are:'),nl,
  mortal(X),
  write(X),nl,
  false.
