Extension { #name : #PRContext }

{ #category : #'*pier-seaside-accessing' }
PRContext >> application [
	"Answer the cached seaside application, this is a short-cut to avoid to unnecessary lookups."

	^ self propertyAt: #application ifAbsentPut: [ 
		(self requestContextIfNilDo: [ ^ nil ]) application ]
]

{ #category : #'*pier-seaside-accessing' }
PRContext >> components [
	^ self componentDictionary values
]

{ #category : #'*pier-seaside-accessing' }
PRContext >> requestContext [
	^ WACurrentRequestContext value
]

{ #category : #'*pier-seaside-accessing' }
PRContext >> requestContextIfNilDo: aBlock [
	^ [ WACurrentRequestContext value ]
		on: WARequestContextNotFound
		do: [ :e | aBlock value ]
]

{ #category : #'*pier-seaside-accessing' }
PRContext >> session [
	"Answer the cached seaside session, this is a short-cut to avoid to unnecessary lookups."

	^ self propertyAt: #session ifAbsentPut: [
		(self requestContextIfNilDo: [ ^ nil ]) session ]
]

{ #category : #'*pier-seaside-accessing' }
PRContext >> views [
	"Answer a list of possible views, dispatching trough the command class."

	^ PRViewComponent withAllConcreteClasses
		select: [ :each | each isValidIn: self ]
]
