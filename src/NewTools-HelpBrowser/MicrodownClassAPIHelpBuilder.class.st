"
A builder to build the API Help for a class. 
The builder can be parametised as follows: 
-	addMethods:	<Boolean> When true the builder will include method help
-	addSubclasses:	 <Boolean> When true the builder will recursively go through and add subclasses
-	subclassesAsSeparateTopic: <Boolean> When true subclasses are managed as separated topics. 


"
Class {
	#name : #MicrodownClassAPIHelpBuilder,
	#superclass : #HelpBuilder,
	#instVars : [
		'showMethods',
		'showMethodsWithoutComment',
		'showSubclasses',
		'showSubclassesAsSeparateTopic'
	],
	#category : #'NewTools-HelpBrowser-TobeMovedIntoHelp'
}

{ #category : #building }
MicrodownClassAPIHelpBuilder class >> buildHierarchicalHelpTopicFrom: aClass withSubclasses: aBoolean withMethods: anotherBoolean [
	"Start building from the given class"
	
	^ self new
			showSubclasses: aBoolean; 
			showMethods: anotherBoolean;
			rootToBuildFrom: aClass;
			build;
			topicToBuild 
]

{ #category : #building }
MicrodownClassAPIHelpBuilder >> build [
	| builder |
	builder := MicroDownParser builder.
	topicToBuild := HelpTopic named: rootToBuildFrom name.
	topicToBuild iconName: #pageIcon.
	rootToBuildFrom buildMicroDownUsing: builder withComment: rootToBuildFrom comment.
	topicToBuild contents: builder contents.
		
	showMethods
		ifTrue: [ self buildSubnodesForMethods ].
	showSubclasses
		ifTrue: [ self buildSubnodesForSubclasses ]
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildMethodTopicsOn: topic for: aClass [

	|stream methodComment|
	stream := String new writeStream.
	aClass selectors asSortedCollection do: [:selector | 
		methodComment := (aClass>>selector) comment.
		showMethodsWithoutComment | methodComment notNil ifTrue: [ 
			stream 
				nextPutAll: '`';
				nextPutAll: aClass name;
				nextPutAll: '>>#';
				nextPutAll: selector asString;
				nextPutAll: '`';
				cr.		

		methodComment ifNil: [ methodComment := 'Method has no comment.' ].
		stream nextPutAll: '_"'; nextPutAll: methodComment; nextPutAll: '"_';cr;cr ] ].
	
	topic contents: stream contents.
	
	
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildSubclassTopicFor: aSubclass [
	 
	^ self class new 
			rootToBuildFrom: aSubclass;
			showSubclasses: showSubclasses;
			showMethods: showMethods;
			showSubclassesAsSeparateTopic: showSubclassesAsSeparateTopic;
			build;
			topicToBuild 
	 
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildSubnodesForMethods [
	| instanceSide classSide |
	instanceSide := HelpTopic named: 'Instance side'.
	classSide := HelpTopic named: 'Class side'.
	topicToBuild iconName: #bookIcon.
	topicToBuild
		addSubtopic: instanceSide;
		addSubtopic: classSide.
	self buildMethodTopicsOn: instanceSide for: rootToBuildFrom.
	self buildMethodTopicsOn: classSide for: rootToBuildFrom class
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildSubnodesForSubclasses [
	| topic |
	rootToBuildFrom subclasses isEmpty
		ifTrue: [ ^ self ].
	topicToBuild iconName: #bookIcon.
	topic := showSubclassesAsSeparateTopic
		ifTrue: [ topicToBuild addSubtopic: (HelpTopic named: 'Subclasses') ]
		ifFalse: [ topicToBuild ].
	rootToBuildFrom subclasses
		do:
			[ :subclass | topic addSubtopic: (self buildSubclassTopicFor: subclass) ].
	topic sortSubtopicsByTitle
]

{ #category : #initialization }
MicrodownClassAPIHelpBuilder >> initialize [
	"Initializes the receiver"
	
	super initialize.
	showSubclasses := false.
	showMethods := true.
	showSubclassesAsSeparateTopic := true.
	showMethodsWithoutComment := true.
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showMethods [
	^ showMethods
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showMethods: aBoolean [
	showMethods := aBoolean
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showMethodsWithoutComment [
	^ showMethodsWithoutComment
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showMethodsWithoutComment: aBoolean [
	showMethodsWithoutComment := aBoolean
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showSubclasses [
	^ showSubclasses
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showSubclasses: aBoolean [
	showSubclasses := aBoolean
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showSubclassesAsSeparateTopic [
	^ showSubclassesAsSeparateTopic
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> showSubclassesAsSeparateTopic: aBoolean [
	showSubclassesAsSeparateTopic := aBoolean
]
