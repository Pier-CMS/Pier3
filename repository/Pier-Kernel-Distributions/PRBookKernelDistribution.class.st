Class {
	#name : #PRBookKernelDistribution,
	#superclass : #PRAbstractKernelSystemManagementDistribution,
	#instVars : [
		'rootPage',
		'book',
		'tableOfContents',
		'tableOfFigures',
		'index',
		'notesComponent',
		'section',
		'bookTemplate',
		'introduction',
		'mainTemplate',
		'bookSamplePierAdmin',
		'sampleContentSelected'
	],
	#category : #'Pier-Kernel-Distributions'
}

{ #category : #testing }
PRBookKernelDistribution class >> isAbstract [ 
	^ false
]

{ #category : #accessing }
PRBookKernelDistribution class >> label [
	^ 'Book Template'
]

{ #category : #accessing }
PRBookKernelDistribution class >> thumbnail [
	^ PRKernelDistributionFileLibrary / #bookthumbnailPng
]

{ #category : #'sample content' }
PRBookKernelDistribution >> addClassCommentsSubTreeTo: structure classes: classes [
	classes do: [ :each |
		| classAsString |
		classAsString := each greaseString.
		structure
			addChild: ((BOPortion named: classAsString)
				type: #section;
				title: classAsString;
				contents:
' ==', classAsString, '==''s class comment:

+value:source|class=', classAsString, '|comment+';
				yourself) ]
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> addSampleContent [
	self removeNode: self book.
	
	self rootPage
		addChild: self bookSamplePierAdmin.
		
	self rootPage
		contents: 'This is the main page of the Pier book distribution.

Jump to the sample *book>\pier-admin-book*, which describes Pier Admin.'.

	self setAdminUserGroupStartingAtStructure: self bookSamplePierAdmin
]

{ #category : #components }
PRBookKernelDistribution >> book [
	^ book ifNil: [
		book := (BOBook named: 'book')
			contents: 'This is a book';
			localEnvironment: self bookTemplate;
			addChild: self tableOfContents;
			addChild: self tableOfFigures;
			addChild: (self introduction
				addChild: self section;
				yourself);
			addChild: self index;
			yourself ]
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryAcknowledgement [
	^ (BOPortion named: 'acknowledgements')
		type: #section;
		title: 'Acknowledgements';
		contents:
'Pier Admin stands on the broad shoulders of *Pier CMS>http://www.piercms.com/about*  which was created and is maintained by *Lukas Renggli>http://www.lukas-renggli.ch/*. Pier admin was conceived at a Pier sprint in Eindhoven. The participants were:
- Adriaan van Os
- Louis Andriese 
- Thomas Noordzij 
- Julian Fitzell 
- Maarten Daalder
- Norbert Hartl 
- Bart Veenstra 
- Nick Ager
- Reza Razavi
- Stephan Eggermont 
- Friso Geerlings

The book stylesheet is based on the one used by *the Moose book>http://www.themoosebook.org/book* by Tudor Girbar.

The tree widget is based on integration work by Bart Veenstra.

Pier admin was largely created by *Nick Ager>http://twitter.com/nickager*, with help from those mentioned above.';
		yourself
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryClassReference [
	^ (BOPortion named: 'class-reference')
		type: #section;
		title: 'Class Reference';
		contents:
'Some of the key classes within Pier: 
*value:children|link*

The documentation is generated from the class comments';
		yourself
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryExportingAKernel [
	^ (BOPortion named: 'exporting-kernels')
		type: #section;
		title: 'Exporting a Kernel';
		contents:
'Exporting and importing the data stored in the kernel is useful for:
- backing up
- upgrading to a new release of Pier

Various methods:
- SIXX exporter
- File system persistence
- Magritte XML and JSON support
- Pier code exporter.

@@todo expand with examples

SIXX is a generic Smalltalk persistency mechanism, which can generate verbose output (eg it exports the document AST rather than just the wiki text). Export methods which understand the structure of the underlying data can be more efficient - such as the Pier-Code-Exporter.
';
		yourself

	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPermissioning [
	^ (BOPortion named: 'permissioning')
		type: #section;
		title: 'Permissioning';
		contents:
'See *../class-reference/PUSecurity*
@@todo expand
@@todo add class comment to ==PUPermission==';
		yourself

	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminFeatures [
	^ (BOPortion named: 'admin-features')
		type: #section;
		title: 'Pier Admin Features';
		contents:
'Pier Admin provides:
# A live preview of the site contents, synchronised with the admin UI.
# A WYSIWYG editor.
# Tree view of the site''s structure.
# From the tree view, a right click menu provides  the ability to edit nodes, add child nodes, rename nodes etc. 
# Editing uses all available space regardless of the content area defined by a site''s template.
# A configurable tabbed interface provides a convenient method for switching between views.
# Customisation via a ==/config== configurator.
# A mechanism for creating Pier sites, that requires the user to define an initial password. For security there is no default password.
# A structure for defining and sharing Pier site definitions, templates and samples (see: ==PRKernelDistributionBase==). Currently blog and book templates are defined.';
		yourself

	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminInsideAjaxUpdates [
	^ (BOPortion named: 'ajax-updates')
		type: #section;
		title: 'Ajax Updates';
		contents:
'There are three different types of requests:
- Initial full page request. Uses */pier-admin-book/under-the-hood/key-classes/PRAdminHtmlDocumentStoredHeadElements* to initially populate the loaded script and style caches. For the iFrame the initial request also uses */pier-admin-book/under-the-hood/key-classes/PRAdminIFrameDecorator*.
- Requests from within the main content use a *hijax>http://en.wikipedia.org/wiki/Hijax* approach and then simulate a request on the session, see */pier-admin-book/under-the-hood/key-classes/PRAdminHtmlDocumentSeparateBodyHeadElements*
- Requests from the admin UI (tabs, tree and commands), initiate an ajax script update, using an announcer to update multiple components.

@@todo Describe how Ajax updates occur - Difference between the update cycle of the main pane and that announcer based views - the view tabs, the global commands and the tree navigator.

+value:source|class=PRAdminUI|selector=renderViewOn:+
+value:source|class=PRAdminUI|selector=renderIFrameViewOn:+
+value:source|class=PRAdminUI|selector=renderResponseForUrl:requestType:callbackId:+
';
		yourself
		
		
		
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminInsideLivePreview [
	^ (BOPortion named: 'inside-preview')
		type: #section;
		title: 'Providing a live preview';
		contents:
'
The aims of the preview are:
# The preview should display the site as it appears outside the administrative interface. That is the preview should not be effected by the css and javascript used in the administration interface.
# Navigating within the preview should be reflected in the administration interface. For example the selected tree node should update as the user navigates around the live preview.

The implication of Item #1 is that the preview should be displayed within an iFrame - so that it can be isolated from the css and javascript of the administration UI.
However synchronising between the iFrame and the main Pier Admin view is tricky as, by default, the request-response cycle for each will use a different Seaside render-loop, resulting in separate session state. 

The initial solution, used some javascript (below), to redirect anchor clicks in the iFrame to requests on the main window (==top.location = this.href==).  
==((html jQuery: #preview) onLoad:
==		(((html jQuery: #preview) contents find: ''body'')
==			delegate: ''a''
==			on: ''click''
==			do: ''top.location = this.href'' asFunction ))

Although this approach worked, each click caused a whole page refresh and we felt that an ajax approach would be preferable.

@@todo describe the *hijax>http://en.wikipedia.org/wiki/Hijax* approach in more detail - how ajax response is injected into the iFrame from outside. The iFrame contents doesn''t contain any javascript specific to the pier administration interface - although anchors and forms are redirected to ajax calls within the main frame.';
		yourself
		
		
		
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminInsidePackages [
	^ (BOPortion named: 'packages')
		type: #section;
		title: 'Pier Admin''s packages ';
		contents:
'Pier Admin''s packages:
- *Seaside>http://seaside.st*.
- Pier - the base Pier classes
- Pier Addons, namely:
-- Pier-Blog 
-- Pier-Book
-- Pier-Design - allows editing of the site''s template and stylesheet.
-- Pier-Documents - Pier widget that contains a Pier document.
-- Pier-EditorEnh - Wiki editor''s toolbar and help support.
-- Pier-Google - support for *Google analytics>http://www.google.com/analytics/*
-- Pier-JQuery - jQuery widgets in Pier cycler and search
-- Pier-LinkChecker - shows all links in a document and allows them to be checked (contains bugs)
-- Pier-TagCloud - tag cloud
-- Pier-Wysiwyg - Pier WYSIWYG editor
-- Pier-FileUpload-Common-Wysiwyg
-- Pier-FileUpload-Wysiwyg - file upload support for the WYSIWYG editor
- JQWidgetBox-UILayout-Core layout allowing the left column to be collapsed
- JQWidgetBox-JSTree-Core - tree widget.';
		yourself
		
		
		
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminInsideTheWysiwygEditor [
	^ (BOPortion named: 'inside-wysiwyg-editor')
		type: #section;
		title: 'Inside the WYSIWYG editor';
		contents:
'The WYSIWYG editor includes an Html parser. The Html parser is written in Javascript as the parser leverages the browser''s ability to interpret Html. The WYSIWYG editor''s Javascript parser walks the browser''s DOM, and translates DOM nodes into Pier wiki format. There''s a set of *tests>http://localhost:8080/tests/testwysiwgParser* associated with the parser.

@@todo describe the file upload implementation';
		addChild: ((BOPortion named: 'wysiwyg-onSelectTabJSOn')
			type: #subsection;
			title: 'PRWysiwygEditor>>#onSelectTabJSOn:';
			contents:'Flipping between tabs 
|!From|!To|!Description|
|WYSIWYG|Wiki view|Parse the WYSIWYG editor''s Html with the Javascript parser.|
|Wiki view|WYSIWYG|Ajax request with wiki text, with the response containing the resultant Html.|
			+value:source|class=PRWysiwygEditor|selector=onSelectTabJSOn:+';
			yourself);
		addChild: ((BOPortion named: 'wysiwyg-renderPreviewOn')
			type: #subsection;
			title: 'PRWysiwygEditor>>#renderPreviewOn:';
			contents:'+value:source|class=PRWysiwygEditor|selector=renderPreviewOn:+';
			yourself);
		addChild: ((BOPortion named: 'wysiwyg-renderSetEditorHtmlContentJS')
			type: #subsection;
			title: 'PRWysiwygEditor>>#renderSetEditorHtmlContentJS';
			contents: 'Render the html contents for the WYSIWYG editor: +value:source|class=PRWysiwygEditor|selector=renderSetEditorHtmlContentJS+';
			yourself);
		yourself
		
		
		
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminInstallation [
	^ (BOPortion named: 'installation')
		type: #section;
		title: 'Pier Admin Installation';
		contents: self installationInstructions;
		yourself

	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminKeyClasses [
	| keyClassesStructure |
	keyClassesStructure := (BOPortion named: 'key-classes')
		type: #section;
		title: 'Key classes';
		contents: 'Some key classes: *value:children|link*';
		yourself.
		
	self addClassCommentsSubTreeTo: keyClassesStructure classes: self keyPierAdminClassses.
	
	^ keyClassesStructure
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminMotivation [
	^ (BOPortion named: 'motivation')
		type: #section;
		title: 'Motivation for the administration interface';
		contents:
'Pier Admin''s purpose is to improve the usablity of Pier''s administration features. Pier sites have traditionally included links to administrative tools within the site''s template (environment). Pier Admin instead provides an administration interface which is available from a separate url. Some of the benefits of this approach include:
# Focus the site''s template (environment) on the content of the site and not to be worried about the administrative interface.
# Simplify the site''s template definition by removing the administration tools. 
# Eliminate the concern that editing the site''s template can break the admin interface.
# Provide a consistent administration interface across all Pier sites.
# Allow separate security to be applied to the administration url.
# Provide a more intuitive interface to Pier.
@@note It is also possible to combine approaches by including some adminstration features directly in the site and use the admin UI for others.';
		yourself
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminOverview [
	^ (BOPortion named: 'overview')
		type: #chapter;
		title: 'Pier Admin Overview';
		contents: 'Pier Admin provides an administrative interface to *Pier>http://piercms.com*. An introduction to the interface:

{{{<iframe src="http://player.vimeo.com/video/32749535?title=0&byline=0&portrait=0&color=0" width="400" height="300" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>}}}

*value:children|link*';
		yourself

]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminUIBugsAndOmissions [
	^ (BOPortion named: 'bugs')
		type: #section;
		title: 'Admin UI bugs and missing features';
		contents: '*value:children|link*
		
see also *WYSIWYG editor bugs>/pier-admin-book/overview/wysiwyg-editor-capabilities/wysiwyg-known-bugs*';
		addChild: ((BOPortion named: 'admin-ui-bugs-rearranging-content')
			type: #subsection;
			title: 'Rearranging content';
			contents: 'Rearranging content in the structure tree would ideally be performed through a drag and drop interface. Although the admin UI tree control supports drag and drop, it might be worth reviewing available tree widgets to see if there are controls that work well with a touch interface and integrate those controls instead.

Currently rearranging content, copying nodes uses the traditional Pier interface. Unfortunately this means the client-site tree becomes out of sync with the server kernel. As a work-around, use the "Refresh Navigator" button to rebuild the tree from the server-side state. 
@@note Maintaining the client tree state and server state in sync is an unsolved problem.';
			yourself);
		addChild: ((BOPortion named: 'admin-ui-bugs-first-child')
			type: #subsection;
			title: 'First child bug';
			contents: 'When adding the first child to a node, the tree will add two children. This appears to be a client jstree bug - though more work is required to confirm. To work-around use the "Refresh Navigator" button to reload the tree.';
			yourself);
		addChild: ((BOPortion named: 'admin-ui-bugs-style-bleeding')
			type: #subsection;
			title: 'Style bleeding';
			contents: 'Site styles can effect the Admin UI. Site styles are loaded into the admin UI to allow custom commands and views to be executed - for example the WYSIWYG editor pulls in numerous styles. Gradually the admin UI styles are being "hardened" to combant style infection from Pier sites being administered.';
			yourself);
		addChild: ((BOPortion named: 'admin-ui-bugs-fixed-size-preview')
			type: #subsection;
			title: 'Fixed size preview';
			contents: 'The preview iFrame has a fixed size - would be great to make it size dynamically based on the content height';
			yourself);
		addChild: ((BOPortion named: 'admin-ui-bugs-url-update')
			type: #subsection;
			title: 'Address bar update';
			contents: 'Currently the address bar doesn''t update as site map is navigated in the administrative UI, unlike  Pier sites, resulting in surprising behaviour when using the back button.';
			yourself);
		addChild: ((BOPortion named: 'admin-ui-missing-features-blog-importer')
			type: #subsection;
			title: 'Blog importer';
			contents: 'To help developers migrate from Wordpress and Blogger a blog importer would be a valuable feature. The importer could use an existing blogs RSS feed, to create Pier blog posts.';
			yourself);
		addChild: ((BOPortion named: 'admin-ui-missing-features-style-importer')
			type: #subsection;
			title: 'Wordpress style importer';
			contents: 'Another impediment to adoption of Pier blogs is the limited selection of styles available, an area in which Wordpress excels. To encourage adoption the ability to import Wordpress blog themes/styles would be a valuable feature.';
			yourself);

		yourself

	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminUnderTheHood [
	^ (BOPortion named: 'under-the-hood')
		type: #chapter;
		title: 'Pier Admin Under the Hood';
		contents: '*value:children|link*';
		yourself

]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierAdminjQueryGotchas [
	^ (BOPortion named: 'jquery-gotchas')
		type: #section;
		title: 'jQuery Gotchas';
		contents:
'
When updating the iframe content, you need to update the head content (to add scripts, styles) as well as the body content. Unfortunately jQuery handles ajax updates that include script tags in a ''special'' way (see jQuery internal method ==domManip( args, table, callback)==). jQuery extracts any script tags and creates non-asychronous ajax script requests. The jQuery special handling, ends up evaluating the script in the context of the main window (not the iframe), resulting in scripts not being available to the iframe when updated via ajax. 
I created a function ==evalScriptWithinIFrame(script)== to solve the problem. However the result of this is that we have to pull out the scripts we send to ==evalScriptWithinIFrame(script)==. I do this with a custom document class - */pier-admin-book/under-the-hood/key-classes/PRAdminHtmlDocumentSeparateBodyHeadElements* - which stores the separate sections of the head, rather than rendering html head output. I could have achieved a similar result using client site regex ala ==JQAjaxifierLibrary>>#ajaxifierJs== but that seems rather ugly and brittle.

A further complication arises if you reevaluate the jQuery libraries you loose jQuery extensions. For example, JQueryTree ''disappears'' as a JQuery extension if I reload the jQueryUI library, that is calling something like ==$("#menu").jstree(xxx)== - will fail as jstree is no longer registered.
The solution I''ve developed to the above is to cache a list of all the libraries I''ve loaded into the main frame or the iframe so that I don''t reload a library which has already been loaded. There are a set of javascript functions which compare scripts and styles to a cached set. For the iFrame: ==addIFrameStyleIfNotAlreadyInstalled()==,  ==addIFrameScriptUrlIfNotAlreadyInstalled()==, ==addIFrameScriptIfNotAlreadyInstalled()== and for the main window: ==addStyleIfNotAlreadyInstalled()==, ==addScriptIfNotAlreadyInstalled()==,  ==addScriptUrlIfNotAlreadyInstalled()==. 
@@note caching styles isn''t strictly necessary but prevents the browser requesting the same styles multiple times. I also found that loading a set of style files after each update would cause the UI to flicker as differing styles are applied.

@@todo describe how jQuery libraries have to be served locally otherwise the jQuery ajax call to load the scripts fails with a cross-site-scripting security error';
		yourself
		
		
		
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierBriefIntroduction [
	^ (BOPortion named: 'pier-brief-introduction')
		type: #chapter;
		title: 'A brief introduction to Pier ';
		contents: '
@@todo I think we need something like: ''''A gentle introduction to Pier for Seaside developers''''. 
		
Pier is an extensible CMS built on Seaside, a brief introduction is available *here>>http://www.piercms.com/doc*.

In Pier every component has access to an associated structure to store it''s persistent state. With this consistent use of structures, Pier can then provide features that work across all content such as search, tag clouds, persistency mechanisms, editing history etc. Pier also provides access-control, user management, bookmarkable URLs, as well as numerous useful widgets out of the box. Seaside components can also be embedded within Pier structures.

Pier also supports rich-text documents, which are stored within a document *AST>http://en.wikipedia.org/wiki/Abstract_syntax_tree*. Pier supports rich-text parsing and generatation in a variety for formats, see *../pier-brief-introduction/class-reference/PRDocument*

*value:children|link*';
		yourself
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierPRCommand [
	^ (BOPortion named: 'PRCommand')
		type: #section;
		title: 'PRCommand';
		contents:
'
@@todo expand on the class comment below; when to use ==PRCommand== and when to use traditional Seaside ==#show:==, ==#answer:== - when kernel data is mutated. What does this mean in practice?

 ==PRCommand==''s class comment:
+value:source|class=PRCommand|comment+
';
		yourself
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierPRContentsWidget [
	^ (BOPortion named: 'PRContentsWidget')
		type: #section;
		title: 'PRContentsWidget';
		contents:
'Holds the component created from the current structure and command. It is the central Seaside component in every page. 

+value:source|class=PRContentsWidget|selector=buildComponent:+
';
		yourself
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierPRDefaultView [
	^ (BOPortion named: 'PRDefaultView')
		type: #section;
		title: 'PRDefaultView';
		contents:
'@@todo describe ==PRDefaultView==.

+value:source|class=PRDefaultView+';
		yourself

]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierPRDocument [
	^ (BOPortion named: 'PRDocument')
		type: #section;
		title: 'PRDocument';
		contents:
'Wiki markup can be easily translated into a ==PRDocument==:

==PRDocumentParser parse: ''Here is some ""bold"" text''. 

See: */pier-admin-book/overview/wiki-syntax*

@@todo Expand:. The value of storing a document *AST>http://en.wikipedia.org/wiki/Abstract_syntax_tree* vs raw Html (avoiding dangerous html submitted by "bad guys", ease of translating to other formats eg plain-text, html, wiki-format, *LaTeX>http://en.wikipedia.org/wiki/LaTeX*, possibly in the future ebook formats, Seaside code etc.).

Generating html from the wiki-markup:

==WARenderCanvas builder render: [ :html |
==	| renderer document |
==	document := PRDocumentParser parse: ''Here is some ""bold"" text''.
==	renderer := PRViewRenderer new.
==	renderer withinContentDo: [ 
==		renderer start: document in: self on: html ] ]

@@todo expand: ==PRDocument==s use a visitor pattern to extract information from Pier''s document AST. See classes derived from *../PRVisitor*

 ==PRDocument==''s class comment:
+value:source|class=PRDocument|comment+

See also *../PRDocumentWriter*';
		yourself
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierPRPierFrame [
	^ (BOPortion named: 'PRPierFrame')
		type: #section;
		title: 'PRPierFrame';
		contents:
'Pier''s Seaside root component. Owns the *context>../PRContext*, parses the url and generates the ==#children== collection based on the current envrionment and selected structure.
';
		yourself
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierPRStructure [
	^ (BOPortion named: 'PRStructure')
		type: #section;
		title: 'PRStructure';
		contents:
'The ''model'' portion of Pier elements; stores the data. There are structures associated with books, book chapters, sections etc, blogs, blog entries,  pages all based on ==PRStructure==. 

 ==PRStructure==''s class comment:

+value:source|class=PRStructure|comment+

@@todo expand';
		yourself
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryPierPRWidget [
	^ (BOPortion named: 'PRWidget')
		type: #section;
		title: 'PRWidget';
		contents:
'@@todo difference between ==WAComponent== and ==PRWidget== - access to the context, properties and the concept of an owner. Difference between a ==PRWidget== and a ==PRViewComponent== 

@@todo create a ''hello world'' equivalent for Pier using a ==PRWidget== derived class.

+value:source|class=PRWidget+

@@todo expand';
		yourself
	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryStructureNavigating [
	^ (BOPortion named: 'structure-navigating')
		type: #section;
		title: 'Navigating Pier''s structures';
		contents:
'Pier''s ==PRStructure== contains a reference to it''s parent and a ==childrenDecoration== method which returns a ==PRChildren== decoration containing a reference to the children.

@@todo why are the children added as a decoration and not directly as an instance collection to ==PRStructure==?

!!Navigating up the structure tree
The ==findAncestor:== method on ==PRStructure== iterates up the structure tree until the block returns true or the root is reached. For example:
+value:source|class=PBPostFilter|selector=findPost+

!!Searching children
Enumerating child structures uses the collection protocol (==do:==, ==collect:==, ==select:== .. etc) accessed through the ==enumerator== method on ==PRStructure==. You can cascade calls to ==with== and ==all== which respectively include the start structure in the enumeration and visit structures recursively. For example:
+value:source|class=BONoteWidget|selector=notes+
and:
+value:source|class=PRValueLink|selector=randomIn:+
';
		yourself

	
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryWikiSyntax [
	^ (BOPortion named: 'wiki-syntax')
		type: #section;
		title: 'Wiki syntax';
		contents: PRKernel defaultInfoSyntax contents;
		yourself
]

{ #category : #'sample content' }
PRBookKernelDistribution >> bookEntryWysiwygEditorFeatures [
	^ (BOPortion named: 'wysiwyg-editor-capabilities')
		type: #section;
		title: 'WYSIWYG Editor Capabilities';
		contents:
'The WYSIWYG editor is designed for entering simple rich-text. ', PRWysiwygEditorExample editorSupportInfo, '

@@note Rich text can be pasted into the WYSIWYG editor. The editor will sanitise pasted text, striping out any extraneous HTML tags not supported by the wiki markup.

The WYSIWYG editor also provides a UI for internal and external links and file upload.

Not all markup is possible to create in WYSIWYG mode, however the editor aims to preserve all markup and allows editing of markup created in wiki mode. For example annotated paragraphs can be created in wiki mode, then edited in a WYSIWYG mode. Special Pier markup such as verbatim, embedded links, value-links etc are shown and preserved in the WYSIWYG editor, but are not editable. Currently the  WYSIWYG editor maintains but doesn''t allow insertion of the following:
- definition list and definitions
- preformatted text.
- shout code formatting.
- named anchors
- mail to: links
- annotated paragraphs
- value links
- annotations
- verbatim content
- tables
- embedded links
@@todo describe the editor''s permissioning features; enabling and disabling WYSIWYG, wiki and preview views based on user permissions.
see also *ref:/pier-admin-book/under-the-hood/inside-wysiwyg-editor*';
		addChild: ((BOPortion named: 'wysiwyg-known-bugs')
			type: #subsection;
			title: 'Known WYSIWYG editor bugs';
			contents:'
When initially released the WYSIWYG editor didn''t support nested lists and tables. The WYSIWYG editor now correctly parses nested lists and tables along with book index links. Please report any markup that is lost or corrupted.';
			yourself);
		yourself

	
]

{ #category : #components }
PRBookKernelDistribution >> bookSamplePierAdmin [
	^ bookSamplePierAdmin ifNil: [
		| pierClassReference |
		bookSamplePierAdmin := (BOBook named: 'pier-admin-book')
			title: 'Pier Admin Documentation';
			localEnvironment: self bookTemplate;
			contents: 
'!+value:structure|title+
{{{<div class="table-of-contents">}}}*value:book.contents|target=/pier-admin-book*{{{</div>}}}
{{{<div class="table-of-figures">}}}*value:book.figures|target=/pier-admin-book*{{{</div>}}}';
			addChild: (self bookEntryPierAdminOverview
				addChild: self bookEntryPierAdminMotivation;
				addChild: self bookEntryPierAdminFeatures;
				addChild: self bookEntryPierAdminInstallation;
				addChild: self bookEntryWysiwygEditorFeatures;
				addChild: self bookEntryPierAdminUIBugsAndOmissions;
				addChild: self bookEntryAcknowledgement;
				addChild: self bookEntryWikiSyntax;
				yourself);
			addChild: (self bookEntryPierAdminUnderTheHood
				addChild: self bookEntryPierAdminInsidePackages;
				addChild: self bookEntryPierAdminInsideLivePreview;
				addChild: self bookEntryPierAdminjQueryGotchas;
				addChild: self bookEntryPierAdminInsideAjaxUpdates;
				addChild: self bookEntryPierAdminKeyClasses;
				addChild: self bookEntryPierAdminInsideTheWysiwygEditor;
				yourself);
			addChild: (self bookEntryPierBriefIntroduction
				addChild: self bookEntryStructureNavigating;
				addChild: self bookEntryExportingAKernel;
				addChild: self bookEntryPermissioning;
				addChild: (pierClassReference := self bookEntryClassReference
					addChild: self bookEntryPierPRDocument;
					addChild: self bookEntryPierPRStructure;
					addChild: self bookEntryPierPRPierFrame;
					addChild: self bookEntryPierPRWidget;
					addChild: self bookEntryPierPRCommand;
					addChild: self bookEntryPierPRContentsWidget;
					addChild: self bookEntryPierPRDefaultView;
					yourself);
				yourself);
			yourself.
		
		self addClassCommentsSubTreeTo: pierClassReference classes: self interestingClassesWithComments.
		bookSamplePierAdmin ]
]

{ #category : #templates }
PRBookKernelDistribution >> bookTemplate [
	^ bookTemplate ifNil: [
		bookTemplate := (PRPage named: 'bookTemplate')
		title: '_BookTemplate';
		contents: 
'{{{<div class="wrap">
  <div class="body">
    <div class="main">
      <h1 class="capt"><span>}}}*>value:structure|display=number*{{{</span>}}}*value:structure|link*{{{</h1>
      }}}+/system/contents+{{{
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
		yourself ]
]

{ #category : #components }
PRBookKernelDistribution >> components [
	^ OrderedCollection new
		add: self footerPage;
		add: self poweredPage;
		add: self searchWidget;
		add: self notesComponent;
		yourself
]

{ #category : #creation }
PRBookKernelDistribution >> createRootOn: theKernel [
	super createRootOn: theKernel.
	
	self sampleContentSelected ifTrue: [
		self addSampleContent ].
	
	self clearInternalLinkTargetsStartingAt: theKernel root.
	
	^ theKernel
]

{ #category : #'magritte description' }
PRBookKernelDistribution >> descriptionContainer [
	<magritteContainer>
	^ super descriptionContainer
		componentRenderer: TWBSMagritteFormRenderer;
		yourself
]

{ #category : #components }
PRBookKernelDistribution >> index [
	^ index ifNil: [ index := (BOPortion named: 'index')
		type: #chapter;
		title: 'Keyword index';
		contents: '{{{<div class="keyword-index">}}}*value:book.index|target=/book*{{{</div>}}}';
		numberedTitle: false;
		yourself ]


]

{ #category : #'sample content' }
PRBookKernelDistribution >> interestingClassesWithComments [
	^ #(PRKernel PRContext PRAddCommand PREditCommand PRViewCommand PRCase PRPage PRDecoration PRChildren PRLink PRInternalLink PRValueLink PRVisitor PRDocumentWriter PRFullTextSearch PRPathLookup PRIncomingReferences PROutgoingReferences PUSecurity PRSettingsCommand MAContainer MADescription)
]

{ #category : #components }
PRBookKernelDistribution >> introduction [
	^ introduction ifNil: [ introduction := (BOPortion named: 'introduction')
		type: #chapter;
		contents: 'A book is formed by chapters. This is a chapter.
You can define references like: +ref:section+.

You can define +index:keywords!keywords+ keywords that appear automatically in the keyword index.';
		yourself ]

]

{ #category : #'sample content' }
PRBookKernelDistribution >> keyPierAdminClassses [
	^ #(PRAdminActionPhaseContinuation PRAdminContext PRAdminHtmlDocumentSeparateBodyHeadElements PRAdminHtmlDocumentStoredHeadElements PRAdminHtmlRoot PRAdminIFrameDecorator #PRAdminPierComponent PRAdminRenderPhaseContinuation PRAdminRequestContext #PRAdminSetup PRAdminUI)
]

{ #category : #templates }
PRBookKernelDistribution >> mainTemplate [
	^ mainTemplate ifNil: [
		mainTemplate := (PRPage named: 'mainTemplate')
		title: '_MainTemplate';
		contents: 
'{{{<div class="wrap">
  <div class="body">
    <div class="main">
      <h1 class="capt">}}}*>value:structure*{{{</h1>
      }}}+/system/contents+{{{
    </div>
    <div class="clear"></div>
  </div>
</div>}}}
+/system/components/notes+{{{
<div class="foot">}}}+/system/components/footer+{{{</div>}}}
+/system/components/googleanalytics+
';
		yourself ]
]

{ #category : #components }
PRBookKernelDistribution >> notesComponent [
	^ notesComponent ifNil: [ notesComponent := 
		(PRComponent named: 'notes')
			title: 'Notes';
			prototypeInstance: BONoteWidget new;
			yourself ]
]

{ #category : #components }
PRBookKernelDistribution >> rootPage [
	^ rootPage ifNil: [
		rootPage := (PRPage named: 'pier')
			title: 'Welcome to Pier!';
			yourself.

		rootPage 
			contents:
'This is the main page of the Pier book distribution.

Jump to the *book>\book*.'.
		rootPage
			addChild: self book.
		
		rootPage ]
]

{ #category : #stylesheets }
PRBookKernelDistribution >> rootStyleSheetContents [
	^
'a:hover img {background: none;}
.about dd {font-family: Georgia, "Lucida Bright", "Times New Roman", serif; font-style: italic;}

code, pre {font-size: 0.9em;}

.clear {clear: both;}

pre.shout {
  -moz-box-shadow: 5px 5px 5px #ccc;
  -webkit-box-shadow: 5px 5px 5px #ccc;
  box-shadow: 5px 5px 5px #ccc;
}

/* TOOLS */
.inline, .inline p, .inline div { display: inline; }

/* ANNOTATIONS */
p.blockquote { padding: 0.8em; margin-left: 2em; margin-bottom: 1em; }
p.todo { color: red; }
p.todo:before { color: red; content: "TODO"; }
p.note { padding: 0.8em; margin-bottom: 1em; background: #eeeeee; -moz-border-radius: 0.5em; -webkit-border-radius: 0.5em; border-radius: 0.5em; }
p.note:before { color: #777; content: "Note"; }
p.note {font-style: italic;}
p.todo {  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; position: relative; }
p.todo:before, p.note:before {left: -20%; width: 18%; text-align: right; position: absolute; }
 
/* === head === */
.head {
	margin-left: 1em;
	margin-right: 1em;
	height: 44px;
	text-align: left;
	position: relative;
	-moz-border-radius: 1em;
	-webkit-border-radius: 1em; 
	border-radius: 1em;
}
.head img{max-width: 200px;}
.head h1 {
	float: left;
	margin: 10px;
	margin-left: 20px;
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
	margin: 1em;
	padding-top: 10ex;
	padding-bottom: 10ex;
	background-color: #FFF;
	border: 1px solid #CCC;
	-moz-border-radius: 1em;
	-webkit-border-radius: 1em; 
}
.body {
	margin: auto 10%;
	text-align: left;}
 
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
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-size: 90%;
	display: block;
	text-align: center;
	font-weight: normal;
	color: #888;
	margin-top: 1em;
}
.main div.figure label span {font-weight: italic;}
.main img {
	max-width: 100%;
}

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
 
.main .keyword-index dl { position: relative; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
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

.side ul {list-style: none; margin-left: 0;}

/* === footers === */
.admin, .footer { 
	padding: 2em;
	padding-bottom: 0;
	background-repeat: repeat-x;
	background-color: #DDD;
}
.hidden {
	width: 0px;
	height: 0px;
	left: -1000px;
	position: absolute;}
 
/* --- notes --- */
.notes { 
	border: 1px solid #CCC;
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	text-align: left;
	margin: 1em;
	background-color: #eee;
	padding-left: 10%;
	padding-right: 10%;
	padding-top: 10ex;
	padding-bottom: 10ex;
	-moz-border-radius: 1em;
	-webkit-border-radius: 1em;  }
.notes h1 { font-size: 1.5em; line-height: 1; margin-bottom: 1em; }
.notes .listing {margin-bottom: 2em;}
.notes .listing .note { margin-bottom: 1em; }
.notes .listing .note .meta { border-bottom: 1px solid #ddd; margin-bottom: 1em; }
.notes .listing .note .meta .author { font-weight: normal; }
.notes .listing .note .meta .publication { font-size: 80%; }
.notes .listing .note .meta .commands { float: right; }
.notes .listing .note .body { margin: 0; font: 1em ''andale mono'', ''lucida console'', monospace; line-height: 1.5; }
.notes .listing .note .body p { margin: 0; }
.notes .addnote th { width: 120px; background: none;}
.notes .addnote textarea { height: 100px; width: 90%; }
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
.footer { font-size: 0.7em; font-style: italic; }
.footer p { text-align: center; }
 
/* === pages === */
body.book h1.capt { display: none; }
#body.book img { margin: 0; max-width: 515px; }

/*DEFAULT*/
textarea {width: 100%; max-width: 100%;}
p, li, dd, dt { text-align: left; }
dl dt {font-weight: normal;}
body { font-family: Georgia, "Lucida Bright", "Times New Roman", serif; font-size: 100%; margin: 0; background-color: #ddd;}
table, tr, td, th { margin: 0; border: 0; padding-left: 0; }
td, th {padding-left: 0.5em;}
table { margin-bottom: 1.6em; }
h1, h2, h3, h4, h5, h6 { font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
h1 a, h2 a, h3 a, h4 a, h5 a, h5 a, h6 a { color: #222; text-decoration: none; outline: none; }
.nohover a:hover { color: inherit; background: none;}
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
form { font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;  }

/* PIER */
.errors, .broken { color: red; font-weight: bold;}
.error, .notice, .success { border: none; }
.protected { color: #aaa; }
a {color: #0066CC; text-decoration: none;}
a:hover, a.external:hover {background: #0066CC; color: white;}
a:hover.nobackground {background: white;}
a.view, a.command {color: gray;}
a.external { background: url(data:image/png;base64,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) right center no-repeat; padding-right: 14px; }
a {text-decoration: none;}
.right {text-align: right;}
.left {text-align: left;}
.center {text-align: center;}
tr th {background: #eee; font-weight: normal; -moz-border-radius: 0.5em; -webkit-border-radius: 0.5em; border-radius: 0.5em;}
tr.group th {background: white; font-size: 1em; font-weight: bold; margin-top: 1.5em; }
td.required:after {color: #ff6633; content: "*"; margin-left: 0.5em;}

span.aggregatedEdit {
	font-size: 14px; float: right; position: relative !important;
}

span.aggregatedEdit a {
	color: #0066cc;
}

span.aggregatedEdit a:hover {
	color: white;
}'
]

{ #category : #templates }
PRBookKernelDistribution >> rootTemplate [
	^ self mainTemplate
]

{ #category : #accessing }
PRBookKernelDistribution >> sampleContentSelected [
	^ sampleContentSelected ifNil: [ sampleContentSelected := true ]
]

{ #category : #accessing }
PRBookKernelDistribution >> sampleContentSelected: anObject [
	sampleContentSelected := anObject
]

{ #category : #'magritte description' }
PRBookKernelDistribution >> sampleContentSelectedDescription [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'add sample content';
		accessor: #sampleContentSelected;
		componentClass: TWBSMagritteCheckboxComponent;
		priority: 600;
		yourself
]

{ #category : #components }
PRBookKernelDistribution >> section [
	^ section ifNil: [ section := (BOPortion named: 'section')
		type: #section;
		contents: 'This is a section.
@@todo this is a todo annotation.

@@note this is a note annotation.
';
		yourself ]
]

{ #category : #components }
PRBookKernelDistribution >> tableOfContents [
	^ tableOfContents ifNil: [ tableOfContents := (BOPortion named: 'table-of-contents')
		title: 'Table of contents';
		type: #chapter;
		contents: '{{{<div class="table-of-contents">}}}*value:book.contents|target=/book*{{{</div>}}}';
		numberedTitle: false;
		yourself ]

]

{ #category : #components }
PRBookKernelDistribution >> tableOfFigures [
	^ tableOfFigures ifNil: [ tableOfFigures := (BOPortion named: 'table-of-figures')
		title: 'Table of figures';
		type: #chapter;
		contents: '{{{<div class="table-of-figures">}}}*value:book.figures|target=/book*{{{</div>}}}';
		numberedTitle: false;
		yourself ]


]

{ #category : #templates }
PRBookKernelDistribution >> templates [
	^ Array with: self bookTemplate
]
