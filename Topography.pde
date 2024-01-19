/* 
FINAL CHANGES:
add a menu to the game screen

how the hell do i map the temps of mars? (no way im doing it manually). Maybe the same way im gonna do biomes? (with triangle mapping?)
maybe try mapping the stuff on the cube & ico (too hard for time constraint?)
maybe make enum for spheremode since nobody knows what it means (spheremode.ico)

PROBLEMS:
    ico is gonna make gaps cus triangles r gonna be diff altitudes (get each vertex alt)

POSSIBLE OPTIMIZATION:
maybe import the graph and add triangles to match it, then send out ray to check if it hits


ADDITIONS:
calculating total amt of water on the planet at a certain water level(gallons)

ecology stuff:
gulfstreams and grasslands and beaches
adding something to auto detect range of colors from low to high (so i dont have to use grayscale)
CLIMATE:
https://www.jstor.org/stable/24975952?seq=5 go page 5 for graph of temps on mars



FEATURE LIST:
different sphere visualization types
using rayleigh scattering to correctly predict what the water would look like (actually hard)
detail level
wrapping
my own vector classes
binary conversion
taking in any greyscale image (works with any)
water rises and falls
altitude scalar
controller


FEATURES (glitches) IM AWARE OF:
when scaling altitude, some quads change color before they r underwater (bc one vertex is underwater and it changes the whole quad)
sphereType doesnt do anything
*/
