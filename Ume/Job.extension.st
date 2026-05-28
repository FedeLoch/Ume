Extension { #name : 'Job' }

{ #category : '*Ume' }
Job >> updateProgress: aProgress forTests: tests iteration: iteration [
	
	self 
		progress: ( aProgress );
		title: 'Running Ume Campaign... (', (aProgress * 100) rounded asString , '%)', String cr,
		'Iteration: ', iteration asString, ' Found: ', tests size asString.
]
