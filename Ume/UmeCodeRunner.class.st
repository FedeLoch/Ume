Class {
	#name : 'UmeCodeRunner',
	#superclass : 'Object',
	#category : 'Ume-PerfUme Experimentation',
	#package : 'Ume',
	#tag : 'PerfUme Experimentation'
}

{ #category : 'running' }
UmeCodeRunner class >> run: code [
	
	^ OpalCompiler new evaluate: code	
]
