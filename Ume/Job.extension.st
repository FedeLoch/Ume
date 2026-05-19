Extension { #name : 'Job' }

{ #category : '*Ume' }
Job >> updateProgress: aProgress [
	
	self 
		progress: ( aProgress );
		title: 'Running Ume Campaign... (', (aProgress * 100) rounded asString , '%)'.
]

{ #category : '*Ume' }
Job >> updateProgress: aProgress with: aNumberOfTest [
	
	self 
		progress: ( aProgress );
		title: 'Running Ume Campaign | ', aNumberOfTest asString , ' generated tests | (', (aProgress * 100) rounded asString , '%)'.
]

{ #category : '*Ume' }
Job >> updateProgress: aProgress with: aNumberOfTest saved: aNumberOfSavedTest [
	
	self 
		progress: ( aProgress );
		title: 'Running Ume Campaign | ', aNumberOfTest asString , ' generated tests | ', aNumberOfSavedTest asString , ' saved tests | (', (aProgress * 100) rounded asString , '%)'.
]
