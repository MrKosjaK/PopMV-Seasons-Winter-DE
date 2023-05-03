require(get_script_dir() .. "Common");
local Lang = require(get_script_dir() .. "Language\\LangLvl1");

e_allocate_thing_buffers(3);

function _OnTurn(turn)
  if (is_first_init()) then
    -- hide panel
    e_hide_panel();
    
    -- set cinema rectangles to fill entire screen
    e_queue_command(E_CMD_CINEMA_SET_SIZE, 0, bit32.rshift(gns.ScreenH, 1));
    e_queue_command(E_CMD_CINEMA_RAISE, 0, true);
    e_queue_command(E_CMD_SET_CAMERA_PARAMS, 0, 18, 232, 1769);
    e_queue_command(E_CMD_TRIBE_SET_SKIN, 0, 0, 0, true);
    e_queue_command(E_CMD_SPAWN_THINGS, 0, -1, 1, T_PERSON, M_PERSON_MEDICINE_MAN, TRIBE_BLUE, 97, 207);
    e_queue_command(E_CMD_SPAWN_THINGS, 0, -1, 1, T_PERSON, M_PERSON_MEDICINE_MAN, TRIBE_RED, 101, 119);
    
    -- misc stuff
    PLAYER_IDX_2_PTR(TRIBE_BLUE).DeadCount = 0;
    PLAYER_IDX_2_PTR(TRIBE_RED).DeadCount = 0;
    set_number_of_one_shots_of_a_spell_player_has(TRIBE_BLUE, M_SPELL_INSECT_PLAGUE, 4);
    
    -- alliances
    e_queue_command(E_CMD_SET_ALLIANCE, 0, TRIBE_RED, TRIBE_YELLOW);
    e_queue_command(E_CMD_SET_ALLIANCE, 0, TRIBE_YELLOW, TRIBE_RED);
    
    -- we'll play some music first as opening
    --e_queue_command(E_CMD_MUSIC_PLAY, 0, "bgm_lvl1_opening", false);
    e_queue_command(E_CMD_QUEUE_MSG, 24, Lang.get_str("StrDlgGeneralText1"), nil, nil, nil, 0, 128);
    e_queue_command(E_CMD_QUEUE_MSG, 60, Lang.get_str("StrDlgGeneralText2"), nil, nil, nil, 0, 128);
    e_queue_command(E_CMD_QUEUE_MSG, 96, Lang.get_str("StrDlgGeneralText3"), nil, nil, nil, 0, 128);
    
    -- lower cinema
    e_queue_command(E_CMD_CINEMA_SET_SIZE, 146, bit32.rshift(gns.ScreenH, 3));
    
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
    e_queue_command(E_CMD_QUEUE_MSG, 278, Lang.get_str("StrDlgStoryTellerText1"), "Story Teller", 1, 170, 3, 64*3);
    e_queue_command(E_CMD_QUEUE_MSG, 345, Lang.get_str("StrDlgStoryTellerText2"), "Story Teller", 1, 170, 3, 64*3);
    e_queue_command(E_CMD_QUEUE_MSG, 402, Lang.get_str("StrDlgBravesText1"), "Folks", 1, 170, 4, 64*2);
    e_queue_command(E_CMD_CINEMA_FADE, 402, false);
    e_queue_command(E_CMD_STOP_EXECUTION, 403);
    
    -- start engine
    e_start();
  end
end
