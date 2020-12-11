BO2: ZM QOL Mod (Quality of Life)
===============================

**[Download latest public release.](https://github.com/mikzyy/zm-QoL-mod/releases)**

# Overview

The Black Ops 2 Quality of Life Mod is a mod that makes all the basic and essential features on a server easy to use and super configurable to your liking!

Mods featured:
* Revive rewards (both for player revived and player reviving)
* Round rewards
* and more!

# Contributing 

To contribute to the project, we accept any changes you may think could be added, whether its a fix or a new feature! We will be looking at this project when we have free time, 
so feel free to help us out! All you need to do is:
1. Fork the repository
2. Go to your forked repository and make your changes
3. Go to your forked repository's pull requests and create a new one
4. Add the title/description of whatever you are adding

# Building

To build the source of the project, you must use GSC Studio or another program that can compile. (GSC Studio is recommended to use because of how we seperated all
of the files out seperately to make it more organized and easier to target functions and any bugs with it). If you cannot use GSC Studio, you can also
combine all of the files manually into one file and then compile then. We do not offer any support for building the project and is something you do on your
own if you have the knowledge to do so.

# Configurable Dvars

Because of how easy we want the mod to be for any server owner, new or old, we have decided to make it possible to change/configure the mod without having to rebuilt the sourc
or decompiling whatsoever! Thanks to JezuzLizard, one of the mod contributors, we were able to do this.

To modify the mod, you must modify the Dvars. To do so, follow these steps:
1. Go into your server config (dedicated_zm.cfg)
2. Find a area where you can put dvars, whether its below the sv_hostname or not.
3. To set the Dvar, you need to type ``set (dvar) (value)``

## List of configurable Dvars:
~~~
set QOL_thank_reviver 1                                 // Enable/Disable the "Press (Key) to say thanks" to thank reviver when revived
set QOL_thank_reviver_expire_time 5                     // How long (in seconds) until the "Press (Key) to say thanks" will disappear

set QOL_revive_rewards_on 1                             // [IMPORTANT] Enable/Disable overall revive rewards (*This needs to be on for thank revive & reviving rewards)

set QOL_thank_reviver_rewards_on 1                      // Enable/Disable giving the player a point reward for thanking the reviver (encourages good behavior)
set QOL_thank_reviver_reward 100                        // How much the point reward will be per thank you
set QOL_revive_rewards_points_on 1                      // Enable/Disable the reviver getting a point reward for reviving
set QOL_revive_rewards_points 500                       // How much the point reward will be per revive
set QOL_revive_rewards_speedboost_on 1                  // Enable/Disable the reviver getting a x1.2 speed boost from x1.0 for reviving
set QOL_revive_rewards_speedboost_length 3              // How long (in seconds) the speed boost will last

Round Dvars:
set QOL_round_salary_on 1                               // Enable/Disable getting points for advancing higher in rounds
set QOL_round_salary_points_per_round 50                // How many points you want to give per round. The math for this is: (salary * round number) - salary
set QOL_round_salary_printin 1                          // Enable/Disable the player getting the message: "New round! Rewarded X points."
~~~
