"
PRTestWysiwgEditorParser is derived from JSJasmineBaseTestRunner, which is checked into:
 * repository: http://www.squeaksource.com/Seaside30Addons
 * package: Javascript-Jasmine
"
Class {
	#name : #PRTestWysiwgEditorParser,
	#superclass : #JSJasmineBaseTestRunner,
	#category : #'Pier-Tests-Wysiwyg'
}

{ #category : #'class initialization' }
PRTestWysiwgEditorParser class >> initialize [
	| application |
	application := WAAdmin register: self asApplicationAt: 'tests/testwysiwgParser'.
	
	"need to use JQScriptGenerator as the default generator (WADefaultScriptGenerator) adds an onload handler to the body tag,
	which the overrides the onload used by the test runner"
	application preferenceAt: #scriptGeneratorClass put: JQScriptGenerator.
]

{ #category : #tests }
PRTestWysiwgEditorParser >> testsToRun [
	^ '
describe("Parser", function() {
	beforeEach(function() {
		this.addMatchers({
			shouldParseInto: function(expectedWikiOuput) {
      			var newDiv = document.createElement("div");
      			newDiv.innerHTML = this.actual;
				var parsedResult = parseHtmlToPierWikiSyntax (newDiv, "/pier");
				var result = (parsedResult == expectedWikiOuput);
				if (!result) {
					expect(parsedResult).toEqual(expectedWikiOuput);
				}
				return result;
			}
		});
	});

	it("should translate annotated paragraphs", function() {
		expect("<p class=''annotated note''>a note</p>").shouldParseInto("@@note a note\n");
	});


	it("should translate normal paragraphs", function() {
		expect("<p>a paragraph</p>").shouldParseInto("a paragraph\n");
	});
	
	describe("lists", function() {
		it("should translate unordered lists", function() {
			expect("<ul><li>bullet 1</li><li>bullet 2</li></ul>").shouldParseInto("- bullet 1\n- bullet 2\n");
		});
	
		it("should translate ordered lists", function() {
			expect("<ol><li>item 1</li><li>item 2</li></ol>").shouldParseInto("# item 1\n# item 2\n");
		});
	
		it("should translate lists when surrounded by spurious inline markup", function() {
			expect("<b><ol><li>item 1</li><li>item 2</li></ol></b>").shouldParseInto("# item 1\n# item 2\n");
		});
	
		it("should translate lists when surrounded by spurious inline markup #2", function() {
			expect("<i><ol><li>item 1</li><li>item 2</li></ol></i>").shouldParseInto("# item 1\n# item 2\n");
		});
		
		it("should translate nested lists", function() {
			expect("<ul><li>Item 1<ul><li>Item11</li><li>Item12</li></ul></li><li>Item 2</li></ul>").shouldParseInto("- Item 1\n-- Item11\n-- Item12\n- Item 2\n");
		});
				
		it("should translate a definition list", function() {
			expect("<dl><dt>word</dt><dd>a definition</dd></dl>").shouldParseInto(";word\n:a definition\n");
		});	
	});
	
	it("should translate bold", function() {
		expect("<b>bold</b>").shouldParseInto("\"\"bold\"\"");
	});
	
	it("should translate strong", function() {
		expect("<strong>strong</strong>").shouldParseInto("\"\"strong\"\"");
	});
	
	it("should translate italic", function() {
		expect("<i>italic</i>").shouldParseInto("''''italic''''");
	});
	
	it("should translate emphasized", function() {
		expect("<em>emphasized</em>").shouldParseInto("''''emphasized''''");
	});
	
	it("should translate inserted", function() {
		expect("<ins>inserted</ins>").shouldParseInto("__inserted__");
	});
	
	it("should translate underlined", function() {
		expect("<u>underlined</u>").shouldParseInto("__underlined__");
	});
	
	it("should translate deleted", function() {
		expect("<del>deleted</del>").shouldParseInto("--deleted--");
	});
	
	it("should translate code", function() {
		expect("<code>code</code>").shouldParseInto("==code==");
	});
	
	it("should translate subscript", function() {
		expect("<sub>subscript</sub>").shouldParseInto("@@subscript@@");
	});
	
	it("should translate superscript", function() {
		expect("<sup>superscript</sup>").shouldParseInto("^^superscript^^");
	});
	
	it("should ignore spans", function() {
		expect("<span>ignore span</span>").shouldParseInto("ignore span");
	});
	
	it("should ignore divs", function() {
		expect("<div>ignore div</div>").shouldParseInto("ignore div\n");
	});
	
	describe("using links", function() {
		it("should preserve embedded links", function() {
			expect("<span class=''pierEmbeddedLink yui-noedit pierNonEditable''>+/system/components/designchooser+</span>").shouldParseInto("+/system/components/designchooser+");
		});
			
		it("should translate external links with link text", function() {
			expect("<a href=\"http://www.getitmade.com\" class=\"external\" title=\"http://www.getitmade.com\">crowd fund your ideas</a>").shouldParseInto("*crowd fund your ideas>http://www.getitmade.com*");
		});
		
		it("should preserve ref links", function() {
			expect("<span class=\"pierUnknownInternalLinkType yui-noedit pierNonEditable\">*ref:/book/under-the-hood/inside-wysiwyg-editor*</span>").shouldParseInto("*ref:/book/under-the-hood/inside-wysiwyg-editor*");
		});

		it("should translate external links without link text", function() {
			expect("<a href=\"http://www.getitmade.com\" class=\"external\" title=\"http://www.getitmade.com\">http://www.getitmade.com</a>").shouldParseInto("*http://www.getitmade.com*");
		});	
	
		it("should translate links to emails", function() {
			expect("<a title=\"nick.ager@gmail.com\" class=\"external\" href=\"mailto:%6E%69%63%6B.%61g%65%72%40g%6Dai%6C%2Ecom\">mail me</a>").shouldParseInto("*mail me>nick.ager@gmail.com*");
		});

		it("should translate internal links ", function() {
			expect("<a title=\"Blog\" class=\"internal blog\" href=\"/pier/blog?_s=QeMP6lT6t0jWkbFh&amp;_k=xB2pw-H5qfmJxwEr&amp;_n&amp;12\">Blog</a>").shouldParseInto("*Blog>/blog*");
		});	
			
		it("should translate root internal links ", function() {
			expect("<a title=\"Blog\" class=\"internal blog\" href=\"/pier?_s=QeMP6lT6t0jWkbFh&amp;_k=xB2pw-H5qfmJxwEr&amp;_n&amp;12\">Home</a>").shouldParseInto("*Home>/*");
		});	
	});	

	it("should translate h1", function() {
		expect("<h1>heading</h1>").shouldParseInto("!heading\n");
	});

	it("should translate h2", function() {
		expect("<h2>heading</h2>").shouldParseInto("!!heading\n");
	});

	it("should translate h3", function() {
		expect("<h3>heading</h3>").shouldParseInto("!!!heading\n");
	});

	it("should translate h4", function() {
		expect("<h4>heading</h4>").shouldParseInto("!!!!heading\n");
	});

	it("should translate h5", function() {
		expect("<h5>heading</h5>").shouldParseInto("!!!!!heading\n");
	});				

	it("should translate h6", function() {
		expect("<h6>heading</h6>").shouldParseInto("!!!!!!heading\n");
	});	
		
	it("should translate horizontal line", function() {
		expect("<hr>").shouldParseInto("_\n");
	});		
			
	it("should translate line break", function() {
		expect("<br>").shouldParseInto("\n");
	});	
		
	it("should translate preformatted", function() {
		expect("<pre>line 1\nline 2</pre>").shouldParseInto("=line 1\n=line 2\n");
	});	
		
	it("should translate tables", function() {
		expect("<table><tr><th>Heading</th><td>normal</td></tr><tr><td>normal</td><td style=''text-align: right''>right</td></tr><tr><td style=''text-align: left''>left</td><td>normal</td></tr><tr><td style=''text-align: center''>centre</td><td>normal</td></tr></table>").shouldParseInto("\n|!Heading|normal\n|normal|}right\n|{left|normal\n||centre|normal");
	});	
		
	it("should translate shout code highlighting", function() {
		expect("<pre class=''shout''><span class=''undefinedIdentifier''>WAAdmin</span> <span class=''undefinedKeyword''>register:</span> <span class=''undefinedIdentifier''>ScrapBook</span> <span class=''undefinedKeyword''>asApplicationAt:</span> <span class=''string''>''hello''</span></pre>").shouldParseInto("==WAAdmin register: ScrapBook asApplicationAt: ''hello''\n");
	});	

	it("should translate multiline shout code highlighting", function() {
		expect("<pre class=''shout''><span class=''globalVar''>WAComponent</span> <span class=''keyword''>subclass:</span> <span class=''symbol''>#</span><span class=''symbol''>ScrapBook</span><br>    <span class=''keyword''>instanceVariableNames:</span> <span class=''string''>''''</span><br>    <span class=''keyword''>classVariableNames:</span> <span class=''string''>''''</span><br>    <span class=''keyword''>poolDictionaries:</span> <span class=''string''>''''</span><br>    <span class=''keyword''>category:</span> <span class=''string''>''SeasideBook-Hello''</span></pre>").shouldParseInto("==WAComponent subclass: #ScrapBook\n==    instanceVariableNames: ''''\n==    classVariableNames: ''''\n==    poolDictionaries: ''''\n==    category: ''SeasideBook-Hello''\n");
	});
	
	describe("escaped text", function() {
		it("should escaped text containing code markup", function() {
			expect("To make something <code>monospaced</code>, surround it with <code>==</code>").shouldParseInto("To make something ==monospaced==, surround it with ==\\=\\===");	
		});
	
		it("should escaped text containing link markup", function() {
			expect("To create a link, put it between <code>*</code>").shouldParseInto("To create a link, put it between ==\\*==");	
		});
	});
	describe("images", function() {
		it("should convert embedded images into embedded links", function() {
			expect("<img src=\"\/pier\/astructure\/logo.png\">").shouldParseInto(" +\/astructure\/logo.png+ ");	
		});
		it("should convert embedded images into embedded links without path", function() {
			expect("<img src=\"\/pier\/logo.png\">").shouldParseInto(" +\/logo.png+ ");	
		});
		it("should convert embedded images into embedded links with attributes #1", function() {
			expect("<img src=\"\/pier\/astructure\/logo.png\" align=\"left\">").shouldParseInto(" +\/astructure\/logo.png|align=left+ ");	
		});
		it("should convert embedded images into embedded links with attributes #2", function() {
			expect("<img src=\"\/pier\/astructure\/logo.png\" style=\"display:block\">").shouldParseInto(" +\/astructure\/logo.png|style=display:block+ ");	
		});
		it("should convert embedded images into embedded links with attributes #3", function() {
			expect("<img src=\"\/pier\/astructure\/logo.png\" style=\"display: block;\" align=\"center\">").shouldParseInto(" +\/astructure\/logo.png|style=display: block|align=center+ ");	
		});
		it("should convert embedded images into embedded links with attributes #4", function() {
			expect("<img src=\"\/pier\/astructure\/logo.png\" style=\"display: block; align=center\">").shouldParseInto(" +\/astructure\/logo.png|style=display: block; align=center+ ");	
		});
		it("should convert external images into embedded links", function() {
			expect("<img src=\"http://www.easyvectors.com/assets/images/vectors/afbig/flag-of-chiyoda-tokyo-clip-art.jpg\" style=\"display: block; align=center\">").shouldParseInto(" +http://www.easyvectors.com/assets/images/vectors/afbig/flag-of-chiyoda-tokyo-clip-art.jpg|style=display: block; align=center+ ");	
		});
	});
});
'
]

{ #category : #updating }
PRTestWysiwgEditorParser >> updateRoot: anHtmlRoot [
	anHtmlRoot javascript url: PRWysiwygFileLibrary / #parseHtmlToPierWikiSyntaxJs.			
	super updateRoot: anHtmlRoot.
]
