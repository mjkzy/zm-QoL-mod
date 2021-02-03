BO2: ZM QOL Mod (Quality of Life)
===============================

# Project Ended (Please Read)

Before reading, please know: This mod was not final and a good amount of the features implemented may not be working, or partially broken.

"This project was originally planned to be a All-in-One "Quality of Life" mod for Black Ops 2: Plutonium Zombies. At the time, I  was very invested into doing it while I had free time. Now, I don't have as much time to do so and the mod has sat here for 3 months without too much happening.
So, I'm open sourcing this project for anyone to get code snippets, or see how we went about doing a lot of the stuff.

We will still be taking contributions, and I will still check the issues from time to time. Please feel free to use ANY of this code from the mod. If you want to open a pull request too, we will review that as much as I check.

We hope you guys can get something from this :)"
-Mikey

## Overview

The Black Ops 2 "Quality of Life" Mod is a mod that makes all the basic and essential features on a server easy to use and super configurable to your liking, and features a variety of mods! Along with that, the mod has the ability to be compatible alongside other mods. (Stability and compatibility with other mods are not guaranteed)

## Contributing 

To contribute to the project, we accept any changes you may think could be added, whether its a fix or a new feature! We will be looking at this project when we have free time, 
so feel free to help us out! All you need to do is:
1. Fork the repository
2. Go to your forked repository and make your changes
3. Go to your forked repository's pull requests and create a new one
4. Add the title/description of whatever you are adding

## Building

To build the source of the project, you must use GSC Studio or another program that can compile. GSC Studio is recommended to use because of the way all of the files are seperated to make it more organized and easier to target functions and any bugs with it. If you cannot use GSC Studio, you can also combine all of the files manually into one file and then compile then. We do not offer any support for building the project and is something you do on your own if you have the knowledge to do so.

After compiling, you must rename the final product to "_scoreboard.gsc" and put it in: 
``<GAMEDIR>\t6r\data\maps\mp\gametypes_zm\_scoreboard.gsc``

## Configurable Dvars

Because of how easy we want the mod to be for any server owner, new or old, we have decided to make it possible to change/configure the mod without having to rebuilt the sourc
or decompiling whatsoever! Thanks to JezuzLizard, one of the mod contributors, we were able to do this.

To modify the mod, you must modify the Dvars. To do so, follow these steps:
1. Go into your server config (ex: dedicated_zm.cfg)
2. Find a area where you can put dvars. (You could do this anywhere like below the sv_hostname)
3. To set the Dvar, you need to type ``set (dvar) (value)``. The Dvar list is included in: ``resources/dvars.txt``
