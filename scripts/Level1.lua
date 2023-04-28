require(get_script_dir() .. "Common");

e_allocate_thing_buffers(3);

function _OnTurn(turn)
  if (is_first_init()) then
    -- e_queue_command(E_CMD_CINEMA_SET_SIZE, 0, bit32.rshift(gns.ScreenH, 1));
    -- e_queue_command(E_CMD_CINEMA_RAISE, 0, true);
    -- e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 0);
    -- e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GET_WOOD, 116, 108);
    -- e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_BUILD_BUILDING, 112, 116);
    -- e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_HEAD_PRAY, 70, 102);
    -- e_queue_command(E_CMD_PLACE_BLDG_SHAPE, 6, 1, TRIBE_BLUE, 0, 112, 116);
    -- e_queue_command(E_CMD_SPAWN_THINGS, 2, 1, 2, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 122, 118);
    -- e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 24);
    -- e_queue_command(E_CMD_SET_NEXT_COMMAND, 25, CMD_GUARD_AREA_PATROL, 102, 130);
    -- e_queue_command(E_CMD_SET_NEXT_COMMAND, 25, CMD_GUARD_AREA_PATROL, 116, 130);
    -- e_queue_command(E_CMD_DISPATCH_COMMANDS, 26, 2);
    -- e_queue_command(E_CMD_SPAWN_THINGS, 24, 2, 2, T_PERSON, M_PERSON_WARRIOR, TRIBE_BLUE, 108, 122);
    -- e_queue_command(E_CMD_DISPATCH_COMMANDS, 12, 1);
    -- e_queue_command(E_CMD_CINEMA_FADE, 12, false);
    -- e_queue_command(E_CMD_SHOW_PANEL, 68);
    -- e_queue_command(E_CMD_STOP_EXECUTION, 68);
    
    -- e_queue_command(E_CMD_QUEUE_MSG, 12, get_text_str("STR_DIALOG_TEXT_1"), nil, 0, 174, 2, 256);
    -- e_queue_command(E_CMD_QUEUE_MSG, 36, get_text_str("STR_DIALOG_TEXT_2"), nil, 0, 174, 2, 256);
    
    -- e_start();
    e_hide_panel();
    
    -- set cinema rectangles to fill entire screen
    e_queue_command(E_CMD_CINEMA_SET_SIZE, 0, bit32.rshift(gns.ScreenH, 1));
    e_queue_command(E_CMD_CINEMA_RAISE, 0, true);
    e_queue_command(E_CMD_SET_CAMERA_PARAMS, 0, 18, 232, 1769);
    
    -- alliances
    e_queue_command(E_CMD_SET_ALLIANCE, 0, TRIBE_RED, TRIBE_YELLOW);
    e_queue_command(E_CMD_SET_ALLIANCE, 0, TRIBE_YELLOW, TRIBE_RED);
    
    -- we'll play some music first as opening
    --e_queue_command(E_CMD_MUSIC_PLAY, 0, "bgm_lvl1_opening", false);
    e_queue_command(E_CMD_QUEUE_MSG, 24, "In the beginning...", nil, nil, nil, 0, 128);
    e_queue_command(E_CMD_QUEUE_MSG, 60, "Somewhere in distant cold and harsh environment...", nil, nil, nil, 0, 128);
    e_queue_command(E_CMD_QUEUE_MSG, 96, "A group of people decided to go camping...", nil, nil, nil, 0, 128);
    
    -- lower cinema
    e_queue_command(E_CMD_CINEMA_FADE, 146, false);
    
    -- spawn in people
    -- story teller
    e_queue_command(E_CMD_SPAWN_THINGS, 146, 1, 1, T_PERSON, M_PERSON_RELIGIOUS, TRIBE_RED, 19, 227);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 146);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 146, CMD_GOTO_POINT, 18, 240);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 146, CMD_GOTO_POINT, 14, 252);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 146, CMD_GOTO_POINT, 16, 254);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 146, 1);
    
    -- listeners
    e_queue_command(E_CMD_SPAWN_THINGS, 162, 2, 3, T_PERSON, M_PERSON_BRAVE, TRIBE_RED, 19, 227);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 162);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 162, CMD_GOTO_POINT, 18, 240);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 162, CMD_GOTO_POINT, 14, 252);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 162, CMD_GOTO_POINT, 12, 252);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 162, 2);
    
    e_queue_command(E_CMD_SPAWN_THINGS, 174, 3, 3, T_PERSON, M_PERSON_BRAVE, TRIBE_YELLOW, 19, 227);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 174);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 174, CMD_GOTO_POINT, 18, 240);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 174, CMD_GOTO_POINT, 14, 250);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 174, 3);
    
    -- story teller starts talking
    e_queue_command(E_CMD_QUEUE_MSG, 278, "Alright folks... We're at the designated point, let's setup a temprorary camp here!", "Story Teller", 1, 170, 1, 256);
    
    -- start engine
    e_start();
  end
end
