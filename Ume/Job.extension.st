Extension { #name : 'Job' }

{ #category : '*Ume' }
Job >> updateProgress: aProgress [
	
	self 
		progress: ( aProgress );
		title: 'Running Ume Campaign... (', (aProgress * 100) rounded asString , '%)'.
]
