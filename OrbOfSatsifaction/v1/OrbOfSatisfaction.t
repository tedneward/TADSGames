#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

/* The header, shown above, tells TADS to include some essential files. */

versionInfo: GameID
    IFID = '558c20af-6559-477a-9f98-b7b4274cd304'
    name = 'The Best Burglar'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">
                  Eric Eve</a>'
    version = '1'
    authorEmail = 'Eric Eve <eric.eve@hmc.ox.ac.uk>'
    desc = 'You are the world\'s best burglar faced with the greatest challenge
        of your felonious career.'
    htmlDesc = 'You are the world\'s best burglar faced with the greatest
        challenge of your felonious career.'
;

/* Notice that each object definition, including versionInfo, ends with a semicolon. */

gameMain: GameMainDef
    /* The initial player character is an object called 'me', which will be defined shortly. */
    initialPlayerChar = me
;

/* Objects in the game are created by giving the object a name that can be referred to in
   your game code, then by stating what class the object is (in the case below, it's an
   OutdoorRoom), and then giving it a name that will be displayed when the game is running. */

startRoom: OutdoorRoom 'Driveway'
    "The great house stands before you to the north. "
    north = hallway
    
    roomAfterAction()
    {
        if(orb.isIn(me))
        {
            "Congratulations! You have just got away with the Orb of Ultimate
            Satisfaction! ";
            finishGameMsg(ftVictory, [finishOptionUndo]);
        }
    }
;

/* The plus sign on the first line of an object declaration tells TADS that this object
   will be located inside of the previous object. */

+ me: Actor
;

/* Another room. Notice how the exits from the room are listed. The text in
   double-quotes is the description of the room, and will be displayed when the player
   enters the room or types 'look'. Notice also that text in TADS generally ends with
   a space after the final period and before the closing quotation mark. */

hallway: Room 'Hallway'
    "This hall is pretty bare, but there are exits to west and south. "
    south = startRoom
    west = study
;

study: Room 'Study'
    "This study is much as you would expect. A desk stands in the middle of the
    room. The way out is to the east. "
    east = hallway
;

/* The desk object has two single-quoted strings in its declaration. The first creates
   some vocabulary words that the player can use to refer to the desk. The second is how
   the game will refer to it when assembling text to show to the player. */

+ desk: Heavy, Platform 'plain wooden desk' 'desk'
    "It's a plain wooden desk; nothing fancy, just a horizontal surface on legs
    but no drawers or anything like that. "    
;

/* Notice that the orb is defined starting with TWO + signs. This will cause it to show
   up on the desk.
*/

++ orb: Thing 'ultimate orb/satisfaction' 'Orb of Ultimate Satisfaction'
    "It's -- well how can you describe such a thing? -- it's simply the most
    valuable and desirable object in the known universe!"
;