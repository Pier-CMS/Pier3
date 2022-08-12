Class {
	#name : #PRKernelCodeExporter,
	#superclass : #GRObject,
	#instVars : [
		'exportedMethods',
		'recursiveMethods',
		'standardPermissions',
		'standardOtherPermissions',
		'isPier3',
		'dispatcherPathName',
		'exportHelper',
		'rootOwnerPermissions'
	],
	#classInstVars : [
		'baseDirectory'
	],
	#category : #'Pier-Exporter-Code'
}

{ #category : #accessing }
PRKernelCodeExporter class >> baseDirectory [
	^baseDirectory ifNil: [ ^baseDirectory := FileSystem disk workingDirectory ]
]

{ #category : #accessing }
PRKernelCodeExporter class >> baseDirectory: aFolder [
	^baseDirectory := aFolder asFileReference
]

{ #category : #'instance creation' }
PRKernelCodeExporter class >> exportAsPier1or2Kernel: kernelOrPierDispatchPath [
	^ self new
		setOldPRComponentGeneration;
		exportWithPierKernelOrDispatchPath: kernelOrPierDispatchPath;
		yourself
]

{ #category : #'instance creation' }
PRKernelCodeExporter class >> exportAsPier3Kernel: kernelOrPierDispatchPath [
	^ self new
		setPrototypePRComponentGeneration;
		exportWithPierKernelOrDispatchPath: kernelOrPierDispatchPath;
		yourself
]

{ #category : #exporting }
PRKernelCodeExporter >> addDispatcherPathNameOn: component [
	| method |
	method := String streamContents: [ :stream |
		stream << 'dispatcherPathName' << String cr <<
			'	^ ' << dispatcherPathName asCode ].
	self compile: method into: component classified: #constants

]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> addKernelGroups: kernel to: component [
	| method |
	method := String streamContents: [ :stream |
		stream << 'addGroupsToKernel: aKernel' << String cr <<
			'	aKernel propertyAt: #groups put:' << String cr <<
			' 		(Set new' << String cr. 
		kernel groups do: [ :group |
			stream << '			add: '.
			self writeGroup: group on: stream ]. 
	stream << '			yourself).' << String cr.
	stream << '	aKernel propertyAt: #adminGroup put: (aKernel groupNamed: ''' << kernel adminGroup name << ''' ifNone: nil)' << String cr ].
	self compileMethod: method intoComponent: component
]

{ #category : #exporting }
PRKernelCodeExporter >> addKernelNameAccessorMethod: aKernel forComponent: component [
	| method |
	method := String streamContents: [ :stream |
		stream << 'kernelName' << String cr <<
			'	^ ' << aKernel name asCode ].
	self compile: method into: component classified: #constants
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> addKernelUsers: kernel to: component [
	| method |
	method := String streamContents: [ :stream |
		stream << 'addUsersToKernel: aKernel' << String cr <<
			'	aKernel propertyAt: #users put: (Set new' << String cr. 
		kernel users do: [ :user |
			stream << '		add: '.
			self writeUser: user on: stream ]. 
	stream << '		yourself).' << String cr.
	stream << 
		'	aKernel propertyAt: #adminUser put: (aKernel userNamed: ''' << kernel adminUser name << ''' ifNone: nil)' << String cr ].
	self compileMethod: method intoComponent: component
	

]

{ #category : #exporting }
PRKernelCodeExporter >> addRootAccessorMethodOn: component [
	| method |
	method := String streamContents: [ :stream |
		stream << 'root' << String cr <<
			'	^ root' ].
	self compileMethod: method intoComponent: component
]

{ #category : #accessing }
PRKernelCodeExporter >> baseDirectory [
	^self class baseDirectory
]

{ #category : #helpers }
PRKernelCodeExporter >> canSave [
	"only implemented with FileSystem, otherwise just use Monticello"
	^Smalltalk includesKey: #FileSystem
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> checkRootOwnerPermissionsMatchDefault: rootComponent [
	rootOwnerPermissions :=  rootComponent securityDecoration ownerPermissions.
	self standardPermissions =  rootOwnerPermissions ifFalse: [
		Transcript 
			show: 'Root permissions are not the same as the standard permissions. Difference:'; cr; 
			show: (self standardPermissions difference: rootOwnerPermissions) greaseString; cr;
			show: 'Will compare each structures permissions against root permissions as well as standard permissions and only write permissions set if there is a difference' ]
]

{ #category : #helpers }
PRKernelCodeExporter >> checkStreamPipeOperatorExists [
	"some old images dont have WriteStream>>#<< so we add it here - was faster than changing all the code "
	(WriteStream includesSelector: #<<) ifFalse: [
		self compile: '<< aCollection
	| newEnd |
	collection class == aCollection class ifFalse:
		[ aCollection putOn: self. ^ self ].

	newEnd := position + aCollection size.
	newEnd > writeLimit ifTrue:
		[self growTo: newEnd + 10].

	collection replaceFrom: position+1 to: newEnd  with: aCollection startingAt: 1.
	position := newEnd.' into: WriteStream classified: '*pier-exporter-code' ]
]

{ #category : #exporting }
PRKernelCodeExporter >> compile: aString into: aClass classified: classificationSymbol [
	GRPlatform current 
		compile: aString
		into: aClass
		classified: classificationSymbol

]

{ #category : #exporting }
PRKernelCodeExporter >> compileMethod: method intoComponent: component [
	self compile: method into: component classified: #'exported code'




]

{ #category : #exporting }
PRKernelCodeExporter >> compileMethods: methods intoComponent: component [
	methods do: [ :method |
		self compileMethod: method intoComponent: component ]



]

{ #category : #exporting }
PRKernelCodeExporter >> createClassFor: kernel [ 
	^ self createClassFor: kernel instanceVariableNames: 'root'
]

{ #category : #exporting }
PRKernelCodeExporter >> createClassFor: kernel instanceVariableNames: instanceVariableNames [
	^ PRKernelCreatorBase
		subclass: ('PRKernelCreatorFor', ((self selectorFromName: kernel name) capitalized))  asSymbol
		instanceVariableNames: instanceVariableNames
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Pier-Exported-Code'
]

{ #category : #accessing }
PRKernelCodeExporter >> dispatcherPathName [
	dispatcherPathName ifNil: [ dispatcherPathName := self kernelName ]
]

{ #category : #accessing }
PRKernelCodeExporter >> exportHelper [
	^ exportHelper
]

{ #category : #accessing }
PRKernelCodeExporter >> exportHelper: anObject [
	exportHelper := anObject
]

{ #category : #exporting }
PRKernelCodeExporter >> exportKernel: kernel [
	| component rootComponent |
	
	self checkStreamPipeOperatorExists.
	
	component := self createClassFor: kernel.
	self addKernelNameAccessorMethod: kernel forComponent: component.
	self addDispatcherPathNameOn: component.
	self addRootAccessorMethodOn: component.

	self addKernelGroups: kernel to: component.
	self addKernelUsers: kernel to: component.
	
	rootComponent := kernel root.
	
	self compile: (self rootTemplate: rootComponent)
		into: component
		classified: #'exported code'.
		
	self checkRootOwnerPermissionsMatchDefault: rootComponent.
		
	rootComponent enumerator with all do: [ :structure |
		| methods |
		methods := self writeCodeFor: structure.
		self compileMethods: methods intoComponent: component ].
	
	self rewriteRecursiveMethodsFor: kernel
]

{ #category : #exporting }
PRKernelCodeExporter >> exportWithPierKernelOrDispatchPath: kernelOrPierDispatchPath [
	self exportWithPierKernelOrDispatchPath: kernelOrPierDispatchPath save: self canSave
]

{ #category : #exporting }
PRKernelCodeExporter >> exportWithPierKernelOrDispatchPath: kernelOrPierDispatchPath save: aBoolean [
	| kernel |
	kernel := kernelOrPierDispatchPath isString
		ifTrue: [ dispatcherPathName := kernelOrPierDispatchPath.
			self kernelFromDispatcherConfiguration: dispatcherPathName ]
		ifFalse: [ dispatcherPathName := self
				selectorFromName: kernelOrPierDispatchPath name.
			kernelOrPierDispatchPath ].
	kernel isNil
		ifTrue: [ Error
				signal: 'Not Found, kernel or dispatcher named: ' , dispatcherPathName ].
	self preExportKernel: kernel.
	self exportKernel: kernel.
	aBoolean
		ifTrue: [ self saveExportFor: kernel ]
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> ifPermissions: aPermissionSet differFromStandard: aBlock [
	((aPermissionSet = self standardPermissions) or: [ aPermissionSet = self rootOwnerPermissions ]) ifFalse: [
		| permissionDifference |
		permissionDifference := (self rootOwnerPermissions difference: aPermissionSet) greaseString.
		aBlock value: permissionDifference ]
]

{ #category : #initialization }
PRKernelCodeExporter >> initialize [
 	super initialize.
	
	exportedMethods := Set new.
	recursiveMethods := Set new
]

{ #category : #helpers }
PRKernelCodeExporter >> isPier1 [
	^ (Smalltalk at: #WAEntryPoint ifAbsent: [ ]) notNil
]

{ #category : #helpers }
PRKernelCodeExporter >> isPier3 [
	^ isPier3 ifNil: [
		isPier3 := (Smalltalk at: #MAPragmaBuilder ifAbsent: [ ]) notNil ]
]

{ #category : #helpers }
PRKernelCodeExporter >> kernelFromDispatcherConfiguration: dispatcherPath [
	^ self isPier1 
		ifTrue: [ (WADispatcher default entryPointAt: dispatcherPath) configuration valueAt: #kernel ]
		ifFalse: [ 
			| handler |
			handler := WADispatcher default handlerAt: dispatcherPath ifAbsent: nil.
			handler isNil
				ifTrue: [ nil ]
				ifFalse: [ handler configuration at: #kernel ] ]
]

{ #category : #helpers }
PRKernelCodeExporter >> magritteSelector [
	^ self isPier3  
		ifTrue: [ #magritteDescription ]
		ifFalse: [ #description ]
]

{ #category : #exporting }
PRKernelCodeExporter >> preExportKernel: aKernel [
	"Change the old Pier to prevent import problems - first modify *..* links to absolute paths"

	aKernel root enumerator
		all;
		do: [ :page | 
			page outgoingReferences
				do: [ :link | 
					(link isInternal
						and: [ link target ~~ page and: [ page parents includes: link target ] ])
						ifTrue: [ link reference: link target absolutePath ] ] ]
]

{ #category : #exporting }
PRKernelCodeExporter >> rewriteRecursiveMethodsFor: kernel [
	| instanceVariables component |
	instanceVariables := String streamContents: [ :stream |
		stream << 'root '.
		recursiveMethods do: [ :each | 
			stream nextPutAll: each ]
			separatedBy: [ stream nextPut: Character space ] ].
		
	component := self createClassFor: kernel instanceVariableNames: instanceVariables.
	
	"this is somewhat hacky - we rewrite reentrant component creation methods with lazy initialiser.
	A two pass generator would remove the need for this hack - but would be more complex. "
	recursiveMethods do: [ :each | 
		| method existingMethodStream |
		existingMethodStream := (component sourceCodeAt: (each, ':') asSymbol) greaseString readStream.
		existingMethodStream nextLine; nextLine.
		method := String streamContents: [ :stream |
			stream 
				<<  each << ': aKernel' << String cr
				<< '	 ^ ' << each << ' ifNil: [ ' << String cr
				<< '		| structure |' << String cr
				<< '	' << (existingMethodStream nextLine) greaseString << String cr
				<< '		' << each << ' := structure.' << String cr
				<< (existingMethodStream upToAll: '	^ structure') greaseString	
				<< '		' << each << ' ]' ].
				
		self compileMethod: method intoComponent: component ]
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> rootOwnerPermissions [
	^ rootOwnerPermissions
]

{ #category : #exporting }
PRKernelCodeExporter >> rootTemplate: rootComponent [
	^ String streamContents: [ :stream | 
		stream << 'root: aKernel
	^ root ifNil: [
		root := self ' << (rootComponent asSelector) << ': aKernel ]' ]
]

{ #category : #exporting }
PRKernelCodeExporter >> saveExportFor: aKernel [
	| folder |
	folder := self baseDirectory / aKernel name.
	(folder respondsTo: #ensureCreateDirectory) ifTrue: [ 
		folder ensureCreateDirectory ]
	ifFalse: [  
		folder ensureDirectory].
	" use filetree if possible "
	(Smalltalk at: #MCFileTreeRepository ifAbsent: [ nil ])
		ifNil: [ 
			Gofer new 
				directory: folder fullName;
				package: 'Pier-Exported-Code';
				commit: 'Automatic save from Pier-Exporter' ]
		ifNotNil: [
			Gofer new 
				url: ('filetree://', folder fullName);
				package: 'Pier-Exported-Code';
				commit: 'Automatic save from Pier-Exporter' ]
]

{ #category : #helpers }
PRKernelCodeExporter >> selectorFromName: aName [
	| selector |
	selector := aName select: [ :each | each isAlphaNumeric ].
	[ selector first isDigit ]
		whileTrue: [ selector := selector allButFirst ].
		
	selector at: 1 put: selector first asLowercase.
		
	^ selector asSymbol
]

{ #category : #initialization }
PRKernelCodeExporter >> setOldPRComponentGeneration [
	self exportHelper: (PRPier1or2ToPier1or2ExportHelper recursiveMethods: recursiveMethods)
]

{ #category : #initialization }
PRKernelCodeExporter >> setPrototypePRComponentGeneration [
	self exportHelper: (self isPier3 
		ifTrue: [ PRPier3ToPier3ExportHelper recursiveMethods: recursiveMethods ]
		ifFalse: [ PRPier1or2ToPier3ExportHelper recursiveMethods: recursiveMethods ])
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> standardOtherPermissions [
	^ standardOtherPermissions ifNil: [
		standardOtherPermissions := PUSecurity new otherPermissions ]
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> standardPermissions [
	^ standardPermissions ifNil: [
		standardPermissions :=  PUSecurity new ownerPermissions ]
]

{ #category : #accessing }
PRKernelCodeExporter >> writeCodeFor: structure [
	| methods method codeBuilder selector |
	selector := structure asSelector.
	
	"recursion guard"
	(exportedMethods includes: selector)
		ifTrue: [ recursiveMethods add: selector. ^ #() ]
		ifFalse: [ exportedMethods add: selector ].
	
	methods := OrderedCollection new.
	
	method :=  String streamContents: [ :stream | 
		stream << selector << ': aKernel' << String cr << 
			'	| structure  |' << String cr <<
			'	structure := ' << structure class greaseString << ' named: ''' << structure name << '''.' << String cr.

		codeBuilder := PRCodeBuilderDescriptionVisitor structure: structure methods: methods exporter: self on: stream.
		(structure perform: self magritteSelector) do: [ :aDescription |
			codeBuilder visit: aDescription ].
		
		structure class name = #PRComponent ifTrue: [ self exportHelper handlerPRComponent: structure initialisationOn: stream ].
		
		structure enumerator size > 2 
			ifTrue: [
				stream << '	#('.
				structure enumerator do: [ :each | stream << '	#''' << (each asSelector) << ':''' ] separatedBy: [ stream cr ].
				stream << ' ) do: [ :each | ' << String cr << '	structure addChild: (self perform: each with: aKernel) ].' << String cr ]
			ifFalse: [ 
				structure enumerator do: [ :each | 
					stream << '	structure addChild: (self ' << (each asSelector) << ': aKernel).' ] ].

		self writeOwnershipAndSecurityCodeFor: structure on: stream.
		
		stream <<'	^ structure' ].
	
	methods add: method.
	^ methods
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> writeGroup: group on: stream [
	stream << '(PUGroup named: ''' << group name << ''');' << String cr
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> writeOwnershipAndSecurityCodeFor: structure on: stream [
	| securityDecoration |
	securityDecoration := structure securityDecoration.
	
	securityDecoration owner notNil ifTrue: [	
		stream nextPut: Character cr.	
		stream << '	structure securityDecoration owner: (aKernel userNamed: ''' << structure securityDecoration owner name << ''' ifNone: nil).' << String cr.
		self ifPermissions: securityDecoration ownerPermissions differFromStandard: [ :difference |
			stream << '	"difference: ' << difference << '"' << String cr.
			stream << '	structure securityDecoration ownerPermissions: '.
			self writePermissions: securityDecoration ownerPermissions on: stream ] ].
	
	securityDecoration group notNil ifTrue: [	
		stream << '	structure securityDecoration group: (aKernel groupNamed: ''' << structure securityDecoration group name << ''' ifNone: nil).' << String cr.
		self ifPermissions: securityDecoration groupPermissions differFromStandard: [  :difference |
			stream << '	"difference: ' << difference << '"' << String cr.
			stream << '	structure securityDecoration groupPermissions: '.
			self writePermissions: securityDecoration groupPermissions on: stream ] ].

	securityDecoration otherPermissions = self standardOtherPermissions ifFalse: [ 
		stream << '	structure securityDecoration otherPermissions: '.
		self writePermissions: securityDecoration otherPermissions on: stream ]
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> writePermissions: permissions on: stream [
	stream << '(Set withAll: {'.
	permissions do: [ :each |
		(each isKindOf: PUAddPermission) 
			ifTrue: [
				stream << '(PUAddPermission on: ' << each command name << ' structure: ' <<  each structure name << ')' ]
			ifFalse: [
				stream << '(PUPermission on: ' << each command name << ')' ] ] 
		separatedBy: [ stream nextPutAll: '. ' ].
	stream << '}).' << String cr.
]

{ #category : #'exporting - permissions' }
PRKernelCodeExporter >> writeUser: user on: stream [
	stream << '((PUUser named: ''' << user name << ''')' << String cr <<
		'			groups: (OrderedCollection new' << String cr. 
	user groups do: [ :each |
		stream << '				add: (aKernel groupNamed: ''' << each name << ''' ifNone: nil);' << String cr ].
	stream << '				yourself);' << String cr.
	stream << '			instVarNamed: ''password'' put: ' << (user instVarNamed: 'password') asCode << ';' << String cr.
	stream << '			email: '; print: user email; nextPut: $;; nextPut: Character cr.
	stream << '			firstName: '; print: user firstName; nextPut: $;; nextPut: Character cr.
	stream << '			lastName: '; print: user lastName; nextPut: $;; nextPut: Character cr.			
	user superuser ifTrue: [
		stream << '			superuser: true;' << String cr ].
	stream << '			yourself);' << String cr
]
