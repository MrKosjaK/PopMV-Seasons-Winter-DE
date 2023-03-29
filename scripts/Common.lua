require(get_script_dir() .. "Globals");



function OnRegenerate(level)
  if _OnRegenerate ~= nil then _OnRegenerate(level); end
end

function OnTurn()
  if _OnTurn ~= nil then _OnTurn(Game.getTurn()); end
  
  e_process();
  
  -- for some reason some of draw functions returned info based on 640x480 resolution
  -- this thing fixes it.
  if (is_first_init()) then
    e_init_engine();
    
    G_SAVEDATA.INIT = false;
  end
end

function OnThing(t_thing)
  if _OnThing ~= nil then _OnThing(t_thing); end
end

function OnSave(slot)
  SaveTable("G_SAVEDATA", slot);

  if _OnSave ~= nil then _OnSave(slot); end
end

function OnLoad(slot)
  LoadTable("G_SAVEDATA", slot);

  if _OnLoad ~= nil then _OnLoad(slot); end
  
  G_GAME_LOADED = true;
end

function OnFrame()
  local x, z = Mouse.getMapX(), Mouse.getMapZ();
  PopSetFont(P3_SMALL_FONT_NORMAL, 0);
  DrawTextStr(Mouse.getScreenX(), Mouse.getScreenY() - CharHeight('A'), string.format("%i, %i", x, z));
  e_draw();
  
  if _OnFrame ~= nil then _OnFrame(); end
end