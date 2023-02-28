require(get_script_dir() .. "Engine"); -- Main Engine

-- SAVE ITEMS
G_SAVEDATA =
{
  DIFF = Difficulty.get()
}

-- NON SAVE ITEMS
G_GAME_LOADED = false;

-- CONSTANTS
G_CONST = constants();