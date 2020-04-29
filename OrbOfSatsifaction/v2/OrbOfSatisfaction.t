#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID
    IFID = '558c20af-6559-477a-9f98-b7b4274cd304'
    name = 'The Best Burglar'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">
                  Eric Eve</a>'
    version = '2'
    authorEmail = 'Eric Eve <eric.eve@hmc.ox.ac.uk>'
    desc = 'You are the world\'s best burglar faced with the greatest challenge
        of your felonious career.'
    htmlDesc = 'You are the world\'s best burglar faced with the greatest
        challenge of your felonious career.'
;

gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = me
    
    showIntro()
    {
        "<b>The Best Burglar</b>\nWell, you've got this far. Now it's just a
        quick nip inside the house and out again carrying the Orb of Ultimate
        Satisfaction, an object that no burglar has ever managed to steal
        before. If you can pull it off you're sure to win the Burglar of the
        Year Award, putting you at the pinnacle of your profession.\b";
    }
;

/* The asExit line in the room below will cause TADS to interpet the command 'in' exactly
   as if the player had typed 'north'. */

startRoom: OutdoorRoom 'Driveway'
    "Here you are in the drive of Number 305 Erehwon Avenue, with the great 
    house you've come to burgle standing just before you to the north. The
    drive back to the road where you left your getaway vehicle runs off
    to the southwest. "
    north = frontDoor
    in asExit(north)
    southwest = drive
;

+ me: Actor
    pcDesc = "You're Alexis Lightfinger, burglar extraordinaire, the most
        professional thief in the known universe; but you're on a job now, so
        you don't have time for the narcissistic indulgence of admiring your own
        appearance. You're far too professional not to have come fully prepared,
        so there's no practical need to look yourself over again. "
;

++ Container 'large white swag bag*bags' 'swag bag'
    "It's a large white bag with <q>SWAG</q> printed on it in very large
    letters. Everyone knows that no real burglar would ever carry such a thing,
    so by carrying it you know no one will take you for a real burglar. Cunning,
    eh? "
;

/* The frontDoor object is in the same location as me and the brassKey. TADS understands
   that doors are usually scenery, so no special effort is needed to prevent the game from
   reporting, "You can see a front door here." */

+ frontDoor: LockableWithKey, Door 'front door*doors' 'front door'
    keyList = [brassKey]
;

+ brassKey: Key 'small brass key*keys' 'small brass key'
    "It's an ordinary enough small brass key. "
    initSpecialDesc = "A small brass key lies on the ground near the door. "
;

/* The next object is an anonymous object. That is, it has no in-code name of its own,
   because the game code never needs to refer to it. The arrow pointing to frontDoor
   tells TADS where to send the player if he should type 'enter the house'. As you can
   see from the description, this object is the exterior of the house. */
   
+ Enterable -> frontDoor 'large tudor house/mansion*houses*buildings' 'house'
    "It's a large Tudor house with mullioned windows. "
;

+ drive: PathPassage 'drive/path' 'drive'
    "The drive leading back to the road runs off to the southwest. "
    
    dobjFor(TravelVia)
    {
        action()
        {
            "You retrace your steps back to the road, where your trusty unmarked
            burglarmobile is still parked, ready for your quick getaway. ";
            
            if(orb.isIn(me))
            {
                "Congratulations! You have got away with the Orb of Ultimate
                Satisfaction, a feat never before performed. As you slip the orb
                onto the back seat of your car and climb into the driver's seat
                you tell yourself that you're now absolutely certain to win
                the Burglar of the Year Award!\b";
                
                finishGameMsg(ftVictory, [finishOptionUndo]);
            }
            else
            {
                "It's a shame you didn't manage to steal the orb, though.
                Without it you'll never win the Burglar of the Year Award
                now.\b";
                
                finishGameMsg(ftFailure, [finishOptionUndo]);
            }
        }
    }
;

