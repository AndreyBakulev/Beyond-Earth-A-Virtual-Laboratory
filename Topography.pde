/* 
PROBLEMS:
keep optimizing
scaleWater is not correct

POSSIBLE OPTIMIZATION:
make a list of all pixels and remove the ones that are already below water level (same time complexity?)
the double for loops in drawSphere() that check if waterlevel is higher is O(n^2) i think...
if i make a 1d array and check it like that (similar to photo.pixels[]), will that be O(n)?

ADDITIONS:
maybe add "initialGlobe" array to GenerateSphere so we can call it on waterLevelDown
make the ground colored (map it from greyval seems ez)
adding compass
calculating total amt of water on the planet at a certain water level(gallons)

ecology stuff:
gulfstreams and grasslands and beaches
adding something to auto detect range of colors from low to high (so i dont have to use grayscale)
CLIMATE:
https://www.jstor.org/stable/24975952?seq=5 go page 5 for graph of temps on mars
*/
