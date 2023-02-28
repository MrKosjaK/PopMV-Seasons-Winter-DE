require(get_script_dir() .. "Common");

function _OnRegenerate(level)
  --Engine:queue_command(ENGINE_CMD_PLACE_BLDG_SHAPE, 12, M_BUILDING_DRUM_TOWER, TRIBE_BLUE, G_RANDOM(4), 112, 118);
  e_queue_command(ENGINE_CMD_STOP_EXECUTION, 24);
  
  e_start();
end

function _OnTurn(turn)
  --Engine:process_execution();
end

