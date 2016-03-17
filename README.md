# mpcs51030-2016-winter-project-scj0055
mpcs51030-2016-winter-project-scj0055 created by Classroom for GitHub

Attributions:
/// -Attribution: http://www.brianjcoleman.com/tutorial-rate-me-using-uialertview-in-swift/

/// -Attribution: AudioKit documentation

/// -Attribution: class, lecture

/// -Attribution: AudioKit documentation

/// -Attribution: AudioKit documentation

/// -Attribution: AudioKit documentation

/// -Attribution: AudioKit documentation

/// -Attribution: All of these came from lecture/previous projects

/// -Attribution: For all of the following - previous lecture/projects/in-class slides


I think my marketing materials do a fairly good job of describing the app, so I'll refrain from doing that here.

KNOWN ISSUE: There is one known issue at this point that I can't figure out for the life of me, and I think it's related to some 
weird bug in CoreAudio. If you switch patches, then attempt to use the ribbon controller, the app will crash. The only thing 
that I've been able to find about this is some sort of potential Apple bug relating to a memory leak, but that was supposed 
to be fixed in iOS 8. Anyways, to test the ribbon controller, you can do so on startup - it will work when the default patch
is initialized and the app loads. 
