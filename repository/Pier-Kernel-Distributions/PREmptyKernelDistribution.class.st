Class {
	#name : #PREmptyKernelDistribution,
	#superclass : #PRAbstractKernelDistribution,
	#category : #'Pier-Kernel-Distributions'
}

{ #category : #testing }
PREmptyKernelDistribution class >> isAbstract [ 
	^ false
]

{ #category : #accessing }
PREmptyKernelDistribution class >> label [
	^ 'Blank Template'
]

{ #category : #accessing }
PREmptyKernelDistribution class >> thumbnail [
	^ PRKernelDistributionFileLibrary / #emptykernelPng
]

{ #category : #creation }
PREmptyKernelDistribution >> showCustomizeUIOn: calleeComponent thenAddRootToKernel:  theKernel [
	"no customization to be performed"
	theKernel root: 
		((PRPage named: 'root')
		contents: 'An minimal kernel, with just this one page and an empty template.';
		localEnvironment: ((PRComponent named: 'contents')
			prototypeInstance: (PRContentsWidget new heading: ''; yourself);
			yourself);
		yourself).
	^ theKernel

]