hallway: Room 'Hallway'
    "This hall is or grand proportions but pretty bare. The front door lies to
    the south and other exits lead east, north and west. "
    
    south = hallDoor
    out asExit(south)
    west = study
    north: FakeConnector { "You're pretty sure that only leads to the kitchen,
        and you haven't come here to cook a meal. " }
    
    east: DeadEndConnector { 'the living room' "You <<one of>>walk through the
        doorway and find yourself in<<or>>return to<<stopping>> the living room
        where you take <<one of>> a <<or>>another<<stopping>> quick look around,
        but <<one of>><<or>> once again<<stopping>> failing to find anything of
        interest you quickly return to the hall. "}
;

+ hallDoor: Lockable, Door -> frontDoor 'front door*doors' 'front door'
;

+ table: Surface 'small wooden mahogany side table/legs*tables' 'small table'
    "It's a small mahogany table standing on four thin legs. "
    initSpecialDesc = "A small table rests by the east wall. "  
;

++ vase: Container 'cheap china floral vase/pattern' 'vase'
    "It's only a cheap thing, made of china but painted in a tasteless floral
    pattern using far too many primary colours. "    
;

/* An object of the Hidden class will show up only when the player thinks to search its
   container. */
   
+++ silverKey: Hidden, Key 'small silver key*keys' 'small silver key'
;

study: Room 'Study'
    "This study is much as you would expect: somewhat spartan. A desk stands in
    the middle of the room with a chair placed just behind it. The way out is to
    the east. "
    east = hallway
    out asExit(east)
;

+ desk: Heavy, Platform 'plain wooden desk' 'desk'
    "It's a plain wooden desk with a single drawer. "          
;

++ drawer: KeyedContainer, Component '(desk) drawer*drawers' 'drawer'
    "It's an ordinary desk drawer with a small silver lock. "
    keyList = [silverKey]
;

/* The notebook object needs some special code for the command 'open notebook'. The
   dobjFor macro creates some code for the Open action, and the asDobjFor(Read) code
   causes 'open notebook' to have the same result as 'read notebook. */

+++ notebook: Readable 'small bright red notebook/book/cover/pages' 
    'small red notebook'
    "It's a small notebook with a bright red cover. "
    
    readDesc = "You open the notebook and flick through its pages. The only
        thing you find of any interest is a page with 1589 scrawled across it.
        After satisfying yourself that the notebook contains nothing else of
        any potential relevance you snap it shut again. "
    
    dobjFor(Open) asDobjFor(Read)
    cannotCloseMsg = 'It\'s already closed. '
;

+ CustomImmovable, Chair 'red office swivel chair' 'chair'
    "It's a typical office swivel chair, covered in red fabric. "
    cannotTakeMsg = 'You see no reason to burden yourself with such a useless
        object; that would be quite unprofessional. '
;
    
+ safe: CustomFixture, IndirectLockable, OpenableContainer 
    'sturdy steel safe' 'safe'
    "It's a sturdy steel safe with a single dial on its door. "
    specialDesc = "A safe is built into one wall. "
    cannotTakeMsg = 'It's firmly built into the wall; you can't budge it. '
;

++ orb: Thing 'ultimate battered dull metal orb/sphere/ball/satisfaction' 
    'Orb of Ultimate Satisfaction'
    "It doesn't look much be honest, just a battered sphere made of some dull
    metal, but you've been told it's the most valuable and desirable object 
    in the known universe! "
    
    aName = (theName)
;

/* Notice how the double angle brackets are used to let the description of the safe
   refer to the properties of the object. This is an extremely common and useful
   technique in TADS. */

+ safeDial: NumberedDial, CustomFixture 'dial*dials' 'dial'
    "The dial can be turned to any number between <<minSetting>> and
    <<maxSetting>>. It's currently at <<curSetting>>. "
    
    minSetting = 0
    maxSetting = 99
    curSetting = '35'
    
    num1 = 0
    num2 = 0
    correctCombination = 1589
    
    makeSetting(val)
    {
        inherited(val);
        num2 = num1;
        num1 = toInteger(val);
        if(100 * num2 + num1 == correctCombination)
        {
            "You hear a slight <i>click</i> come from the safe door. ";
            safe.makeLocked(nil);
        }
        else if(!safe.isOpen)
            safe.makeLocked(true);
    }
    
    cannotTakeMsg = 'It's firmly attached to the safe. '
;