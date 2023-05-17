require(get_script_dir() .. "Common");
local Lang = require(get_script_dir() .. "Language\\LangLvl1");

e_allocate_thing_buffers(7);
e_allocate_variables(16);

function _OnTurn(turn)
  if (is_first_init()) then
    -- hide panel
    e_hide_panel();
    
    -- set cinema rectangles to fill entire screen
    e_queue_command(E_CMD_CINEMA_SET_SIZE, 0, bit32.rshift(gns.ScreenH, 1));
    e_queue_command(E_CMD_CINEMA_RAISE, 0, true);
    e_queue_command(E_CMD_SET_CAMERA_PARAMS, 0, 19, 233, 1769);
    e_queue_command(E_CMD_TRIBE_SET_SKIN_PARAMS, 0, TRIBE_BLUE, TRIBE_BLUE, BANK_MV8P, BLOCKS_BANK_8P, TRIBE_BLUE, true);
    e_queue_command(E_CMD_TRIBE_SET_DISPLAY_PI_PARAMS, 0, TRIBE_BLUE, 144, 146, 143, 12, 145);
    e_queue_command(E_CMD_TRIBE_SET_DISPLAY_WI_PARAMS, 0, TRIBE_BLUE, 145, 196); --196
    -- uncover some fog while it's black screen
    --e_queue_command(E_CMD_FOW_COVER, 0, 0, 0, 8, true);
    e_queue_command(E_CMD_FOW_UNCOVER, 2, 18, 234, 4, -1);
    e_queue_command(E_CMD_FOW_UNCOVER, 3, 18, 240, 5, -1);
    e_queue_command(E_CMD_FOW_UNCOVER, 4, 14, 252, 6, -1);
    
    e_queue_command(E_CMD_SET_CAMERA_PARAMS, 16, 19, 233, 1769);
    
    -- misc stuff
    SET_REINCARNATION(0, TRIBE_BLUE);
    SET_REINCARNATION(0, TRIBE_RED);
    SET_REINCARNATION(0, TRIBE_YELLOW);
    game_disable_wins();
    game_disable_loses();
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
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 146, CMD_GOTO_POINT, 16, 254);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 146, 1);
    
    -- listeners
    e_queue_command(E_CMD_SPAWN_THINGS, 162, 2, 3, T_PERSON, M_PERSON_BRAVE, TRIBE_RED, 19, 227);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 162);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 162, CMD_GOTO_POINT, 18, 240);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 162, CMD_GOTO_POINT, 12, 252);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 162, 2);
    
    e_queue_command(E_CMD_SPAWN_THINGS, 174, 3, 3, T_PERSON, M_PERSON_BRAVE, TRIBE_YELLOW, 19, 227);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 174);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 174, CMD_GOTO_POINT, 18, 240);
    e_queue_command(E_CMD_SET_NEXT_COMMAND, 174, CMD_GOTO_POINT, 14, 250);
    e_queue_command(E_CMD_DISPATCH_COMMANDS, 174, 3);
    e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 174);
    e_queue_command(E_CMD_SET_VARIABLE, 174, 1, 1);
    e_queue_command(E_CMD_STOP_EXECUTION, 175);
    
    -- start engine
    e_start();
  end
  
  -- first part
  if (e_get_var(1) == 1) then
    -- check for priest's arrival at point
    if (does_map_xz_contain_a_thing(T_PERSON, M_PERSON_RELIGIOUS, -1, 16, 254)) then
      e_set_var(1, 2);
      
      -- story teller starts talking
      e_queue_command(E_CMD_PERS_SET_ANGLE, 9, 1, 15, 251);
      e_queue_command(E_CMD_PERS_SET_ANGLE, 9, 2, 17, 255);
      e_queue_command(E_CMD_PERS_SET_ANGLE, 9, 3, 17, 255);
      e_queue_command(E_CMD_PERS_NEW_STATE, 10, 2, S_PERSON_STAND_FOR_TIME);
      e_queue_command(E_CMD_PERS_NEW_STATE, 10, 3, S_PERSON_STAND_FOR_TIME);
      e_queue_command(E_CMD_PERS_SET_COUNT, 11, 2, 156);
      e_queue_command(E_CMD_PERS_SET_COUNT, 11, 3, 156);
      e_queue_command(E_CMD_QUEUE_MSG, 12, Lang.get_str("StrDlgStoryTellerText1"), "Story Teller", 1, 170, 3, 64*3);
      e_queue_command(E_CMD_QUEUE_MSG, 70, Lang.get_str("StrDlgStoryTellerText2"), "Story Teller", 1, 170, 3, 64*3);
      e_queue_command(E_CMD_QUEUE_MSG, 145, Lang.get_str("StrDlgBravesText1"), "Folks", 1, 170, 4, 64*2);
    
      -- braves chop trees and bring to point
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 166, CMD_GET_WOOD, 12, 4);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 166, CMD_DROP_WOOD, 14, 252);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 166, 2);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 166);
      
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 168, CMD_GET_WOOD, 24, 244);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 168, CMD_DROP_WOOD, 14, 252);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 168, 3);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 168);
      
      -- raise cinematic stuff
      e_queue_command(E_CMD_CLEAR_THING_BUFFER, 174, 1);
      e_queue_command(E_CMD_CLEAR_THING_BUFFER, 174, 2);
      e_queue_command(E_CMD_CLEAR_THING_BUFFER, 174, 3);
      e_queue_command(E_CMD_CINEMA_SET_SIZE, 174, bit32.rshift(gns.ScreenH, 1));
      e_queue_command(E_CMD_SET_VARIABLE, 174, 1, 3);
      e_queue_command(E_CMD_QUEUE_MSG, 229, Lang.get_str("StrDlgGeneralText4"), nil, nil, nil, 0, 256);
      e_queue_command(E_CMD_STOP_EXECUTION, 230);
      
      e_start();
    end
  elseif (e_get_var(1) == 3) then
    -- check for 6 woodpiles at specific point, then spawn tower and campfire.
    if (count_things_at_map_xz(T_SCENERY, M_SCENERY_WOOD_PILE, -1, 14, 252) >= 6) then
      e_set_var(1, 4);
      
      -- spawn red drum tower.
      local t; -- dummy
      CREATE_THING_WITH_PARAMS4(t, T_BUILDING, M_BUILDING_DRUM_TOWER, TRIBE_RED, xz_to_c3d(10, 254), 3, 0, 2, -1);
      
      -- spawn camp fire
      create_local_thing(T_INTERNAL, M_INTERNAL_GUARD_POST_DISPLAY, TRIBE_BLUE, xz_to_c3d(14, 252));
      
      -- delete wood piles
      e_queue_command(E_CMD_DELETE_THINGS, 0, 6, T_SCENERY, M_SCENERY_WOOD_PILE, -1, 14, 252, 0);
      
      -- reveal screen
      e_queue_command(E_CMD_CINEMA_SET_SIZE, 12, bit32.rshift(gns.ScreenH, 3));
      
      -- story teller starting speech.
      e_queue_command(E_CMD_QUEUE_MSG, 64, Lang.get_str("StrDlgStoryTellerText3"), "Story Teller", 1, 170, 3, 64*3);
      e_queue_command(E_CMD_QUEUE_MSG, 112, Lang.get_str("StrDlgStoryTellerText4"), "Story Teller", 1, 170, 3, 64*3);
      
      -- transition to another place with Tiyao's shaman
      e_queue_command(E_CMD_CINEMA_SET_SIZE, 182, bit32.rshift(gns.ScreenH, 1));
      
      -- jump camera to a new place
      e_queue_command(E_CMD_SET_CAMERA_PARAMS, 228, 91, 221, 1911);
      e_queue_command(E_CMD_SET_VARIABLE, 249, 1, 5);
      e_queue_command(E_CMD_STOP_EXECUTION, 250);
      
      e_start();
    end
  elseif (e_get_var(1) == 5) then
    if (e_is_ready()) then
      e_set_var(1, 6);
      
      -- uncover fog
      e_queue_command(E_CMD_FOW_UNCOVER, 0, 96, 206, 5, -1);
      e_queue_command(E_CMD_FOW_UNCOVER, 1, 90, 220, 6, -1);
      e_queue_command(E_CMD_CINEMA_SET_SIZE, 2, bit32.rshift(gns.ScreenH, 3));
      
      -- spawn Tiyao's followers and herself as well
      e_queue_command(E_CMD_SPAWN_THINGS, 8, 3, 1, T_PERSON, M_PERSON_MEDICINE_MAN, TRIBE_BLUE, 97, 207);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 9, CMD_GOTO_POINT, 90, 220);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 9, 3);
      
      e_queue_command(E_CMD_SPAWN_THINGS, 24, 4, 2, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 97, 207);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 25, 4);
      
      e_queue_command(E_CMD_SPAWN_THINGS, 26, 5, 2, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 97, 207);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 27, 5);
      
      e_queue_command(E_CMD_SPAWN_THINGS, 28, 6, 2, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 97, 207);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 29, 6);
      
      e_queue_command(E_CMD_SPAWN_THINGS, 30, 7, 2, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 97, 207);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 31, 7);
      
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 31);
      
      -- speech
      e_queue_command(E_CMD_QUEUE_MSG, 32, Lang.get_str("StrDlgTiyaoText1"), "Tiyao", 1, 170, 10, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 120, Lang.get_str("StrDlgTiyaoText2"), "Tiyao", 1, 170, 10, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 160, Lang.get_str("StrDlgTiyaoText3"), "Tiyao", 1, 170, 10, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 190, Lang.get_str("StrDlgBravesText2"), "Followers", 1, 170, 10, 64*2);
      
      e_queue_command(E_CMD_CINEMA_SET_SIZE, 230, bit32.rshift(gns.ScreenH, 1));
      e_queue_command(E_CMD_SET_VARIABLE, 281, 1, 7);
      e_queue_command(E_CMD_STOP_EXECUTION, 282);
    
      e_start();
    end
  elseif (e_get_var(1) == 7) then
    if (e_is_ready()) then
      e_set_var(1, 8);
      
      -- move camera
      e_queue_command(E_CMD_SET_CAMERA_PARAMS, 0, 117, 103, 1911);
      e_queue_command(E_CMD_TRIBE_SET_SKIN_PARAMS, 0, TRIBE_RED, TRIBE_BLUE, BANK_NORMAL, BLOCKS_BANK_DEFAULT, TRIBE_BLUE, false);
      e_queue_command(E_CMD_FOW_UNCOVER, 1, 116, 102, 5, -1);
      
      -- spawn chumara and ikani meanwhile, make them walk to interest points then talk.
      e_queue_command(E_CMD_SPAWN_THINGS, 2, 1, 1, T_PERSON, M_PERSON_MEDICINE_MAN, TRIBE_YELLOW, 139, 105);
      e_queue_command(E_CMD_SPAWN_THINGS, 2, 2, 1, T_PERSON, M_PERSON_MEDICINE_MAN, TRIBE_RED, 107, 115);
      
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 3, CMD_GOTO_POINT, 131, 103);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 3, CMD_GOTO_POINT, 125, 103);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 3, CMD_GOTO_POINT, 119, 103);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 3, 1);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 3);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 3, CMD_GOTO_POINT, 109, 111);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 3, CMD_GOTO_POINT, 111, 107);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 3, CMD_GOTO_POINT, 115, 103);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 3, 2);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 3);
      e_queue_command(E_CMD_CINEMA_SET_SIZE, 12, bit32.rshift(gns.ScreenH, 3));
      
      -- them talking sum smack
      e_queue_command(E_CMD_QUEUE_MSG, 80, Lang.get_str("StrDlgChumaraText1"), "Chumara", 1, 170, 4, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 80, Lang.get_str("StrDlgIkaniText1"), "Ikani", 1, 170, 2, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 80, Lang.get_str("StrDlgChumaraText2"), "Chumara", 1, 170, 4, 64);
      e_queue_command(E_CMD_QUEUE_MSG, 80, Lang.get_str("StrDlgChumaraText3"), "Chumara", 1, 170, 4, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 80, Lang.get_str("StrDlgChumaraText4"), "Chumara", 1, 170, 4, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 80, Lang.get_str("StrDlgIkaniText2"), "Ikani", 1, 170, 2, 64*2);
      e_queue_command(E_CMD_QUEUE_MSG, 80, Lang.get_str("StrDlgChumaraText5"), "Chumara", 1, 170, 4, 64*2);
      
      -- Ikani walks away
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 420, CMD_GOTO_POINT, 125, 103);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 420, CMD_GOTO_POINT, 131, 103);
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 420, CMD_GOTO_POINT, 139, 105);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 420, 1);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 420);
      
      -- passive aggressive moment
      e_queue_command(E_CMD_QUEUE_MSG, 501, Lang.get_str("StrDlgIkaniText3"), "Ikani", 1, 170, 2, 64*2);
      e_queue_command(E_CMD_SET_VARIABLE, 540, 1, 9);
      e_queue_command(E_CMD_CINEMA_SET_SIZE, 540, bit32.rshift(gns.ScreenH, 1));
      
      -- task player's units to build some stuff
      e_queue_command(E_CMD_PLACE_BLDG_SHAPE, 541, M_BUILDING_DRUM_TOWER, TRIBE_BLUE, G_RANDOM(4), 100, 232); -- tower plan
      e_queue_command(E_CMD_PLACE_BLDG_SHAPE, 542, M_BUILDING_TEPEE, TRIBE_BLUE, G_RANDOM(4), 92, 228); -- first hut
      e_queue_command(E_CMD_PLACE_BLDG_SHAPE, 543, M_BUILDING_TEPEE, TRIBE_BLUE, G_RANDOM(4), 92, 236); -- second hut
      e_queue_command(E_CMD_PLACE_BLDG_SHAPE, 544, M_BUILDING_TEPEE, TRIBE_BLUE, G_RANDOM(4), 106, 236); -- third hut
      
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 545, CMD_BUILD_BUILDING, 100, 232);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 545, 4);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 545);
      
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 546, CMD_BUILD_BUILDING, 92, 228);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 546, 5);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 546);
      
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 547, CMD_BUILD_BUILDING, 92, 236);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 547, 6);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 547);
      
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 548, CMD_BUILD_BUILDING, 106, 236);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 548, 7);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 548);
      
      e_queue_command(E_CMD_SET_NEXT_COMMAND, 549, CMD_GOTO_POINT, 98, 236);
      e_queue_command(E_CMD_DISPATCH_COMMANDS, 549, 3);
      e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 549);
      
      e_queue_command(E_CMD_STOP_EXECUTION, 582);
      
      e_start();
    end
  elseif (e_get_var(1) == 9) then
    if (e_is_ready()) then
      e_set_var(1, 10);
      
      -- activate tribes
      PLAYER_IDX_2_PTR(TRIBE_BLUE).DeadCount = 0;
      PLAYER_IDX_2_PTR(TRIBE_RED).DeadCount = 0;
      
      e_queue_command(E_CMD_SET_CAMERA_PARAMS, 0, 99, 237, 493);
      e_queue_command(E_CMD_CINEMA_FADE, 12, false);
      e_queue_command(E_CMD_SHOW_PANEL, 68);
      
      e_queue_command(E_CMD_STOP_EXECUTION, 69);
      
      e_start();
    end
  end
end
