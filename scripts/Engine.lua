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

local dialog_mt = {};
dialog_mt.__index = dialog_mt;

setmetatable(Engine.Dialog,
{
  __call = function(t, ...) log("DO NOT CALL DIALOG DIRECTLY!"); end,
  __index = dialog_mt
});

function dialog_mt:init_dialog()
  if (#self.MessageQueue > 0) then
    for i,msg in pairs(self.MessageQueue) do
      self.MessageQueue[i] = nil;
    end
  end
  
  self.CurrMessageInfo.String = nil;
  self.CurrMessageInfo.Elements = nil;
  self.CurrMessageInfo.Elements = {};
  
  self.DrawInfo.Width = bit32.rshift(gns.ScreenW, 1);
  self.DrawInfo.Height = bit32.rshift(gns.ScreenH, 3);
  self.DrawInfo.PosX = GFGetGuiWidth();
  self.DrawInfo.PosY = 64;
  
  self.DrawInfo.Area.Left = self.DrawInfo.PosX;
  self.DrawInfo.Area.Right = self.DrawInfo.Area.Left + self.DrawInfo.Width;
  self.DrawInfo.Area.Top = self.DrawInfo.PosY;
  self.DrawInfo.Area.Bottom = self.DrawInfo.Area.Top + self.DrawInfo.Height;
end

function dialog_mt:draw()
  PopSetFont(4);
  LbDraw_Rectangle(self.DrawInfo.Area, 196);
  if (self.CurrMessageInfo.String ~= nil) then
    LbDraw_Text(self.DrawInfo.Area.Left, self.DrawInfo.Area.Top, self.CurrMessageInfo.String, 0);
  end
end

-- cached stuff for engine
local e_cache_map = MapPosXZ.new();
local e_cache_c2d = Coord2D.new();
local e_cache_c3d = Coord3D.new();
local e_cache_cti = CmdTargetInfo.new();
local e_cache_cmd =
{
  Commands.new(),
  Commands.new(),
  Commands.new(),
  Commands.new(),
  Commands.new(),
  Commands.new(),
  Commands.new(),
  Commands.new()
};
local e_cache_me = nil;

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

for i = 0,7 do e.CmdCache[i] = {}; end

-- set_next_command
e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[1];
e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 2] = data[2];
e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 3] = data[3];
e.CmdCurrIdx = e.CmdCurrIdx + 1;

-- dispatch commands



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
  [8] = function(e, data) for i = 1, data[2] do map_xz_to_world_coord2d(data[6], data[7], e_cache_c2d); centre_coord_on_block(e_cache_c2d); coord2D_to_coord3D(e_cache_c2d, e_cache_c3d); local t = createThing(data[3], data[4], data[5], e_cache_c3d, false, false); if (data[1] ~= -1) then e.ThingBuffers[data[1]][#e.ThingBuffers[data[1]] + 1] = t; end end end,
  [9] = function(e, data) map_xz_to_world_coord2d(data[5], data[6], e_cache_c2d); SearchMapCells(SQUARE, 0, 0, data[7], world_coord2d_to_map_idx(eng_cache_c2d), function(me) if (not me.MapWhoList:isEmpty()) then me.MapWhoList:processList(function(t) if (t.Type == data[2] or data[2] == -1) then if (t.Model == data[3] or data[3] == -1) then if (t.Owner == data[4] or data[4] == -1) then delete_thing_type(t); return true; end end end return true; end); end return true; end); end,
  [10] = function(e, data) e_cache_map.XZ.X = data[4]; e_cache_map.XZ.Z = data[5]; process_shape_map_elements(e_cache_map.Pos, data[1], data[3], data[2], SHME_MODE_SET_PERM); end,
  [11] = function(e, data) e_cache_map.XZ.X = data[2]; e_cache_map.XZ.Z = data[3]; process_shape_map_elements(e_cache_map.Pos, 0, 0, data[1], SHME_MODE_REMOVE_PERM); end,
  [12] = function(e, data) set_players_allied(data[1], data[2]); end,
  [13] = function(e, data) set_players_enemies(data[1], data[2]); end
};

function e_init_engine()
  if (#Engine.Cmds ~= 0) then
    for i,k in pairs(Engine.Cmds) do
      Engine.Cmds[i] = nil;
    end
  end
  
  Engine.IsExecuting = false;
  Engine.Turn = 0;
  
  Engine.Dialog:init_dialog();
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
  
  --self.Dialog:draw();
end