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
    
    dialog_queue_msg("Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...", "Tooltip", 1, 7452, 7, 360);
    dialog_queue_msg("Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...Test... Test... Test... Test...", "Tooltip", 0, 171, 2, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 0, 172, 2, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 0, 173, 3, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 0, 174, 4, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 0, 175, 5, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 0, 176, 6, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 1, 7400, 7, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 1, 172, 8, 90);
    dialog_queue_msg("Test... Test... Test... Test...", "Tooltip", 1, 173, 9, 90);
  end
end
