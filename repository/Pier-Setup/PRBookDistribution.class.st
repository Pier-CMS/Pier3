Class {
	#name : #PRBookDistribution,
	#superclass : #PRDistribution,
	#instVars : [
		'book',
		'tableOfContents',
		'introduction',
		'tableOfFigures',
		'section',
		'index',
		'notesComponent',
		'bookStylesheetFile'
	],
	#category : #'Pier-Setup'
}

{ #category : #accessing }
PRBookDistribution class >> title [
	^ 'Book'
]

{ #category : #structures }
PRBookDistribution >> book [
	^ book ifNil: [
		book := (BOBook named: 'book')
			contents: 'This is a book';
			yourself
	]
]

{ #category : #structures }
PRBookDistribution >> bookStylesheetFile [
	bookStylesheetFile isNil
		ifFalse: [ ^ bookStylesheetFile ].
	bookStylesheetFile := (PRFile named: 'bookCss')
		filename: 'bookstyle.css';
		mimetype: 'text/css';
		contents: 
'/* ANNOTATIONS */
p.blockquote { padding: 0.8em; margin-left: 2em; margin-bottom: 1em; }
p.todo { color: red; }
p.todo:before { color: red; content: "TODO"; }
p.note { color: blue; border-top: 1px solid #bbb; border-bottom: 1px solid #bbb; padding: 0.8em; padding-left: 0; margin-bottom: 1em}
p.note:before { color: blue; content: "Note"; }
p.todo, p.note {  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; position: relative; }
p.todo:before, p.note:before {left: -20%; width: 18%; text-align: right; position: absolute; }
 
/* === head === */
.head {
	height: 96px;
	text-align: left;
	position: relative;
	background-repeat: repeat-x;
	background-image: url(header.png);
}
.head h1 {
	float: left;
	margin: 0 20px;
	font-size: 20px;
	line-height: 60px;
}
.head h1 a { color: #fff; }
.head .donate { float: right; margin-right: 20px; }
.head .donate form { line-height: 60px; }
.head .donate form input { vertical-align: middle; }
.head .search { float: right; margin-right: 20px; line-height: 60px; }
.head .search input { width: 150px; vertical-align: middle; }
 
/* BODY */
.wrap {
	text-align: left;
	padding-bottom: 2ex;
	background-color: #fff;
}
.body {
	margin: auto 10%;
	text-align: left;
}
 
/* MAIN */
.main {
	float: left;
	width: 62.5%;
	text-align: left;
	position: relative;
}
.main h1.capt span {
	left: -20%;
	width: 18%;
	text-align: right;
	position: absolute;
}
.main div.figure {
	position: relative;
	margin-bottom: 1.6em;
}
.main div.figure img {
	float: none;
	margin: 0 auto;
	display: block;
	max-width: 100%;
	text-align: center;
}
.main div.figure label {
	display: block;
	text-align: center;
	font-weight: normal;
}
.main div.figure label span {font-weight: italic;}

.main .table-of-contents { font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
.main .table-of-contents dl { position: relative; }
.main .table-of-contents dt { width: 30px; position: absolute; }
.main .table-of-contents dd  { padding-left: 40px; }
.main .table-of-contents a.part { font-weight: bold; }
.main .table-of-contents a.section { padding-left: 2em; }
.main .table-of-contents a.subsection { padding-left: 4em; }
 
.main .table-of-figures dl { position: relative; }
.main .table-of-figures dt { width: 30px; position: absolute; text-align: right; }
.main .table-of-figures dd { padding-left: 40px; }
 
.main .keyword-index dl { position: relative; }
.main .keyword-index dt { width: 200px; position: absolute; }
.main .keyword-index dd { padding-left: 220px; }
 
/* --- side --- */
.side {
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; 
	width: 25%;
	float: right;
	text-align: left;
	position: relative;
}
.side dl dt {
	left: -50%;
	width: 45%;
	text-align: right;
	position: absolute;
}
.side p, .side li, .side dd, .side dt { text-align: left; }
 
/* === footers === */
.notes, .admin, .foot { 
	padding: 20px;
	text-align: left;
	background-repeat: repeat-x;
	background-image: url(footer.png);
}
.hidden {
	width: 0px;
	height: 0px;
	left: -1000px;
	position: absolute;
 
}
 
/* --- notes --- */
.notes { font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
.notes h1 { font-size: 1.5em; line-height: 1; margin-bottom: 1em; }
.notes .listing .note { margin-bottom: 1em; }
.notes .listing .note .meta { border-bottom: 1px solid #ddd; margin-bottom: 1em; }
.notes .listing .note .meta .author { font-weight: normal; }
.notes .listing .note .meta .publication { font-size: 80%; }
.notes .listing .note .meta .commands { float: right; }
.notes .listing .note .body { margin: 0; font: 1em ''andale mono'', ''lucida console'', monospace; line-height: 1.5; }
.notes .listing .note .body p { margin: 0; }
.notes .addnote th { width: 120px; }
.notes .addnote textarea { height: 100px; width: 100%; }
.notes .addnote .buttons { margin-left: 130px; }
.notes .addnote .buttons input { margin-right: 1em; }
 
/* --- admin --- */
.admin { font-size: .8em; line-height: 1.875em; color: #555; }
.admin .tool { width: 25%; float: left; }
.admin .tool ul { margin: 0; padding: 0; list-style: none; }
.admin .tool li li { margin-left: 1em; }
.admin .tool li span.button { float: left; width: 1em; }
.admin .tool .active { font-weight: bold; }
 
/* --- foot --- */
.foot { font-size: 0.7em; line-height: 1.765em; padding-bottom: 0;  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
.foot p { text-align: center; }
 
/* === pages === */
body.book h1.capt { display: none; }
body.book img { margin: 0; max-width: 515px; }

/*DEFAULT*/
p, li, dd, dt { text-align: left; }
body { font-size: 90%; background-color: #eee; font-family: Georgia, "Lucida Bright", "Times New Roman", serif;}
table, tr, td, th { margin: 0; border: 0; padding-left: 0; font-weight: bold; }
table { margin-bottom: 1.6em; }
h1, h2, h3, h4, h5, h6 { font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
h1 a, h2 a, h3 a, h4 a, h5 a, h5 a, h6 a { color: #222; text-decoration: none; outline: none; }
h1 a:hover, h2 a:hover, h3 a:hover, h4 a:hover, h5 a:hover, h5 a:hover, h6 a:hover { color: #222; }
pre { padding: 5px; background-color: #eee; -moz-border-radius: 5px; -webkit-border-radius: 5px; }
code, tt { padding: 2px; background-color: #eee; -moz-border-radius: 3px; -webkit-border-radius: 3px; }
h1 { font-size: 2em; line-height: 1; margin-bottom: 0.75em; }
h2 { font-size: 1.5em; line-height: 1; margin-bottom: 1em; }
h3 { font-size: 1.2em; line-height: 1.25; margin-bottom: 1.25em; }
h4 { font-size: 1em; line-height: 1; margin-bottom: 1.5em; }
h5 { font-size: 1em; line-height: 1; }
ins { background: #E6EFC2; color: #264409; }
del { background: #FBE3E4; color: #8a1f11; }
label { font-weight:normal; }

/* PIER */
.errors, .broken { color: red; font-weight: bold;}
.error, .notice, .success { border: none; }
.protected { color: #aaa; }
a {color: #ff6633;}
a:hover {
	color: white;
	background: #ff6633; }
a:hover.nobackground {background: white;}
a.view, a.command {color: gray;}
a.external { background: url(external.png) right center no-repeat; padding-right: 14px; }
a {text-decoration: none;}
.right {text-align: right;}
.left {text-align: left;}
.center {text-align: center;}
tr th {background: #eee; font-weight: normal;}
tr.group th {background: white; font-size: 1em; font-weight: bold; margin-top: 1.5em; }
td.required:after {color: #ff6633; content: "*"; margin-left: 0.5em;}

'.	
	^bookStylesheetFile

]

{ #category : #structures }
PRBookDistribution >> environmentPage [
	^ environmentPage ifNil: [
		environmentPage := (PRPage named: 'environment')
		title: '_Environment';
		contents: 
'{{{<div class="wrap">
  <div class="body">
    <div class="main">
      <h1 class="capt"><span>}}}*>value:structure|display=number*{{{</span>}}}*value:structure|link*{{{</h1>
      }}}+/system/components/contents+{{{
    </div>
    <div class="side">}}}
      *>value:book.parent*
      *>value:book.navigation*{{{
    </div>
    <div class="clear"></div>
  </div>
</div>}}}
+/system/components/notes+{{{
<div class="foot">}}}+/system/components/footer+{{{</div>}}}
+/system/components/googleanalytics+
';
		yourself
	]

]

{ #category : #structures }
PRBookDistribution >> index [
	^ index ifNil: [ index := (BOPortion named: 'index')
		type: #chapter;
		title: 'Keyword index';
		contents: '{{{<div class="keyword-index">}}}*value:book.index|target=/book*{{{</div>}}}';
		numberedTitle: false; 
		yourself ]

]

{ #category : #structures }
PRBookDistribution >> introduction [
	^ introduction ifNil: [ introduction := (BOPortion named: 'introduction')
		type: #chapter;
		contents: 'A book is formed by chapters. This is a chapter.
You can define references like: +ref:section+.

You can define +index:keywords!keywords+ keywords that appear automatically in the keyword index.';
		yourself ]

]

{ #category : #structures }
PRBookDistribution >> mainEnvironmentPage [
"Removed:
		<div class=postticker column prepend-6 span-6 last>
			<h2>What''s new</h2>
			+/system/components/postticker+
			+/system/components/sidebar+
		</div>
"

	^ mainEnvironmentPage ifNil: [
		mainEnvironmentPage := (PRPage named: 'mainenvironment')
		title: '_Main Environment';
		contents: 
'{{{<div class="container">}}}
	+/system/components/header+{{{
	<div class="column span-24 last mainbody">
		<h1 class="heading">}}}*value:structure*{{{</h1>
		<div class="contents column span-12">}}}+/system/components/contents+{{{</div>
	</div>
	}}}+/system/components/footer+{{{
</div>}}}
+/system/components/googleanalytics+
';
		yourself
	]
]

{ #category : #structures }
PRBookDistribution >> menuPage [
	^ menuWidget ifNil: 
		[ menuWidget := (PRPage named: 'menu')
			contents:
'- *Home>/*
- *Book>/book*
- *About>/about*';
			yourself ]
]

{ #category : #structures }
PRBookDistribution >> notesComponent [
	^ notesComponent ifNil: [notesComponent := 
		(PRComponent named: 'notes')
		title: 'Notes';
		prototypeInstance: BONoteWidget new;
		yourself
	]
]

{ #category : #creation }
PRBookDistribution >> root [
	self rootPage
		addChild: (self aboutPage
				addChild: self syntaxPage;
				yourself);
		addChild: (self book
				addChild: self tableOfContents;
				addChild: self tableOfFigures;
				addChild: (self introduction
					addChild: self section;
					yourself);
				addChild: self index;
				yourself);
		addChild: (self systemPage
			addChild: (self componentsPage
				addChild: self headerPage;
				addChild: self siteTitlePage;
				addChild: self footerPage;
				addChild: self menuPage;
				addChild: self childrenWidget;
				addChild: self breadcrumbWidget;
				addChild: self sitemapPage;
				addChild: self viewsPage;
				addChild: self commandsPage;
				addChild: self loginCommandWidget;
				addChild: self contentsWidget;
				addChild: self stylesheetFile;
				addChild: self bookStylesheetFile;
				"addChild: self postTickerWidget;
				addChild: self blogArchiveWidget;"
				addChild: self searchWidget;
				addChild: self poweredPage;
				addChild: self loggedInUserPage;
				addChild: self designChooserWidget;
				addChild: self notesComponent;
"				addChild: self documentWidget;
"				yourself);
			addChild: self systemManagementPage;
			addChild: (self templatesPage
				addChild: self environmentPage;
				"addChild: self blogEnvironmentPage;"
				addChild: self mainEnvironmentPage;
				addChild: self metaEnvironmentPage;
				yourself
			);
			yourself
		).
	self rootPage localEnvironment: self mainEnvironmentPage.
	"self blog localEnvironment: self blogEnvironmentPage."
	self environmentPage localEnvironment: self metaEnvironmentPage.
	"self mainEnvironmentPage localEnvironment: self metaEnvironmentPage."
	self metaEnvironmentPage localEnvironment: self metaEnvironmentPage.
	self systemManagementPage localEnvironment: self metaEnvironmentPage.
	self rootPage localStyleSheet: self stylesheetFile.
	
"Specific to the book"
	self book localEnvironment: self environmentPage.
	self book localStyleSheet: self bookStylesheetFile.
	
	self rootPage enumerator
		with;
		all;
		do: [ :each | 
			each outgoingReferences 
				do: [ :link | (link isKindOf: PRInternalLink) ifTrue: [ link target: nil ] ].
			each securityDecoration owner: self kernel users anyOne.
			each securityDecoration group: self kernel groups anyOne ].
	self makePrivate: self systemPage.
	self makePrivate: self environmentPage.
	"self makePrivate: self blogEnvironmentPage."
	self makePrivate: self mainEnvironmentPage.
	self makePrivate: self metaEnvironmentPage.
	self makePrivate: self sitemapPage.
	self makePrivate: self viewsPage.
	self makePrivate: self commandsPage.
	self makePrivate: self systemManagementPage.
	self makePrivate: self loggedInUserPage.
	"pier-sprint-eindhoven -http://forum.world.st/huge-security-problem-with-pier-td3241518.html"
	self makePrivate: self designChooserWidget.
	^ self rootPage

]

{ #category : #structures }
PRBookDistribution >> section [
	^ section ifNil: [ section := (BOPortion named: 'section')
		type: #section;
		contents: 'This is a section.
@@todo this is a todo annotation.

@@note this is a note annotation.
';
		yourself ]

]

{ #category : #structures }
PRBookDistribution >> tableOfContents [
	^ tableOfContents ifNil: [ tableOfContents := (BOPortion named: 'table-of-contents')
		title: 'Table of contents';
		type: #chapter;
		contents: '{{{<div class="table-of-contents">}}}*value:book.contents|target=/book*{{{</div>}}}';
		numberedTitle: false;
		yourself ]

]

{ #category : #structures }
PRBookDistribution >> tableOfFigures [
	^ tableOfFigures ifNil: [ tableOfFigures := (BOPortion named: 'table-of-figures')
		title: 'Table of figures';
		type: #chapter;
		contents: '{{{<div class="table-of-figures">}}}*value:book.figures|target=/book*{{{</div>}}}';
		numberedTitle: false;
		yourself ]

]
