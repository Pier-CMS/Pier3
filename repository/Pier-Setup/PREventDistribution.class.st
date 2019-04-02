Class {
	#name : #PREventDistribution,
	#superclass : #PRDistribution,
	#instVars : [
		'eventTitlePage',
		'callPage',
		'pcPage',
		'datesPage'
	],
	#category : #'Pier-Setup'
}

{ #category : #accessing }
PREventDistribution class >> title [
	^ 'Event'
]

{ #category : #structures }
PREventDistribution >> blog [
	^ blog ifNil: [
		blog := (PBBlog named: 'news')
		addChild: (
			(PBPost named: 'online')
			title: 'Online';
			contents: 'The page is online. Stay tuned for more news.';
			publication: DateAndTime today;
			yourself
		);
		yourself
	].

]

{ #category : #structures }
PREventDistribution >> callPage [
	^ callPage ifNil: 
		[ callPage := (PRPage named: 'call')
			title: 'Call for Contributions';
			contents: 'TBA';
			yourself ]
]

{ #category : #structures }
PREventDistribution >> datesPage [
	^ datesPage ifNil: 
		[ datesPage := (PRPage named: 'dates')
			title: 'Important Dates';
			contents: 'TBA';
			yourself ]
]

{ #category : #structures }
PREventDistribution >> environmentPage [
	^ environmentPage ifNil: [
		environmentPage := (PRPage named: 'environment')
		title: '_Environment';
		contents: 
'{{{<div class="header">
	<div class="container">
		<div class="eventTitle">}}}+/system/components/eventtitle+{{{</div>
		<div class="menu">}}}+/system/components/menu|menu+{{{</div>
	</div>
</div>
<div class="container">
	<div class="column span-24 last mainbody">
		<h1>}}}*value:structure*{{{</h1>
		<div class="column span-12 contents">
			}}}+/system/components/contents+{{{
		</div>
		<div class="column span-6 prepend-6 last sidebar">
			<h2>What''s new</h2>
			<div class="postticker">}}}+/system/components/postticker+{{{</div>
		</div>
	</div>
	}}}+/system/components/footer+{{{
</div>}}}
+/system/components/googleanalytics+
';
		yourself
	]
]

{ #category : #structures }
PREventDistribution >> eventTitlePage [
	^ eventTitlePage ifNil: 
		[ eventTitlePage := (PRPage named: 'eventtitle')
			title: 'Event Title';
			contents: '{{{<h1 class="heading">Event</h1>
			<h2>Location</h2>}}}';
			yourself ]
]

