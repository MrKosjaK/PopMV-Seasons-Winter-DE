local gns = gnsi();

Engine = 
{
  Cmds = {},
  Variables = {},
  ThingBuffers = {},
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
local eng_cache_map = MapPosXZ.new();
local eng_cache_c2d = Coord2D.new();
local eng_cache_c3d = Coord3D.new();
local eng_cache_cti = CmdTargetInfo.new();
local eng_cache_cmd = Commands.new();
local eng_cache_me = nil;

-- command defines
ENGINE_CMD_STOP_EXECUTION = 0; -- NO PARAMS
ENGINE_CMD_SHOW_PANEL = 1; -- NO PARAMS
ENGINE_CMD_HIDE_PANEL = 2; -- NO PARAMS
ENGINE_CMD_ENABLE_INPUT = 3; -- NO PARAMS
ENGINE_CMD_DISABLE_INPUT = 4; -- NO PARAMS
ENGINE_CMD_SET_VARIABLE = 5; -- INDEX, VALUE
ENGINE_CMD_CLEAR_THING_BUFFER = 6; -- INDEX
ENGINE_CMD_ADD_THINGS_TO_BUFFER = 7; -- INDEX, AMOUNT, TYPE, MODEL, OWNER, X, Z, RADIUS
ENGINE_CMD_SPAWN_THINGS = 8; -- INDEX, AMOUNT, TYPE, MODEL, OWNER, X, Z
ENGINE_CMD_DELETE_THINGS = 9; -- AMOUNT, TYPE, MODEL, OWNER, X, Z, RADIUS
ENGINE_CMD_PLACE_BLDG_SHAPE = 10; -- MODEL, OWNER, ORIENTATION, X, Z
ENGINE_CMD_DELETE_BLDG_SHAPE = 11; -- OWNER, X, Z
ENGINE_CMD_SET_ALLIANCE = 12; -- PLAYER_1, PLAYER_2
ENGINE_CMD_BREAK_ALLIANCE = 13; -- PLAYER_1, PLAYER_2
ENGINE_CMD_START_REINCARNATION = 14; -- OWNER, X, Z
ENGINE_CMD_CREATE_SHOT = 15; -- OWNER, START_X, START_Z, END_X, END_Z, EFFECT_TYPE, EFFECT_MODEL
ENGINE_CMD_SET_PERS_ANIM_RUNNING = 16; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_JUMPING = 17; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_STANDING = 18; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_DROWNING = 19; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_FLEEING = 20; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_FLYING = 21; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_WORKING = 22; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_PUNCHING = 23; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_FLINCHING = 24; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_PUSHING = 25; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_PUSHED = 26; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_SITTING = 27; -- INDEX
ENGINE_CMD_SET_PERS_ANIM_KICKING = 28; -- INDEX
ENGINE_CMD_SET_THING_FRAME_COUNT = 29; -- INDEX, VALUE
ENGINE_CMD_SET_THING_NO_ANIMATE = 30; -- INDEX
ENGINE_CMD_SET_THING_NO_DRAW = 31; -- INDEX
ENGINE_CMD_SET_THING_TRANSPARENT = 32; -- INDEX
ENGINE_CMD_SET_THING_OPAQUE = 33; -- INDEX
ENGINE_CMD_SET_THING_DRAW = 34; -- INDEX
ENGINE_CMD_SET_THING_ANIMATE = 35; -- INDEX
ENGINE_CMD_PERS_GOTO_POINT = 36; -- INDEX, X, Z
ENGINE_CMD_PERS_BUILD_BLDG = 37; -- INDEX, X, Z
ENGINE_CMD_PERS_ENTER_BLDG = 38; -- INDEX, X, Z
ENGINE_CMD_PERS_DISMANTLE_BLDG = 39; -- INDEX, X, Z
ENGINE_CMD_PERS_SABOTAGE_BLDG = 40; -- INDEX, X, Z
ENGINE_CMD_PERS_ENTER_VEHICLE = 41; -- INDEX, X, Z
ENGINE_CMD_PERS_GUARD_AREA = 42; -- INDEX, X, Z
ENGINE_CMD_PERS_GUARD_PATROL = 43; -- INDEX, X1, Z1, X2, Z2
ENGINE_CMD_PERS_PRAY_HEAD = 44; -- INDEX, X, Z
ENGINE_CMD_PERS_ATTACK_AREA = 45; -- INDEX, X, Z
ENGINE_CMD_PERS_ATTACK_PERSON = 46; -- INDEX, THINGNUM
ENGINE_CMD_SPARE_1 = 47; -- NO PARAMETERS
ENGINE_CMD_SPARE_2 = 48; -- NO PARAMETERS
ENGINE_CMD_SPARE_3 = 49; -- NO PARAMETERS
ENGINE_CMD_SPARE_4 = 50; -- NO PARAMETERS
ENGINE_CMD_SPARE_5 = 51; -- NO PARAMETERS
ENGINE_CMD_SPARE_6 = 52; -- NO PARAMETERS
ENGINE_CMD_SPARE_7 = 53; -- NO PARAMETERS
ENGINE_CMD_SPARE_8 = 54; -- NO PARAMETERS
ENGINE_CMD_SPARE_9 = 55; -- NO PARAMETERS

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
local ENGINE_FUNC_TABLE_EXECUTE =
{
  [0] = function(e, data) e_stop(); end,
  [1] = function(e, data) e_show_panel(); end,
  [2] = function(e, data) e_hide_panel(); end,
  [3] = function(e, data) ENABLE_USER_INPUTS(); end,
  [4] = function(e, data) DISABLE_USER_INPUTS(); end,
  [5] = function(e, data) e.Variables[data[1]] = data[2]; end,
  [6] = function(e, data) e.ThingBuffers[data[1]] = nil; e.ThingBuffers[data[1]] = {}; end,
  [7] = function(e, data) end,
  [8] = function(e, data) for i = 1, data[2] do map_xz_to_world_coord2d(data[6], data[7], eng_cache_c2d); centre_coord_on_block(eng_cache_c2d); coord2D_to_coord3D(eng_cache_c2d, eng_cache_c3d); local t = createThing(data[3], data[4], data[5], eng_cache_c3d, false, false); if (data[1] ~= -1) then e.ThingBuffers[data[1]][#e.ThingBuffers[data[1]] + 1] = t; end end end,
  [9] = function(e, data) map_xz_to_world_coord2d(data[5], data[6], eng_cache_c2d); SearchMapCells(SQUARE, 0, 0, data[7], world_coord2d_to_map_idx(eng_cache_c2d), function(me) if (not me.MapWhoList:isEmpty()) then me.MapWhoList:processList(function(t) if (t.Type == data[2] or data[2] == -1) then if (t.Model == data[3] or data[3] == -1) then if (t.Owner == data[4] or data[4] == -1) then delete_thing_type(t); return true; end end end return true; end); end return true; end); end,
  [10] = function(e, data) eng_cache_map.XZ.X = data[4]; eng_cache_map.XZ.Z = data[5]; process_shape_map_elements(eng_cache_map.Pos, data[1], data[3], data[2], SHME_MODE_SET_PERM); end,
  [11] = function(e, data) eng_cache_map.XZ.X = data[2]; eng_cache_map.XZ.Z = data[3]; process_shape_map_elements(eng_cache_map.Pos, 0, 0, data[1], SHME_MODE_REMOVE_PERM); end,
  [12] = function(e, data) set_players_allied(data[1], data[2]); end,
  [13] = function(e, data) set_players_enemies(data[1], data[2]); end,
  [14] = function(e, data) local s = getShaman(data[1]) if (s ~= nil) then remove_all_persons_commands(s); set_player_reinc_site_on(getPlayer(data[1])); map_xz_to_world_coord2d(data[2], data[3], eng_cache_cti.TargetCoord); centre_coord_on_block(eng_cache_cti.TargetCoord); update_cmd_list_entry(eng_cache_cmd, CMD_MOVE_REINCARN_SITE, eng_cache_cti, CMD_FLAG_AUTO_CMD); add_persons_command(s, eng_cache_cmd, 0); set_person_top_state(s); end end,
  [15] = function(e, data) map_xz_to_world_coord2d(data[4], data[5], eng_cache_c2d); centre_coord_on_block(eng_cache_c2d); coord2D_to_coord3D(eng_cache_c2d, eng_cache_c3d); local t = createThing(T_SHOT, 1, data[1], eng_cache_c3d, false, false); map_xz_to_world_coord2d(data[2], data[3], eng_cache_c2d); coord2D_to_coord3D(eng_cache_c2d, t.u.Shot.StartCoord); t.u.Shot.StartCoord.Ypos = 3048; t.u.Shot.EffectType = data[6]; t.u.Shot.EffectModel = data[7]; end,
  [16] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_running_anim(t); end end end,
  [17] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_jumping_anim(t); end end end,
  [18] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_standing_anim(t); end end end,
  [19] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_drowning_anim(t); end end end,
  [20] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_fleeing_anim(t); end end end,
  [21] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_flying_anim(t); end end end,
  [22] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_working_anim(t); end end end,
  [23] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_punching_anim(t); end end end,
  [24] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_flinching_anim(t); end end end,
  [25] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_pushing_anim(t); end end end,
  [26] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_pushed_anim(t); end end end,
  [27] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_sitting_anim(t); end end end,
  [28] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_kicking_anim(t); end end end,
  [29] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do t.DrawInfo.FrameCount = data[2]; end end,
  [30] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do t.DrawInfo.Flags = bit32.bor(t.DrawInfo.Flags, DF_NO_ANIMATE); end end,
  [31] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do t.DrawInfo.Flags = bit32.bor(t.DrawInfo.Flags, DF_THING_NO_DRAW); end end,
  [32] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do t.DrawInfo.Flags = bit32.bor(t.DrawInfo.Flags, DF_GLASS); end end,
  [33] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do t.DrawInfo.Flags = bit32.band(t.DrawInfo.Flags, bit32.bnot(DF_GLASS)); end end,
  [34] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do t.DrawInfo.Flags = bit32.band(t.DrawInfo.Flags, bit32.bnot(DF_THING_NO_DRAW)); end end,
  [35] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do t.DrawInfo.Flags = bit32.band(t.DrawInfo.Flags, bit32.bnot(DF_NO_ANIMATE)); end end,
  [36] = function(e, data) map_xz_to_world_coord2d(data[2], data[3], eng_cache_cti.TargetCoord); centre_coord_on_block(eng_cache_cti.TargetCoord); update_cmd_list_entry(eng_cache_cmd, CMD_GOTO_POINT, eng_cache_cti, 0); for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); add_persons_command(t, eng_cache_cmd, 0); set_person_top_state(t); end end end,
  [37] = function(e, data) map_xz_to_world_coord2d(data[2], data[3], eng_cache_c2d); centre_coord_on_block(eng_cache_c2d); eng_cache_me = world_coord2d_to_map_ptr(eng_cache_c2d); eng_cache_cti.TMIdxs.TargetIdx:set(eng_cache_me.ShapeOrBldgIdx:getThingNum()); eng_cache_cti.TMIdxs.MapIdx = world_coord2d_to_map_idx(eng_cache_c2d); update_cmd_list_entry(eng_cache_cmd, CMD_BUILD_BUILDING, eng_cache_cti, 0); for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); add_persons_command(t, eng_cache_cmd, 0); set_person_top_state(t); end end end,
  [38] = function(e, data) map_xz_to_world_coord2d(data[2], data[3], eng_cache_c2d); centre_coord_on_block(eng_cache_c2d); eng_cache_me = world_coord2d_to_map_ptr(eng_cache_c2d); eng_cache_cti.TargetIdx:set(eng_cache_me.ShapeOrBldgIdx:getThingNum()); update_cmd_list_entry(eng_cache_cmd, CMD_GO_IN_BLDG, eng_cache_cti, 0); for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); add_persons_command(t, eng_cache_cmd, 0); set_person_top_state(t); end end end,
  [39] = function(e, data) map_xz_to_world_coord2d(data[2], data[3], eng_cache_c2d); centre_coord_on_block(eng_cache_c2d); eng_cache_me = world_coord2d_to_map_ptr(eng_cache_c2d); eng_cache_cti.TMIdxs.TargetIdx:set(eng_cache_me.ShapeOrBldgIdx:getThingNum()); eng_cache_cti.TMIdxs.MapIdx = world_coord2d_to_map_idx(eng_cache_c2d); update_cmd_list_entry(eng_cache_cmd, CMD_DISMANTLE_BUILDING, eng_cache_cti, 0); for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); add_persons_command(t, eng_cache_cmd, 0); set_person_top_state(t); end end end,
  [40] = function(e, data) map_xz_to_world_coord2d(data[2], data[3], eng_cache_cti.TargetCoord); centre_coord_on_block(eng_cache_cti.TargetCoord); update_cmd_list_entry(eng_cache_cmd, CMD_SPY_SABOTAGE, eng_cache_cti, 0); for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); add_persons_command(t, eng_cache_cmd, 0); set_person_top_state(t); end end end,
  [41] = function(e, data) map_xz_to_world_coord2d(data[2], data[3], eng_cache_cti.TargetCoord); centre_coord_on_block(eng_cache_cti.TargetCoord); update_cmd_list_entry(eng_cache_cmd, CMD_SPY_BURN_WOOD, eng_cache_cti, 0); for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); add_persons_command(t, eng_cache_cmd, 0); set_person_top_state(t); end end end,
  [42] = function(e, data) end,
  [43] = function(e, data) end,
  [44] = function(e, data) end,
  [45] = function(e, data) end,
  [46] = function(e, data) end,
  [47] = function(e, data) end,
  [48] = function(e, data) end,
  [49] = function(e, data) end,
  [50] = function(e, data) end,
  [51] = function(e, data) end,
  [52] = function(e, data) end,
  [53] = function(e, data) end,
  [54] = function(e, data) end,
  [55] = function(e, data) end,
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
          ENGINE_FUNC_TABLE_EXECUTE[cmd.Type](Engine, cmd.Data);
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