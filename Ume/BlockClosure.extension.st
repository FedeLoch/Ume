Extension { #name : 'BlockClosure' }

{ #category : '*Ume' }
BlockClosure >> satisfiesReceiver: aReceiver args: anArgs result: aResult [

    ^ self value: aReceiver value: anArgs value: aResult
]
