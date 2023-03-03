require(get_script_dir() .. "Common");

e_allocate_thing_buffers(2);

function _OnRegenerate(level)
  --Engine:queue_command(ENGINE_CMD_PLACE_BLDG_SHAPE, 12, M_BUILDING_DRUM_TOWER, TRIBE_BLUE, G_RANDOM(4), 112, 118);
  e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 0);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 110, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 104, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 100, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 96, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 90, 118);
  e_queue_command(E_CMD_SPAWN_THINGS, 2, 1, 12, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 122, 118);
  e_queue_command(E_CMD_DISPATCH_COMMANDS, 12, 1);
  
  e_start();
end

function _OnTurn(turn)
  --Engine:process_execution();
end

