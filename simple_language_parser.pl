determiner([the|X]-X).
determiner(['a'|X]-X).

noun([dog|X]-X).
noun([bone|X]-X).
noun([mouse|X]-X).
noun([cat|X]-X).

verb([ate|X]-X).
verb([chases|X]-X).

adjective([big|X]-X).
adjective([brown|X]-X).
adjective([lazy|X]-X).


sentence(Sentence):-
  nounphrase(Sentence-RestOfSentence),
  verbphrase(RestOfSentence-[]),
  !.

nounphrase(Phrase-OtherWords):-
  determiner(Phrase-S1),
  nounexpression(S1-OtherWords).
nounphrase(Phrase-OtherWords):-
  nounexpression(Phrase-OtherWords).

nounexpression(NE-X):-
  noun(NE-X).
nounexpression(NE-X):-
  adjective(NE-S1),
  nounexpression(S1-X).


verbphrase(VP-X):-
  verb(VP-S1),
  nounphrase(S1-X).
