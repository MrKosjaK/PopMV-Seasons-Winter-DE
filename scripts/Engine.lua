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
    Queue = {},
    Msg =
    {
      Title = nil;
      Lines = {}
    },
    DrawInfo =
    {
      DrawCount = 0,
      Bank = -1,
      Sprite = -1,
      Draw = false,
      PosX = 0,
      PosY = 0,
      Width = 0,
      Height = 0,
      Area = TbRect.new(),
      BoxM = TbRect.new(),
      BoxI = TbRect.new(),
      BoxT = TbRect.new(),
      Clipper = 
      {
        Clip = TbRect.new(),
        Line = 0,
        Size = 0
      },
      Style = BorderLayout.new(),
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


-- dialogstuff

local DIALOG_STYLE_TABLE =
{
  {1450, 1451, 1452, 1453, 1454 + math.random(0, 1), 1456 + math.random(0, 1), 1458 + math.random(0, 1), 1460 + math.random(0, 1), 1462 + math.random(0, 2)},  -- standard default
  {879, 880, 881, 882, 883, 884, 885, 886, 887}, -- blue default
  {906, 907, 908, 909, 910, 911, 912, 913, 914}, -- red default
  {933, 934, 935, 936, 937, 938, 939, 940, 941}, -- yellow default
  {960, 961, 962, 963, 964, 965, 966, 967, 968}, -- green default
  {794, 795, 796, 797, 798, 799, 800, 801, 802}, -- yellow 1
  {821, 822, 823, 824, 825, 826, 827, 828, 829}, -- yellow 2
  {996, 997, 998, 999, 1000, 1001, 1002, 1003, 1004}, -- yellow 3
  {510, 511, 512, 513, 514, 515, 516, 517, 518}, -- grey
  {},
  {}
};

local function dialog_get_drawinfo_ptr()
  return Engine.Dialog.DrawInfo;
end

local function dialog_get_ptr()
  return Engine.Dialog;
end

local function dialog_get_msg_ptr()
  return Engine.Dialog.Msg;
end

local function dialog_get_queue_ptr()
  return Engine.Dialog.Queue;
end

local function dialog_clear_msg_info()
  local d = dialog_get_msg_ptr();
  d.Lines = {};
  d.Title = nil;
end

local function dialog_create_new_line(_text)
  return {Width = 0, Text = _text};
end

local function dialog_set_style(_style_num)
  if (_style_num < 0 or _style_num > #DIALOG_STYLE_TABLE) then
    do return end;
  end
  
  local d = dialog_get_drawinfo_ptr();
  
  d.Style.TopLeft = DIALOG_STYLE_TABLE[_style_num][1];
  d.Style.TopRight = DIALOG_STYLE_TABLE[_style_num][2];
  d.Style.BottomLeft = DIALOG_STYLE_TABLE[_style_num][3];
  d.Style.BottomRight = DIALOG_STYLE_TABLE[_style_num][4];
  
  d.Style.Top = DIALOG_STYLE_TABLE[_style_num][5];
  d.Style.Bottom = DIALOG_STYLE_TABLE[_style_num][6];
  d.Style.Left = DIALOG_STYLE_TABLE[_style_num][7];
  d.Style.Right = DIALOG_STYLE_TABLE[_style_num][8];
  
  d.Style.Centre = DIALOG_STYLE_TABLE[_style_num][9];
end

local function dialog_clear_clipper_info()
  local d = dialog_get_drawinfo_ptr();
  
  d.Clipper.Size = 0;
  d.Clipper.Line = 0;
  d.Clipper.Clip.Left = 0;
  d.Clipper.Clip.Right = 0;
  d.Clipper.Clip.Top = 0;
  d.Clipper.Clip.Bottom = 0;
end

local function dialog_advance_clipper()
  local d = dialog_get_drawinfo_ptr();
  local m = dialog_get_msg_ptr();
  
  if (d.Clipper.Line < #m.Lines) then
    d.Clipper.Size = d.Clipper.Size + bit32.rshift(CharWidth(65), 1);
    
    d.Clipper.Clip.Left = d.Area.Left;
    d.Clipper.Clip.Right = d.Clipper.Clip.Left + d.Clipper.Size;
    d.Clipper.Clip.Top = d.Area.Top + (CharHeight('A') * d.Clipper.Line);
    d.Clipper.Clip.Bottom = d.Clipper.Clip.Top + CharHeight('A');
    
    if (d.Clipper.Size >= m.Lines[d.Clipper.Line + 1].Width) then
      d.Clipper.Size = 0;
      d.Clipper.Line = d.Clipper.Line + 1;
    end
  end
end

local function dialog_recalc_draw_area(_x, _y, _width, _height)
  local d = dialog_get_drawinfo_ptr();
  local m = dialog_get_msg_ptr();
  
  d.Width = _width or d.Width;
  d.Height = _height or d.Height;
  d.PosX = _x or d.PosX;
  d.PosY = _y or d.PosY;
  
  d.Area.Left = d.PosX;
  d.Area.Right = d.Area.Left + d.Width;
  d.Area.Top = d.PosY;
  d.Area.Bottom = d.Area.Top + d.Height;
  
  d.BoxM.Left = d.Area.Left - 8;
  d.BoxM.Right = d.Area.Right + 8;
  d.BoxM.Top = d.Area.Top - 8;
  d.BoxM.Bottom = d.Area.Bottom + 8;
  
  if (m.Title ~= nil) then
    PopSetFont(P3_LARGE_FONT, 0);
    d.BoxT.Left = d.Area.Left + CharWidth(65) - 8;
    d.BoxT.Right = d.BoxT.Left + string_width(m.Title) + 18;
    d.BoxT.Top = d.Area.Top - CharHeight('A') - 12;
    d.BoxT.Bottom = d.BoxT.Top + 48;
  end
  
  if (d.Sprite > -1) then
    local spr = nil;
    
    if (d.Bank == 0) then
      spr = get_hfx_sprite(d.Sprite);
    elseif (d.Bank == 1) then
      spr = get_hspr_sprite(0, d.Sprite);
    end
    
    if (spr ~= nil) then
      d.BoxI.Left = d.Area.Left - 48;
      d.BoxI.Right = d.BoxI.Left + 32;
      d.BoxI.Top = d.Area.Top + bit32.rshift(d.Height, 1) - bit32.rshift(math.max(32, spr.Height), 1);
      d.BoxI.Bottom = d.BoxI.Top + math.max(32, spr.Height);
    end
  end
end

local function dialog_format_text(_text)
  --Timer.Start();
  dialog_clear_msg_info();
  
  dialog_recalc_draw_area(nil, nil, bit32.rshift(gns.ScreenW, 1), nil);
  
  PopSetFont(P3_SMALL_FONT_NORMAL, 0);
  
  local current_text = _text;
  
  local d = dialog_get_msg_ptr();
  d.Lines[#d.Lines + 1] = dialog_create_new_line(current_text);
  
  local curr_pos = 1;
  local curr_char = nil;
  local end_pos = string.len(current_text);
  local line_width = 0;
  local break_pos = 0;
  
  while (curr_pos <= end_pos) do
    curr_char = string.char(string.byte(current_text, curr_pos));
    
    line_width = line_width + CharWidth(string.byte(current_text, curr_pos));
    d.Lines[#d.Lines].Width = line_width;
    curr_pos = curr_pos + 1;
    --Log(string.format("Current line width: %i, Break pos: %i, Curr pos: %i, End pos: %i", line_width, break_pos, curr_pos, end_pos));
    
    if (curr_char == ' ') then
      break_pos = curr_pos;
    end
    
    if (line_width > Engine.Dialog.DrawInfo.Width and break_pos ~= curr_pos) then
      --Log(string.format("Current line width: %i, Break pos: %i, Curr pos: %i, End pos: %i", line_width, break_pos, curr_pos, end_pos));
      d.Lines[#d.Lines].Text = string.sub(current_text, 1, break_pos - 2);
      d.Lines[#d.Lines].Width = string_width(d.Lines[#d.Lines].Text);
      current_text = string.sub(current_text, break_pos);
      
      d.Lines[#d.Lines + 1] = dialog_create_new_line(current_text);
      
      line_width = 0;
      curr_pos = 1;
      end_pos = string.len(current_text);
      break_pos = 0;
    end
  end
  
  dialog_recalc_draw_area(nil, nil, nil, #d.Lines * CharHeight('A'));
  
  --Log(string.format("III - Time elapsed: %.04f", Timer.Stop()));
end

function dialog_queue_msg(_text, _title, _bank, _sprite, _style_num, _draw_count)
  local msg =
  {
    Text = _text,
    Title = _title or nil,
    StyleNum = _style_num or 0,
    DrawCount = _draw_count or 0,
    BankNum = _bank or -1,
    SpriteNum = _sprite or -1
  }
  
  local q = dialog_get_queue_ptr();
  q[#q + 1] = msg;
end

local function dialog_render_frame()
  local d = dialog_get_drawinfo_ptr();
  --Timer.Start();
  
  if (d.Draw) then
    PopSetFont(P3_SMALL_FONT_NORMAL, 0);
  
    local gui_width = GFGetGuiWidth();
    local m = dialog_get_msg_ptr();
    
    dialog_recalc_draw_area((bit32.rshift(gns.ScreenW, 1) - bit32.rshift(d.Width, 1)) + bit32.rshift(gui_width, 1), (gns.ScreenH - d.Height) - bit32.rshift(gns.ScreenH, 4), nil, nil);
  
    if (m.Title ~= nil) then
      DrawStretchyButtonBox(d.BoxT, d.Style);
      PopSetFont(P3_LARGE_FONT, 0);
      DrawTextStr(d.Area.Left + CharWidth(65), d.Area.Top - CharHeight('A') - 7, m.Title);
      PopSetFont(P3_SMALL_FONT_NORMAL, 0);
    end
    
    DrawStretchyButtonBox(d.BoxM, d.Style);
    
    if (d.Sprite > -1) then
      DrawStretchyButtonBox(d.BoxI, d.Style);
      -- HFX sprite.
      if (d.Bank == 0) then
        LbDraw_ScaledSprite(d.BoxI.Left + 4, d.BoxI.Top + 4, get_hfx_sprite(d.Sprite), (d.BoxI.Right - d.BoxI.Left) - 8, (d.BoxI.Bottom - d.BoxI.Top) - 8);
      elseif (d.Bank == 1) then -- HSPR BANK 0
        LbDraw_ScaledSprite(d.BoxI.Left + 4, d.BoxI.Top + 4, get_hspr_sprite(0, d.Sprite), (d.BoxI.Right - d.BoxI.Left) - 8, (d.BoxI.Bottom - d.BoxI.Top) - 8);
      end
    end
    
    for i,k in ipairs(m.Lines) do
      if (d.Clipper.Line >= (i-1)) then
        DrawTextStr(d.Area.Left, d.Area.Top + ((i-1)*CharHeight(32)), k.Text);
      end
      LbDraw_SetFlagsOn(8);
      LbDraw_Rectangle(d.Clipper.Clip, 128);
      LbDraw_SetFlagsOff(8);
    end
    
    dialog_advance_clipper();
    
    d.DrawCount = d.DrawCount - 1;
  end
  
  --Log(string.format("Frame ms: %.04f", Timer.Stop()));
end

function e_init_engine()
  if (#Engine.Cmds ~= 0) then
    for i,k in pairs(Engine.Cmds) do
      Engine.Cmds[i] = nil;
    end
  end
  
  Engine.IsExecuting = false;
  Engine.Turn = 0;
  
  local q = dialog_get_queue_ptr();
  
  if (#q > 0) then
    for i,msg in pairs(q) do
      q[i] = nil;
    end
  end
  
  dialog_clear_msg_info();
  dialog_clear_clipper_info();
end

function e_post_load_items()
  if (not Engine.IsPanelShown) then
    toggle_panel(0);
  end
end

function e_show_panel()
  toggle_panel(1);
  Engine.isPanelShown = true;
end

function e_hide_panel()
  toggle_panel(0);
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

function e_process()
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
  
  -- dialog queue process
  local d = dialog_get_drawinfo_ptr();
  local q = dialog_get_queue_ptr();
  local m = dialog_get_msg_ptr();
  
  if (d.DrawCount <= 0) then
    -- check if queue has any msgs.
    if (#q > 0) then
      local msg = q[1];
       
      dialog_format_text(msg.Text);
      m.Title = msg.Title;
      dialog_set_style(msg.StyleNum);
      d.Bank = msg.BankNum;
      d.Sprite = msg.SpriteNum;
      d.DrawCount = msg.DrawCount;
      d.Draw = true;
      dialog_clear_clipper_info();
      
      table.remove(q, 1);
    else
      d.Draw = false;
      d.DrawCount = 0;
      dialog_clear_msg_info();
      dialog_clear_clipper_info();
    end
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
  if (is_game_active()) then
    local gui_width = GFGetGuiWidth();
    PopSetFont(P3_SMALL_FONT_NORMAL, 0);
    local y = 0;
    
    DrawTextStr(gui_width, y, "=====ENGINE SYSTEM=====");
    y = y + CharHeight('A');
    
    DrawTextStr(gui_width, y, string.format("Commands: %i", #Engine.Cmds));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Turn: %i", Engine.Turn));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Active: %s", Engine.IsExecuting));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Queued Msgs: %s", #Engine.Dialog.Queue));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Draw Count: %s", Engine.Dialog.DrawInfo.DrawCount));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Game Turn: %s", Game.getTurn()));
    y = y + CharHeight('A');
    
    DrawTextStr(gui_width, y, "=====GAME DIFFICULTY=====");
    y = y + CharHeight('A');
    
    DrawTextStr(gui_width, y, string.format("Is Game Easy: %s", is_game_diff_easy()));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Is Game Normal: %s", is_game_diff_normal()));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Is Game Hard: %s", is_game_diff_hard()));
    y = y + CharHeight('A');
    DrawTextStr(gui_width, y, string.format("Is Game Very Hard: %s", is_game_diff_very_hard()));

    dialog_render_frame();
  end
end