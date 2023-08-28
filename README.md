# AltArrowFix

Bringing IntelliJ feel of editing source files to Xcode



## Project idea

I spent a lot of time working in IntelliJ before Xcode and I really got used to how Alt/Option + Arrow keys working there. IntelliJ does not skip special characters or the end of a line when moving a cursor or selection between words, while Xcode just skips them and jumps right to the next word even if it's on another line. I spent some time and figured there is no such setting or key binding inside Xcode that would do similar behavior to IntelliJs, so I decided to make a Source Editor Extension named AltArrowFix



## Installation

1. Open the project in Xcode

2. Product -> Archive

3. Right click on archive -> Show in Finder

4. Right click on the file in Finder -> Show Package Contents -> Products -> Applications

5. Move/copy AltArrowFix.app to Applications folder

6. Open it once and close it

7. Open System Settings -> Privacy & Security -> Extensions -> Xcode Source Editor

8. Activate AltArrowFixExtension

9. Map shortcuts for new commands in Xcode or you can use AltArrowKeyBindings.idekeybindings in the repository with my custom key bindings instead:

    1. Move the file to '~/Library/Developer/Xcode/UserData' folder
    2. Open Xcode -> Preferences -> Key Bindings
    3. Select AltArrowKeyBindings under Key Bindings Set

10. Enjoy

