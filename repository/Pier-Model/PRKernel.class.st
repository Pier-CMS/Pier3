"
I am the kernel of Pier. Several instances of myself might exist at the same time, but they all exist independently and don't share any data. I know the root structure and the persistency strategy of the whole data-model. Moreover I prevent any concurrent modifications to the model by providing a global mutex.
"
Class {
	#name : #PRKernel,
	#superclass : #PRObject,
	#instVars : [
		'name',
		'root',
		'persistency'
	],
	#classInstVars : [
		'instances'
	],
	#category : #'Pier-Model-Kernel'
}

{ #category : #configuration }
PRKernel class >> defaultInfo [
	^ (PRPage named: 'information')
		addChild: self defaultInfoIntroduction;
		addChild: self defaultInfoSyntax;
		addChild: self defaultInfoLicense;
		contents: '*value:children|link*';
		yourself
]

{ #category : #configuration }
PRKernel class >> defaultInfoIntroduction [
	^ (PRPage named: 'introduction')
		contents: 'Pier is a powerful and extensible implementation of a meta-described content management and Wiki system, written with objects from top to bottom:

-''''Object-Oriented Design:'''' Pier features a fully object oriented and meta-described domain model built using Magritte. The content of the pages is parsed and stored as a tree of different entities representing text, links, tables, lists, formattings, etc.
-''''Extensibility:'''' Everything in Pier can be extended: page types, storage mechanism, actions, security mechanism, web-server, etc. Plug-ins can be shared within the community and loaded independently of each other into the system.
-''''Open Source:'''' Pier is released under the MIT license which grants unrestricted rights to copy, modify, and redistribute as long as the original copyright and license terms are retained.
-''''Test Suites:'''' Pier is heavily tested. There are more than 1200 unit tests included with the core of Pier. This makes it easy to change and verify the code and comes in extremely useful when porting Pier to other Smalltalk dialects or when writing extensions.

Up to date information about *Pier>http://www.piercms.com* and *Magritte>http://www.lukas-renggli.ch/smalltalk/magritte* can be obtained through their respective web sites.

!Development
- *Code Repository>http://source.lukas-renggli.ch/pier.html*
- *Issue Tracker>http://code.google.com/p/pier/*

!Mailing-Lists
- *Magritte, Pier and Related Tools>https://www.iam.unibe.ch/mailman/listinfo/smallwiki*
- *Seaside>http://lists.squeakfoundation.org/cgi-bin/mailman/listinfo/seaside*

!Documentation
- *Magritte -- Meta-Described Web Application Development>http://www.iam.unibe.ch/~scg/Archive/Diploma/Reng06a.pdf* (Chapter 3)';
		yourself
]

{ #category : #configuration }
PRKernel class >> defaultInfoLicense [
	^ (PRPage named: 'license')
		contents: '!' , PRBasicObject pierLicense;
		yourself
]

{ #category : #configuration }
PRKernel class >> defaultInfoSyntax [
	^ (PRPage named: 'syntax')
		contents:
			'*value:toc*
!Paragraphs
A single newline has no effect on the layout. An empty line starts a new paragraph.
An annotated paragraph starts a line with ==\@\@==, for example:

 ==\@\@==quote this is a quote annotation.

@@quote this is a quote annotation.

 ==\@\@==note this is a note annotation.

@@note this is a note annotation.

!Sections
A line starting with ==!== becomes a section heading.
!!Subsection
Use multiple ==!== to create a subsection.

!Horizontal Line
A line starting with ==_== (underline) becomes a horizontal line. This is often used to separate topics.
_
!Lists
Lines starting with ==#==, ==-==, ==;== or ==:== create a list:
-A block of lines, where each line starts with ==-== is transformed to a bulleted list, where each line is an entry.
-A block of lines, where each line starts with ==#== is transformed to an ordered list, where each line is an entry.
-A block of lines, where each line starts with ==;== or ==:== is transformed to a definition list, where the keyword is prepended with ==;== and the definition with ==:==. Keywords and definitions can be mixed arbitrary.
Lists can also be nested. Thus, a line starting with ==#-== is an element of a bulleted list that is part of an ordered list.

!Tables
To create a table, start off the lines with ==|== and separate the elements with ==|==s. Each new line represents a new row of the table. The contents of cells can be aligned left, centered or aligned right by using ==|{==, ==||== or ==|}== respectively. Add a single ==!== to let the cell become a table heading.

!Preformatted
To create a preformatted section, begin each line with ==\===. A preformatted section uses equally spaced text so that spacing is preserved.

!Formatting
There is some sugar for font formatting:
-To make something ""bold"", surround it with ==\"\"==
-To make something ''''italic'''', surround it with ==\''\''==
-To make something ==monospaced==, surround it with ==\=\===
-To make something --strikethrough--, surround it with ==\-\-==
-To make something @@subscript@@, surround it with ==\@\@==
-To make something ^^superscript^^, surround it with ==\^\^==
-To make something __underlined__, surround it with ==\_\_==

!Verbatim
If you want to include verbatim text (i.e. markup) into a page you must enclose it in ==\{{{== and ==\}}}==, otherwise Pier ensures that all text appears as you type it. For example: ==<i>italic</i>== appears as is, but ==\{{{html: <i>italic</i>\}}}== appears as {{{html: <i>italic</i>}}} text if displayed using HTML.

!Links
To create a link, put it between ==\*==. All links have the following form ==\*reference\*==, or ==\*alias>reference|parameters\*== for the complete form. The ''''reference'''' depends on the kind of link that is created (see below). The ''''alias'''' is a string being used as the text of the link, if left out a default is used. The ''''parameters'''' are optional parameters to further configure the behavior on the link, again this depends on the kind of link you create. The contents of some links, e.g. links pointing to image-files, downloads or other pages, can be embedded into the current document by adding the parameter: ==embedded=true==.  For example: ==\*reference|embedded=true\*==.  Not all types of links support embedding and quietly ignore it.

!!Internal Links
If a structure with the given name exists, a link to that item shows up when the page is saved. In case the path points to an non-existing structure, the user will be offered the possibility to create a new one when clicking on the link. The reference can be an absolute (==/information/license==) or relative (==../license==) path. The parameters ==command== and ==view== are supported to create specific links onto commands and views of the target page.

!!External Links
-If the link is an URL (e.g. ==\*http://www.lukas-renggli.ch\*==), a link to the external page shows up.
-If the link is an e-mail address (e.g. ==\*renggli@gmail.com\*==), a link to mail that person shows up.

!!Value Links
To add dynamic content to a page use a value link. For example, the expression ==\*value:date\*== adds the current date ==*value:date*==. Some values might be undefined at certain points, in this case the alias of the link is displayed instead. For example, the expression ==\*untouched>value:edited|display=date\*== displays the date of the last edit operation, or ==untouched== if the current page has never been edited. There is a wide variety of possible expression available:

	*value:values*
	
The expressions that work on structures (==children==, ==parent==, ==structure== ...) support a wide variety of ==display== parameters, for example ==title==, ==name==, ==tags==, ==menu==, ==owner==, ==group==, that is any structure property with a magritte description that defines ==parameterName== eg for ==PRPage== the available properties are defined by evaluating:
=PRPage new magritteDescription children 
=	select: [ :each | each parameterName notNil ] 
=	thenCollect: [ :each | each parameterName ]
All value expressions that work on structures can be combined like ==\*value:structure|display={title} is owned by {owner}\*==. Furthermore these expressions become an internal link if you add the parameter ==link==.  By default all value links are embedded. The expressions on contexts (==context== and ==edited==) also support ==display== parameters, namely ==date==, ==time== and ==user==, for example: ==\*value:edited|display=date\*==
!!Example Embedded Link to the License
This text:
= */information/license|embedded=true*
is displayed as:
*/information/license|embedded=true*
';
		yourself
]

{ #category : #configuration }
PRKernel class >> defaultRoot [
	^ (PRPage named: 'pier')
		addChild: self defaultInfo;
		contents: 'Welcome to Pier, the next generation of a fully extensible content management system implemented in Smalltalk. To read additional information, please consult the *information page>information* or go to the official Pier *web site>http://www.piercms.com*.';
		yourself
]

{ #category : #accessing }
PRKernel class >> instanceNamed: aString [
	"Answer a kernel named aString, create a new one if none exists."

	^ self instances 
		detect: [ :each | each name = aString ]
		ifNone: [ self named: aString ]
]

{ #category : #accessing }
PRKernel class >> instances [
	"Answer the registered kernel instances."

	^ instances ifNil: [ instances := Set new ]
]

{ #category : #testing }
PRKernel class >> isAbstract [
	^ false
]

{ #category : #'instance creation' }
PRKernel class >> named: aString [
	"Create a new kernel with the name aString."

	^ self named: aString root: self defaultRoot
]

{ #category : #'instance creation' }
PRKernel class >> named: aString root: aStructure [
	"Create a new kernel named aString with the root aStructure."

	^ self instances add: (self new
		name: aString;
		root: aStructure;
		yourself)
]

{ #category : #'instance creation' }
PRKernel class >> remove: aString [
	" Removes a new kernel with the name aString."
	| inst |
	inst := self instances 
		detect: [ :each | each name = aString ]
		ifNone: [ ^nil ].
	self instances remove: inst ifAbsent: [  ].
	^inst
]

{ #category : #private }
PRKernel class >> reset [
	"This method is for development and testing purpose only, you should not call it directly unless you want to loose your wiki-kernels."

	instances := nil
]

{ #category : #configuration }
PRKernel >> defaultName [
	^ 'Pier'
]

{ #category : #configuration }
PRKernel >> defaultPersistency [
	^ PRHistoryPersistency new
]

{ #category : #'accessing-description' }
PRKernel >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'name';
		accessor: #name;
		label: 'Name';
		priority: 100;
		beRequired;
		yourself
]

{ #category : #initialization }
PRKernel >> initialize [
	super initialize.
	self name: self defaultName.
	self persistency: self defaultPersistency
]

{ #category : #accessing }
PRKernel >> name [
	"Answer the name of the kernel."

	^ name
]

{ #category : #accessing }
PRKernel >> name: aString [
	name := aString
]

{ #category : #accessing }
PRKernel >> persistency [
	"Answer the persistency strategy of the receiver."

	^ persistency
]

{ #category : #accessing }
PRKernel >> persistency: aPersistency [
	| replacement |
	replacement := aPersistency 
		ifNil: [ PRNullPersistency new ].
	replacement setKernel: self.
	persistency isNil
		ifFalse: [ persistency setKernel: nil ].
	persistency := replacement
]

{ #category : #printing }
PRKernel >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' name: '; print: self name
]

{ #category : #accessing }
PRKernel >> root [
	"Answer the root structure of the kernel."

	^ root
]

{ #category : #accessing }
PRKernel >> root: aStructure [
	root := aStructure
]
