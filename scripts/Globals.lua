require(get_script_dir() .. "Engine"); -- Main Engine

-- SAVE ITEMS
G_SAVEDATA =
{
  DIFF = Difficulty.get(),
  INIT = true;
}

-- NON SAVE ITEMS
G_GAME_LOADED = false;

-- CONSTANTS
G_CONST = constants();

function is_first_init()
  return G_SAVEDATA.INIT;
end

function is_game_loaded()
  return G_GAME_LOADED;
end