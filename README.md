# Pier3
Pier3 is a content management system (CMS) written in Smalltalk, official site is: http://www.piercms.com/. It relies on the Seaside webserver (http://www.seaside.st), and uses Magritte and Pillar as its model. This version has been tested only in Pharo (https://pharo.org).

This is a port of the code to Github, instructions on loading are: http://www.myborden.com/pier/john-c-borden/smalltalk/pier/loading-with-gofer

This can be loaded from Pharo 7 by running this in a workspace:
```
Metacello new
  baseline:'PierCore';
  repository: 'github://jborden23/Pier3:master/repository';
  onConflict: [ :ex | ex allow ];
  load.
```
