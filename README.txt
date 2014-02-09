Have you ever been doing Baneclaw and been unable to find a downed player in the sea of Mammoths? Have you ever been doing a crowded ARES mission and been unable to find an injured player? Well, this addon should help alleviate situations like those.

Medic! is an addon that places a noticeable marker above a player who needs a revive or healing, making it easy to find them in a crowded area. It also has the option to display who needs healing/a revive in chat if you so desire. It's fully customizable, allowing you to control when it notifies you based on class and distance from people, and for how long.

Compatable with Melder - if you're pulling this from Github, just zip all the files up and add it to your addons folder.

Version History:

Version 1:
Initial Release

Version 1.2:
*Fixed some really terrible grammar
*Moved enable button
*Added option for health on text notification
*Included a suggested addition to prevent freezing if the player is not fully loaded yet
*Added option for displaying the name of the person in need on the marker

Version 1.3:
*Fixed the bug where markers were getting stuck (I believe)

Version 1.4
*Coded by Legendinium
*Added icons to the markers
*Added Marker/trail/icon colors
*Added Marker "ping" count and interval
*Added Audio alert on initial marker ping
*Added Activation and marker destroy threshold based on caller's health
*Added friends only mode
*Added option for live status (HP% or time-till-respawn) on marker
*Marker auto-destroys on next ping when no longer needed

Version 1.5:
*Coded by Legendinium
*Added safeguard on self spawn that destroys any lingering Medic! markers
*Added slash command '/medic clear' to manually clear all Medic! markers
*Fixed a bug where Accord Bios would not pass the "canHeal()" test
*Added tooltips to all the options under 'Esc->Options->Addons->Medic!' and changed healthy threshold to % for clarity
 
Known Issues:
* With the latest milestone patch, the FireFall core has adopted some basic features from the Medic! addon. It will now create markers of its own on player distress, though without pings, health/respawn info or indeed any user configurability.
(Health marker created only if distressed player has less than 50% HP, lasts 6 seconds, 1 initial ping only. Revive marker lasts 30 seconds, 1 initial ping only)
Medic! plays nice with this new core feature so long as the "Add Name To Marker" option is enabled. The next release of Medic! will integrate, extend or disable this part of the FireFall's functionality.
 
ToDo:
+Integrate with FireFall Core SOS functionality.
*Implement ping extensions
*Consider Color-by-severity-of-distress mode
*Implement "responsive mode" (faster update on life/time callbacks)
*Implement marker texture/color change on revive