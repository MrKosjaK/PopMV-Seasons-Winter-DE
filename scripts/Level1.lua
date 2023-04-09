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
    
    e_queue_command(E_CMD_QUEUE_MSG, 12, "Hello, Traveler! Isn't it a beautiful day to murder some enemy tribes? Get some action going on.", nil, 0, 174, 2, 256);
    
    e_start();
    e_hide_panel();
    
    --dialog_queue_msg("Pressure Point is identicle to the Single Player level, Middle Ground. However most players do not worship the Stone Head which grants you Armageddon unlike the computer players do in Single Player. This is a level which goes in depth on defending with towers.", "Pressure Point", 0, 173, 1, 128);
    --dialog_queue_msg("Anyone can help create and edit pages for the wiki. We are trying to get everyone involved and create professional articles about anything related to Populous. If you need help please see the Wiki Help page for more infomation about editing the Populous Wiki. If you need ideas goto Wanted Pages.", "Wiki Help", 0, 174, 1, 128);
    --dialog_queue_msg("Welcome to the Populous Wiki, a resource full of information about everything related to Populous. You will find many strategy guides, hints, tricks and tutorials on playing or editing Populous. Everyone can help extend the wiki by adding or editing articles, for more information see Wiki Help. If you have your own website related to Populous then please link to this resource and then add your website to the links section after logging in.", "Wiki Welcome", 0, 175, 5, 128);
  end
end
