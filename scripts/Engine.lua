local gns = gnsi();

Engine = 
{
  Cmds = {},
  Variables = {},
  ThingBuffers = {},
  CmdCurrIdx = 0,
  CmdCache =
  {
    [0] = {}, {}, {}, {}, {}, {}, {}, {}
  },
  
  -- Dialog
  Dialog = 
  {
    MessageQueue = {},
    CurrMessageInfo =
    {
      String = nil,
      Elements = {}
    },
    DrawInfo =
    {
      PosX = 0,
      PosY = 0,
      Width = 0,
      Height = 0,
      Area = TbRect.new(),
    },
  },
  
  IsPanelShown = true,
  IsExecuting = false,
  Turn = 0,
};

-- cached stuff for engine
local e_cache_map = MapPosXZ.new();
local e_cache_c2d = Coord2D.new();
local e_cache_c3d = Coord3D.new();
local e_cache_cti = CmdTargetInfo.new();
local e_cache_cmd = {}; -- fucking stupid ass old 1.01 i hate you so fucking much.
local e_cache_me = nil;

local function construct_command_buffer()
  e_cache_cmd = {};
  local num_cmds = Engine.CmdCurrIdx - 1;
  if (num_cmds >= 0) then
    for i = 0, num_cmds do
      local data = Engine.CmdCache[i];
      e_cache_cmd[#e_cache_cmd + 1] = get_next_free_command_list_idx();
      if (e_cache_cmd[#e_cache_cmd] ~= 0) then
        local flags = 0;
        
        if ((i + 1) < num_cmds) then
          flags = bit32.bor(flags, bit32.lshift(1, 7));
        end
        
        e_cache_cti.TargetCoord.Xpos = bit32.lshift(data[2], 8);
        e_cache_cti.TargetCoord.Zpos = bit32.lshift(data[3], 8);
        update_cmd_list_entry(e_cache_cmd[#e_cache_cmd], data[1], e_cache_cti, flags);
      end
    end
  end
end


-- command defines
E_CMD_STOP_EXECUTION = 0; -- NO PARAMS
E_CMD_SHOW_PANEL = 1; -- NO PARAMS
E_CMD_HIDE_PANEL = 2; -- NO PARAMS
E_CMD_ENABLE_INPUT = 3; -- NO PARAMS
E_CMD_DISABLE_INPUT = 4; -- NO PARAMS
E_CMD_SET_VARIABLE = 5; -- INDEX, VALUE
E_CMD_CLEAR_THING_BUFFER = 6; -- INDEX
E_CMD_ADD_THINGS_TO_BUFFER = 7; -- INDEX, AMOUNT, TYPE, MODEL, OWNER, X, Z, RADIUS
E_CMD_SPAWN_THINGS = 8; -- INDEX, AMOUNT, TYPE, MODEL, OWNER, X, Z
E_CMD_DELETE_THINGS = 9; -- AMOUNT, TYPE, MODEL, OWNER, X, Z, RADIUS
E_CMD_PLACE_BLDG_SHAPE = 10; -- MODEL, OWNER, ORIENTATION, X, Z
E_CMD_DELETE_BLDG_SHAPE = 11; -- OWNER, X, Z
E_CMD_SET_ALLIANCE = 12; -- PLAYER_1, PLAYER_2
E_CMD_BREAK_ALLIANCE = 13; -- PLAYER_1, PLAYER_2
E_CMD_CLEAR_COMMAND_CACHE = 14; -- NO PARAMS
E_CMD_SET_NEXT_COMMAND = 15; -- CMD_TYPE, X, Z
E_CMD_DISPATCH_COMMANDS = 16; -- INDEX


-- clear cmd cache

--for i = 0,7 do e.CmdCache[i] = {}; end

-- set_next_command
--e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[1]; e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 2] = data[2]; e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 3] = data[3]; e.CmdCurrIdx = e.CmdCurrIdx + 1;

-- dispatch commands

--local num_cmds = Engine.CmdCurrIdx - 1;
-- for i,t in ipairs(e.ThingBuffers[data[1]]) do
  -- if (t.Type == T_PERSON) then
    -- remove_all_persons_commands(t);
    
    -- for j = 0, num_cmds do
      -- add_persons_command(t, e_cache_cmd[j], j);
    -- end

    -- set_person_top_state();
  -- end
-- end

--for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); for j = 0, num_cmds do add_persons_command(t, e_cache_cmd[j], j); end set_person_top_state(); end end



-- map_xz_to_world_coord2d(data[2], data[3], eng_cache_cti.TargetCoord);
-- centre_coord_on_block(eng_cache_cti.TargetCoord);
-- update_cmd_list_entry(eng_cache_cmd, CMD_GOTO_POINT, eng_cache_cti, 0);
-- for i,t in ipairs(e.ThingBuffers[data[1]]) do
  -- if (t.Type == T_PERSON) then
    -- remove_all_persons_commands(t);
    -- add_persons_command(t, eng_cache_cmd, 0);
    -- set_person_top_state(t);
  -- end
-- end

--map_xz_to_world_coord2d(data[2], data[3], eng_cache_c2d); centre_coord_on_block(eng_cache_c2d); eng_cache_me = world_coord2d_to_map_ptr(eng_cache_c2d); eng_cache_cti.TMIdxs.TargetIdx:set(eng_cache_me.ShapeOrBldgIdx:getThingNum()); eng_cache_cti.TMIdxs.MapIdx = world_coord2d_to_map_idx(eng_cache_c2d); update_cmd_list_entry(eng_cache_cmd, CMD_BUILD_BUILDING, eng_cache_cti, 0); for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); add_persons_command(t, eng_cache_cmd, 0); set_person_top_state(t); end end

-- table execution for commands
local E_FUNC_TABLE_EXECUTE =
{
  [0] = function(e, data) e_stop(); end,
  [1] = function(e, data) e_show_panel(); end,
  [2] = function(e, data) e_hide_panel(); end,
  [3] = function(e, data) ENABLE_USER_INPUTS(); end,
  [4] = function(e, data) DISABLE_USER_INPUTS(); end,
  [5] = function(e, data) e.Variables[data[1]] = data[2]; end,
  [6] = function(e, data) e.ThingBuffers[data[1]] = nil; e.ThingBuffers[data[1]] = {}; end,
  [7] = function(e, data) end,
  [8] = function(e, data) for i = 1, data[2] do local t = create_thing(data[3], data[4], data[5], data[6], data[7]); if (data[1] ~= -1) then e.ThingBuffers[data[1]][#e.ThingBuffers[data[1]] + 1] = t; end end end,
  [9] = function(e, data) map_xz_to_world_coord2d(data[5], data[6], e_cache_c2d); SearchMapCells(SQUARE, 0, 0, data[7], world_coord2d_to_map_idx(eng_cache_c2d), function(me) if (not me.MapWhoList:isEmpty()) then me.MapWhoList:processList(function(t) if (t.Type == data[2] or data[2] == -1) then if (t.Model == data[3] or data[3] == -1) then if (t.Owner == data[4] or data[4] == -1) then delete_thing_type(t); return true; end end end return true; end); end return true; end); end,
  [10] = function(e, data) e_cache_map.XZ.X = data[4]; e_cache_map.XZ.Z = data[5]; process_shape_map_elements(e_cache_map.Pos, data[1], data[3], data[2], SHME_MODE_SET_PERM); end,
  [11] = function(e, data) e_cache_map.XZ.X = data[2]; e_cache_map.XZ.Z = data[3]; process_shape_map_elements(e_cache_map.Pos, 0, 0, data[1], SHME_MODE_REMOVE_PERM); end,
  [12] = function(e, data) set_players_allied(data[1], data[2]); end,
  [13] = function(e, data) set_players_enemies(data[1], data[2]); end,
  [14] = function(e, data) for i = 0,7 do e.CmdCache[i] = {}; end end,
  [15] = function(e, data) e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[1]; e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[2]; e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[3]; e.CmdCurrIdx = e.CmdCurrIdx + 1; end,
  [16] = function(e, data) construct_command_buffer(); local num_cmds = Engine.CmdCurrIdx - 1; for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); t.Flags = bit32.bor(t.Flags, TF_RESET_STATE); for j = 0, num_cmds do add_persons_command(t, e_cache_cmd[j + 1], j); end end end end,
};


-- some dialog helper functions.
local function format_string_2(_string)
  Timer.Start();
  local str_fmt = string.format;
  local str_char = string.char;
  local str_byte = string.byte;
  local start_n = 1;
  local end_n = string.len(_string);
  local temp_str = nil;
  
  -- format by single char approach.
  while (start_n <= end_n) do
    temp_str = (str_fmt("%s", str_char(str_byte(_string, start_n))));
    start_n = start_n + 1;
  end
  
  Log(string.format("II - Time elapsed: %.04f", Timer.Stop()));
end

local function format_string(_string)
  Timer.Start();
  local d = Engine.Dialog;
  
  d.CurrMessageInfo.String = _string;
  
  PopSetFont(P3_SMALL_FONT_NORMAL, 0);
  
  local num_words = 0;
  local max_width = 240;
  local curr_width = 0;
  local num_spaces = 0;
  local current_line = 
  {
    text = nil,
    width = 0
  };
  local str_table = {};
  
  --Log(string.format("%i", CharWidth(65)));
  --Log(string.format("Max width: %i, String width: %i", max_width, string_width(_string)));
  
  for w in _string:gmatch("(%S+)") do
    
    local w_width = string_width(w);
    
    --Log("Real Width: " .. (curr_width + (num_spaces * CharWidth(65))));
    --Log("Word Width: " .. w_width);
    
    -- ok we want to check if next word can fit into our width.
    if ((curr_width + (num_spaces * CharWidth(65))) + w_width < max_width) then
      -- it does fit, pass into current_line
      str_table[#str_table + 1] = w;
      curr_width = curr_width + w_width;
      --Log(string.format("After Width: %i", (curr_width + (num_spaces * CharWidth(65)))));
    else
      -- compile line and make new one
      --Log("Test");
      current_line.text = table.concat(str_table, " ");
      --Log(string.format("%s", current_line.text));
      str_table = {};
      current_line.width = curr_width + (num_spaces * CharWidth(65));
      --Log(string.format("Final string size is: %i", current_line.width));
      num_spaces = 0;
      curr_width = 0;
      num_words = 0;
    end

    num_words = num_words + 1;
    num_spaces = num_words - 1;
  end
  
  --Log(string.format("String contained: %i words", num_words));
  Log(string.format("I - Time elapsed: %.04f", Timer.Stop()));
end

format_string("Test this string!");
format_string_2("Test this string!");
--format_string("Pressure Point is identicle to the Single Player level, Middle Ground. However most players do not worship the Stone Head which grants you Armageddon unlike the computer players do in Single Player. This is a level which goes in depth on defending with towers. You each start with a good shaped, bunky base with many wildies spread over the terrain.");

function e_init_engine()
  if (#Engine.Cmds ~= 0) then
    for i,k in pairs(Engine.Cmds) do
      Engine.Cmds[i] = nil;
    end
  end
  
  Engine.IsExecuting = false;
  Engine.Turn = 0;
  
  local d = Engine.Dialog;
  
  if (#d.MessageQueue > 0) then
    for i,msg in pairs(d.MessageQueue) do
      d.MessageQueue[i] = nil;
    end
  end
  
  d.CurrMessageInfo.String = nil;
  d.CurrMessageInfo.Elements = {};
  
  d.DrawInfo.Width = bit32.rshift(gns.ScreenW, 1);
  d.DrawInfo.Height = bit32.rshift(gns.ScreenH, 3);
  d.DrawInfo.PosX = GFGetGuiWidth();
  d.DrawInfo.PosY = 64;
  
  d.DrawInfo.Area.Left = d.DrawInfo.PosX;
  d.DrawInfo.Area.Right = d.DrawInfo.Area.Left + d.DrawInfo.Width;
  d.DrawInfo.Area.Top = d.DrawInfo.PosY;
  d.DrawInfo.Area.Bottom = d.DrawInfo.Area.Top + d.DrawInfo.Height;
end

function e_post_load_items()
  if (not Engine.IsPanelShown) then
    process_options(OPT_TOGGLE_PANEL, 0, 0);
  end
end

function e_show_panel()
  process_options(OPT_TOGGLE_PANEL, 1, 0);
  Engine.isPanelShown = true;
end

function e_hide_panel()
  process_options(OPT_TOGGLE_PANEL, 0, 0);
  Engine.isPanelShown = false;
end

function e_queue_command(_type, _turn, ...)
  local cmd = 
  {
    Type = _type,
    Turn = _turn,
    Data = {...},
    Executed = false
  };
  
  Engine.Cmds[#Engine.Cmds + 1] = cmd;
end

function e_process_execution()
  if (Engine.IsExecuting) then
    if (#Engine.Cmds > 0) then
      for i, cmd in ipairs(Engine.Cmds) do
        if (Engine.Turn >= cmd.Turn and not cmd.Executed) then
          E_FUNC_TABLE_EXECUTE[cmd.Type](Engine, cmd.Data);
          cmd.Executed = true;
        end
      end
    end
    
    Engine.Turn = Engine.Turn + 1;
  end
end

function e_start()
  Engine.Turn = 0;
  Engine.IsExecuting = true;
end

function e_stop()
  if (#Engine.Cmds ~= 0) then
    for i,k in pairs(Engine.Cmds) do
      Engine.Cmds[i] = nil;
    end
  end
  
  Engine.Turn = 0;
  Engine.IsExecuting = false;
end

function e_toggle_pause()
  self.IsExecuting = not self.IsExecuting;
end

function e_allocate_thing_buffers(_amount)
  for i = 1, _amount do
    Engine.ThingBuffers[#Engine.ThingBuffers + 1] = {};
  end
end

function e_allocate_variables(_amount)
  for i = 1, _amount do
    Engine.Variables[i] = 0;
  end
end

function e_set_var(_idx, _value)
  Engine.Variables[_idx] = _value;
end

function e_get_var(_idx)
  return Engine.Variables[_idx];
end

function e_debug_keys_handle(k)
  if (k == LB_KEY_1) then
    e_stop();
  end
  
  if (k == LB_KEY_2) then
    e_start();
  end
  
  if (k == LB_KEY_3) then
    e_toggle_pause();
  end
  
  if (k == LB_KEY_4) then
    if (#Engine.Cmds ~= 0) then
      for i,k in pairs(Engine.Cmds) do
        Engine.Cmds[i] = nil;
      end
    end
  end
  
  if (k == LB_KEY_5) then
    e_queue_command(1, G_RANDOM(1024));
  end
end

function e_draw()
  local gui_width = GFGetGuiWidth();
  PopSetFont(P3_SMALL_FONT_NORMAL, 0);
  local y = 0;
  DrawTextStr(gui_width, y, string.format("Commands: %i", #Engine.Cmds));
  y = y + CharHeight('A');
  DrawTextStr(gui_width, y, string.format("Turn: %i", Engine.Turn));
  y = y + CharHeight('A');
  DrawTextStr(gui_width, y, string.format("Active: %s", Engine.IsExecuting));
  
  
  PopSetFont(P3_SMALL_FONT_NORMAL, 0);
  
  local d = Engine.Dialog;
  
  LbDraw_Rectangle(d.DrawInfo.Area, 196);
  if (d.CurrMessageInfo.String ~= nil) then
    DrawTextStr(d.DrawInfo.Area.Left, d.DrawInfo.Area.Top, d.CurrMessageInfo.String);
  end
end