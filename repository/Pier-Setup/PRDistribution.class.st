Class {
	#name : #PRDistribution,
	#superclass : #Object,
	#instVars : [
		'blog',
		'contentsWidget',
		'environmentPage',
		'metaEnvironmentPage',
		'breadcrumbWidget',
		'commandsPage',
		'siteTitlePage',
		'sitemapPage',
		'stylesheetFile',
		'systemManagementPage',
		'viewsPage',
		'menuWidget',
		'loginCommandWidget',
		'mainEnvironmentPage',
		'childrenWidget',
		'postTickerWidget',
		'rootPage',
		'kernel',
		'syntaxPage',
		'aboutPage',
		'blogArchiveWidget',
		'blogEnvironmentPage',
		'poweredByPage',
		'searchWidget',
		'headerPage',
		'footerPage',
		'loggedInUserPage',
		'designChooserWidget',
		'documentWidget',
		'systemPage',
		'componentsPage',
		'templatesPage'
	],
	#category : #'Pier-Setup'
}

{ #category : #accessing }
PRDistribution class >> register [
	^ self new register
]

{ #category : #accessing }
PRDistribution class >> title [
	"override this method to name the design"
	^'Default'
]

{ #category : #structures }
PRDistribution >> aboutPage [
	^ aboutPage ifNil: [
		aboutPage := (PRPage named: 'about')
					title: 'About Pier';
					contents:
'*Pier>http://www.piercms.com* is a content management system that allows users to manage their content from the browser.

The central concept in Pier is the one of Structure. For example, the current page is a structure. The */blog* is also a structure, but it is slightly different than a page. A file is also a structure.

Commands can be executed on a Structure. For example, a Structure can be edited. In the current setup you can edit this site after logging in (the commands appear in the footer). Once in edit mode, you can use the *syntax*. To make life easier, Pier also offers access to these commands via *shortcuts>http://www.piercms.com/doc/shortcuts*.

Any Structure can be Viewed. The default View is the one that renders the structure for normal usage. Another example, is the Browse View which offers a file system like view on the Pier structures.

Any Structure has an environment which defines the template. For example, the environment of this page is */system/templates* (you have to be logged in to see it). To set the environment to be a different page use the Settings command. To edit the environment use the Edit Design command.

A Structure can contain Widgets. For example, the environment of this page contains a menu widget on top, and a widget that enumerates the children of the current sturcture to the right.

More about Pier can be found at: *http://www.piercms.com*.'
	]
]

{ #category : #structures }
PRDistribution >> blog [
	^ blog ifNil: [
		blog := (PBBlog named: 'blog')
		addChild: (
			(PBPost named: 'downtobusiness')
			title: 'Down to business';
			contents: 'I like blogging, so here is my second post.';
			publication: DateAndTime now;
			addChild: ((PBComment named: '1')
				contents: 'We are glad to see that you get serious about blogging. Btw, this is a comment.';
				author: 'The Pier Team';
				website: 'http://www.piercms.com';
				yourself
				);
			yourself
		);
		addChild: (
			(PBPost named: 'hello')
			title: 'Hello';
			contents: 'Hi! This is my first post.';
			publication: DateAndTime today;
			yourself
		);
		yourself
	].

]

{ #category : #structures }
PRDistribution >> blogArchiveWidget [
	^ blogArchiveWidget ifNil: [
		blogArchiveWidget := (PRComponent named: 'blogarchive')
		title: 'Blog Archive';
		prototypeInstance: PBPostArchive new;
		yourself
	]
]

{ #category : #structures }
PRDistribution >> blogEnvironmentPage [
	^ blogEnvironmentPage ifNil: [
		blogEnvironmentPage := (PRPage named: 'blogenvironment')
		title: '_Blog Environment';
		contents: 
'{{{<div class="container">
	}}}+/system/components/header+{{{
	<div class="column span-24 last mainbody">
		<h1 class="heading">}}}*>value:structure|level=2*{{{</h1>
		<h1>}}}*>value:structure|level=0|lower=3*{{{</h1>
		<div class="column span-12 contents">
			}}}+/system/components/contents+{{{
		</div>
		<div class="column span-6 prepend-6 last sidebar">
			<h2>Archive</h2>
			}}}+/system/components/blogarchive+{{{
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
PRDistribution >> breadcrumbWidget [
	^ breadcrumbWidget ifNil: [breadcrumbWidget := (PRComponent named: 'breadcrumb')
		prototypeInstance: PRBreadcrumbWidget new;
		yourself
	]
]

{ #category : #structures }
PRDistribution >> childrenWidget [
	^ childrenWidget ifNil: [
		childrenWidget := 
			((PRComponent named: 'children')
				prototypeInstance: (PRDynamicChildrenWidget new
					level: 2;
					expanded: true;
					yourself))
			yourself ]
]

{ #category : #structures }
PRDistribution >> commandsPage [
	^ commandsPage ifNil: [
		commandsPage := 
			((PRPage named: 'commands') 
				addChild: 
					((PRComponent named: 'widget')
						prototypeInstance: PRCommandsWidget new; 
						yourself);
			contents: 'Commands: +widget+';
			yourself) ]
]

{ #category : #structures }
PRDistribution >> componentsPage [
	^ componentsPage ifNil: [
		componentsPage := (PRPage named: 'components')
		contents: '*value:children|link*';
		yourself
	]
]

{ #category : #structures }
PRDistribution >> contentsWidget [
	^ contentsWidget ifNil: [
		contentsWidget := 
			((PRComponent named: 'contents')
				prototypeInstance: (PRContentsWidget new heading: ''; yourself);
				yourself) ]
]

{ #category : #structures }
PRDistribution >> designChooserWidget [
	^ designChooserWidget ifNil: [
		designChooserWidget := (PRComponent named: 'designchooser')
			prototypeInstance: PRDesignChooserWidget new;
			yourself ]
]

{ #category : #structures }
PRDistribution >> documentWidget [
	^ documentWidget ifNil: [
		documentWidget := 
			(PRComponent named: 'sidebar')
				title: 'Sidebar Document';
				prototypeInstance: PRDocumentWidget new;
				yourself ]
]

{ #category : #structures }
PRDistribution >> environmentPage [
	^ environmentPage ifNil: [
		environmentPage := (PRPage named: 'environment')
		title: '_Environment';
		contents: 
'{{{<div class="container">
	}}}+/system/components/header+{{{
	<div class="column span-24 last mainbody">
		<h1 class="heading">}}}*>value:structure|level=2*{{{</h1>
		<h1>}}}*>value:structure|level=0|lower=3*{{{</h1>
		<div class="column span-12 contents">
			}}}+/system/components/contents+{{{
		</div>
		<div class="column span-6 prepend-6 last sidebar">
			<h2>Navigation</h2>
			}}}+/system/components/children+{{{
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
PRDistribution >> footerPage [
	^ footerPage ifNil: [
		footerPage := (PRPage named: 'footer')
		contents:
'{{{<div class="footer column span-24 last">
	<div class="column span-18">
		}}}+/system/components/justlogincommand+
		+/system/components/loggedinuser+{{{
		<div class="commands">}}}+/system/components/commands+{{{</div>
		<div class="views">}}}+/system/components/views+{{{</div>
		<div class="sitemap">}}}+/system/components/sitemap+{{{</div>
	</div>
	<div class="column span-6 last">}}}+/system/components/poweredby+{{{</div>
</div>}}}';
		yourself
	]
]

{ #category : #structures }
PRDistribution >> headerPage [
	^ headerPage ifNil: [
		headerPage := (PRPage named: 'header')
		contents:
'{{{<div class="column span-24 last header">
	<div class="menu">}}}+/system/components/menu|menu+{{{</div>
</div>}}}';
		yourself
	]
]

{ #category : #creation }
PRDistribution >> kernel [
	^ kernel ifNil: [
		kernel := PRKernel named: 'pier'.
		kernel root: self root.
		kernel
	]
]

{ #category : #structures }
PRDistribution >> loggedInUserPage [
	^ loggedInUserPage ifNil: [
		loggedInUserPage := 
			(PRPage named: 'loggedinuser') 
				addChild: ((PRComponent named: 'widget') prototypeInstance: PUSecurityWidget new; yourself);
				contents: 'Logged in as *value:user* (+widget+?)';
				yourself ]
]

{ #category : #structures }
PRDistribution >> loginCommandWidget [
	^ loginCommandWidget ifNil: [
		loginCommandWidget := 
			(PRComponent named: 'justlogincommand')
				title: 'Just Login Command';
				prototypeInstance: (PRCommandsWidget new commandClasses: (Array with: PULogin); yourself);
				yourself ]
]

{ #category : #structures }
PRDistribution >> mainEnvironmentPage [
	^ mainEnvironmentPage ifNil: [
		mainEnvironmentPage := (PRPage named: 'mainenvironment')
		title: '_Main Environment';
		contents: 
'{{{<div class="container">
	}}}+/system/components/header+{{{
	<div class="column span-24 last mainbody">
		<h1 class="heading">}}}*value:structure*{{{</h1>
		<div class="contents column span-12">}}}+/system/components/contents+{{{</div>
		<div class="postticker column prepend-6 span-6 last">
			<h2>What''s new</h2>
			}}}+/system/components/postticker+
			+/system/components/sidebar+{{{
		</div>
	</div>
	}}}+/system/components/footer+{{{
</div>}}}
+/system/components/googleanalytics+
';
		yourself
	]
]

{ #category : #rights }
PRDistribution >> makePrivate: aStructure [
	"Makes a structure private."

	aStructure securityDecoration
		owner: self kernel users anyOne;
		ownerPermissions: PUChangeSecurity permissionInstances.
	aStructure securityDecoration
		group: self kernel groups anyOne;
		groupPermissions: PUChangeSecurity permissionInstances.
	aStructure securityDecoration
		otherPermissions: #()
]

{ #category : #rights }
PRDistribution >> makePublic: aStructure [
	"Make aStructure public visible."

	aStructure securityDecoration
		owner: self kernel users anyOne;
		ownerPermissions: PUChangeSecurity permissionInstances.
	aStructure securityDecoration
		group: self kernel groups anyOne;
		groupPermissions: PUChangeSecurity permissionInstances.
	aStructure securityDecoration
		otherPermissions: PRViewCommand permissions
]

{ #category : #structures }
PRDistribution >> menuPage [
	^ menuWidget ifNil: 
		[ menuWidget := (PRPage named: 'menu')
			contents:
'- *Home>/*
- *Blog>/blog*
- *About>/about*';
			yourself ]
]

{ #category : #structures }
PRDistribution >> metaEnvironmentPage [
	^ metaEnvironmentPage ifNil: [
		metaEnvironmentPage := (PRPage named: 'metaenvironment')
		title: '_Meta Environment';
"		hideFromMenus: true;"
		contents: '{{{<div class="container metaenvironment">
	<div class="span-24 last metaheader">
		Meta page: }}}+/system/components/breadcrumb+{{{
	</div>
	<div class="span-24 last">
		}}}+/system/components/contents+{{{
	</div>
	<div class="span-24 last metafooter">
		<div class="span-10">}}}+/system/components/commands+{{{</div>
		<div class="span-10 last">}}}+/system/components/sitemap+{{{</div>
	</div>
</div>}}}';
		yourself
	]
]

{ #category : #structures }
PRDistribution >> postTickerWidget [
	^ postTickerWidget ifNil: [
		postTickerWidget := 
			(PRComponent named: 'postticker')
				title: 'Post Ticker';
				prototypeInstance: (PBPostTicker new blog: self blog; yourself);
				yourself ]
]

{ #category : #structures }
PRDistribution >> poweredPage [
	^ poweredByPage ifNil: [poweredByPage := (PRPage named: 'poweredby')
		title: 'Powered By';
		contents: 
'Powered by *Pier>http://www.piercms.com*';
		yourself
	]
]

{ #category : #creation }
PRDistribution >> register [ 
	| application |
	PRKernel reset.
	application := PRPierFrame 
		registerAsApplication: 'pier'
		kernel: self kernel.
	application parent defaultName: 'pier'.
]

{ #category : #creation }
PRDistribution >> replaceRoot [
	kernel := PRKernel instances anyOne.
	kernel root: self root
]

{ #category : #creation }
PRDistribution >> root [
	self rootPage
		addChild: self blog;
		addChild: (self aboutPage
				addChild: self syntaxPage;
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
				addChild: self postTickerWidget;
				addChild: self blogArchiveWidget;
				addChild: self searchWidget;
				addChild: self poweredPage;
				addChild: self loggedInUserPage;
				addChild: self designChooserWidget;
				addChild: self documentWidget;
				yourself);
			addChild: self systemManagementPage;
			addChild: (self templatesPage
				addChild: self environmentPage;
				addChild: self blogEnvironmentPage;
				addChild: self mainEnvironmentPage;
				addChild: self metaEnvironmentPage;
				yourself
			);
			yourself
		).
	self rootPage localEnvironment: self mainEnvironmentPage.
	self blog localEnvironment: self blogEnvironmentPage.
	self aboutPage localEnvironment: self environmentPage.
	self environmentPage localEnvironment: self metaEnvironmentPage.
	self mainEnvironmentPage localEnvironment: self metaEnvironmentPage.
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
	self makePrivate: self blogEnvironmentPage.
	self makePrivate: self mainEnvironmentPage.
	self makePrivate: self metaEnvironmentPage.
"	self makePublic: self sitemapPage." "Disabled because makePublic has the same implementation as makePrivate, added issue 134 on the public issue tracker for this."
	self makePrivate: self viewsPage.
	self makePrivate: self commandsPage.
	self makePrivate: self systemManagementPage.
	self makePrivate: self loggedInUserPage.	
	"pier-sprint-eindhoven -http://forum.world.st/huge-security-problem-with-pier-td3241518.html"
	self makePrivate: self designChooserWidget.
	^ self rootPage
]

{ #category : #structures }
PRDistribution >> rootPage [
	^ rootPage ifNil: [
		rootPage := (PRPage named: 'pier')
		title: 'Welcome to Pier!';
		yourself.

		rootPage 
		contents:
'This is the main page of the official Pier distribution. Before you can modify this site, you have to login using: admin/pier.

If you are not satisfied with the current look, perhaps you want to choose another one:

+/system/components/designchooser+

Have fun!

The Pier Team
'.
		rootPage]
]

{ #category : #structures }
PRDistribution >> searchWidget [
	^ searchWidget ifNil: [
		searchWidget := (PRComponent named: 'search')
			prototypeInstance: PRSearchWidget new;
			yourself ]
]

{ #category : #structures }
PRDistribution >> siteTitlePage [
	^ siteTitlePage ifNil: [
		siteTitlePage := (PRPage named: 'sitetitle')
		title: 'Site Title';
		contents: '!*Your Pier>/*';
		yourself
	]
]

{ #category : #structures }
PRDistribution >> sitemapPage [
	sitemapPage
		ifNil: [ 
			(sitemapPage := PRPage named: 'sitemap')
				addChild:
						((PRComponent named: 'widget')
								prototypeInstance: PRTreeWidget new;
								yourself);
				contents:
						'Sitemap
+widget+'.
			sitemapPage securityDecoration otherPermissions: PRViewCommand permissions ].
	^ sitemapPage
]

{ #category : #structures }
PRDistribution >> stylesheetFile [
	^ stylesheetFile ifNil: [
		stylesheetFile := (PRFile named: 'defaultCss')
		filename: 'style.css';
		mimetype: 'text/css';
		contents: 
'/* HEADER */
.icon a {outline: none; background: white;}
.search input.text {
	border: 1px solid white;
	color: black;}
.search input.text:focus {
	border: 1px solid #ff6633;
	color: black;}
.search input {
	color: #ff6633;
	font-size: 1em;
	outline: none;
	width: 98%;
	border: 0;
	margin-top: 0.1em;
	padding: 0.3em;
	padding-top: 0;
	background: 0;}
.search ul {
	margin: 0;
	padding: 0;
	background: white;
	list-style-type: none;
	border: 1px solid #ff6633;
	border-top: 0;}
.search li.selected a {color: #fff;}
.search li.selected {
	background-color: #ff6633;
	color: white;}
.search li {
	margin: 0;
	display: block;
	padding: 0.2em;
	cursor: pointer;
	list-style-type: none;}
.menu ul {
	margin: 0;
	margin-top: 0.2em;
	padding-bottom: 0.2em;
	list-style-type: none;}
.menu ul li {
	display: inline;
	margin: 0;
	margin-right: 1.5em;
	list-style-type: none;}
.menu li a {
	padding-left: 0.3em;
	padding-right: 0.3em;
	padding-top: 0.5em;
	padding-bottom: 0.3em;}


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
	padding-left: 0.3em;
	padding-right: 0.3em;
	padding-top: 0.3em;
	padding-bottom: 0.3em;}
.sidebar p,
.sidebar h1, .sidebar h2, .sidebar h3,
.sidebar .postticker .timestamp,
.sidebar .postticker .summary {padding-left: 0.3em;}
.sidebar .active,
.menu li a.active {
	color: white;
	background: #ff6633;}


/*MAIN BODY*/
.mainbody {
	padding-top: 4em;
	padding-bottom: 15em;}
.postticker ul {
	font-size: 80%;
	color: #aaa;
	list-style: none;
	margin-left: 0;}
.postticker ul li {
	margin-bottom: 1.5em;}
.postticker .timestamp {color: #aaa; font-size: 80%;}
.postticker .subscribe,
.postticker .timestamp .time,
.postticker .timestamp .author {display: none;}
.postticker a.post {color: #aaa;}


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
h1.heading { font-size: 2em; margin-bottom: 1.5em; }
h1 { font-size: 1.5em; line-height: 1; margin-bottom: 1em; }
.maincontents {font-size: 1.5em;}
h2 { font-size: 1.2em; height: 1.25em; line-height: 1.25; margin-bottom: 1.25em; }
h3 { font-size: 1em; font-weight: bold; margin-bottom: 1.5em; }
h4 { font-size: 1em; font-weight: bold; }
h5 { font-size: 1em; }
textarea {width: 100%;}
input.text, input.password {width: 200px;}
input[type="button"], input[type="submit"], input[type="reset"], input[type="file"], button { margin-left: 0.5em;} 


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
tr th {background: #eee; font-weight: normal;}
label {font-weight: normal;}
tr.group th {background: white; font-size: 1em; font-weight: bold; margin-top: 1.5em; }
td.required:after {color: #ff6633; content: "*"; margin-left: 0.5em;}
';
		yourself]
]

{ #category : #structures }
PRDistribution >> syntaxPage [
	^ syntaxPage ifNil: [
		syntaxPage := PRKernel defaultInfoSyntax].
]

{ #category : #structures }
PRDistribution >> systemManagementPage [
	^ systemManagementPage ifNil: [
		systemManagementPage := (PRPage named: 'management')
		title: 'Management';
		addChild: ((PRComponent named: 'users')
				prototypeInstance: PUUsersWidget new;
				yourself);
		addChild: ((PRComponent named: 'groups')
				prototypeInstance: PUGroupsWidget new;
				yourself);
		addChild: ((PRComponent named: 'persistency')
				prototypeInstance: PRPersistencySettings new;
				yourself);
		addChild: ((PRComponent named: 'kernel')	
				componentClass: PRKernelSettings;
				yourself);
		addChild: ((PRComponent named: 'file')
				prototypeInstance: PRFileSettings new;
				yourself);
		contents: '!Users
+users+

!User Group
+groups+

!Persistency
+persistency+

!Kernel Settings
+kernel+

!File Settings
+file+';
		yourself
	]
]

{ #category : #structures }
PRDistribution >> systemPage [
	^ systemPage ifNil: [
		systemPage := (PRPage named: 'system')
		contents: '*value:children|link*';
		yourself
	]
]

{ #category : #structures }
PRDistribution >> templatesPage [
	^ templatesPage ifNil: [
		templatesPage := (PRPage named: 'templates')
		contents: '*value:children|link*';
		yourself
	]
]

{ #category : #structures }
PRDistribution >> viewsPage [
	^ viewsPage ifNil: [
		viewsPage := (PRPage named: 'views')
		addChild: ((PRComponent named: 'widget')
				prototypeInstance: PRViewsWidget new;
				yourself);
		contents: 'Views: +widget+'
	]
]
