Class {
	#name : #MicrodownisedHelp,
	#superclass : #Object,
	#category : #'NewTools-HelpBrowser-TobeMovedIntoHelp'
}

{ #category : #conversion }
MicrodownisedHelp class >> asHelpTopic [ 
	<newSystemHelp>
	
	^ MicrodownStyleHelpBuilder new build topicToBuild
]
