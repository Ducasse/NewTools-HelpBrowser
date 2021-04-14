Class {
	#name : #MicrodownisedHelp,
	#superclass : #Object,
	#category : #'NewTools-HelpBrowser-tomoveBackInHelp'
}

{ #category : #conversion }
MicrodownisedHelp class >> asHelpTopic [ 
	<newSystemHelp>
	
	^ MicrodownStyleHelpBuilder new build topicToBuild
]
