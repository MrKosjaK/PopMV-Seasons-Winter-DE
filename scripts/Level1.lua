require(get_script_dir() .. "Common");
local Lang = require(get_script_dir() .. "Language\\LangLvl1");

e_allocate_thing_buffers(3);
e_allocate_variables(16);

function _OnTurn(turn)
  if (is_first_init()) then
    -- hide panel
    e_hide_panel();
    
    -- set cinema rectangles to fill entire screen
    e_queue_command(E_CMD_CINEMA_SET_SIZE, 0, bit32.rshift(gns.ScreenH, 1));
    e_queue_command(E_CMD_CINEMA_RAISE, 0, true);
    e_queue_command(E_CMD_SET_CAMERA_PARAMS, 0, 19, 233, 1769);
    
    -- uncover some fog while it's black screen
    --e_queue_command(E_CMD_FOW_COVER, 0, 0, 0, 8, true);
    e_queue_command(E_CMD_FOW_UNCOVER, 2, 18, 234, 4, -1);
    e_queue_command(E_CMD_FOW_UNCOVER, 3, 18, 240, 5, -1);
    e_queue_command(E_CMD_FOW_UNCOVER, 4, 14, 252, 6, -1);
    
    e_queue_command(E_CMD_SET_CAMERA_PARAMS, 16, 19, 233, 1769);
    e_queue_command(E_CMD_TRIBE_SET_SKIN, 0, 0, 0, true);
    --e_queue_command(E_CMD_SPAWN_THINGS, 0, -1, 1, T_PERSON, M_PERSON_MEDICINE_MAN, TRIBE_BLUE, 97, 207);
    --e_queue_command(E_CMD_SPAWN_THINGS, 0, -1, 1, T_PERSON, M_PERSON_MEDICINE_MAN, TRIBE_RED, 101, 119);
    
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
      
      
      e_queue_command(E_CMD_STOP_EXECUTION, 250);
    
      e_start();
    end
  end
end
