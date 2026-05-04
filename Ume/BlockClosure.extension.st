Extension { #name : 'BlockClosure' }

{ #category : '*Ume' }
BlockClosure >> satisfies: aReceiver args: anArgs result: aResult [

    ^ self value: aReceiver value: anArgs value: aResult
]
