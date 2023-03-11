require(get_script_dir() .. "Globals");

e_init_engine();

function OnRegenerate(level)
  if _OnRegenerate ~= nil then _OnRegenerate(level); end
end

function OnTurn(turn)
  if _OnTurn ~= nil then _OnTurn(turn); end
  
  e_process_execution();
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