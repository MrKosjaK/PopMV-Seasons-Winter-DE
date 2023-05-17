local p = player_info();
local w = world_info();

function OnTurn()
  p[TRIBE_BLUE + 1].LiteColour = 146;
  p[TRIBE_BLUE + 1].Colour = 144;
  p[TRIBE_BLUE + 1].DarkColour = 143;
  p[TRIBE_BLUE + 1].Alpha = 12;
  p[TRIBE_BLUE + 1].ManaBarClr = 145;
  
  w[TRIBE_BLUE + 1].Person = 145;
  w[TRIBE_BLUE + 1].Alpha = 196;
end