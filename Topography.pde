/* 
FINAL CHANGES:
make water realer by adding depth (more water = darker)
when using detail level, make it go down by 10 percent instead of by 1 every time
add a simple gui w description {
    maybe add a feature list
}
maybe try mapping the stuff on the cube & ico (too hard for time constraint?)
maybe make enum for spheremode since nobody knows what it means (spheremode.ico)

PROBLEMS:
    ico is gonna make gaps cus triangles r gonna be diff altitudes (get each vertex alt)
    lowering detail doesnt work (I think the initial image isnt changing but the w and h are so its shrinking){
        its coming from the arrays being made at the start and remembering the whole picture,
        then when i scale it down, i only shrink the height and width.
        how to solve: change the arrays too when u shrink
        UPDATE: I think the prob is topography.pixels isnt changing AND im only getting the greyvalues once with startSphere
        I need to change both of those so they happen every time
        ORR SET UP A WHOLE NEW CAM SYSTEM{
            in this system, you load the whole image at the start, but only focus on a small bit of it
            maybe better?
        }
    }
going up in detail is messed up cus of arrayoutofbounds

NEXT STEPS:
    make the diff sphere types render the image (TALK TO FARRAR){
        make water level local for each sphere
        make their radius change based on altitude scalar
        it might be gg for me
        for norm and spheri cube: let certain faces become more detailed for efficiency

    }

    make a gui (ask farrar how to approach it)
    calculate the rain and temp stuff in generateSphere in sphere class
    how the hell do i map the temps of mars? (no way im doing it manually). Maybe the same way im gonna do biomes? (with triangle mapping?)

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
using rayleigh scattering to correctly predict what the water would look like (actually hard)
detail level
wrapping
taking in any greyscale image
water rises and falls
altitude scalar
different sphere visualization types
controller
binary conversion
GLITCHES IM AWARE OF:
when scaling altitude, some quads change color before they r underwater (bc one vertex is underwater and it changes the whole quad)
*/
