# Pier3
Pier3 is a content management system (CMS) written in Smalltalk, official site is: http://www.piercms.com/. It relies on the Seaside webserver (http://www.seaside.st), and uses Magritte and Pillar as its model. This version has been tested only in Pharo (https://pharo.org).

This is a port of the code to Github, instructions on loading are: http://www.myborden.com/pier/john-c-borden/smalltalk/pier/loading-with-gofer

This can be loaded from Pharo 8, 9, 10 by running this in a workspace:
```
Metacello new
	baseline: 'Pier';
	repository: 'github://Pier-CMS/Pier3/repository';
	onConflictUseLoaded;
	load.
```
A more complete system with extra goodies can be loaded with:
```
Metacello new
  baseline:'Pier';
  repository: 'github://Pier-CMS/Pier3/repository';
  onConflictUseLoaded;
  load: 'addons'.
```
## Development
There are over 1200 tests for Pier. These can be loaded by following the above instructions, then in Iceberg, select Pillar and load the package Pillar-Tests-Core & Pillar-Tests-Model. Next run:
```
Metacello new
	baseline: 'PierTests';
	repository: 'github://Pier-CMS/Pier3/repository';
	onConflictUseLoaded;
	load: #('default').
```
