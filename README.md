TunlrSwitcher
=============

A quick menubar application for Mac that lets you quickly switch between the [Tunlr DNS servers](http://www.tunlr.net) and default empty DNS settings on all adaptors.

Currently VERY hacky. A shell script is used to change the DNS servers using networksetup. The shell script is called via AppleScript embedded in Objective-C. This was the easiest way to get the administrative privileges required to run the script as Apple have made it much more difficult to do so (have to register code-signed helper applications and communicate via sockets). I'm pretty unfamiliar with Objective-C/Cocoa so if anyone knows a better way I'm happy to accept pull requests.