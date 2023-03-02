require(get_script_dir() .. "Common");

e_allocate_thing_buffers(2);

function _OnRegenerate(level)
  --Engine:queue_command(ENGINE_CMD_PLACE_BLDG_SHAPE, 12, M_BUILDING_DRUM_TOWER, TRIBE_BLUE, G_RANDOM(4), 112, 118);
  e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 0);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 50, 50);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 58, 50);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 62, 50);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 68, 50);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 72, 50);
  e_queue_command(E_CMD_DISPATCH_COMMANDS, 12, 1);
  
  e_start();
end

function _OnTurn(turn)
  --Engine:process_execution();
end

