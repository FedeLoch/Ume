Extension { #name : 'Duration' }

{ #category : '*Ume' }
Duration >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeString: (self humanReadablePrintString)
]
