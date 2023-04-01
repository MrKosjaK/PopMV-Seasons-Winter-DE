require(get_script_dir() .. "Common");

e_allocate_thing_buffers(2);

function _OnTurn(turn)
  if (is_first_init()) then
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 0);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 110, 118);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 104, 118);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 100, 118);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 96, 118);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 90, 118);
    e_queue_command(E_CMD_SPAWN_THINGS, 2, 1, 12, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 122, 118);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 12, 1);
    
    e_start();
    e_hide_panel();
    
    dialog_queue_msg("T....ASDFASDF  SDFASDFAS DFASDF ASDFAS FASDF ASDFASDFASDFASDF ASDF ASDF ASDF ASDF ASDF", "Tooltip", 0, 173, 0, 580);
    dialog_queue_msg("Test.. Test... Test...", "Tooltip", 0, 174, 0, 280);
    dialog_queue_msg("Test. .. Test...", "Tooltip", 0, 175, 5, 280);
  end
end
