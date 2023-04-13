require(get_script_dir() .. "Common");

e_allocate_thing_buffers(2);

function _OnTurn(turn)
  if (is_first_init()) then
    e_queue_command(E_CMD_CINEMA_SET_SIZE, 0, bit32.rshift(gns.ScreenH, 1));
    e_queue_command(E_CMD_CINEMA_RAISE, 0, true);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 0);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GET_WOOD, 116, 108);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_BUILD_BUILDING, 112, 116);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_HEAD_PRAY, 70, 102);
    e_queue_command(E_CMD_PLACE_BLDG_SHAPE, 6, 1, TRIBE_BLUE, 0, 112, 116);
    e_queue_command(E_CMD_SPAWN_THINGS, 2, 1, 2, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 122, 118);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 24);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 25, CMD_GUARD_AREA_PATROL, 102, 130);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 25, CMD_GUARD_AREA_PATROL, 116, 130);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 26, 2);
    e_queue_command(E_CMD_SPAWN_THINGS, 24, 2, 2, T_PERSON, M_PERSON_WARRIOR, TRIBE_BLUE, 108, 122);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 12, 1);
    e_queue_command(E_CMD_CINEMA_FADE, 12, false);
    e_queue_command(E_CMD_SHOW_PANEL, 68);
    e_queue_command(E_CMD_STOP_EXECUTION, 68);
    
    e_queue_command(E_CMD_QUEUE_MSG, 12, get_text_str("STR_DIALOG_TEXT_1"), nil, 0, 174, 2, 256);
    e_queue_command(E_CMD_QUEUE_MSG, 36, get_text_str("STR_DIALOG_TEXT_2"), nil, 0, 174, 2, 256);
    
    e_start();
    e_hide_panel();
  end
end
