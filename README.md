# Pier3
Pier3 is a CMS in Smalltalk, official site is: http://www.piercms.com/

This is a port of the code to Github, instructions on loading are: http://www.myborden.com/pier/john-c-borden/smalltalk/pier/loading-with-gofer

This can be loaded from Pharo 7 with:
 `Metacello new
  baseline:'PierCore';
  repository: 'github://jborden23/Pier3:master/repository';
  onConflict: [ :ex | ex allow ];
  load.`
