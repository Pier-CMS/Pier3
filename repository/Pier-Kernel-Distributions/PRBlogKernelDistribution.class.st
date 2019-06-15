Class {
	#name : #PRBlogKernelDistribution,
	#superclass : #PRAbstractKernelSystemManagementDistribution,
	#instVars : [
		'blog',
		'blogArchiveWidget',
		'blogTagWidget',
		'blogCloudWidget',
		'blogTemplate',
		'rootPage',
		'menuWidget',
		'blogPostTickerWidget',
		'sidebarDocumentWidget',
		'mainTemplate',
		'siteTitlePage',
		'headerPage',
		'editingTemplateWithSideBarDocumentWidget',
		'sampleContentSelected',
		'importBlogFromUrl',
		'calleeComponent',
		'importStyleFromUrl'
	],
	#category : #'Pier-Kernel-Distributions'
}

{ #category : #testing }
PRBlogKernelDistribution class >> isAbstract [ 
	^ false
]

{ #category : #accessing }
PRBlogKernelDistribution class >> label [
	^ 'Blog Template'
]

{ #category : #accessing }
PRBlogKernelDistribution class >> thumbnail [
	^ PRKernelDistributionFileLibrary / #blogDistributionPng
]

{ #category : #'sample content' }
PRBlogKernelDistribution >> addSampleContent [
	self blog
		addChild: self blogPostOverview;
		addChild: self blogPostEmbeddingComponents;
		addChild: self blogPostCodeHighlighting;
		addChild: self blogPostWikiMarkup;
		addChild: self blogPostInstallation.
		
	self setAdminUserGroupStartingAtStructure: self blog
]

{ #category : #components }
PRBlogKernelDistribution >> blog [
	^ blog ifNil: [
		blog := (PBBlog named: 'blog')
			localEnvironment: self blogTemplate;
			localEditingEnvironment: (self emptyEnvironment);
			socialSharingWidgetClassName: #PBSocialWidgetsAddThis;
			yourself ]
]

{ #category : #components }
PRBlogKernelDistribution >> blogArchiveWidget [
	^ blogArchiveWidget ifNil: [
		blogArchiveWidget := (PRComponent named: 'blogArchive')
			title: 'Blog Archive';
			prototypeInstance: PBPostArchive new;
			yourself ]
]

{ #category : #components }
PRBlogKernelDistribution >> blogCloudWidget [
	^ blogCloudWidget ifNil: [ 
		blogCloudWidget := (PRComponent named: 'blogCloud') 
			prototypeInstance: (PRTagCloudWidget new
				startAt: self blog;
				showExponential: true;
				maxItems: 35;
				ignoredTags: 'object';
				yourself);
			yourself ]
]

{ #category : #'sample content' }
PRBlogKernelDistribution >> blogPostCodeHighlighting [
	^ (PBPost named: 'code-highlighting')
		title: 'Smalltalk code highlighting';
		tags: #('Smalltalk' 'code' 'highlighting');
		publication: GRPlatform current magritteTimeStampClass now;
		contents:
'Pier uses the Shout code highlighter. To highlight small quantity of code, start the line with: \=\= For example:

= ==renderContentOn: html
= ==	html heading: count. 
= ==	html anchor 
= ==		callback: [ self increase ]; 
= ==		with: ''++''. 
= ==	html space. 
= ==	html anchor 
= ==		callback: [ self decrease ]; 
= ==		with: ''--''
results in:		
==renderContentOn: html
==	html heading: count.
==	html anchor
==		callback: [ self increase ];
==		with: ''++''.
==	html space.
==	html anchor
==		callback: [ self decrease ];
==		with: ''--''

However with a Pier blog there is no need to copy and paste code into blog posts. Instead, you can embed a reference to your code directly into posts:

# Show a class definition: \+value:source|class=WACounter\+
# A method definition: \+value:source|class=WACounter|selector=renderContentOn:\+
# A class comment: \+value:source|class=WACounter|comment\+

The class definition (from above): 
+value:source|class=WACounter+

A method (as above): 
+value:source|class=WACounter|selector=renderContentOn:+

A comment:
+value:source|class=WACounter|comment+
';
	 yourself
]

{ #category : #'sample content' }
PRBlogKernelDistribution >> blogPostEmbeddingComponents [
	^ (PBPost named: 'embedding-components')
		title: 'Embedding components';
		tags: #('components' 'embedding' 'Seaside');
		publication: GRPlatform current magritteTimeStampClass now;
		contents:
'Embedding Seaside components is straightforward. Simply add a component to a node within the site''s tree structure, then add a reference to that component within a blog post. For example if you add a component as a child of this post, you can then then embed the component using the syntax. \+mychild\+. Here is an embedded ajaxified counter:

+ajaxcounter+

...and the standard counter:

+counter+

Test Seaside''s state management by clicking on the \+\+ and \-\- links. Pier blogs are ideal for demoing and describing your Seaside components. In fact you can use Pier as the basis for application development by embedding components in pages, especially if you are building a content-rich site.';
		addChild: ((PRComponent named: 'ajaxcounter')
			componentClass: JQCounterFunctionalTest;
			yourself);
		addChild: ((PRComponent named: 'counter')
			componentClass: WACounter;
			yourself);
		yourself.
]

{ #category : #'sample content' }
PRBlogKernelDistribution >> blogPostInstallation [
	^ (PBPost named: 'installation')
		title: 'Installing PierAdmin';
		tags: #('installation' 'metacello');
		publication: GRPlatform current magritteTimeStampClass now;
		contents: self installationInstructions;
		yourself
]

{ #category : #'sample content' }
PRBlogKernelDistribution >> blogPostOverview [
	^ (PBPost named: 'overview')
		title: 'What can Pier blogs do for me?';
		tags: #('features' 'overview');
		publication: GRPlatform current magritteTimeStampClass now;
		contents:
'The following posts illustrate some of the powerful features available in Pier powered blogs. Some highlights:

- Feature-rich blog, including:
-- Powerful wiki syntax as well as WYSIWYG editor.
-- Tags and tag-cloud.
-- User and permission management.
-- File Uploads.
-- Bookmarkable Urls.
- Embed live Seaside components.
- Advanced support for Smalltalk code highlighting, using the same highlighter as Pharo''s code editor.
- Easy to extend and add additional pages, menu items.
- Extend with Seaside components, Pier widgets, structures and views.
- Open source, with a range a contributed add-ons available.';
		yourself
]

{ #category : #components }
PRBlogKernelDistribution >> blogPostTickerWidget [
	^ blogPostTickerWidget ifNil: [
		blogPostTickerWidget := (PRComponent named: 'blogPostTicker')
			title: 'Blog Post Ticker';
			componentClass: PBPostTicker;
			prototypeInstance: (PBPostTicker new blog: self blog; yourself);
			yourself ]
]

{ #category : #'sample content' }
PRBlogKernelDistribution >> blogPostWikiMarkup [
	^ (PBPost named: 'wiki-markup')
		title: 'Wiki markup';
		tags: #('wiki' 'markup');
		publication: GRPlatform current magritteTimeStampClass now;
		contents: PRKernel defaultInfoSyntax contents;
		yourself.
]

{ #category : #components }
PRBlogKernelDistribution >> blogTagWidget [
	^ blogTagWidget ifNil: [
		blogTagWidget := (PRComponent named: 'blogTags')
			title: 'Blog Tags';
			prototypeInstance: PBPostTags new;
			yourself ]
]

{ #category : #templates }
PRBlogKernelDistribution >> blogTemplate [
	^ blogTemplate ifNil: [
		blogTemplate := (PRPage named: 'blogTemplate')
		title: '_Blog Template';
		contents: 
'{{{<div class="header">
	<div class="container">
		<div class="siteTitle">}}}+/system/components/sitetitle+{{{</div>
		<div class="menu">}}}+/system/components/menu|menu+{{{</div>
	</div>
</div>
<div class="container">
	<div class="column span-24 last mainbody">
		<div class="column span-15 contents">
			}}}+/system/contents+{{{
		</div>
		<div class="column span-6 prepend-3 last sidebar">
			<h2 class="blogArchiveTitle">Archive</h2>
			<div class="blogArchive">}}}+/system/components/blogArchive+{{{</div>
			<h2 class="blogTagsTitle">Tags</h2>
			<div class="blogTags">}}}+/system/components/blogTags+{{{</div>
			<h2 class="blogCloudTitle">Cloud</h2>
			<div class="blogCloud">}}}+/system/components/blogCloud+{{{</div>
		</div>
	</div>
	}}}+/system/components/footer+{{{
</div>}}}
+/system/components/googleanalytics+
';
		yourself ]
]

{ #category : #components }
PRBlogKernelDistribution >> components [
	^ OrderedCollection new
		add: self blogArchiveWidget;
		add: self blogCloudWidget;
		add: self blogTagWidget;
		add: self blogPostTickerWidget;
		add: self footerPage;
		add: self headerPage;
		add: self poweredPage;
		add: self searchWidget;
		add: self sidebarDocumentWidget;
		add: self siteTitlePage;
		add: self menuPage;
		yourself
]

{ #category : #creation }
PRBlogKernelDistribution >> createRootOn: theKernel [
	super createRootOn: theKernel.
	
	self sampleContentSelected ifTrue: [
		self addSampleContent ].
	
	self importBlogFromUrl notNil ifTrue: [
		| result |
		result := calleeComponent call: (PRBlogImporter blogStructure: self blog blogUrl: self importBlogFromUrl).
		result ifFalse: [ ^ nil ] ].
	
	self flag: #todo. "allow importing  Workpress styles"

	self clearInternalLinkTargetsStartingAt: theKernel root.
	
	^ theKernel
]

{ #category : #'magritte description' }
PRBlogKernelDistribution >> descriptionContainer [
	<magritteContainer>
	^ super descriptionContainer
		componentRenderer: TWBSMagritteFormRenderer;
		yourself
]

{ #category : #components }
PRBlogKernelDistribution >> headerPage [
	^ headerPage ifNil: [
		headerPage := (PRPage named: 'header')
		contents:
'{{{<div class="column span-24 last header">
	<div class="menu">}}}+/system/components/menu|menu+{{{</div>
</div>}}}';
		yourself ]
]

{ #category : #accessing }
PRBlogKernelDistribution >> importBlogFromUrl [
	^ importBlogFromUrl
]

{ #category : #accessing }
PRBlogKernelDistribution >> importBlogFromUrl: anObject [
	importBlogFromUrl := anObject
]

{ #category : #'magritte description' }
PRBlogKernelDistribution >> importBlogFromUrlDescription [
	<magritteDescription>
	^ MAStringDescription new
		priority: 10;
		label: 'Import Blog From Url';
		accessor: #importBlogFromUrl;
		comment: 'Leave blank if you don''t want to import existing blog content';
		componentClass: TWBSMagritteTextInputComponent; "is required for placeholder text below"
		placeholder: 'import blog url';
		yourself
]

{ #category : #accessing }
PRBlogKernelDistribution >> importStyleFromUrl [
	^ importStyleFromUrl
]

{ #category : #accessing }
PRBlogKernelDistribution >> importStyleFromUrl: anObject [
	importStyleFromUrl := anObject
]

{ #category : #'magritte description' }
PRBlogKernelDistribution >> importStyleFromUrlDescription [
	<magritteDescription>
	^ MAStringDescription new
		priority: 12;
		label: 'Import Style From Url';
		cssClass: 'disabled warning';
		accessor: #importStyleFromUrl;
		comment: 'TODO: Please help implement';
		componentClass: TWBSMagritteDisabledTextInputComponent; 
		placeholder: 'url of Wordpress theme';
		yourself
]

{ #category : #templates }
PRBlogKernelDistribution >> mainTemplate [
	^ mainTemplate ifNil: [
		mainTemplate := (PRPage named: 'mainTemplate')
		title: '_Main Template';
		contents: 
'{{{<div class="header">
	<div class="container">
		<div class="siteTitle">}}}+/system/components/sitetitle+{{{</div>
		<div class="menu">}}}+/system/components/menu|menu+{{{</div>
	</div>
</div>
<div class="container">
	<div class="column span-24 last mainbody">
		<div class="column span-15 contents">
			}}}+/system/contents+{{{
		</div>
		<div class="column span-6 prepend-3 last sidebar">
			<h2>What''s new</h2>
			<div class="blogPostTicker">}}}+/system/components/blogPostTicker+{{{</div>
			<div class="sidebarDocument">}}}+/system/components/sidebarDocumentWidget+{{{</div>
		</div>
	</div>
	}}}+/system/components/footer+{{{
</div>}}}
+/system/components/googleanalytics+
';
		yourself ]
]

{ #category : #components }
PRBlogKernelDistribution >> menuPage [
	^ menuWidget ifNil: 
		[ menuWidget := (PRPage named: 'menu')
			contents:
'- *Home>/*
- *Blog>/blog*';
			yourself ]
]

{ #category : #templates }
PRBlogKernelDistribution >> rootEditingTemplate [
	^ editingTemplateWithSideBarDocumentWidget ifNil: [
	editingTemplateWithSideBarDocumentWidget := (PRPage named: 'editingTemplateWithSideBarDocumentWidget')
		contents: '+/system/contents+
Sidebar widget: 
+/system/components/sidebarDocumentWidget+'; 
	yourself ]
]

{ #category : #components }
PRBlogKernelDistribution >> rootPage [
	^ rootPage ifNil: [
		rootPage := (PRPage named: 'pier')
			title: 'Welcome to Pier!';
			yourself.

		rootPage 
			contents:
'This is the main page of the Pier blog distribution.'.
		rootPage
			addChild: self blog.
		
		rootPage ]
]

{ #category : #stylesheets }
PRBlogKernelDistribution >> rootStyleSheetContents [
	^ '.header h1.heading { font-size: 2em; padding-top: 1.5em; margin-bottom: 0; color: white;}
.header h2 { font-size: 1.2em; margin-top: 0; padding-bottom: 1.25em; color: white;}
.header {background: #545454; color: white;}
.siteTitle {font-size:2em; margin-bottom:0.8em;padding-top:0.5em;}

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

pre.shout {
  -moz-box-shadow: 5px 5px 5px #ccc;
  -webkit-box-shadow: 5px 5px 5px #ccc;
  box-shadow: 5px 5px 5px #ccc;
}

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
.sidebar .blogPostTicker .timestamp,
.sidebar .blogPostTicker .summary {}
.sidebar .active,
.menu li a.active {
	color: white;
	background: #ff6633;}
.sidebar .sidebarDocument {
	padding-top: 0.3em;
}


/*MAIN BODY*/
.mainbody {
	padding-top: 4em;
	padding-bottom: 15em;}
.blogPostTicker ul {
	list-style: none;
	margin-left: 0;}
.blogPostTicker ul li {
	margin-bottom: 1.5em;}
.blogPostTicker .timestamp {display: inline; padding-left: 1em; color: #aaa; font-size: 80%;}
.blogPostTicker .subscribe,
.blogPostTicker .timestamp .time,
.blogPostTicker .timestamp .author {display: none;}


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
.socialSharingWidget a:hover { border:none;}

/*DEFAULT*/
body {
	font-family: Verdana,Helvetica,Geneva,sans-serif;
	font-size: 13px;
	line-height: 1.538em;
	margin-top: 0;}
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
a.view, a.command {color: gray;}
a.environment:after {content: "*";}
.right {text-align: right;}
.left {text-align: left;}
.center {text-align: center;}
.float {float: right;}
.nobullets ul {list-style: none; margin-left: 0;}
.nobullets ul li {list-style: none; margin-left: 0;}
th {background: #eee; font-weight: normal;}


a {
	color: royalBlue;
	text-decoration: none;
}

a:hover {
	border-bottom: 1px dotted;
	color: royalBlue;
}

.menu a {
    color: #FF6633;
}

.menu a:hover {
	color: white;
	background: #FF6633;
	border-bottom: 0px none;
}

h1 a {
	color:#545454;
}

h1 a:hover {
	color:#545454;
	background: white
}

h2.subHeading a {
	color:white;
}

h2.subHeading a:hover {
	color:#545454;
	background: white
}


/* BLOG template */
.blogArchiveTitle, .blogTagsTitle, .blogCloudTitle {
	border-bottom: 6px solid #dddddd;
	color: #444444;
	padding: 0 0 3px;
}

.blogArchiveTitle, .blogTagsTitle {
	border-bottom: 6px solid #dddddd;
	color: #444444;
	padding: 0 0 3px;
}

.blogArchive, .blogTags {
	text-align: right;
	font-size: 15px;
	color: #BBBBBB;
}

.blogArchive ul, .blogTags ul {
	margin: 0;
}

.blogArchive a, .blogTags a, .blogCloud a {
	color: #777777;
}

.meta {
	border-bottom: 1px solid;
}

div.post > div.meta {
	color: #333;
	background: #f3f3f3;
	padding: 5px 10px;
	margin: 0 0 30px 0;
	border-top: #bbb 1px solid;
}

div.meta > a.link {
	color: #333;
	font-weight: bold;
	margin-left: 10px;
}

div.meta > a.comment {
	color: #333;
	font-weight: bold;
	margin-left: 10px;
}

pre.shout, pre {
	background-color: #eee;
	border-radius: 5px 5px;
	padding: 5px;
	font-size: 0.9em;
}
'
]

{ #category : #templates }
PRBlogKernelDistribution >> rootTemplate [
	^ self mainTemplate
]

{ #category : #accessing }
PRBlogKernelDistribution >> sampleContentSelected [
	^ sampleContentSelected ifNil: [ sampleContentSelected := false ]
]

{ #category : #accessing }
PRBlogKernelDistribution >> sampleContentSelected: anObject [
	sampleContentSelected := anObject
]

{ #category : #'magritte description' }
PRBlogKernelDistribution >> sampleContentSelectedDescription [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'add sample content';
		accessor: #sampleContentSelected;
		componentClass: TWBSMagritteCheckboxComponent;
		priority: 600;
		yourself
]

{ #category : #creation }
PRBlogKernelDistribution >> showCustomizeUIOn: theCalleeComponent thenAddRootToKernel:  theKernel [
	calleeComponent := theCalleeComponent.
	^ super showCustomizeUIOn: theCalleeComponent thenAddRootToKernel:  theKernel
]

{ #category : #components }
PRBlogKernelDistribution >> sidebarDocumentWidget [
	^ sidebarDocumentWidget ifNil: [
		sidebarDocumentWidget := (PRComponent named: 'sidebarDocumentWidget')
			title: 'Sidebar Document';
			prototypeInstance: PRDocumentWidget new;
			yourself ]
]

{ #category : #components }
PRBlogKernelDistribution >> siteTitlePage [
	^ siteTitlePage ifNil: 
		[ siteTitlePage := (PRPage named: 'sitetitle')
			title: 'Site Title';
			contents: self kernel name;
			yourself ]
]

{ #category : #templates }
PRBlogKernelDistribution >> templates [
	^ Array with: self blogTemplate
]
