male(vasya).
male(viktor).
male(michael).
male(artem).
male(nikita).
male(luka).
male(oleg).
male(sergei).
male(pavel).

female(nastya).
female(lena).
female(nelli).
female(ludmilla).
female(tatiana).
female(ekaterina).

parent(vasya, nikita).
parent(nelli, nikita).

parent(artem, luka).
parent(ludmilla, luka).

parent(sergei, pavel).
parent(lena, pavel).
parent(sergei, nastya).
parent(lena, nastya).

parent(michael, vasya).
parent(ekaterina, vasya).

parent(someone, lena).
parent(ekaterina, lena).
parent(someone, oleg).
parent(ekaterina, oleg).

parent(viktor, nelli).
parent(viktor, ludmilla).
parent(tatiana, nelli).
parent(tatiana, ludmilla).


spouse(nelli, vasya).
spouse(viktor, tatiana).
spouse(ekaterina, michael).
spouse(artem, ludmilla).
spouse(lena, sergei).

married(X, Y):-spouse(X, Y).
married(Y, X):-spouse(X, Y).

mother(Mother, Daughter):-
  female(Mother), parent(Mother, Daughter).

father(Father, Daughter):-
  male(Father), parent(Father, Daughter).

sibling(X, Y):-
  parent(Parent, X), parent(Parent, Y), X \= Y.

full_sibling(X, Y):-
  father(Father, X), mother(Mother, X), father(Father, Y), mother(Mother, Y), X \= Y.

brother(X, Brother):-
  sibling(X, Brother), male(Brother).

sister(X, Brother):-
  sibling(X, Brother), female(Brother).

aunt(X, Aunt):-
  parent(Parent, X), sister(Parent, Aunt).

aunt(X, Aunt):-
  parent(Parent, X), sibling(Parent, Sibling), married(Sibling, Aunt), female(Aunt).
other(Parent, Uncle).

uncle(X, Uncle):-
  parent(Parent, X), sibling(Parent, Sibling), married(Sibling, Uncle), male(Uncle).

cousine(X, Cousine):-
  parent(Parent, X), sibling(Parent, Sibling), parent(Sibling, Cousine).

grandparent(X, GrandParent):-
  parent(Y, X), parent(GrandPare
uncle(X, Uncle):-
  parent(Parent, X), brnt, Y).

ansestor(Ansestor, Ancestry):-
  parent(Ansestor, Ancestry).

ansestor(Ansestor, Ancestry):-
  parent(X, Ancestry),
  ansestor(Ansestor, X).

descendant(Descendant, Ansestor):-
  parent(Ansestor, Descendant).

descendant(Descendant, Ansestor):-
  parent(Ansestor, X),
  descendant(Descendant, X).
