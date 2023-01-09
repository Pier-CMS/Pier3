"
A PREditorScripts is library of JavaScript, CSS, and toolbar icons.  It is also used in the WYSIWYG editor.
"
Class {
	#name : #PREditorScripts,
	#superclass : #WAFileLibrary,
	#category : #'Pier-EditorEnh'
}

{ #category : #accessing }
PREditorScripts >> selectorsToInclude [
	^ #( toolbarCss toolbarJs )
]

{ #category : #'accessing-files' }
PREditorScripts >> toolbarCss [
	^ '/*	Silk Icons 1.3 (http://www.famfamfam.com/lab/icons/silk/)
	Creative Commons Attribution 2.5 License
	Mark James */
	
td.wiki textarea,
textarea.wiki-inline {
	outline: 0;
	margin: 0;
	padding: 0;
	clear: both;
	width: 100%;
	height: 250px;
	font-size: 10px;
	font-family: Monaco, Courier, monospace;
}
	
td.wiki .pr-toolbar,
td.wiki .pr-toolbar * {
	border: 0;
	outline: 0;
	margin: 0;
	padding: 0;
	background-color: inherit;
}
td.wiki .pr-toolbar {
	width: 100%;
	position: relative;
}

td.wiki .pr-toolbar select {
	position: absolute;
	border: 1px solid #ccc;
	background-color: #eee;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
}

td.wiki .pr-toolbar div {
	float: left;
	width: 1px;
	clear: none;
	height: 16px;
	margin: 4px;
	display: block;
	background-color: #ccc;
}
td.wiki .pr-toolbar a {
	float: left;
	width: 16px;
	height: 16px;
	padding: 4px;
	display: block;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
}
td.wiki .pr-toolbar a:hover { background-color: #eee; }
td.wiki .pr-toolbar a:active { background-color: #ccc; }

td.wiki .pr-toolbar a span {
	width: 16px;
	height: 16px;
	display: block;
	background-color: inherit;
	background-repeat: no-repeat;
	background-image: url(toolbar.png);
}

td.wiki .pr-toolbar a.pr-bold span { background-position: 0px 0px; }
td.wiki .pr-toolbar a.pr-italic span { background-position: -16px 0px; }
td.wiki .pr-toolbar a.pr-underline span { background-position: -32px 0px; }
td.wiki .pr-toolbar a.pr-strikethrough span { background-position: -48px 0px; }
td.wiki .pr-toolbar a.pr-monospace span { background-position: -64px 0px; }
td.wiki .pr-toolbar a.pr-subscript span { background-position: -80px 0px; }
td.wiki .pr-toolbar a.pr-superscript span { background-position: -96px 0px; }

td.wiki .pr-toolbar a.pr-link span { background-position: -128px 0px; }
td.wiki .pr-toolbar a.pr-embed span { background-position: -144px 0px; }

td.wiki .pr-toolbar a.pr-anchor span { background-position: -176px 0px; }
td.wiki .pr-toolbar a.pr-header span { background-position: -192px 0px; }
td.wiki .pr-toolbar a.pr-ruler span { background-position: -208px 0px; }
td.wiki .pr-toolbar a.pr-ordered span { background-position: -224px 0px; }
td.wiki .pr-toolbar a.pr-unordered span { background-position: -240px 0px; }
td.wiki .pr-toolbar a.pr-term span { background-position: -256px 0px; }
td.wiki .pr-toolbar a.pr-data span { background-position: -272px 0px; }
td.wiki .pr-toolbar a.pr-table span { background-position: -288px 0px; }
td.wiki .pr-toolbar a.pr-preformatted span { background-position: -304px 0px; }

td.wiki .pr-toolbar a.pr-help span { background-position: -336px 0px; }'
]

{ #category : #'accessing-files' }
PREditorScripts >> toolbarJs [
	^ 'function EditorEnh(textarea, options) {
	var self = this;
	self.textarea = textarea;

	// public
	self.addButton = function(css, tooltip, method) {
		var args = new Array();
		for (var index = 3; index < arguments.length; index++)
			args[index - 3] = arguments[index];
		var button = document.createElement("a");
		button.title = tooltip;
		button.className = css;
		self.registerEvent(button, "click", function(event) {
			if (method != "browseTo")
				self.textarea.focus();
			self[method].apply(button, args);
			return false;
		});
		button.appendChild(document.createElement("span"));
		self.toolbar.appendChild(button);
	};
	self.addSeparator = function() {
		var separator = document.createElement("div");
		self.toolbar.appendChild(separator);
	};
	
	// actions
	self.replaceText = function(text) {
		var value = self.textarea.value;
		var selection = self.getSelection(self.textarea);
		self.preserveScrollOffset(self.textarea, function() {
			self.textarea.value = value.substring(0, selection[0]) + text + value.substring(selection[1], value.length);
			self.setSelection(self.textarea, [selection[0] + text.length, selection[0] + text.length]);
		});
	};
	self.insertText = function(open, close, sample, url) {
		var value = self.textarea.value;
		var selection = self.getSelection(self.textarea);
		if(url && selection[1] <= selection[0]) {
			var button = this;
			var request = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");
			request.open("GET", url, true);
			request.onreadystatechange = function() {
				if(request.readyState == 4 && request.status == 200) {
					var selectList = document.createElement("select");
					selectList.size = 20;
					selectList.innerHTML = request.responseText;
					selectList.style.left = button.offsetLeft + "px";
					selectList.style.top = button.offsetTop + button.offsetHeight + "px";
					button.parentNode.appendChild(selectList);
					selectList.focus();
					self.registerEvent(selectList, "click", function(event) {
						self.insertText(open, close, selectList.value);
					});
					self.registerEvent(selectList, "blur", function(event) {
						selectList.parentNode.removeChild(selectList);
					});
				}
			};
			request.send(null);
		} else {
			var selected = value.substring(selection[0], selection[1]) || sample;
			self.preserveScrollOffset(self.textarea, function() {
				self.textarea.value = value.substring(0, selection[0]) + open + selected +
					close + value.substring(selection[1], value.length);
				self.setSelection(self.textarea, [selection[0] + open.length, selection[0] + open.length + selected.length]);
			});
		}
	};
	self.insertLine = function(open, sample) {
		var value = self.textarea.value;
		var selection = self.getSelection(self.textarea);
		var start = value.lastIndexOf("\n", selection[0]);
		if (start < 0) start = 0;
		var end = value.indexOf("\n", selection[1]);
		if (end < 0) end = value.length - 1;
		var selected = value.substring(start, end) || (open + sample);
		selected = selected.replace(/[	 ]*\n/g, "\n" + open);
		if (start === 0) selected = open + selected;
		self.preserveScrollOffset(self.textarea, function() {
			self.textarea.value = value.substring(0, start) + selected +
				value.substring(end, value.length);
			self.setSelection(self.textarea, [start + open.length, start + open.length + selected.length - 1]);
		});
	};
	self.insertTableLine = function(open, sample) {
		self.insertLine(open, sample);
		var value = self.textarea.value;
		var selection = self.getSelection(self.textarea);
		var start = value.lastIndexOf("\n", selection[0]);
		if (start < 0) start = 0;
		var end = value.indexOf("\n", selection[1]);
		if (end < 0) end = value.length - 1;
		var selected = value.substring(start, end);
		selected = selected.replace(/[	]/g, " | ");
		if (start === 0) selected = open + selected;
		self.preserveScrollOffset(self.textarea, function() {
			self.textarea.value = value.substring(0, start) + selected +
				value.substring(end, value.length);
			self.setSelection(self.textarea, [start + open.length, start + open.length + selected.length - 1]);
		});
	};
	self.browseTo = function(url) {
		self.preserveScrollOffset(self.textarea, function() {
			window.open(url, "help", "width=800,height=600,location=no,menubar=no,toolbar=no,scrollbars=yes");
		});
	};
	
	// private
	self.registerEvent = function(target, name, handler) {
		if (target.addEventListener)
			target.addEventListener(name, handler, false);
		else if (target.attachEvent)
			target.attachEvent("on" + name, function() {
				return handler.apply(target, [window.event]);
			});
	};
	self.onKeyDown = function(event) {
		if (!event.shiftKey && !event.ctrlKey && !event.altKey && !event.metaKey) {
			if (event.which == 9 || event.keyCode == 9) {
				self.replaceText("\t");
				setTimeout(function() { self.textarea.focus(); }, 1);
				if (event.preventDefault)
					event.preventDefault();
				if (event.stopPropagation)
					event.stopPropagation();
				return false;
			}
		}
		return true;
	};
	self.preserveScrollOffset = function(element, during) {
		var scrollLeft = element.scrollLeft;
		var scrollTop = element.scrollTop;
		var result = during();
		element.scrollLeft = scrollLeft;
		element.scrollTop = scrollTop;	
	};
	self.getSelection = function(element) {
		if (document.selection && document.selection.createRange) {
			var range = document.selection.createRange();
			var stored = range.duplicate();
			stored.moveToElementText(element);
			stored.setEndPoint("EndToEnd", range);
			element.selectionStart = stored.text.length - range.text.length;
			element.selectionEnd = element.selectionStart + range.text.length;
		}
		return [element.selectionStart, element.selectionEnd];
	};
	self.setSelection = function(element, range) {
		element.selectionStart = range[0];
		element.selectionEnd = range[1];
		if (document.selection && document.selection.createRange) {
			var range = document.selection.createRange();
			range.moveStart("character", element.selectionStart);
			range.moveEnd("character", element.selectionEnd - element.selectionStart);
			range.select();
		}
	};
	
	// constructor
	if (options.binding)
		self.registerEvent(self.textarea, "keydown", self.onKeyDown);
	if (options.toolbar) {
		self.toolbar = document.createElement("div");
		self.toolbar.className = "pr-toolbar";
		self.addButton("pr-bold", "Bold Text", "insertText", ''""'', ''""'', "Bold Text");
		self.addButton("pr-italic", "Italic Text", "insertText", "''''", "''''", "Italic Text");
		self.addButton("pr-underline", "Underlined Text", "insertText", "__", "__", "Underlined Text");
		self.addButton("pr-strikethrough", "Striked Text", "insertText", "--", "--", "Striked Text");
		self.addButton("pr-monospace", "Monospace Text", "insertText", "==", "==", "Monospace text");
		self.addButton("pr-subscript", "Subscript Text", "insertText", "@@", "@@", "Subscript Text");
		self.addButton("pr-superscript", "Superscript Text", "insertText", "^^", "^^", "Superscript Text");
		self.addSeparator();
		self.addButton("pr-link", "Link", "insertText", "*", "*", "Alias>Path@Anchor", EditorEnh.linkOptionUrl);
		self.addButton("pr-embed", "Embed", "insertText", "+", "+", "Alias>Path@Anchor", EditorEnh.linkOptionUrl);
		self.addSeparator();
		self.addButton("pr-anchor", "Anchor", "insertLine", "@", "Anchor");
		self.addButton("pr-header", "Header", "insertLine", "!", "Header");
		self.addButton("pr-ruler", "Horizontal Ruler", "insertLine", "_", "");
		self.addButton("pr-ordered", "Ordered List", "insertLine", "#", "Ordered List");
		self.addButton("pr-unordered", "Unordered List", "insertLine", "-", "Unordered List");
		self.addButton("pr-term", "Definition Term", "insertLine", ";", "Definition Term");
		self.addButton("pr-data", "Definition Data", "insertLine", ":", "Definition Data");
		self.addButton("pr-table", "Table", "insertTableLine", "|", "Table");
		self.addButton("pr-preformatted", "Preformatted", "insertLine", "= ", "Preformatted");
		self.addSeparator();
		self.addButton("pr-help", "Pier Syntax", "browseTo", window.location.protocol + "//" + window.location.host + window.location.pathname + "?view=PREditorHelp");
		self.textarea.parentNode.insertBefore(self.toolbar, self.textarea);
	}
}

// install editors
(function() {
	var load = function(event) {
		var textareas = document.getElementsByTagName("textarea");
		for (var index = 0; index < textareas.length; index++) {
			var textarea = textareas[index];
			new EditorEnh(textarea, { 
				binding: true,
				toolbar: textarea.parentNode.tagName == "TD" && textarea.parentNode.className.indexOf("wiki") >= 0
			});
		}
	};
	if (window.addEventListener)
		window.addEventListener("load", load, false);
	else if (window.attachEvent)
		window.attachEvent("onload", load);
})();'
]

{ #category : #'accessing-files' }
PREditorScripts >> toolbarPng [

	"PNGReadWriter formFromStream: self new toolbarPng readStream."

	^ #( 137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 1 96 0 0 0 16
	     8 6 0 0 0 40 52 165 57 0 0 0 25 116 69 88 116 83 111 102 116 119
	     97 114 101 0 65 100 111 98 101 32 73 109 97 103 101 82 101 97 100
	     121 113 201 101 60 0 0 22 38 73 68 65 84 120 218 236 92 11 92 148
	     213 182 95 51 204 48 131 163 242 80 145 151 242 16 67 20 13 211
	     227 3 53 169 212 44 187 73 62 242 148 47 44 179 227 241 150 99
	     102 234 201 43 166 86 162 166 216 81 75 236 6 136 230 177 212
	     180 186 157 126 62 177 148 180 212 64 81 20 13 16 16 121 15 239
	     199 204 124 51 231 191 62 102 112 68 158 1 29 187 135 237 111
	     185 191 215 218 223 222 251 91 251 191 254 123 237 61 72 140 70
	     35 181 167 246 212 158 218 211 31 57 5 31 72 31 130 44 204 203
	     78 57 188 92 103 32 22 157 193 64 21 122 67 17 174 151 64 242
	     32 2 68 3 201 135 68 67 142 68 78 238 161 251 119 214 91 214 254
	     233 218 211 255 199 116 241 226 197 77 122 189 126 142 78 167
	     35 228 17 163 71 143 126 227 65 174 239 107 145 25 222 67 188
	     85 55 102 142 180 151 252 167 125 171 221 63 20 174 4 15 124 69
	     48 26 220 12 0 77 193 64 164 231 92 224 99 35 233 145 223 21 129
	     4 189 17 215 13 63 191 59 163 247 16 115 25 6 189 126 232 195
	     78 29 135 47 30 221 237 158 178 203 180 6 219 114 136 166 82 112
	     211 2 106 75 170 4 74 205 43 165 127 254 90 54 22 183 213 38 32
	     110 181 116 230 166 182 151 193 104 124 209 96 48 206 66 238 84
	     221 30 99 22 242 93 200 63 155 224 111 251 235 3 11 192 155 54
	     109 10 70 182 25 98 135 10 135 189 249 230 155 139 204 247 150
	     47 95 254 165 86 171 13 170 172 172 92 180 109 219 182 176 255
	     52 35 157 186 237 150 135 167 163 226 144 173 141 212 227 92 98
	     105 216 87 75 188 86 181 195 108 253 9 192 203 224 27 2 240 229
	     227 119 112 169 77 1 120 217 178 101 53 83 73 1 32 1 91 37 216
	     42 149 151 151 139 82 86 86 38 74 105 105 169 152 39 37 37 221
	     3 180 12 190 45 4 112 181 175 171 82 157 120 187 50 236 239 193
	     110 127 168 241 1 160 122 109 242 144 78 93 155 163 179 106 223
	     205 1 247 148 161 215 119 239 108 93 221 165 233 133 2 201 37 18
	     146 225 212 10 8 167 144 75 169 167 66 74 86 82 41 201 173 136
	     6 186 217 144 139 173 202 97 231 79 153 31 180 38 0 199 92 175
	     152 12 224 253 187 123 23 153 179 196 104 16 237 128 147 84 42
	     245 214 10 210 213 87 51 202 231 127 254 99 206 107 207 15 119
	     60 80 39 0 155 0 112 33 20 253 97 184 133 144 176 170 170 42 127
	     24 112 32 242 67 200 25 252 10 155 90 161 213 171 87 175 130 142
	     26 198 104 11 41 66 25 113 219 183 111 15 172 239 249 55 222 120
	     35 18 117 152 141 247 7 46 89 178 100 145 229 189 138 138 138
	     57 40 195 3 250 141 26 215 134 13 27 236 81 247 117 144 11 208
	     177 71 29 188 240 110 175 205 155 55 143 109 195 1 24 195 131
	     157 7 30 222 197 18 140 1 24 137 122 115 221 233 200 145 35 129
	     45 41 223 182 131 85 216 181 212 242 32 65 47 4 15 241 237 20 194
	     54 216 14 179 13 2 48 75 177 41 111 243 247 173 91 183 174 69 204
	     149 153 111 244 105 141 209 194 158 22 32 219 202 131 216 228
	     68 68 219 226 156 237 139 143 247 239 223 95 243 78 6 95 143 110
	     214 238 38 86 23 214 92 253 165 75 151 26 153 173 241 179 102
	     49 247 157 165 46 231 44 199 143 31 191 167 189 45 209 7 155 21
	     193 247 112 114 20 152 47 116 5 232 34 215 9 186 187 57 174 153
	     239 45 27 254 46 202 18 20 150 239 23 116 186 206 42 25 51 103
	     176 92 173 4 96 11 240 69 111 202 244 200 1 186 82 126 155 81 32
	     87 91 43 90 190 39 141 66 167 187 211 143 201 242 110 173 245
	     253 143 93 41 155 140 118 68 249 56 201 85 69 165 101 148 152
	     94 70 105 249 101 34 131 119 180 181 166 126 174 157 169 127 79
	     165 115 236 181 194 168 255 61 150 70 47 143 233 121 224 62 0 102
	     0 92 191 126 189 59 0 195 95 34 145 196 173 92 185 146 153 3 45
	     92 184 48 2 29 26 12 79 238 143 211 129 77 173 20 244 87 189 245
	     214 91 193 232 120 91 148 169 254 248 227 143 35 27 211 49 127
	     184 218 41 44 44 172 112 206 156 57 77 2 127 124 224 95 81 78 104
	     72 72 72 184 169 254 75 97 116 243 26 96 222 49 166 195 56 8 59
	     159 84 148 97 7 25 7 189 28 212 253 16 247 9 218 95 136 188 176
	     164 164 36 16 199 234 51 103 206 28 178 168 119 24 158 103 192
	     181 69 253 183 68 70 70 166 78 156 56 49 6 231 30 144 22 131 229
	     39 115 220 130 56 127 105 103 90 80 134 70 119 171 181 1 4 83 116
	     149 159 159 223 95 93 93 93 151 59 59 59 219 39 39 39 167 21 22
	     22 62 143 91 183 236 236 236 206 120 33 221 185 115 71 115 251
	     246 237 247 19 18 18 182 159 58 117 170 204 82 127 242 228 201
	     170 1 3 6 252 213 197 197 101 185 163 163 163 253 173 91 183 210
	     138 138 138 106 244 221 221 221 189 178 178 178 52 40 227 253
	     203 151 47 111 199 224 47 107 75 64 196 183 192 103 208 125 106
	     2 128 188 182 6 96 16 6 99 99 172 215 124 221 244 204 61 0 102
	     6 223 232 239 53 198 153 143 218 75 0 232 219 112 186 173 169
	     239 103 230 203 224 107 202 169 185 250 161 161 161 45 114 32 45
	     209 103 144 226 244 98 223 151 155 244 124 89 37 48 66 47 80 45
	     0 118 232 100 45 165 178 42 190 47 128 117 74 68 112 19 193 23
	     98 69 0 101 212 16 248 76 18 161 152 206 38 107 232 98 90 81 102
	     107 124 251 111 227 139 189 224 124 62 236 235 170 80 221 41 40
	     163 163 9 185 228 108 43 167 23 31 237 73 70 252 59 127 83 67 223
	     196 223 161 209 62 93 49 211 233 172 58 22 159 243 225 230 195
	     73 191 44 154 248 80 178 172 46 230 192 32 200 222 204 130 125
	     166 242 98 157 9 128 155 156 22 47 94 204 236 217 29 32 86 180
	     99 199 142 200 38 14 156 122 25 11 27 111 99 105 237 218 181 243
	     152 245 194 243 219 155 175 109 217 178 37 116 214 172 89 99 26
	     80 179 67 251 130 225 116 236 80 215 133 104 123 204 138 21 43
	     86 193 171 231 98 176 124 243 225 135 31 170 167 79 159 206 96
	     106 119 240 224 193 160 17 35 70 172 2 8 115 95 212 0 240 198
	     141 27 15 189 250 234 171 65 168 251 73 188 127 33 192 55 21 207
	     7 54 149 249 54 133 65 7 46 79 92 213 221 69 73 183 146 74 131
	     104 78 143 86 3 143 65 131 6 89 3 56 67 124 124 124 150 76 155
	     54 77 4 139 94 189 122 245 140 137 137 217 139 250 100 204 156
	     57 211 85 38 147 17 192 211 254 194 133 11 235 211 210 210 186
	     65 103 5 142 181 172 63 110 220 56 235 30 61 122 132 244 238 221
	     123 201 248 241 227 197 250 246 68 58 123 246 236 94 244 71 6 250
	     194 213 10 35 33 47 47 207 254 202 149 43 162 62 116 86 160 77
	     218 214 6 194 239 191 255 254 103 188 115 32 219 16 128 95 2 251
	     167 212 91 169 14 209 209 209 122 180 229 151 151 95 126 249 79
	     117 233 189 254 250 235 239 192 6 250 193 6 120 234 248 5 102
	     122 251 224 240 167 161 156 169 12 152 248 30 87 190 254 250 235
	     144 81 163 70 141 71 251 158 60 127 254 252 162 90 179 174 22 51
	     224 150 232 155 194 14 191 57 244 16 250 77 65 194 210 103 28 252
	     106 234 51 115 102 162 37 99 173 45 104 191 111 237 50 222 61 92
	     144 240 246 196 234 50 154 163 207 177 94 78 123 79 231 52 169
	     174 207 14 118 32 109 109 0 214 106 187 219 218 88 81 81 133 158
	     202 171 140 0 96 163 200 130 165 130 137 13 195 16 24 140 201
	     104 69 217 197 85 180 229 232 205 98 156 5 183 134 205 85 86 105
	     103 248 184 216 184 20 150 84 209 119 113 217 84 85 169 163 233
	     207 120 51 212 139 247 159 244 239 78 151 83 243 233 212 213 108
	     26 63 208 149 6 122 218 186 156 186 156 53 131 131 4 247 1 176
	     105 240 215 196 47 230 206 157 107 7 3 12 54 1 96 100 179 42 6 61
	     6 114 12 232 67 205 153 58 242 7 250 173 0 12 221 100 19 136 47
	     93 176 96 129 61 218 18 254 201 39 159 92 192 160 9 109 40 164
	     4 103 17 7 246 31 104 118 64 166 250 191 13 189 35 230 119 51 147
	     17 3 237 103 206 172 242 246 246 14 170 93 8 156 76 204 159 255
	     252 231 45 12 192 208 221 12 93 251 166 182 187 49 6 61 114 241
	     149 32 133 141 212 35 249 106 113 32 102 100 254 15 7 95 244 136
	     143 124 36 181 53 12 8 192 51 30 224 59 111 204 152 49 26 181
	     90 125 22 206 101 28 0 217 170 127 255 254 158 0 93 79 56 23 202
	     204 204 20 58 117 234 116 36 40 40 168 31 63 11 38 124 26 170
	     95 89 234 7 4 4 104 86 175 94 125 182 184 184 120 28 152 180 149
	     175 175 175 103 118 118 182 231 206 157 59 9 207 139 250 19 38
	     76 16 245 193 144 107 244 91 57 244 240 53 164 138 109 0 12 126
	     132 160 23 227 177 103 77 54 113 164 62 61 56 217 16 128 112 38
	     190 67 236 246 237 219 247 241 181 136 136 136 125 83 145 96 67
	     1 0 223 41 0 223 0 124 139 185 248 182 1 184 125 15 0 3 112 140
	     13 176 94 1 58 231 144 143 168 239 253 159 198 20 24 25 136 78
	     92 41 233 189 247 117 207 155 191 119 200 166 82 39 208 252 93
	     25 87 146 110 148 77 57 190 198 39 17 253 229 89 31 120 214 30
	     159 65 155 82 124 61 156 20 251 59 90 203 140 22 227 176 201 250
	     122 225 46 217 123 97 164 35 125 126 38 155 158 31 209 189 230
	     218 129 179 217 52 121 216 221 243 188 226 202 251 24 48 188 171
	     123 247 206 114 42 170 52 146 56 122 81 19 43 128 175 148 107
	     36 84 3 176 204 40 37 38 219 130 92 192 243 122 207 195 139 70
	     20 180 70 223 149 87 234 102 202 165 74 250 41 165 144 42 42 181
	     28 82 161 130 18 45 197 167 106 72 165 180 162 161 189 187 210
	     163 253 186 210 254 51 41 116 49 37 143 30 243 115 162 178 10 237
	     204 58 1 216 34 86 227 1 182 16 2 227 11 2 136 122 192 152 99 190
	     253 246 219 57 205 4 224 32 6 114 24 222 161 102 232 212 11 192
	     108 208 77 136 59 31 3 136 28 195 64 26 131 119 207 67 91 230
	     77 154 52 233 2 218 177 172 129 216 243 33 115 219 217 249 152
	     1 24 204 57 220 242 221 150 14 224 230 205 155 117 182 137 193
	     18 109 96 22 205 207 175 50 197 228 26 77 141 49 232 103 222 75
	     138 116 115 82 142 214 187 119 152 93 82 33 20 237 123 221 203
	     174 181 6 31 88 223 72 91 91 91 197 137 19 39 212 120 103 52 192
	     35 27 142 164 163 189 189 189 8 36 185 185 185 116 84 179 65 42
	     88 101 62 133 227 191 224 217 48 214 49 3 40 31 119 238 220 89
	     1 198 171 70 155 163 1 192 217 243 231 207 239 136 231 196 62 43
	     40 40 160 143 62 250 168 2 44 122 74 126 126 254 76 60 27 38 149
	     74 71 182 5 0 63 241 196 19 171 217 12 68 70 181 119 175 24 22
	     152 61 123 246 200 38 58 193 154 111 111 105 143 108 19 156 126
	     248 225 135 88 63 63 191 225 104 83 64 109 93 48 236 22 49 216
	     151 2 29 36 207 111 74 241 30 230 35 46 198 53 187 172 87 194
	     211 213 189 157 21 234 159 147 74 195 190 88 236 213 44 38 188
	     246 235 44 99 119 91 107 178 177 150 83 158 70 190 107 200 130
	     75 179 126 218 183 79 217 36 54 186 62 217 215 217 81 190 203
	     163 139 172 175 84 98 69 139 63 203 48 126 240 162 155 100 95 19
	     245 69 167 9 0 54 96 134 45 3 67 61 240 99 14 152 170 148 14 158
	     205 33 9 51 88 211 51 135 127 202 97 79 79 114 25 199 187 59 144
	     86 87 155 1 87 185 59 217 42 40 49 91 48 233 85 131 175 180 26
	     139 171 237 220 40 22 65 122 38 152 181 17 188 69 0 172 117 229
	     169 86 106 110 177 184 75 131 99 214 235 14 196 209 132 193 61
	     232 97 143 174 84 92 174 163 180 156 82 18 244 6 74 189 163 33
	     217 0 23 42 173 168 114 189 47 6 108 2 16 17 128 57 236 0 6 192
	     49 224 119 48 173 140 144 203 229 193 67 135 14 253 5 215 31 187
	     116 233 82 163 177 88 76 223 252 97 252 28 79 46 194 180 189 201
	     0 204 198 206 70 223 28 0 222 180 105 211 18 100 235 205 231 152
	     253 138 57 216 23 229 228 228 80 124 124 252 160 228 228 228 163
	     60 189 180 12 219 129 185 109 172 253 110 110 123 93 239 103 32
	     50 51 224 134 146 41 94 188 8 101 111 6 8 47 244 244 244 60 148
	     146 146 18 211 148 93 12 13 49 232 111 254 246 80 32 181 81 66
	     155 83 192 80 43 187 118 237 218 201 202 202 234 75 128 163 34
	     52 52 148 84 42 85 77 191 187 76 210 74 60 187 251 210 233 170
	     109 31 219 221 30 93 200 58 22 253 150 2 134 92 217 165 75 23 81
	     31 162 0 163 172 209 231 126 227 50 77 247 142 130 85 87 162 141
	     41 109 205 234 204 223 179 25 179 16 126 190 199 140 25 51 22 155
	     129 23 210 131 199 132 229 44 204 242 156 211 251 135 115 142
	     187 117 145 63 94 103 124 83 48 138 91 170 116 200 185 42 58 12
	     208 42 96 124 66 122 249 137 207 94 243 122 162 38 134 190 225
	     87 239 161 125 84 55 222 152 224 40 26 41 156 198 2 244 209 86
	     243 140 212 44 22 245 162 235 215 175 215 24 180 151 163 92 237
	     230 32 115 207 115 86 138 139 112 205 209 95 241 95 78 146 255
	     142 206 74 200 209 84 72 147 175 150 204 186 176 227 225 196 167
	     158 122 42 193 204 86 205 139 118 150 11 105 152 193 136 161 134
	     175 222 242 74 124 108 121 226 172 146 10 253 1 149 82 105 216
	     57 199 77 188 222 84 125 115 8 130 65 82 102 37 161 231 134 116
	     3 216 230 210 196 33 142 247 48 96 203 243 155 153 0 58 253 93
	     214 60 126 205 119 54 50 43 169 53 239 118 208 162 127 165 98 105
	     70 170 38 191 213 93 196 255 75 165 213 253 95 90 86 206 94 182
	     184 213 0 184 162 170 26 216 33 90 61 142 65 179 249 124 100 95
	     39 210 148 86 209 198 47 126 161 74 173 94 172 143 94 130 182
	     194 19 128 1 83 189 0 108 98 111 150 192 183 8 157 22 172 84 42
	     253 193 128 130 155 18 107 130 126 48 199 253 48 248 14 53 171
	     49 229 229 113 24 8 129 211 166 77 11 130 23 173 209 29 60 120
	     112 32 140 39 174 30 6 187 129 195 112 124 12 22 105 15 32 211
	     152 239 141 29 59 118 30 166 211 75 77 139 72 23 18 18 18 6 55
	     20 127 102 3 173 61 192 204 32 212 16 3 7 99 181 131 94 24 3 48
	     152 82 88 223 190 125 61 108 108 108 24 72 15 57 56 56 4 78 250
	     224 210 170 166 236 98 248 173 12 186 37 9 253 29 3 0 205 122
	     232 161 135 222 134 3 48 128 169 202 79 85 108 38 131 80 76 90
	     113 21 90 32 23 7 111 242 117 26 74 37 149 101 20 239 115 216
	     86 127 218 238 84 109 125 111 111 239 183 49 219 16 245 243 242
	     242 8 78 143 172 173 173 201 205 205 141 0 238 114 60 55 24 223
	     96 8 192 62 11 3 49 166 181 234 143 89 194 2 148 247 6 100 83 80
	     80 208 54 203 239 89 123 54 181 114 229 202 154 103 49 235 216
	     86 71 248 43 125 207 158 61 31 152 175 141 26 53 106 56 190 73
	     15 203 241 81 219 65 51 248 58 118 190 59 148 12 6 99 245 254
	     85 22 189 68 92 153 103 194 166 151 25 112 44 19 65 217 197 222
	     250 30 192 30 220 91 117 163 82 107 160 255 249 34 211 184 102
	     170 139 36 42 42 170 89 139 104 63 93 47 9 43 40 181 81 199 95
	     45 193 216 116 161 230 234 151 87 25 232 243 215 61 251 90 48 127
	     239 218 97 3 203 221 12 150 233 228 251 190 137 200 250 78 223
	     145 153 240 91 244 153 1 27 209 71 50 0 228 55 23 114 197 88 45
	     231 34 64 73 239 130 176 204 180 136 214 215 69 9 48 187 11 192
	     250 42 109 55 149 74 41 238 116 48 152 194 15 204 181 152 5 27
	     77 199 12 193 54 114 162 124 0 34 158 207 62 182 246 217 86 251
	     5 26 192 244 54 128 223 219 213 78 73 197 37 229 248 254 213 107
	     104 111 134 159 49 45 16 2 239 141 6 209 37 56 59 117 161 138
	     42 29 131 246 237 58 1 216 12 188 150 0 12 64 41 4 160 16 47 196
	     0 132 108 155 84 169 178 178 32 102 156 205 9 63 152 12 124 11
	     199 142 33 33 99 198 140 137 59 118 236 88 234 160 65 131 2 113
	     125 51 202 122 174 9 0 62 117 202 148 41 246 251 247 239 23 99
	     190 71 143 30 229 48 66 184 175 175 175 17 101 218 55 242 110
	     209 91 215 3 192 118 144 194 70 152 47 191 159 251 202 159 119
	     77 104 52 154 83 38 182 17 22 53 207 83 13 195 75 109 108 23 67
	     125 12 186 45 1 88 16 132 164 226 226 226 23 142 31 63 254 37 156
	     85 55 133 66 81 73 195 180 202 177 126 179 73 224 253 140 6 129
	     216 124 50 139 210 169 191 219 8 42 213 86 72 10 103 156 138 31
	     176 86 106 125 105 133 193 8 96 77 42 42 42 122 225 228 201 147
	     95 186 186 186 138 250 168 191 52 63 63 255 21 228 183 75 74 74
	     190 196 107 228 24 124 10 128 111 46 206 95 64 95 36 181 86 253
	     153 233 41 21 60 227 149 108 221 189 123 247 86 158 121 189 244
	     210 75 105 150 12 120 205 154 53 61 113 253 22 59 3 153 149 140
	     46 93 190 180 181 54 64 213 5 216 12 182 150 128 91 159 131 190
	     163 209 213 201 116 117 122 254 69 22 137 140 205 130 180 221
	     151 150 7 57 181 40 132 241 229 210 222 45 90 132 251 116 174
	     139 223 61 160 122 242 164 178 185 101 236 121 245 110 25 205
	     209 231 62 226 69 126 222 163 59 126 96 55 58 22 159 71 99 30 190
	     187 45 248 104 92 46 13 243 177 167 78 54 213 112 117 61 189 136
	     84 10 153 101 248 161 131 76 101 45 130 181 21 80 88 48 72 196
	     88 131 184 227 129 65 217 80 189 3 162 3 30 200 213 84 240 243
	     153 173 57 126 74 43 170 162 51 115 203 222 241 247 180 167 155
	     25 5 164 213 85 135 177 222 155 51 76 12 173 44 217 113 202 196
	     118 13 244 39 159 238 148 116 75 195 97 139 232 122 25 48 51 87
	     6 28 243 181 62 125 250 168 59 118 236 200 155 199 11 97 128 81
	     141 85 232 233 167 159 14 68 135 186 99 80 82 108 108 108 179
	     0 56 58 58 58 117 194 132 9 3 81 143 16 72 196 192 129 3 185 78
	     113 168 207 156 244 244 244 212 38 0 48 15 146 117 143 63 254
	     120 248 137 19 39 52 22 33 4 13 174 135 55 2 192 188 213 238 20
	     131 231 184 113 227 56 254 42 2 31 152 157 154 193 151 25 48 156
	     144 154 23 204 234 96 97 181 67 4 247 133 12 26 218 197 208 24
	     131 46 40 40 136 107 43 0 198 84 148 227 97 92 190 167 249 218
	     220 200 71 140 12 190 183 242 111 136 123 49 245 6 157 24 219
	     42 174 42 33 255 30 163 168 84 87 46 59 151 114 154 145 73 113
	     238 220 185 251 244 107 165 206 109 233 64 0 154 78 232 183 44
	     133 194 134 157 221 50 128 46 135 64 156 144 139 49 224 213 171
	     87 243 177 2 178 12 67 114 221 181 235 215 24 152 187 213 55 3 170
	     61 30 44 201 8 159 215 142 19 183 198 175 215 150 237 205 224
	     153 43 241 230 163 141 51 220 126 247 95 195 97 204 25 27 90 52
	     179 220 211 203 2 39 42 105 45 125 189 105 199 21 131 39 131 47
	     39 115 206 172 150 29 216 15 137 53 67 153 122 117 179 174 217
	     57 49 74 189 135 145 122 205 144 62 61 41 171 216 72 169 217 2 129
	     12 147 210 90 74 74 57 64 29 250 114 107 9 89 3 220 59 119 32 186
	     153 94 206 11 118 217 173 217 119 96 192 187 15 199 166 188 58
	     123 156 143 203 83 131 221 232 240 143 191 138 139 113 255 56 121
	     173 230 25 41 198 207 147 195 251 192 201 72 41 242 187 43 153
	     152 33 237 174 142 75 91 252 45 8 76 31 25 128 38 194 8 237 76
	     134 23 103 242 248 188 7 54 14 198 189 5 32 212 32 8 142 31 63
	     126 21 47 30 153 153 2 239 155 189 113 227 70 208 239 101 72 120
	     255 60 188 115 29 222 159 140 252 11 136 134 99 169 168 191 61
	     64 108 25 253 155 146 105 23 67 80 113 190 86 205 187 24 4 189
	     144 106 185 139 1 128 31 99 238 115 228 188 27 34 204 50 94 7 35
	     102 6 29 247 123 213 119 198 39 125 141 207 62 252 42 6 135 32
	     10 131 241 157 162 52 114 232 232 68 191 164 199 210 209 107 223
	     93 211 234 233 145 140 247 140 21 244 111 78 123 247 238 237 136
	     190 153 139 62 90 100 103 103 215 147 227 217 56 223 239 236 236
	     60 131 167 130 112 48 187 113 62 197 211 211 75 121 245 234 149
	     52 254 101 28 88 255 87 225 225 225 53 251 131 49 107 122 7 253
	     220 207 52 3 250 2 78 112 159 159 159 223 52 158 81 153 194 14
	     87 112 124 21 122 79 66 216 161 164 243 242 3 198 79 122 107 181
	     227 205 221 25 198 179 63 107 122 159 222 210 191 217 187 32 30
	     85 95 86 123 249 116 84 223 188 86 26 6 253 63 212 47 225 222
	     222 147 100 124 115 162 7 197 165 20 211 99 253 187 82 76 66 30
	     5 250 221 101 192 7 207 230 210 164 97 119 253 37 51 224 247 63
	     191 74 145 139 135 75 2 254 26 49 13 151 34 60 220 28 109 188
	     60 122 83 105 149 81 156 133 84 233 36 164 213 87 255 124 153
	     89 168 131 173 45 253 101 156 19 197 95 75 166 143 14 198 70 196
	     110 159 243 82 107 182 33 120 253 137 201 112 36 81 243 159 245
	     83 113 72 37 54 33 131 210 178 52 100 64 29 92 187 219 82 64 63
	     87 144 55 43 90 29 121 182 76 48 24 102 127 191 229 249 3 247
	     1 240 131 144 70 141 26 101 52 199 217 44 54 173 215 48 15 24 255
	     31 242 183 242 207 188 151 20 35 238 98 128 113 180 246 46 134
	     182 72 147 62 246 18 42 153 189 24 192 10 245 90 234 213 181 159
	     116 152 215 56 58 159 22 75 199 147 142 92 2 248 14 201 124 207
	     88 245 32 212 53 42 42 138 195 27 54 0 86 71 228 27 84 42 85 16
	     239 192 0 24 139 83 91 222 197 113 59 227 54 101 220 206 56 4 27
	     90 2 201 131 84 68 68 68 84 61 72 125 62 114 225 101 239 97 127
	     178 191 193 12 120 208 160 65 11 224 12 182 154 23 176 204 225
	     20 51 155 52 237 216 168 25 11 193 31 165 164 250 123 168 220
	     227 82 203 110 69 206 247 244 104 174 62 143 187 186 22 203 44
	     89 107 97 97 161 164 161 113 251 91 245 223 218 117 205 184 236
	     57 79 211 223 125 48 255 237 7 99 205 223 130 168 43 189 251 143
	     43 134 93 75 2 172 134 190 18 30 58 49 112 192 91 127 155 62 236
	     222 176 154 145 68 32 214 234 171 99 194 219 190 203 164 169 1 142
	     116 228 199 4 138 250 191 159 55 158 219 57 111 73 171 143 153
	     144 111 249 215 112 127 159 58 218 219 217 199 221 129 20 76 187
	     121 214 84 169 167 132 95 115 233 211 127 38 220 49 24 140 175
	     253 184 237 133 154 159 34 75 218 255 26 90 123 106 74 242 91 43
	     205 29 220 243 241 174 49 73 199 47 104 13 20 0 240 213 62 168
	     117 93 187 118 237 120 12 248 137 144 199 76 96 115 18 249 225
	     173 91 183 126 247 160 214 153 217 47 231 63 255 82 20 122 234
	     131 126 205 158 169 1 188 213 222 125 254 152 12 120 113 68 226
	     105 189 78 240 215 10 6 21 239 14 99 225 45 91 58 17 136 245 117
	     234 20 150 84 30 62 190 110 76 208 224 224 109 127 9 24 232 253
	     209 144 190 61 201 174 163 13 217 117 86 146 157 74 65 182 144
	     78 29 172 1 130 82 82 200 164 148 150 175 39 14 27 135 31 140
	     165 175 191 191 172 62 31 185 96 75 91 180 101 236 146 131 189
	     224 52 94 196 204 107 22 28 136 83 245 130 172 33 11 44 124 23
	     142 63 59 191 99 198 61 127 140 167 29 128 219 83 147 146 215
	     74 73 174 96 176 234 90 97 16 228 57 239 25 245 237 61 210 158
	     30 132 244 200 140 45 28 171 224 157 66 252 119 48 186 152 196
	     222 36 182 74 107 185 92 169 148 83 103 21 131 115 7 186 116 61
	     157 23 127 167 95 220 189 240 252 131 80 255 127 9 48 0 46 1 116
	     20 112 56 146 14 0 0 0 0 73 69 78 68 174 66 96 130 ) asByteArray
]
