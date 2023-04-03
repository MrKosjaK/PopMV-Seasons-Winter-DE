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
    
    dialog_queue_msg("Pressure Point is identicle to the Single Player level, Middle Ground. However most players do not worship the Stone Head which grants you Armageddon unlike the computer players do in Single Player. This is a level which goes in depth on defending with towers.", "Pressure Point", 0, 173, 1, 128);
    dialog_queue_msg("Anyone can help create and edit pages for the wiki. We are trying to get everyone involved and create professional articles about anything related to Populous. If you need help please see the Wiki Help page for more infomation about editing the Populous Wiki. If you need ideas goto Wanted Pages.", "Wiki Help", 0, 174, 1, 128);
    dialog_queue_msg("Welcome to the Populous Wiki, a resource full of information about everything related to Populous. You will find many strategy guides, hints, tricks and tutorials on playing or editing Populous. Everyone can help extend the wiki by adding or editing articles, for more information see Wiki Help. If you have your own website related to Populous then please link to this resource and then add your website to the links section after logging in.", "Wiki Welcome", 0, 175, 5, 128);
  end
end
