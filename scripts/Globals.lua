gns = gnsi();

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

function is_game_diff_easy()
  return (G_SAVEDATA.DIFF == 0);
end

function is_game_diff_normal()
  return (G_SAVEDATA.DIFF == 1);
end

function is_game_diff_hard()
  return (G_SAVEDATA.DIFF == 2);
end

function is_game_diff_very_hard()
  return (G_SAVEDATA.DIFF == 3);
end

function is_game_active()
  return (bit32.band(gns.Flags, 2) == 0 and bit32.band(gns.Flags3, 2147483648) == 0);
end