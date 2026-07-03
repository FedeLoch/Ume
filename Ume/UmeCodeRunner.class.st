Class {
	#name : 'UmeCodeRunner',
	#superclass : 'Object',
	#category : 'Ume-Paper Experimentation',
	#package : 'Ume',
	#tag : 'Paper Experimentation'
}

{ #category : 'running' }
UmeCodeRunner class >> run: code [
	
	^ OpalCompiler new evaluate: code	
]
