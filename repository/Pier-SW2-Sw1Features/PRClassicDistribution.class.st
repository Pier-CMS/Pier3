"
PRClassicDistribution is a design option that has only a limited number of options.  This is used for an internal wiki used at Amdocs.

Instance Variables:
	searchHelpPage	<PRPage>
	linkPath 			<PRComponent(PRPathNavigationWidget)>

Future Plans:
- Replace PRPathNavigationWidget with a core component
- Remove #mainEnvironmentPage - Resolve the date problem for the blog
- Remove #systemManagementPage - resolve the MessageNotUnderstood: MAExternalFileModel class>>baseDirectoryPath: in the file editor

For some instances, /System/Components/Sitemap should be viewable by admins only, for other cases it should be viewable to any logged in user - this can require manual actions (change others or change group) - not sure how to make this easier.
"
Class {
	#name : #PRClassicDistribution,
	#superclass : #PRDistribution,
	#instVars : [
		'searchHelpPage',
		'linkPath'
	],
	#category : #'Pier-SW2-Sw1Features'
}

{ #category : #accessing }
PRClassicDistribution class >> title [
	"Most similar to the original Smallwiki2"

	^ 'Classic'
]

{ #category : #structures }
PRClassicDistribution >> blogEnvironmentPage [
	^ blogEnvironmentPage ifNil: [
		blogEnvironmentPage := (PRPage named: 'blogenvironment')
		title: '_Blog Environment';
		contents: 
'{{{<div class="container">
	}}}+/system/components/header+{{{
	<div class="column span-16 last mainbody">
		<h1 class="heading">}}}*>value:structure|level=2*{{{</h1>
		<h1>}}}*>value:structure|level=0|lower=3*{{{</h1>
		<div class="column span-10 contents">
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
PRClassicDistribution >> environmentPage [
	^ environmentPage ifNil: [
		environmentPage := (PRPage named: 'environment')
		title: '_Environment';
		contents: 
'{{{<div class="container">
	}}}+/system/components/header+{{{
	<div class="column span-16 last mainbody">
		<h1 class="heading">}}}*value:structure*{{{</h1>
		<div class="column contents">
			}}}+/system/components/contents+{{{
		</div>
	</div>
	}}}+/system/components/footer+{{{
</div>}}}
+/system/components/googleanalytics+
';
		yourself
	]
]

{ #category : #accessing }
PRClassicDistribution >> linkPath [
	^ linkPath ifNil: [
		linkPath := (PRComponent named: 'linkPath')
			prototypeInstance: PRPathNavigationWidget new;
			yourself ]
]

{ #category : #structures }
PRClassicDistribution >> mainEnvironmentPage [
	^ mainEnvironmentPage ifNil: [
		mainEnvironmentPage := (PRPage named: 'mainenvironment')
		title: '_Main Environment';
		contents: 
'{{{<div class="container">
	}}}+/system/components/header+{{{
	<div class="column span-16 last mainbody">
		<h1 class="heading">}}}*value:structure*{{{</h1>
		<div class="contents column">}}}+/system/components/contents+{{{</div>
	</div>
	}}}+/system/components/footer+{{{
</div>}}}
';
		yourself
	]
]

{ #category : #structures }
PRClassicDistribution >> menuPage [
	^ menuWidget ifNil: 
		[ menuWidget := (PRPage named: 'menu')
			contents:
'- +../LinkPath+
- +../search+';
			yourself ]
]

{ #category : #creation }
PRClassicDistribution >> root [
	super root.
	self aboutPage addChild: self searchHelpPage.
	self componentsPage addChild: self linkPath.
	self makePrivate: self sitemapPage.
	^ self rootPage
]

{ #category : #accessing }
PRClassicDistribution >> searchHelpPage [
	^ searchHelpPage
		ifNil: [ 
			searchHelpPage := (PRPage named: 'searchhelp')
				title: 'Search Help';
				contents: 'Quick Guide - Type in text into the Search field and hit enter.  Results are displayed on the next page.

The search feature of Pier 2 is done by the text box in the top-right corner.  It treats each word as a token, with the ability to negate some words (any page containing those words will not be listed in the results).  If a string is enclosed in single quotes, then it is treated as a single token.  Adding a ==^== as the first character will make the search case-sensitive.

The results are case-insensitive, and do not depend on the order of the search terms.  The searching is done from the current page, and any page under the current page.  To search everything from the root, one must navigate there first.

!Examples
{{{<ul><li>}}}Starting from */information* and entering the text:
=current page
will find pages that contains both ==current== and ==page==.  Entering:
=+current +page
will find the same results (The plus sign in the beginning is ignored).
{{{</li><li>}}}Using dash to negate terms - reduce the number of results - if one searches with the text:
=-current page
or 
=page -current
then the results will be pages containing ==page== but not ==current==
{{{</li><li>}}}Using Quotes:
=''Current page''
Will search for any page that contains the words ==current page== in that order.
{{{</li><li>}}}Case-sensitive:
=^current
will only find pages that have current in lowercase
{{{</li></ul>}}}
_';
				yourself ]
]

{ #category : #structures }
PRClassicDistribution >> stylesheetFile [
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


/*DEFAULT - sizes customized*/
body {margin-top: 0;}
h1, h2, h3, h4, h5, h6 { margin: 0; font-weight: inherit; font-size: 100%; line-height: inherit; }
h1.heading { font-size: 2em; margin-bottom: 1.5em; }
h1 { font-size: 3em; line-height: 1; margin-bottom: 1em; }
.maincontents {font-size: 1.5em;}
h2 { font-size: 2.25em; height: 1.25em; line-height: 1.25; margin-bottom: 1.25em; }
h3 { font-size: 2em; font-weight: bold; margin-bottom: 1.5em; }
h4 { font-size: 1.5em; font-weight: bold; }
h5 { font-size: 1.25em; }
textarea {width: 100%;}
input.text, input.password {width: 150px;}
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

/* Customizations */
table.prtable {table-layout: auto; width: auto; border: inset 1px;}
table.prtable td {border: 1px solid;}

/* 2009-Aug-2 - Bold pre-formatted text should be the same size as normal per-formatted text */
pre b {font-size: 95%;}
code b {font-size: 95%;}

/* 2009-Oct-7 - Add todo items */
.TODO {color: red; background-color: yellow;}
.TODO a {color: #ff6633;}
.TODO a:hover {color: white; background: #ff6633; }

/* 2014-Nov-21 - Added so TOC works taken from PRStructure>>defaultEnvironment */
ul.toc { list-style: none; margin-left: 0; }
ul.toc li.toc-level-1 { margin-left: 0em; }
ul.toc li.toc-level-2 { margin-left: 1em; }
ul.toc li.toc-level-3 { margin-left: 2em; }
ul.toc li.toc-level-4 { margin-left: 3em; }
ul.toc li.toc-level-5 { margin-left: 4em; }
ul.toc li.toc-level-6 { margin-left: 5em; }
';
		yourself]
]

{ #category : #structures }
PRClassicDistribution >> systemManagementPage [
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
		contents: '!Users
+users+

!User Group
+groups+

!Persistency
+persistency+

!Kernel Settings
+kernel+';
		yourself
	]
]
