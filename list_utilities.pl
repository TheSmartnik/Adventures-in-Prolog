remove(H, [H|T], T).
remove(X, [H|T], [H|T2]):-
  remove(X, T, T2).

next(H, [H,Second|T], Second).
next(X, [H|T], Y):-
  next(X, T, Y).

last([H|[]], H).
last([H|T], Y):-
  last(T, Y).

custom_length([], 0).
custom_length([H|T], L):-
  custom_length(T, N),
  L is N + 1.

respond([]).
respond([H|T]):-
  write(H),
  respond(T).


[a,b,c,d] = [H|T].
[a,[b,c,d]] = [H|T].
[] = [H|T].
[a] = [H|T].
[apple,3,X,'What?'] = [A,B|Z].
[[a,b,c],[d,e,f],[g,h,i]] = [H|T].
[a(X,c(d,Y)), b(2,3), c(d,Y)] = [H|T].

