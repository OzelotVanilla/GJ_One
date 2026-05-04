`levels` Folder
====

Contains the levels in the game.

Level Design
----

The game is split to two main phases:
The first phase begins as soon as the player boots the game, in which they see their character, the dog - and a button that says "BUTTON".
If the player clicks the button or activates it using the keyboard, the dog barks and the button text eventually changes to "QUIT", and if the player clicks again the game closes.
From the second boot onwards, the player is given a hint that says "BARK = BUTTON"/"WAN = BUTTON", and when the text changes, so does the hint to "BARK = QUIT"/"WAN = QUIT".
The player is expected to understand that what the bark does is decided based on what is written on the button, and that this screen is in fact a tutorial. The player is expected to change the text of the button from BUTTON/QUIT to "START" and start the game.

The second phase is the main phase of the game: The player is a dog living comfortably in a house with their owner, and they need to manage their life using the ability to bark alone.
Bark can mean different things. Currently brainstormed meanings are:

* BARK = HUNGRY (when the dog needs to eat)
* BARK = SLEEP (when the dog is tired and wants the owner to make their bed)
* BARK = ALERT (when someone is at the door)
* BARK = WALK (when the dog needs a walk)
* BARK = PLAY (when the dog wants to play with the owner)

The map is made of the player's house and the included characters are:
* The dog (playable)
* The owner (NPC)
* Visitors (NPC)
-> possible expansions: Different types of NPC (good visitor/suspicious person)

The game can get gradually more challenging when the player is confronted with multiple needs at once. Examples:
1. The dog is hungry but there is a visitor
2. The dog needs to go on a walk but did not have sleep

The goal can be either:
1. Survive as long as possible
2. Survive a day
3. Make the owner happy