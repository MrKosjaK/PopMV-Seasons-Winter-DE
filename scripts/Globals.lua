require(get_script_dir() .. "Engine"); -- Main Engine

local gns = gnsi();

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

function is_game_active()
  return (bit32.band(gns.Flags, 2) == 0 and bit32.band(gns.Flags3, 2147483648) == 0);
end