{ #category : #structures }
PREventDistribution >> menuPage [
	^ menuWidget ifNil: 
		[ menuWidget := (PRPage named: 'menu')
			contents:
'- *Home>/*
- */call*
- */pc*
- */dates*
- */news*';
			yourself ]
]

{ #category : #structures }
PREventDistribution >> pcPage [
	^ pcPage ifNil: 
		[ pcPage := (PRPage named: 'pc')
			title: 'Program Committee';
			contents: 'TBA';
			yourself ]
]

{ #category : #creation }
PREventDistribution >> root [
	self rootPage
		addChild: self blog;
		addChild: self pcPage;
		addChild: self callPage;
		addChild: self datesPage;
		addChild: (self systemPage
			addChild: (self componentsPage
				addChild: self headerPage;
				addChild: self siteTitlePage;
				addChild: self footerPage;
				addChild: self menuPage;
				addChild: self childrenWidget;
				addChild: self breadcrumbWidget;
				addChild: self googleAnalyticsWidget;
				addChild: self sitemapPage;
				addChild: self viewsPage;
				addChild: self commandsPage;
				addChild: self loginCommandWidget;
				addChild: self contentsWidget;
				addChild: self stylesheetFile;
				addChild: self postTickerWidget;
				addChild: self blogArchiveWidget;
				addChild: self searchWidget;
				addChild: self poweredPage;
				addChild: self loggedInUserPage;
				addChild: self designChooserWidget;
				addChild: self eventTitlePage;
"				addChild: self documentWidget;
"				yourself);
			addChild: self systemManagementPage;
			addChild: (self templatesPage
				addChild: self environmentPage;
				"addChild: self blogEnvironmentPage;"
				"addChild: self mainEnvironmentPage;"
				addChild: self metaEnvironmentPage;
				yourself
			);
			yourself
		).
	self rootPage localEnvironment: self environmentPage"mainEnvironmentPage".
	"self blog localEnvironment: self blogEnvironmentPage."
	self environmentPage localEnvironment: self metaEnvironmentPage.
	"self mainEnvironmentPage localEnvironment: self metaEnvironmentPage."
	self metaEnvironmentPage localEnvironment: self metaEnvironmentPage.
	self systemManagementPage localEnvironment: self metaEnvironmentPage.
	self rootPage localStyleSheet: self stylesheetFile.
	
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
	"self makePrivate: self mainEnvironmentPage."
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
PREventDistribution >> stylesheetFile [

	^ stylesheetFile ifNil: [
		stylesheetFile := (PRFile named: 'eventCss')
		filename: 'style.css';
		mimetype: 'text/css';
		contents: 
'.header h1.heading { font-size: 2em; padding-top: 1.5em; margin-bottom: 0; color: white;}
.header h2 { font-size: 1.2em; margin-top: 0; padding-bottom: 1.25em; color: white;}
.header {background: #545454; color: white;}
body {font-size: 11pt;}


/* HEADER */
.menu ul {
	margin: 0;
	margin-top: 0.2em;
	list-style-type: none;}
.menu ul li {
	display: inline;
	margin: 0;
	margin-right: 1.5em;
	list-style-type: none;}
.menu li a {
	padding-left: 1em;
	padding-right: 1em;
	padding-top: 0.5em;
	padding-bottom: 1em;}


/*BLOG*/
div.post {margin-bottom: 4.5em;}
div.comment {margin-bottom: 3em;}
.meta {font-size: 80%; color: #aaa;}
.leavecomment {margin-top: 4.5em; margin-bottom: 4.5em;}
.comments {margin-top: 4.5em;}


/* NAVIGATION */
.sidebar ul {
	margin-top: 0;
	margin-left: 0;
	list-style-type: none;}
.sidebar ul ul {
	margin-bottom: 0;
	margin-left: 1.5em;}
.sidebar ul li {
	margin-top: 1.5em;}
.sidebar ul li a {
/*	padding-left: 0.3em;
	padding-right: 0.3em;
*/	padding-top: 0.3em;
	padding-bottom: 0.3em;}
.sidebar p,
.sidebar h1, .sidebar h2, .sidebar h3,
.sidebar .postticker .timestamp,
.sidebar .postticker .summary {}
.sidebar .active,
.menu li a.active {
	color: white;
	background: #ff6633;}


/*MAIN BODY*/
.mainbody {
	padding-top: 4em;
	padding-bottom: 15em;}
.postticker ul {
	list-style: none;
	margin-left: 0;}
.postticker ul li {
	margin-bottom: 1.5em;}
.postticker .timestamp {display: inline; padding-left: 1em; color: #aaa; font-size: 80%;}
.postticker .subscribe,
.postticker .timestamp .time,
.postticker .timestamp .author {display: none;}


/* FOOTER */
.footer {
	color: #aaa;
	font-size: 80%;
	text-align: left;}
.footer a { color: #aaa;}
.footer ul {list-style: none; margin-left: 0em;}
.footer ul ul {margin-left: 1.5em;}
.footer .commands ul, .footer .views ul {display: inline;}
.footer .commands ul li, .footer .views ul li {display: inline; padding-right: 1em;}


/* META */
.metaenvironment h1.heading {display: none;}
.metaheader {background: #C3D9FF; font-size: 200%}
.metaheader ul {display: inline; margin: 0;}
.metaheader li {list-style: none; display: inline; margin: 0;}
.metaheader li:after {content: "/"}
.metaenvironment.container {border: 1px solid #C3D9FF; margin-top: 0;}
.metafooter {background: #C3D9FF;}
.metafooter li {list-style: none;}


/*DEFAULT*/
body {margin-top: 0;}
h1, h2, h3, h4, h5, h6 { margin: 0; font-weight: inherit; font-size: 100%; line-height: inherit; }
h1 { font-size: 1.5em; line-height: 1; margin-bottom: 1em; }
.maincontents {font-size: 1.5em;}
h2 { font-size: 1.2em; height: 1.25em; line-height: 1.25; margin-bottom: 1.25em; }
h3 { font-size: 1em; font-weight: bold; margin-bottom: 1.5em; }
h4 { font-size: 1em; font-weight: bold; }
h5 { font-size: 1em; }
textarea {width: 100%;}


/* PIER */
.broken { color: red; font-weight: bold;}
.protected { color: #aaa; }
a {color: #ff6633;}
a:hover {
	color: white;
	background: #ff6633; }
a:hover.nobackground {background: white;}
a.view, a.command {color: gray;}
a {text-decoration: none;}
a.environment:after {content: "*";}
.right {text-align: right;}
.left {text-align: left;}
.center {text-align: center;}
.float {float: right;}
.nobullets ul {list-style: none; margin-left: 0;}
.nobullets ul li {list-style: none; margin-left: 0;}
th {background: #eee; font-weight: normal;}';
		yourself
	]
]
