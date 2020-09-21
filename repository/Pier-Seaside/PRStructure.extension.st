Extension { #name : #PRStructure }

{ #category : #'*Pier-Seaside' }
PRStructure >> defaultEnvironment [
	| requestContext appPath  |
	requestContext := WACurrentRequestContext value.
	appPath := requestContext application url copy.

	^ (PRPage named: 'template')
		addChild: ((PRFile named: 'style.css')
			filename: 'style.css';
			mimetype: 'text/css';
			contents: '/* blueprint patches */
h1, h2, h3, h4, h5, h6 { margin: 0; font-weight: inherit; font-size: 100%; line-height: 1; }
h1 { font-size: 2em; margin-bottom: 0.75em; }
h2 { font-size: 1.5em; line-height: 1; margin-bottom: 1em; }
h3 { font-size: 1.2em; height: 1.25em; line-height: 1.25; margin-bottom: 1.25em; }
h4 { font-size: 1em; font-weight: bold; margin-bottom: 1.5em; }
h5 { font-size: 1em; font-weight: bold; }
h6 { font-size: 1em; }

/* pier */
a.broken { color: #8a1f11; }
a.protected { color: #514721; }
h1.heading { font-size: 3em; line-height: 1; margin-bottom: 0.5em; }
pre, code, tt { background-color: #eaeaea; }

/* widgets */
ul.toc { list-style: none; margin-left: 0; }
ul.toc li.toc-level-1 { margin-left: 0em; }
ul.toc li.toc-level-2 { margin-left: 1em; }
ul.toc li.toc-level-3 { margin-left: 2em; }
ul.toc li.toc-level-4 { margin-left: 3em; }
ul.toc li.toc-level-5 { margin-left: 4em; }
ul.toc li.toc-level-6 { margin-left: 5em; }

/* magritte */
.magritte td { vertical-align: top; }
.magritte textarea { width: 100%; height: 250px; padding: 0; margin: 0; }
.magritte tr td.required:after { content: "*"; color: #8a1f11; font-weight: bold; margin-left: 0.5em; }
.magritte th { vertical-align: top; padding-top: 10px; background-color: inherit; width: 120px; }
.magritte tr.group th { font-size: 1.5em; line-height: 1; margin-bottom: 1em; width: 100% }
.magritte .error { border: 0; padding: 4px 10px 4px 5px; }

/* default look */
.header .title a.page {
	height: 59px;
	outline: none;
	display: block;
	text-indent: -1000em;
	background: url(', (appPath addToPath: '/template/pier.png'; yourself) greaseString, ') no-repeat;
}
.header .search input {
	width: 140px;
	outline: none;
}
.header .search ul {
	margin: 0;
	padding: 0;
	background: #fff;
	list-style-type: none;
	border: 1px solid #666;
	border-top: none;
}
.header .search li.selected {
	background-color: #009;
}
.header .search li {
	margin: 0;
	display: block;
	padding: 0.2em;
	cursor: pointer;
	list-style-type: none;
}
.header .search a {
	text-decoration: none;
}
.header .search li.selected a {
	color: #fff;
}
.header .children {
	height: 4em;
}
.header .children ul {
	margin: 0 0 1em 0;
	list-style-type: none;
}
.header .children ul li {
	float: left;
	width: 110px;
	margin-right: 10px;
	list-style-type: none;
}
.header .children .active {
	font-weight: bold;
}
.sidebar ul {
	margin-top: 0;
	margin-left: 0;
	list-style-type: none;
}
.sidebar ul ul {
	margin-bottom: 0;
	margin-left: 1.5em;
}
.sidebar .active {
	font-weight: bold;
}
.footer {
	font-size: 0.8em;
	margin-top: 1em;
	text-align: center;
}
.annotated {
	margin: 20px 0;
	padding: 15px 30px 15px 15px;
	border-left: 5px solid #eee;
}
.annotated p:last-child {
	margin-bottom: 0;
}
.note {
	background-color: #f0f7fd;
	border-color: #d0e3f0;
}
.quote {
	background-color: #f7f7f7;
	border-color: #d0e3f0;
	font-style: italic;
	margin-left: 3em;
}
.todo {
	color: red;
	background-color: yellow;
}';
			yourself);
		addChild: ((PRFile named: 'pier.png')
			filename: 'pier.png';
			mimetype: 'image/png';
			contents: #(137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 125 0 0 0 59 8 2 0 0 0 217 227 18 3 0 0 0 25 116 69 88 116 83 111 102 116 119 97 114 101 0 65 100 111 98 101 32 73 109 97 103 101 82 101 97 100 121 113 201 101 60 0 0 11 128 73 68 65 84 120 218 236 92 95 108 20 199 25 159 221 251 135 237 59 167 150 33 22 118 8 146 35 25 91 10 180 17 9 8 94 138 2 60 244 1 106 250 84 12 177 213 23 136 68 250 2 168 41 72 141 44 30 74 26 21 164 170 32 5 75 81 98 2 230 165 170 221 152 170 145 48 200 17 18 22 6 75 169 105 226 179 19 211 144 96 163 68 118 0 223 249 236 251 59 253 237 140 111 188 183 123 183 55 187 103 83 27 238 211 228 56 150 221 157 217 223 126 243 251 126 223 55 115 81 40 165 100 233 89 98 42 52 121 245 218 163 254 219 211 193 225 240 80 80 28 119 151 7 42 183 191 94 211 188 207 223 80 79 150 179 41 75 13 247 71 253 183 198 206 95 156 236 185 102 125 218 134 243 31 252 100 211 107 69 220 23 6 241 111 207 188 143 79 153 147 87 212 84 111 186 250 233 242 197 221 189 68 198 49 122 242 189 177 246 11 242 231 207 142 141 47 107 158 89 18 184 15 31 251 195 247 157 255 176 117 9 252 125 89 227 174 46 5 122 177 11 58 172 106 207 47 139 184 23 100 136 162 118 47 129 152 169 105 222 95 196 189 32 75 78 133 236 130 190 161 253 3 8 202 34 238 79 206 106 90 246 63 5 160 47 137 184 138 36 72 70 59 86 238 120 125 237 161 55 151 123 186 180 180 244 59 178 164 123 103 223 215 231 165 122 86 169 106 220 13 208 151 187 128 89 186 121 19 36 249 236 216 216 227 254 219 218 52 12 4 202 26 214 249 235 235 159 2 74 89 30 117 130 121 157 51 254 253 205 129 65 124 246 15 220 105 88 87 91 179 186 106 199 182 45 53 213 85 207 28 238 67 195 119 241 9 8 100 206 12 133 195 248 18 240 251 101 206 215 91 255 192 96 79 111 31 62 121 119 220 214 164 226 165 52 53 161 186 95 122 245 149 119 91 15 23 136 62 110 62 21 154 30 26 30 157 143 49 213 85 47 84 87 109 218 184 193 174 79 224 251 230 87 55 100 189 16 255 138 7 153 10 105 56 148 7 252 6 167 201 131 59 198 215 211 123 227 106 111 31 110 193 143 0 199 243 231 222 43 15 148 101 237 166 243 242 21 61 94 172 203 178 230 189 141 45 77 123 204 151 24 122 185 53 112 7 159 248 142 35 235 146 209 117 169 88 93 50 202 17 159 207 108 93 190 182 85 107 79 182 30 193 99 20 254 58 205 246 171 93 59 223 58 176 47 215 123 197 216 218 59 58 59 47 247 112 196 133 157 61 245 142 126 60 56 237 76 219 133 246 142 46 243 205 143 29 57 200 113 200 137 59 110 125 166 237 162 0 194 112 253 201 214 195 121 187 201 16 45 213 85 103 255 252 142 193 247 1 129 246 82 63 235 19 88 108 77 68 94 73 204 212 165 98 122 172 13 246 161 175 226 63 21 171 240 238 101 102 18 158 226 239 221 87 204 72 89 219 241 35 7 91 154 26 13 247 105 191 212 213 217 125 197 140 6 247 197 174 142 179 226 175 111 28 120 27 47 56 235 157 133 215 102 193 29 215 0 68 225 224 102 195 180 250 184 237 79 252 59 78 59 214 122 42 235 104 12 134 206 48 56 188 0 220 191 179 187 71 255 70 43 105 114 119 108 234 103 201 217 50 154 242 16 226 98 7 83 186 166 31 98 183 183 252 19 79 0 247 185 214 253 145 53 226 240 27 128 238 140 139 4 244 218 107 235 238 201 133 163 176 91 189 127 227 142 252 215 115 23 208 175 197 153 28 189 12 253 142 62 206 95 234 178 158 137 130 31 241 37 175 155 27 38 233 239 91 79 227 133 235 47 1 226 191 137 62 4 171 248 32 25 9 241 165 143 211 52 226 137 204 70 51 29 25 51 47 107 95 120 120 60 136 140 55 228 50 60 26 62 225 227 146 19 37 56 50 10 64 209 35 250 205 139 30 70 238 118 54 208 198 166 67 161 80 216 238 131 161 75 189 227 128 85 0 58 224 94 69 136 23 148 199 154 1 247 36 131 59 206 90 140 16 125 127 136 7 102 220 1 211 161 163 39 242 186 142 140 151 252 241 212 57 249 243 111 222 30 4 238 96 127 25 76 16 47 149 199 83 225 230 131 191 43 124 160 118 13 62 126 116 118 162 134 144 10 17 226 51 79 160 233 79 202 208 231 184 255 64 200 199 222 231 122 60 126 78 92 152 221 250 75 228 73 111 193 13 131 217 179 107 167 252 236 119 17 111 229 245 27 3 79 126 160 191 142 61 126 153 38 158 79 187 185 194 255 80 231 221 30 71 196 49 52 15 107 152 243 159 122 2 147 170 54 77 163 177 248 142 109 91 87 173 172 16 36 121 248 248 187 56 104 45 87 160 133 98 177 248 208 200 2 251 25 250 253 247 157 160 141 186 152 227 200 83 160 149 16 234 226 160 186 137 226 101 205 151 254 194 155 71 107 90 1 73 157 123 7 156 19 35 138 170 115 240 27 2 244 99 173 167 173 123 228 50 12 1 6 74 241 217 173 71 206 16 5 25 69 196 77 102 221 140 221 121 243 105 232 19 93 19 239 0 51 115 154 205 131 239 84 207 60 81 126 214 151 166 151 211 121 121 0 218 89 136 218 255 63 238 242 73 154 133 48 114 112 213 39 222 242 160 226 25 141 145 175 102 201 189 40 115 118 134 50 49 249 62 73 31 76 185 200 164 226 50 100 0 8 212 224 244 188 221 33 119 19 137 219 147 15 102 102 39 112 35 215 194 108 133 12 24 127 240 67 214 44 201 250 122 158 191 224 73 160 112 108 245 13 183 61 81 2 122 39 72 145 254 18 121 48 171 146 18 111 102 84 165 132 50 89 163 112 89 147 36 51 73 50 65 141 133 235 67 71 78 200 140 89 175 124 242 138 113 110 32 37 92 133 155 227 209 108 165 93 128 197 122 72 240 84 55 78 18 99 170 239 168 181 37 158 222 58 176 159 39 141 248 196 189 36 159 199 96 156 175 147 174 180 150 212 225 174 164 19 39 202 112 159 157 33 35 46 159 89 240 229 237 66 43 171 233 184 165 253 146 148 234 64 208 230 32 214 172 174 146 199 29 193 3 23 90 123 33 50 50 213 48 62 121 188 240 36 250 100 122 211 198 245 206 38 93 165 6 42 241 149 166 185 37 51 186 10 146 65 139 81 50 145 201 51 14 152 16 17 88 6 68 248 162 69 65 201 250 109 1 70 67 153 193 48 24 52 213 49 83 183 236 109 92 16 178 91 147 138 187 160 102 203 116 160 235 162 171 32 125 180 153 184 145 223 37 173 190 174 86 76 142 147 18 19 90 31 132 237 26 247 93 193 4 230 127 5 177 23 164 103 12 21 193 254 129 59 206 238 243 98 42 94 170 57 187 66 50 155 226 229 109 206 223 227 38 49 35 111 33 198 69 0 29 25 162 12 47 65 227 59 115 118 193 102 60 242 233 131 10 215 175 93 29 103 249 157 221 134 36 91 190 131 133 82 99 107 146 177 18 191 6 241 156 15 40 233 36 21 113 53 69 73 82 81 52 114 167 177 25 45 18 232 197 187 188 117 94 190 130 209 158 105 187 32 163 100 16 78 77 46 37 27 183 16 9 244 147 6 183 210 23 110 245 150 137 251 3 89 220 55 155 24 201 89 80 229 9 148 175 140 249 184 194 178 86 30 86 117 74 134 178 26 77 120 150 58 115 118 46 28 33 123 228 53 140 221 184 237 192 28 238 39 16 140 105 119 162 100 45 212 148 86 184 230 252 61 141 187 94 201 40 9 40 27 37 73 29 146 187 188 248 203 186 156 18 28 25 181 19 192 215 59 193 93 62 161 48 4 141 155 78 157 157 175 111 248 202 25 161 43 233 226 204 28 201 104 206 14 146 161 172 64 51 51 67 121 89 102 49 12 130 34 215 242 225 34 37 89 238 204 57 21 118 150 163 6 157 150 153 32 102 52 220 159 83 136 75 248 59 3 94 144 76 130 147 15 141 76 211 97 183 119 49 16 255 237 193 125 22 66 206 214 163 149 7 252 139 200 51 230 88 111 177 56 149 23 247 192 42 149 64 183 112 220 85 134 123 186 248 171 145 12 254 198 200 39 153 32 17 143 186 128 112 131 19 64 229 121 213 193 144 29 158 145 79 128 220 14 180 96 125 221 75 6 114 119 204 239 165 132 186 53 133 206 252 221 69 20 94 120 20 36 147 208 190 226 208 212 36 117 44 34 133 30 127 129 65 12 201 145 11 107 120 207 208 240 168 97 127 192 147 224 25 103 38 153 118 243 36 16 238 163 127 146 58 4 213 149 42 241 40 138 91 195 157 168 10 47 18 104 36 147 160 148 113 190 6 189 90 80 80 109 222 219 152 107 69 80 36 177 103 218 46 114 239 193 23 161 106 236 138 52 189 142 204 83 143 204 200 47 194 97 185 73 154 17 181 59 165 43 248 72 28 182 255 60 67 48 172 76 37 128 187 6 186 103 46 75 66 2 165 176 164 73 59 226 81 136 91 163 32 215 10 165 146 38 183 38 34 218 254 142 100 212 46 238 188 92 156 213 128 236 27 7 222 62 214 122 90 63 101 69 78 107 215 217 229 115 26 181 192 216 221 222 33 187 42 203 201 148 23 155 244 197 25 119 137 162 45 125 128 66 188 76 213 64 200 11 208 93 132 183 210 10 165 186 193 245 166 235 209 209 217 9 180 221 113 123 91 183 241 92 0 87 255 116 124 89 188 177 233 80 214 61 23 120 34 126 48 56 178 88 21 99 39 60 19 10 79 139 231 225 235 238 50 12 203 87 121 16 121 68 153 148 139 153 242 26 149 145 59 163 26 143 182 190 167 105 71 38 105 52 198 87 231 116 100 77 131 90 93 171 144 40 29 255 58 85 247 93 148 120 236 237 155 4 142 64 89 75 179 87 87 65 146 231 245 21 78 241 247 11 200 75 100 113 151 143 141 32 22 182 103 33 140 249 40 233 236 96 88 49 7 225 242 124 113 17 206 238 11 164 211 84 149 185 54 99 21 26 103 178 93 200 121 253 70 3 133 68 194 206 3 172 164 4 16 193 192 113 18 110 7 119 233 34 1 176 150 76 187 117 26 121 254 103 49 175 109 92 207 113 127 49 21 247 249 149 140 141 3 72 80 21 58 183 226 33 140 255 19 251 111 98 60 245 104 130 246 148 250 201 162 25 102 36 47 70 218 21 105 182 170 232 139 190 190 42 42 159 186 66 102 6 197 207 169 70 32 158 160 36 78 193 36 218 103 18 60 147 110 148 55 50 121 63 245 205 23 169 15 125 21 139 87 48 208 239 254 148 119 196 185 107 51 229 181 44 238 55 111 47 252 156 226 219 34 13 121 86 185 182 181 189 118 222 151 147 12 101 13 116 66 99 148 55 77 68 38 88 234 196 94 73 52 76 131 215 19 95 12 82 128 126 195 93 186 72 160 235 235 180 206 46 95 18 254 206 119 107 102 149 86 205 108 205 228 91 213 51 253 99 42 49 163 57 56 141 51 184 163 172 105 208 19 126 240 225 127 147 95 245 198 7 255 25 191 254 208 119 162 228 121 61 232 0 168 165 169 209 238 62 239 92 132 126 173 251 35 61 25 58 0 221 86 97 220 109 86 41 11 98 64 228 120 238 37 27 60 231 249 75 93 159 15 223 253 50 238 243 253 43 182 118 179 135 169 26 38 93 224 229 81 58 53 150 2 226 63 126 147 74 198 40 176 238 41 241 139 88 202 196 232 22 196 12 94 59 148 217 141 108 161 178 246 236 218 217 162 139 249 14 146 32 158 12 91 231 101 102 155 223 15 108 177 123 216 174 239 200 188 124 190 250 115 47 248 245 174 120 104 71 60 236 242 42 101 149 154 106 153 158 164 192 58 162 168 159 187 86 12 187 124 248 228 107 29 2 235 172 119 182 222 39 109 70 10 183 218 190 109 75 94 176 16 255 45 52 27 31 207 30 71 43 177 78 112 135 35 163 51 156 124 181 183 79 40 92 204 247 250 186 90 196 76 249 65 112 93 132 251 148 210 84 93 42 6 121 19 33 10 252 122 66 117 243 200 105 112 109 201 20 9 55 68 72 52 231 128 252 199 58 184 155 45 106 226 191 137 16 218 166 60 160 253 130 197 193 239 88 114 226 190 110 227 47 36 175 1 107 47 8 171 10 141 12 150 16 123 187 133 31 61 77 191 102 202 201 239 182 248 209 113 196 207 93 146 221 64 158 49 83 57 139 217 218 174 100 87 216 22 45 11 238 50 59 105 205 28 90 4 174 64 115 221 29 143 88 239 25 55 219 221 123 247 65 190 242 107 90 69 203 130 187 191 114 173 221 107 66 161 105 136 54 232 253 159 174 111 240 249 188 69 16 29 242 187 51 67 40 182 85 29 43 90 6 238 22 59 40 101 36 96 17 65 135 184 155 127 35 107 171 2 83 68 176 160 188 201 226 215 217 22 42 94 242 71 211 69 179 202 87 5 117 220 188 61 24 28 185 139 23 144 107 61 140 111 62 177 254 95 14 20 205 218 254 39 192 0 85 75 56 201 129 50 9 35 0 0 0 0 73 69 78 68 174 66 96 130) asByteArray;
			yourself);
		addChild: ((PRPage named: 'title')
			contents: '!*/*';
			yourself);
		addChild: ((PRComponent named: 'search')
			prototypeInstance: PRSearchWidget new;
			yourself);
		addChild: ((PRComponent named: 'children')
			prototypeInstance: (PRDynamicChildrenWidget new
				level: 1;
				yourself);
			yourself);
		addChild: ((PRPage named: 'sidebar')
			addChild: ((PRComponent named: 'navigation')
				prototypeInstance: (PRDynamicChildrenWidget new
					level: 2;
					expanded: true
					yourself);
				yourself);
			addChild: ((PRComponent named: 'views')
				prototypeInstance: PRViewsWidget new;
				yourself);
			addChild: ((PRComponent named: 'commands')
				prototypeInstance: PRCommandsWidget new;
				yourself);
			contents: '*navigation|embedded=true*
*views|embedded=true*
*commands|embedded=true*';
			yourself);
		addChild: ((PRComponent named: 'contents')
			prototypeInstance: (PRContentsWidget new
				heading: '%c';
				yourself);
			yourself);
		addChild: ((PRPage named: 'footer')
			contents: 'Powered by *Seaside>http://www.seaside.st/*, *Magritte>http://www.lukas-renggli.ch/smalltalk/magritte*
		and *Pier>http://www.piercms.com/*.';
			yourself);
		contents: '{{{<div class="container">
	<div class="header column span-24">
		<div class="title column span-20">}}}*title|embedded=true*{{{</div>
		<div class="search column span-4 last">}}}*search|embedded=true*{{{</div>
		<div class="children column span-24 last">}}}*children|embedded=true*{{{</div>
	</div>
	<div class="body column span-24">
		<div class="sidebar column span-4">}}}*sidebar|embedded=true*{{{</div>
		<div class="contents column span-20 last">}}}*contents|embedded=true*{{{</div>
	</div>
	<div class="footer column span-24">}}}*footer|embedded=true*{{{</div>
</div>}}}';
	yourself
]

{ #category : #'*Pier-Seaside-descriptions' }
PRStructure >> descriptionCustomCssClasses [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'Custom CSS classes associated with this structure.';
		accessor: #customCssClasses;
		group: 'Layout Settings';
		label: 'CSS Classes';
		priority: 830;
		beSetting;
		yourself
]

{ #category : #'*Pier-Seaside-descriptions' }
PRStructure >> descriptionEnvironment [
	<magritteDescription>
	^ PRStructureDescription new
		accessor: #localEnvironment;
		addCondition: (MACondition selector: #hasDocument) labelled: 'The template has to have a document';
		addCondition: (MACondition selector: #hasContentsWidget)
			labelled: 'Invalid template, make sure to embed the contents widget';
		group: 'Layout Settings';
		label: 'Template';
		priority: 800;
		beSetting;
		yourself
]

{ #category : #'*Pier-Seaside-descriptions' }
PRStructure >> descriptionHideFromMenus [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Hides this structure from navigation facilities.';
		checkboxLabel: 'Hide from menus';
		accessor: #hideFromMenus;
		label: 'Visibility';
		priority: 10;
		beSetting;
		yourself
]

{ #category : #'*Pier-Seaside-descriptions' }
PRStructure >> descriptionIcon [
	<magritteDescription>
	^ PRStructureDescription new
		accessor: #localIcon;
		addCondition: (MACondition selector: #isFile) & (MACondition selector: #isImage) labelled: 'Invalid icon';
		group: 'Layout Settings';
		label: 'Shortcut Icon';
		priority: 820;
		beSetting;
		yourself
]

{ #category : #'*Pier-Seaside-descriptions' }
PRStructure >> descriptionNavigationTitle [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'A short title used for navigation facilities.';
		label: 'Navigation Title';
		parameterName: 'menu';
		accessor: #menu;
		beSearchable;
		priority: 20;
		beSetting;
		yourself
]

{ #category : #'*Pier-Seaside-descriptions' }
PRStructure >> descriptionStyleSheet [
	<magritteDescription>
	^ PRStructureDescription new
		addCondition: (MACondition selector: #isFile) & (MACondition selector: #isText) labelled: 'Invalid style sheet';
		accessor: #localStyleSheet;
		group: 'Layout Settings';
		label: 'Style Sheet';
		priority: 810;
		beSetting;
		yourself
]

{ #category : #'*Pier-Seaside-descriptions' }
PRStructure >> descriptionTagsSeaside: aDescription [
	<magritteDescription: #descriptionTags>
	^ aDescription beSetting
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> environment [
	"Answer the (inherited) environment structure of the receiver, if none is available a default one is created."

	^ self localEnvironment ifNil: [
		self isRoot
			ifTrue: [ self newEnvironment ]
			ifFalse: [ self parent environment ] ]
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> icon [
	"Answer the (inherited) icon structure of the receiver,"

	| icon |
	icon := self localIcon.
	^ (icon notNil and: [icon file notNil])
		ifTrue: [ icon ]
		ifFalse: [
			self isRoot
				ifTrue: [ nil ]
				ifFalse: [ self parent icon ] ]
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> localEnvironment [
	^ self propertyAt: #localEnvironment ifAbsent: [ nil ]
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> localEnvironment: aStructure [
	self propertyAt: #localEnvironment put: aStructure
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> localIcon [
	^ self propertyAt: #localIcon ifAbsent: [ nil ]
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> localIcon: aStructure [
	self propertyAt: #localIcon put: aStructure
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> localStyleSheet [
	^ self propertyAt: #localStyleSheet ifAbsent: [ nil ]
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> localStyleSheet: aStructure [
	self propertyAt: #localStyleSheet put: aStructure
]

{ #category : #'*Pier-Seaside-configuration' }
PRStructure >> newEnvironment [
	self localEnvironment: self defaultEnvironment.
	self localStyleSheet: (self localEnvironment 
		childrenDecoration at: 'style.css').
	self childrenDecoration copy children do: [ :each |
		self localEnvironment name = each name
			ifTrue: [ self childrenDecoration remove: each ] ].
	self childrenDecoration add: self localEnvironment.
	^ self localEnvironment
]

{ #category : #'*Pier-Seaside-description' }
PRStructure >> settingsDescription [
	"Answer a description container of settings for the Seaside view."

	^ self magritteDescription select: [ :each | each isSetting ]
]

{ #category : #'*Pier-Seaside-environment' }
PRStructure >> styleSheets [
	"Answer the a collection of stylesheets of the receiver."
	| all |
	all := self parents collect: [ :each | each localStyleSheet ].
	^ all reject: [ :each | 
		each isNil or: [ 
			each file isNil ] ]
]

{ #category : #'*Pier-Seaside-configuration' }
PRStructure >> viewComponentClass [
	"Return the default view component class of the reciever."

	^ PRDefaultView
]
