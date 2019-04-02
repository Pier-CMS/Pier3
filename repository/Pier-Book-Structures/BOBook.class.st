Class {
	#name : #BOBook,
	#superclass : #BOPublication,
	#instVars : [
		'subtitle',
		'tagline',
		'authors',
		'additionalAuthors',
		'latexHeader',
		'latexFooter'
	],
	#category : #'Pier-Book-Structures'
}

{ #category : #testing }
BOBook class >> canBeChildOf: aStructureClass [
	^ (aStructureClass includesBehavior: BOPublication) not
]

{ #category : #testing }
BOBook class >> isAbstract [
	^ false
]

{ #category : #accessing }
BOBook class >> label [
	^ 'Book'
]

{ #category : #visiting }
BOBook >> accept: aVisitor [
	aVisitor visitBook: self
]

{ #category : #accessing }
BOBook >> additionalAuthors [
	^ additionalAuthors
]

{ #category : #accessing }
BOBook >> additionalAuthors: aString [
	additionalAuthors := aString
]

{ #category : #accessing }
BOBook >> authors [
	^ authors
]

{ #category : #accessing }
BOBook >> authors: aString [
	authors := aString
]

{ #category : #defaults }
BOBook >> defaultLatexFooter [
	^ '{\small\raggedright\printindex}
\cleardoublepage
\cleardoublepage
\cleardoublepage'	
]

{ #category : #defaults }
BOBook >> defaultLatexHeader [
	^ '\documentclass[a4paper,10pt,twoside]{book}
\usepackage[
	papersize={6.13in,9.21in},
	hmargin={.75in,.75in},
	vmargin={.75in,1in},
	ignoreheadfoot
]{geometry}

% packages
\usepackage{tikz}
\usepackage{color}
\usepackage{xcolor}
\usepackage{xspace}
\usepackage{ifthen}
\usepackage{amsbsy}
\usepackage{amssymb}
\usepackage{tabularx}
\usepackage{verbatim}
\usepackage{needspace}
\usepackage{microtype}

% english
\usepackage[english]{babel}
\usepackage[parfill]{parskip}
\usepackage[normalem]{ulem}

% fonts
\usepackage{lmodern}
\usepackage{palatino}
\usepackage[T1]{fontenc}

% references
\usepackage{hyperref}
\usepackage[all]{hypcap}
\setcounter{tocdepth}{2}
\hypersetup{
	colorlinks=true,
	linkcolor=black,
	anchorcolor=black,
	citecolor=black,
	filecolor=black,
	pagecolor=black,
	urlcolor=black,
	plainpages=black,
	bookmarksopen=true,
	bookmarksopenlevel=2}

% boxes
\newsavebox{\StandoutBox}

\definecolor{noteBackground}{HTML}{EBEBEB}
\definecolor{noteForeground}{HTML}{777777}
\newenvironment{note}%
	{\begin{lrbox}{\StandoutBox}%
	 \begin{minipage}{0.97\textwidth}}
	{\end{minipage}%
	 \end{lrbox}%
	 \begin{center}
		\begin{tikzpicture}
			\node [fill=noteBackground, rectangle, rounded corners, inner sep=5pt] (box)
				{\usebox{\StandoutBox}};
			\node [text=noteForeground, anchor=south west] at (box.north west)
				{\textbf{Note}};
		\end{tikzpicture}
	 \end{center}}

\definecolor{advancedBackground}{HTML}{D9E6EE}
\definecolor{advancedForeground}{HTML}{01598E}
\newenvironment{advanced}%
	{\begin{lrbox}{\StandoutBox}%
	 \begin{minipage}{0.97\textwidth}}
	{\end{minipage}%
	 \end{lrbox}%
	 \begin{center}
		\begin{tikzpicture}
			\node [fill=advancedBackground, rectangle, rounded corners, inner sep=5pt] (box)
				{\usebox{\StandoutBox}};
			\node [text=advancedForeground, anchor=south west] at (box.north west)
				{\textbf{Advanced}};
		\end{tikzpicture}
	 \end{center}}

\definecolor{importantBackground}{HTML}{E8E0EF}
\definecolor{importantForeground}{HTML}{662D91}
\newenvironment{important}%
	{\begin{lrbox}{\StandoutBox}%
	 \begin{minipage}{0.97\textwidth}}
	{\end{minipage}%
	 \end{lrbox}%
	 \begin{center}
		\begin{tikzpicture}
			\node [fill=importantBackground, rectangle, rounded corners, inner sep=5pt] (box)
			 	{\usebox{\StandoutBox}};
			\node [text=importantForeground, anchor=south west] at (box.north west)
				{\textbf{Important}};
		\end{tikzpicture}
	 \end{center}}

\newenvironment{todo}%
	{\obeylines\comment}%
	{\endtrivlist\normalsize}

\newenvironment{blockquote}%
	{\begin{quote}}
	{\end{quote}}

% source code
\usepackage{textcomp}
\usepackage{listings}
\lstset{
	language={},
	% characters
	tabsize=3,
	frame=single,
	framesep=2pt,
	upquote=true,
	framerule=0pt,
	keepspaces=true,
	breaklines=true,
	alsoletter={\#:},
	mathescape=false,
	columns=fullflexible,
	breakautoindent=true,
	showstringspaces=false,
	basicstyle=\sffamily,
	backgroundcolor=\color{noteBackground}}
\newcommand{\ct}[1]{{\sffamily\textup{#1}}}

% float placement: http://www.tex.ac.uk/cgi-bin/texfaq2html?label=floats
\renewcommand{\topfraction}{.85}
\renewcommand{\bottomfraction}{.7}
\renewcommand{\textfraction}{.15}
\renewcommand{\floatpagefraction}{.66}
\renewcommand{\dbltopfraction}{.66}
\renewcommand{\dblfloatpagefraction}{.66}
\setcounter{topnumber}{9}
\setcounter{bottomnumber}{9}
\setcounter{totalnumber}{20}
\setcounter{dbltopnumber}{9}

% supress widows and orphans
\widowpenalty=300
\clubpenalty=300

% keyword index 
\usepackage{makeidx}
\makeindex
\makeglossary

% graphics
\usepackage{graphicx}
\DeclareGraphicsExtensions{.png,.jpg,.pdf,.gif}

% references
\def\partautorefname{Part}
\def\chapterautorefname{Chapter}
\def\sectionautorefname{Section}
\def\subsectionautorefname{Section}
\def\figureautorefname{Figure}
\def\tableautorefname{Table}'
]

{ #category : #descriptions }
BOBook >> descriptionAdditionalAuthors [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'additionalAuthors';
		accessor: #additionalAuthors;
		label: 'Additional Authors';
		priority: 500;
		beSearchable;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOBook >> descriptionAuthors [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'authors';
		accessor: #authors;
		label: 'Authors';
		beSearchable;
		priority: 400;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOBook >> descriptionLatexFooter [
	<magritteDescription>
	^ MAMemoDescription new
		comment: 'Everything that appears in the backmatter of the book, before the document ends.';
		accessor: #latexFooter;
		label: 'Footer';
		priority: 1100;
		group: 'LaTeX';
		lineCount: 5;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOBook >> descriptionLatexHeader [
	<magritteDescription>
	^ MAMemoDescription new
		comment: 'Everythign that appears at the top of the generated code, before the document begins.';
		accessor: #latexHeader;
		label: 'Header';
		priority: 1000;
		group: 'LaTeX';
		lineCount: 10;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOBook >> descriptionNumberedTitle [
	<magritteDescription>
	^ nil
]

{ #category : #descriptions }
BOBook >> descriptionSubtitle [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'subtitle';
		accessor: #subtitle;
		label: 'Subtitle';
		beSearchable;
		priority: 200;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOBook >> descriptionTagline [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'tagline';
		accessor: #tagline;
		label: 'Tagline';
		beSearchable;
		priority: 300;
		beEditable;
		yourself
]

{ #category : #testing }
BOBook >> isNumberedTitle [
	^ false
]

{ #category : #'accessing-latex' }
BOBook >> latexFooter [
	^ latexFooter ifNil: [ self defaultLatexFooter ]
]

{ #category : #'accessing-latex' }
BOBook >> latexFooter: aString [
	latexFooter := aString
]

{ #category : #'accessing-latex' }
BOBook >> latexHeader [
	^ latexHeader ifNil: [ self defaultLatexHeader ]
]

{ #category : #'accessing-latex' }
BOBook >> latexHeader: aString [
	latexHeader := aString
]

{ #category : #accessing }
BOBook >> subtitle [
	^ subtitle
]

{ #category : #accessing }
BOBook >> subtitle: aString [
	subtitle := aString
]

{ #category : #accessing }
BOBook >> tagline [
	^ tagline
]

{ #category : #accessing }
BOBook >> tagline: aString [
	tagline := aString
]

{ #category : #accessing }
BOBook >> type [
	^ #book
]
