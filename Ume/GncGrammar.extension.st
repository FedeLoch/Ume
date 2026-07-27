Extension { #name : 'GncGrammar' }

{ #category : '*Ume' }
GncGrammar >> to_pnf [
	"Convert this grammar to PNF (Greibach Normal Form).
	 Every production rule will be of the form A -> aα where
	 a is a terminal and α is a (possibly empty) sequence of non-terminals."

	^ UmePNFConverter new convertGrammar: self
]
