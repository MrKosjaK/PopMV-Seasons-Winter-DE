-- DEBUG
Timing = require(get_script_dir() .. "D_Timer"); -- Timer debugging.

require(get_script_dir() .. "Globals"); -- Globals
require(get_script_dir() .. "LbMap"); -- Additional map functions
require(get_script_dir() .. "Engine"); -- Main Engine
require(get_script_dir() .. "Badges"); -- Achievement/Badges system


function OnRegenerate(level)
  Timing.start("OnRegenerate");
  reset_skins_defaults();
  if _OnRegenerate ~= nil then _OnRegenerate(level); end
  Timing.stop("OnRegenerate");
end

function OnTurn()
  Timing.start("OnTurn");
  -- for some reason some of draw functions returned info based on 640x480 resolution
  -- this thing fixes it.
  if (is_first_init()) then
    e_init_engine();
    b_load_data_info("..\\Achievements\\a_global.txt");
  end
  
  if _OnTurn ~= nil then _OnTurn(Game.getTurn()); end
  
  G_SAVEDATA.INIT = false;
  
  -- process engine
  e_process();
  
  -- post load stuff
  if (is_game_loaded()) then
    e_post_load_items();
    
    G_GAME_LOADED = false;
  end
  Timing.stop("OnTurn");
end

function OnThing(t_thing)
  Timing.start("OnThing");
  if _OnThing ~= nil then _OnThing(t_thing); end
  Timing.stop("OnThing");
end

function OnSave(slot)
  Timing.start("OnSave");
  SaveTable("G_SAVEDATA", slot);
  e_save(slot);

  if _OnSave ~= nil then _OnSave(slot); end
  Timing.stop("OnSave");
end

function OnLoad(slot)
  Timing.start("OnLoad");
  LoadTable("G_SAVEDATA", slot);
  e_load(slot);

  if _OnLoad ~= nil then _OnLoad(slot); end
  
  G_GAME_LOADED = true;
  Timing.stop("OnLoad");
end

function OnFrame()
  Timing.start("OnFrame");
  LbDraw_ReleaseClipRect();
  local x, z = Mouse.getMapX(), Mouse.getMapZ();
  PopSetFont(P3_SMALL_FONT_NORMAL, 0);
  DrawTextStr(Mouse.getScreenX(), Mouse.getScreenY() - CharHeight('A'), string.format("%i, %i", x, z));
  e_draw();
  
  if _OnFrame ~= nil then _OnFrame(); end
  Timing.stop("OnFrame");
  Timing.render_all();
end