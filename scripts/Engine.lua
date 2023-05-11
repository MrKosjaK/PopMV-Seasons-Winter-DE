local Engine = 
{
  Cmds = {},
  Variables = {},
  ThingBuffers = {},
  CmdCurrIdx = 0,
  CmdCache =
  {
    [0] = {}, {}, {}, {}, {}, {}, {}, {}, {}
  },
  
  -- Cinematic
  Cinema =
  {
    Draw = false,
    TopR = TbRect.new(),
    BottomR = TbRect.new(),
    State = 0,
    Size = 0
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
        Size = 0,
        Finished = true
      },
      Style = BorderLayout.new(),
      StyleNum = 0
    }
  },
  
  IsPanelShown = true,
  IsExecuting = false,
  Turn = 0
};

EngineSave = {}; -- this is used for saving/loading

function e_load(slot)
  -- we want to copy EngineSave stuff into Engine
  LoadTable("EngineSave", slot);
  
  -- go over fields and stuff, basically just doing it vice versa
  Engine.IsPanelShown = EngineSave.IsPanelShown;
  Engine.Turn = EngineSave.Turn;
  Engine.IsExecuting = EngineSave.IsExecuting;
  
  -- command system
  for i,Cmd in ipairs(EngineSave.Cmds) do
    Engine.Cmds[i] = {};
    Engine.Cmds[i].Type = Cmd.Type;
    Engine.Cmds[i].Turn = Cmd.Turn;
    Engine.Cmds[i].Data = {};
    
    for j = 0, #Cmd.Data do
      Engine.Cmds[i].Data[j] = Cmd.Data[j];
    end
    
    Engine.Cmds[i].Executed = Cmd.Executed;
  end
  
  -- command cache
  -- remember that we're using index 0
  Engine.CmdCurrIdx = EngineSave.CmdCurrIdx;
  for i = 0, EngineSave.CmdCurrIdx - 1 do
    local CCmd = EngineSave.CmdCache[i + 1];
    if (#CCmd > 0) then
      Engine.CmdCache[i] = {CCmd[1], CCmd[2], CCmd[3]};
    end
  end
  
  -- variables
  for i,v in ipairs(EngineSave.Variables) do
    Engine.Variables[i] = v;
  end
  
  -- thing buffers
  -- here we need to get pointers to things
  for i,v in ipairs(EngineSave.ThingBuffers) do
    Engine.ThingBuffers[i] = {};
    
    if (#v > 0) then
      for j,t_num in ipairs(EngineSave.ThingBuffers[i]) do
        Engine.ThingBuffers[i][j] = valid_thing_idx_to_ptr(t_num);
      end
    end
  end
  
  -- cinema
  Engine.Cinema.Draw = EngineSave.Cinema.Draw;
  Engine.Cinema.Size = EngineSave.Cinema.Size;
  Engine.Cinema.State = EngineSave.Cinema.State;
  
  -- top rect
  Engine.Cinema.TopR.Left = EngineSave.Cinema.TopR[1];
  Engine.Cinema.TopR.Right = EngineSave.Cinema.TopR[2];
  Engine.Cinema.TopR.Top = EngineSave.Cinema.TopR[3];
  Engine.Cinema.TopR.Bottom = EngineSave.Cinema.TopR[4];
  
  -- bottom rect
  Engine.Cinema.BottomR.Left = EngineSave.Cinema.BottomR[1];
  Engine.Cinema.BottomR.Right = EngineSave.Cinema.BottomR[2];
  Engine.Cinema.BottomR.Top = EngineSave.Cinema.BottomR[3];
  Engine.Cinema.BottomR.Bottom = EngineSave.Cinema.BottomR[4];
  
  -- dialog
  for i,Msg in ipairs(EngineSave.Dialog.Queue) do
    Engine.Dialog.Queue[i] = {};
    Engine.Dialog.Queue[i].Text = Msg.Text;
    Engine.Dialog.Queue[i].Title = Msg.Title;
    Engine.Dialog.Queue[i].StyleNum = Msg.StyleNum;
    Engine.Dialog.Queue[i].DrawCount = Msg.DrawCount;
    Engine.Dialog.Queue[i].BankNum = Msg.BankNum;
    Engine.Dialog.Queue[i].SpriteNum = Msg.SpriteNum;
  end
  
  Engine.Dialog.Msg.Title = EngineSave.Dialog.Msg.Title;
  for i,Line in ipairs(EngineSave.Dialog.Msg.Lines) do
    Engine.Dialog.Msg.Lines[i] = {};
    Engine.Dialog.Msg.Lines[i].Text = Line.Text;
    Engine.Dialog.Msg.Lines[i].Width = Line.Width;
  end
  
  Engine.Dialog.DrawInfo.DrawCount = EngineSave.Dialog.DrawInfo.DrawCount;
  Engine.Dialog.DrawInfo.Bank = EngineSave.Dialog.DrawInfo.Bank;
  Engine.Dialog.DrawInfo.Sprite = EngineSave.Dialog.DrawInfo.Sprite;
  Engine.Dialog.DrawInfo.Draw = EngineSave.Dialog.DrawInfo.Draw;
  Engine.Dialog.DrawInfo.PosX = EngineSave.Dialog.DrawInfo.PosX;
  Engine.Dialog.DrawInfo.PosY = EngineSave.Dialog.DrawInfo.PosY;
  Engine.Dialog.DrawInfo.Width = EngineSave.Dialog.DrawInfo.Width;
  Engine.Dialog.DrawInfo.Height = EngineSave.Dialog.DrawInfo.Height;
  
  -- rectangles
  Engine.Dialog.DrawInfo.Area.Left = EngineSave.Dialog.DrawInfo.Area[1];
  Engine.Dialog.DrawInfo.Area.Right = EngineSave.Dialog.DrawInfo.Area[2];
  Engine.Dialog.DrawInfo.Area.Top = EngineSave.Dialog.DrawInfo.Area[3];
  Engine.Dialog.DrawInfo.Area.Bottom = EngineSave.Dialog.DrawInfo.Area[4];
  
  Engine.Dialog.DrawInfo.BoxM.Left = EngineSave.Dialog.DrawInfo.BoxM[1];
  Engine.Dialog.DrawInfo.BoxM.Right = EngineSave.Dialog.DrawInfo.BoxM[2];
  Engine.Dialog.DrawInfo.BoxM.Top = EngineSave.Dialog.DrawInfo.BoxM[3];
  Engine.Dialog.DrawInfo.BoxM.Bottom = EngineSave.Dialog.DrawInfo.BoxM[4];
  
  Engine.Dialog.DrawInfo.BoxI.Left = EngineSave.Dialog.DrawInfo.BoxI[1];
  Engine.Dialog.DrawInfo.BoxI.Right = EngineSave.Dialog.DrawInfo.BoxI[2];
  Engine.Dialog.DrawInfo.BoxI.Top = EngineSave.Dialog.DrawInfo.BoxI[3];
  Engine.Dialog.DrawInfo.BoxI.Bottom = EngineSave.Dialog.DrawInfo.BoxI[4];

  Engine.Dialog.DrawInfo.BoxT.Left = EngineSave.Dialog.DrawInfo.BoxT[1];
  Engine.Dialog.DrawInfo.BoxT.Right = EngineSave.Dialog.DrawInfo.BoxT[2];
  Engine.Dialog.DrawInfo.BoxT.Top = EngineSave.Dialog.DrawInfo.BoxT[3];
  Engine.Dialog.DrawInfo.BoxT.Bottom = EngineSave.Dialog.DrawInfo.BoxT[4];
  
  -- clipper
  Engine.Dialog.DrawInfo.Clipper.Clip.Left = EngineSave.Dialog.DrawInfo.Clipper.Clip[1];
  Engine.Dialog.DrawInfo.Clipper.Clip.Right = EngineSave.Dialog.DrawInfo.Clipper.Clip[2];
  Engine.Dialog.DrawInfo.Clipper.Clip.Top = EngineSave.Dialog.DrawInfo.Clipper.Clip[3];
  Engine.Dialog.DrawInfo.Clipper.Clip.Bottom = EngineSave.Dialog.DrawInfo.Clipper.Clip[4];
  
  Engine.Dialog.DrawInfo.Clipper.Line = EngineSave.Dialog.DrawInfo.Clipper.Line;
  Engine.Dialog.DrawInfo.Clipper.Size = EngineSave.Dialog.DrawInfo.Clipper.Size;
  Engine.Dialog.DrawInfo.Clipper.Finished = EngineSave.Dialog.DrawInfo.Clipper.Finished;
  
  -- style
  Engine.Dialog.DrawInfo.Style.TopLeft = EngineSave.Dialog.DrawInfo.Style[1];
  Engine.Dialog.DrawInfo.Style.TopRight = EngineSave.Dialog.DrawInfo.Style[2];
  Engine.Dialog.DrawInfo.Style.BottomLeft = EngineSave.Dialog.DrawInfo.Style[3];
  Engine.Dialog.DrawInfo.Style.BottomRight = EngineSave.Dialog.DrawInfo.Style[4];
  Engine.Dialog.DrawInfo.Style.Top = EngineSave.Dialog.DrawInfo.Style[5];
  Engine.Dialog.DrawInfo.Style.Bottom = EngineSave.Dialog.DrawInfo.Style[6];
  Engine.Dialog.DrawInfo.Style.Left = EngineSave.Dialog.DrawInfo.Style[7];
  Engine.Dialog.DrawInfo.Style.Right = EngineSave.Dialog.DrawInfo.Style[8];
  Engine.Dialog.DrawInfo.Style.Centre = EngineSave.Dialog.DrawInfo.Style[9];

  Engine.Dialog.DrawInfo.StyleNum = EngineSave.Dialog.DrawInfo.StyleNum;
  
  EngineSave = {}; -- flush
  Log("Engine successfully loaded!");
end

function e_save(slot)
  -- we want to compile Engine object into EngineSave
  -- first go over basic variables.
  
  EngineSave.IsPanelShown = Engine.IsPanelShown;
  EngineSave.Turn = Engine.Turn;
  EngineSave.IsExecuting = Engine.IsExecuting
  
  -- command system
  
  EngineSave.Cmds = {};
  for i,Cmd in ipairs(Engine.Cmds) do
    EngineSave.Cmds[i] = {};
    EngineSave.Cmds[i].Type = Cmd.Type;
    EngineSave.Cmds[i].Turn = Cmd.Turn;
    EngineSave.Cmds[i].Data = {};
    
    for j = 1, #Cmd.Data do
      EngineSave.Cmds[i].Data[j] = Cmd.Data[j];
    end
    
    EngineSave.Cmds[i].Executed = Cmd.Executed;
  end
  
  -- command cache
  
  EngineSave.CmdCurrIdx = Engine.CmdCurrIdx;
  EngineSave.CmdCache = {};
  for i = 0, Engine.CmdCurrIdx - 1 do
    local CCmd = Engine.CmdCache[i];
    if (#CCmd > 0) then
      EngineSave.CmdCache[i + 1] = {CCmd[1], CCmd[2], CCmd[3]};
    else
      EngineSave.CmdCache[i + 1] = {};
    end
  end
  
  -- variables 
  
  EngineSave.Variables = {};
  for i,v in ipairs(Engine.Variables) do
    EngineSave.Variables[i] = v;
  end
  
  -- thing buffers
  
  EngineSave.ThingBuffers = {};
  for i,v in ipairs(Engine.ThingBuffers) do
    EngineSave.ThingBuffers[i] = {};
    
    if (#v > 0) then
      for j,t_thing in ipairs(Engine.ThingBuffers[i]) do
        EngineSave.ThingBuffers[i][j] = t_thing.ThingNum; -- we're saving thing nums here since i'm using pointers which are random each time i believe?
      end
    end
  end
  
  -- cinema
  
  EngineSave.Cinema = {};
  EngineSave.Cinema.Draw = Engine.Cinema.Draw;
  EngineSave.Cinema.Size = Engine.Cinema.Size;
  EngineSave.Cinema.State = Engine.Cinema.State;
  EngineSave.Cinema.TopR =
  { 
    [1] = Engine.Cinema.TopR.Left,
    [2] = Engine.Cinema.TopR.Right,
    [3] = Engine.Cinema.TopR.Top,
    [4] = Engine.Cinema.TopR.Bottom
  }; -- this is just a table with 4 integers
  EngineSave.Cinema.BottomR =
  { 
    [1] = Engine.Cinema.BottomR.Left,
    [2] = Engine.Cinema.BottomR.Right,
    [3] = Engine.Cinema.BottomR.Top,
    [4] = Engine.Cinema.BottomR.Bottom
  }; -- this is just a table with 4 integers
  
  -- dialog
  EngineSave.Dialog = {};
  
  EngineSave.Dialog.Queue = {};
  for i,Msg in ipairs(Engine.Dialog.Queue) do
    EngineSave.Dialog.Queue[i] = {};
    EngineSave.Dialog.Queue[i].Text = Msg.Text;
    EngineSave.Dialog.Queue[i].Title = Msg.Title;
    EngineSave.Dialog.Queue[i].StyleNum = Msg.StyleNum;
    EngineSave.Dialog.Queue[i].DrawCount = Msg.DrawCount;
    EngineSave.Dialog.Queue[i].BankNum = Msg.BankNum;
    EngineSave.Dialog.Queue[i].SpriteNum = Msg.SpriteNum;
  end
  
  EngineSave.Dialog.Msg = { Title = Engine.Dialog.Msg.Title, Lines = {} };
  for i,Line in ipairs(Engine.Dialog.Msg.Lines) do
    EngineSave.Dialog.Msg.Lines[i] = {};
    EngineSave.Dialog.Msg.Lines[i].Text = Line.Text;
    EngineSave.Dialog.Msg.Lines[i].Width = Line.Width;
  end
  
  EngineSave.Dialog.DrawInfo = {};
  EngineSave.Dialog.DrawInfo.DrawCount = Engine.Dialog.DrawInfo.DrawCount;
  EngineSave.Dialog.DrawInfo.Bank = Engine.Dialog.DrawInfo.Bank;
  EngineSave.Dialog.DrawInfo.Sprite = Engine.Dialog.DrawInfo.Sprite;
  EngineSave.Dialog.DrawInfo.Draw = Engine.Dialog.DrawInfo.Draw;
  EngineSave.Dialog.DrawInfo.PosX = Engine.Dialog.DrawInfo.PosX;
  EngineSave.Dialog.DrawInfo.PosY = Engine.Dialog.DrawInfo.PosY;
  EngineSave.Dialog.DrawInfo.Width = Engine.Dialog.DrawInfo.Width;
  EngineSave.Dialog.DrawInfo.Height = Engine.Dialog.DrawInfo.Height;
  
  -- rectangles
  EngineSave.Dialog.DrawInfo.Area =
  {
    [1] = Engine.Dialog.DrawInfo.Area.Left,
    [2] = Engine.Dialog.DrawInfo.Area.Right,
    [3] = Engine.Dialog.DrawInfo.Area.Top,
    [4] = Engine.Dialog.DrawInfo.Area.Bottom
  };
  
  EngineSave.Dialog.DrawInfo.BoxM =
  {
    [1] = Engine.Dialog.DrawInfo.BoxM.Left,
    [2] = Engine.Dialog.DrawInfo.BoxM.Right,
    [3] = Engine.Dialog.DrawInfo.BoxM.Top,
    [4] = Engine.Dialog.DrawInfo.BoxM.Bottom
  };
  
  EngineSave.Dialog.DrawInfo.BoxI =
  {
    [1] = Engine.Dialog.DrawInfo.BoxI.Left,
    [2] = Engine.Dialog.DrawInfo.BoxI.Right,
    [3] = Engine.Dialog.DrawInfo.BoxI.Top,
    [4] = Engine.Dialog.DrawInfo.BoxI.Bottom
  };
  
  EngineSave.Dialog.DrawInfo.BoxT =
  {
    [1] = Engine.Dialog.DrawInfo.BoxT.Left,
    [2] = Engine.Dialog.DrawInfo.BoxT.Right,
    [3] = Engine.Dialog.DrawInfo.BoxT.Top,
    [4] = Engine.Dialog.DrawInfo.BoxT.Bottom
  };
  
  -- clipper
  EngineSave.Dialog.DrawInfo.Clipper = {};
  
  EngineSave.Dialog.DrawInfo.Clipper.Clip =
  {
    [1] = Engine.Dialog.DrawInfo.Clipper.Clip.Left,
    [2] = Engine.Dialog.DrawInfo.Clipper.Clip.Right,
    [3] = Engine.Dialog.DrawInfo.Clipper.Clip.Top,
    [4] = Engine.Dialog.DrawInfo.Clipper.Clip.Bottom
  };
  
  EngineSave.Dialog.DrawInfo.Clipper.Line = Engine.Dialog.DrawInfo.Clipper.Line;
  EngineSave.Dialog.DrawInfo.Clipper.Size = Engine.Dialog.DrawInfo.Clipper.Size;
  EngineSave.Dialog.DrawInfo.Clipper.Finished = Engine.Dialog.DrawInfo.Clipper.Finished;
  
  -- style
  EngineSave.Dialog.DrawInfo.Style =
  {
    [1] = Engine.Dialog.DrawInfo.Style.TopLeft,
    [2] = Engine.Dialog.DrawInfo.Style.TopRight,
    [3] = Engine.Dialog.DrawInfo.Style.BottomLeft,
    [4] = Engine.Dialog.DrawInfo.Style.BottomRight,
    [5] = Engine.Dialog.DrawInfo.Style.Top,
    [6] = Engine.Dialog.DrawInfo.Style.Bottom,
    [7] = Engine.Dialog.DrawInfo.Style.Left,
    [8] = Engine.Dialog.DrawInfo.Style.Right,
    [9] = Engine.Dialog.DrawInfo.Style.Centre
  };
  
  EngineSave.Dialog.DrawInfo.StyleNum = Engine.Dialog.DrawInfo.StyleNum;
  
  -- now save it.
  SaveTable("EngineSave", slot);
  EngineSave = {}; -- flush
  Log("Engine successfully saved!");
end

-- cached stuff for engine
local e_cache_map = MapPosXZ.new();
local e_cache_c2d = Coord2D.new();
local e_cache_c3d = Coord3D.new();
local e_cache_cti = CmdTargetInfo.new();
local e_cache_cmd = {}; -- fucking stupid ass old 1.01 i hate you so fucking much.
local e_cache_t = nil;
local e_cache_me = nil;

local function construct_command_buffer()
  Timing.start("CommandBufferConstruct");
  e_cache_cmd = {};
  
  -- clear targetinfo
  e_cache_cti.TargetCoord.Xpos = 0;
  e_cache_cti.TargetCoord.Zpos = 0;
  e_cache_cti.TMIdxs.TargetIdx = 0;
  e_cache_cti.TargetIdx = 0;
  e_cache_cti.TMIdxs.MapIdx = 0;
  e_cache_cti.TIdxSize.MapIdx = 0;
  e_cache_cti.TIdxSize.CellsX = 0;
  e_cache_cti.TIdxSize.CellsZ = 0;
  
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
        
        if (data[1] == CMD_GET_INTO_VEHICLE) then
          e_cache_map.XZ.X = data[2];
          e_cache_map.XZ.Z = data[3];
          
          e_cache_me = MAP_ELEM_IDX_2_PTR(e_cache_map.Pos);
          ProcessMapWho(e_cache_me, function(t)
            if (t.Type == T_VEHICLE) then
              e_cache_cti.TargetIdx = t.ThingNum;
              e_cache_cti.TMIdxs.MapIdx = e_cache_map.Pos;
              return false;
            end
            
            return true;
          end);
        end
        
        if (data[1] == CMD_HEAD_PRAY) then
          e_cache_map.XZ.X = data[2];
          e_cache_map.XZ.Z = data[3];
          
          e_cache_me = MAP_ELEM_IDX_2_PTR(e_cache_map.Pos);
          ProcessMapWho(e_cache_me, function(t)
            if (t.Type == T_SCENERY) then
              if (t.Model == M_SCENERY_HEAD) then
                e_cache_cti.TargetIdx = t.ThingNum;
                return false;
              end
            end
            
            return true;
          end);
        end
        
        if (data[1] == CMD_GO_IN_BLDG) then
          e_cache_map.XZ.X = data[2];
          e_cache_map.XZ.Z = data[3];
          
          e_cache_me = MAP_ELEM_IDX_2_PTR(e_cache_map.Pos);
          e_cache_t = valid_thing_idx_to_ptr(e_cache_me.ShapeOrBldgIdx)
          if (e_cache_t ~= nil) then
            if (e_cache_t.Type == T_BUILDING) then
              e_cache_cti.TargetIdx = e_cache_me.ShapeOrBldgIdx;
            end
          end
        end
        
        if (data[1] == CMD_DISMANTLE_BUILDING or data[1] == CMD_BUILD_BUILDING) then
          e_cache_map.XZ.X = data[2];
          e_cache_map.XZ.Z = data[3];
          
          e_cache_me = MAP_ELEM_IDX_2_PTR(e_cache_map.Pos);
          e_cache_t = valid_thing_idx_to_ptr(e_cache_me.ShapeOrBldgIdx)
          if (e_cache_t ~= nil) then
            e_cache_cti.TMIdxs.TargetIdx = e_cache_me.ShapeOrBldgIdx;
          end
          
          e_cache_cti.TMIdxs.MapIdx = e_cache_map.Pos;
        end
        
        if (data[1] == CMD_ATTACK_AREA_2 or data[1] == CMD_GUARD_AREA) then
          e_cache_map.XZ.X = data[2];
          e_cache_map.XZ.Z = data[3];
          e_cache_cti.TIdxSize.CellsX = 4;
          e_cache_cti.TIdxSize.CellsZ = 4;
          e_cache_cti.TIdxSize.MapIdx = e_cache_map.Pos; 
        end
        
        if (data[1] == CMD_GOTO_POINT or data[1] == CMD_SPY_SABOTAGE or data[1] == CMD_RELIGIOUS_PREACH or
            data[1] == CMD_GET_WOOD or data[1] == CMD_MOVE_REINCARN_SITE or data[1] == CMD_DROP_WOOD or
            data[1] == CMD_GET_OUT_OF_VEHICLE or data[1] == CMD_GUARD_AREA_PATROL) then
          e_cache_cti.TargetCoord.Xpos = bit32.band(bit32.lshift(data[2], 8), 0xfe00) + 256;
          e_cache_cti.TargetCoord.Zpos = bit32.band(bit32.lshift(data[3], 8), 0xfe00) + 256;
        end
        
        --Log(string.format("%i", i));
        update_cmd_list_entry(e_cache_cmd[#e_cache_cmd], data[1], e_cache_cti, flags);
      end
    end
  end
  
  Timing.stop("CommandBufferConstruct");
end



-- cinematicstuff

local function cinema_set_size(_size)
  local c = Engine.Cinema;
  c.Size = _size or 0;
end

local function cinema_start_fade(_instant)
  local c = Engine.Cinema;
  
  -- we basically set size back to 0, and slowly retract rectangles.
  c.Size = 0;
  c.State = 0;
  -- that's about it lol
  
  if (_instant) then
    -- Top rectangle
    c.TopR.Top = 0;
    c.TopR.Bottom = 0;
    c.TopR.Left = 0;
    c.TopR.Right = gns.ScreenW;
      
    -- Bottom rectangle
    c.BottomR.Top = gns.ScreenH;
    c.BottomR.Bottom = gns.ScreenH;
    c.BottomR.Left = 0;
    c.BottomR.Right = gns.ScreenW;
  end
end

local function cinema_start_raise(_instant)
  local c = Engine.Cinema;
  
  c.State = 1;
  
  if (c.Size > 0) then
    c.Draw = true;
    
    if (_instant) then
      -- Top rectangle
      c.TopR.Top = 0;
      c.TopR.Bottom = c.Size;
      c.TopR.Left = 0;
      c.TopR.Right = gns.ScreenW;
      
      -- Bottom rectangle
      c.BottomR.Top = gns.ScreenH - c.Size;
      c.BottomR.Bottom = gns.ScreenH;
      c.BottomR.Left = 0;
      c.BottomR.Right = gns.ScreenW;
    else
      -- Top rectangle
      c.TopR.Top = 0;
      c.TopR.Bottom = 0;
      c.TopR.Left = 0;
      c.TopR.Right = gns.ScreenW;
      
      -- Bottom rectangle
      c.BottomR.Top = gns.ScreenH;
      c.BottomR.Bottom = gns.ScreenH;
      c.BottomR.Left = 0;
      c.BottomR.Right = gns.ScreenW;
    end
  end
end

local function cinema_render()
  local c = Engine.Cinema;
  
  if (c.Draw) then
    if (is_game_active()) then
      if (c.State == 1) then
        -- now check if rectangles need to raise or fade
        if (c.TopR.Bottom <= c.Size) then
          c.TopR.Bottom = math.min(c.TopR.Bottom + 1, c.Size);
        else
          c.TopR.Bottom = math.max(c.TopR.Bottom - 1, 0);
        end
        
        -- now for the other one
        if ((gns.ScreenH - c.BottomR.Top) <= c.Size) then
          c.BottomR.Top = math.max(c.BottomR.Top - 1, (gns.ScreenH - c.Size));
        else
          c.BottomR.Top = math.min(c.BottomR.Top + 1, gns.ScreenH);
        end
      elseif (c.State == 0) then
        -- now check if we need to stop drawing rectangles.
        c.BottomR.Top = math.min(c.BottomR.Top + 1, gns.ScreenH);
        c.TopR.Bottom = math.max(c.TopR.Bottom - 1, 0);
        
        if (c.TopR.Bottom == 0 and c.BottomR.Top == gns.ScreenH) then
          c.Draw = false;
        end
      end
    end
    
    LbDraw_Rectangle(c.TopR, 144);
    LbDraw_Rectangle(c.BottomR, 144);
  end
end


-- dialogstuff

local DIALOG_STYLE_TABLE =
{
  [0] = {0, 0, 0, 0, 0, 0, 0, 0, 0},
  {1450, 1451, 1452, 1453, 1454 + math.random(0, 1), 1456 + math.random(0, 1), 1458 + math.random(0, 1), 1460 + math.random(0, 1), 1462 + math.random(0, 2)},  -- standard default
  {879, 880, 881, 882, 883, 884, 885, 886, 887}, -- blue default
  {906, 907, 908, 909, 910, 911, 912, 913, 914}, -- red default
  {933, 934, 935, 936, 937, 938, 939, 940, 941}, -- yellow default
  {960, 961, 962, 963, 964, 965, 966, 967, 968}, -- green default
  {794, 795, 796, 797, 798, 799, 800, 801, 802}, -- yellow 1
  {821, 822, 823, 824, 825, 826, 827, 828, 829}, -- yellow 2
  {996, 997, 998, 999, 1000, 1001, 1002, 1003, 1004}, -- yellow 3
  {510, 511, 512, 513, 514, 515, 516, 517, 518}, -- grey
  {1615, 1616, 1617, 1618, 1619, 1620, 1621, 1622, 1623}, -- cyan default
  {1642, 1643, 1644, 1645, 1646, 1647, 1648, 1649, 1670}, -- purple default
  {1669, 1670, 1671, 1672, 1673, 1674, 1675, 1676, 1677}, -- black default
  {1696, 1697, 1698, 1699, 1700, 1701, 1702, 1703, 1704} -- orange default
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
  
  d.StyleNum = _style_num;
  if (_style_num == 0) then
    do return end;
  end
  
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
  d.Clipper.Finished = false;
end

local function dialog_advance_clipper()
  local d = dialog_get_drawinfo_ptr();
  local m = dialog_get_msg_ptr();
  
  d.Clipper.Clip.Left = d.Area.Left;
  d.Clipper.Clip.Right = d.Clipper.Clip.Left + d.Clipper.Size;
  d.Clipper.Clip.Top = d.Area.Top + (CharHeight('A') * d.Clipper.Line);
  d.Clipper.Clip.Bottom = d.Clipper.Clip.Top + CharHeight('A');
  
  if (d.Clipper.Line < #m.Lines) then
    d.Clipper.Size = d.Clipper.Size + bit32.rshift(CharWidth('A'), 1);
    
    if (d.Clipper.Size >= m.Lines[d.Clipper.Line + 1].Width) then
      d.Clipper.Size = 0;
      d.Clipper.Line = d.Clipper.Line + 1;
    end
  elseif (not d.Clipper.Finished) then
    d.Clipper.Finished = true;
  end
end

local function dialog_is_clipper_finished()
  return Engine.Dialog.DrawInfo.Clipper.Finished;
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
    d.BoxT.Left = d.Area.Left + CharWidth('A') - 8;
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
  Timing.start("Dlg_Format");
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
    
    line_width = line_width + CharWidth(curr_char);
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
  
  -- figure widest line
  local d_width = 120;
  for i,line in ipairs(d.Lines) do
    d_width = math.max(d_width, line.Width);
  end
  
  dialog_recalc_draw_area(nil, nil, d_width, #d.Lines * CharHeight('A'));
  
  Timing.stop("Dlg_Format");
  --Log(string.format("III - Time elapsed: %.04f", Timer.Stop()));
end

local function dialog_queue_msg(_text, _title, _bank, _sprite, _style_num, _draw_count)
  local msg =
  {
    Text = _text,
    Title = _title or nil,
    StyleNum = _style_num or 0,
    DrawCount = _draw_count or 1,
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
      if (d.StyleNum > 0) then DrawStretchyButtonBox(d.BoxT, d.Style); end
      PopSetFont(P3_LARGE_FONT, 0);
      DrawTextStr(d.Area.Left + CharWidth('A'), d.Area.Top - CharHeight('A') - 7, m.Title);
      PopSetFont(P3_SMALL_FONT_NORMAL, 0);
    end
    
    if (d.StyleNum > 0) then DrawStretchyButtonBox(d.BoxM, d.Style); end
    
    if (d.Sprite > -1) then
      if (d.StyleNum > 0) then DrawStretchyButtonBox(d.BoxI, d.Style); end
      -- HFX sprite.
      if (d.Bank == 0) then
        LbDraw_ScaledSprite(d.BoxI.Left + 4, d.BoxI.Top + 4, get_hfx_sprite(d.Sprite), (d.BoxI.Right - d.BoxI.Left) - 8, (d.BoxI.Bottom - d.BoxI.Top) - 8);
      elseif (d.Bank == 1) then -- HSPR BANK 0
        LbDraw_ScaledSprite(d.BoxI.Left + 4, d.BoxI.Top + 4, get_hspr_sprite(0, d.Sprite), (d.BoxI.Right - d.BoxI.Left) - 8, (d.BoxI.Bottom - d.BoxI.Top) - 8);
      end
    end
    
    for i,k in ipairs(m.Lines) do
      if (d.Clipper.Line > (i-1)) then
        DrawTextStr(d.Area.Left, d.Area.Top + ((i-1)*CharHeight(32)), k.Text);
      elseif (d.Clipper.Line == (i-1)) then
        LbDraw_SetClipRect(d.Clipper.Clip);
        DrawTextStr(d.Area.Left, d.Area.Top + ((i-1)*CharHeight(32)), k.Text);
        LbDraw_ReleaseClipRect();
      end
    end
    
    dialog_advance_clipper();
    
    if (dialog_is_clipper_finished()) then
      d.DrawCount = d.DrawCount - 1;
    end
  end
  
  --Log(string.format("Frame ms: %.04f", Timer.Stop()));
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
E_CMD_QUEUE_MSG = 17; -- TEXT_STR, TITLE_STR, BANK_NUM, SPRITE_NUM, STYLE_NUM, POST_DRAW_COUNT
E_CMD_CINEMA_SET_SIZE = 18; -- SIZE IN PIXELS
E_CMD_CINEMA_RAISE = 19; -- INSTANT?
E_CMD_CINEMA_FADE = 20; -- INSTANT?
E_CMD_MUSIC_PLAY = 21; -- STRING_NAME, LOOPED
E_CMD_MUSIC_STOP = 22; -- NO PARAMS
E_CMD_SET_CAMERA_PARAMS = 23; -- X, Z, ANGLE
E_CMD_TRIGGER_ACTIVATE = 24; -- X, Z
E_CMD_PERS_NEW_STATE = 25; -- INDEX, STATE
E_CMD_TRIBE_SET_SKIN = 26; -- BASE_PN, NEW_PN
E_CMD_FOW_COVER = 27; -- X, Z, RADIUS, DARK?
E_CMD_FOW_UNCOVER = 28; -- X, Z, RADIUS, DURATION (-1 == PERMANENT)
E_CMD_TRIBE_SET_BETA = 29; -- PN, BETA?


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
  [7] = function(e, data) e_cache_map.XZ.X = data[6]; e_cache_map.XZ.Z = data[7]; local count = data[2]; ProcessMap(SQUARE, 0, 0, data[8], e_cache_map.Pos, function(me) ProcessMapWho(me, function(t) if (t.Type == data[3] or data[3] == -1) then if (t.Model == data[4] or data[4] == -1) then if (t.Owner == data[5] or data[5] == -1) then e.ThingBuffers[data[1]][#e.ThingBuffers[data[1]] + 1] = t; count = count - 1 if (count > 0) then return true; else return false; end end end end return true; end); if (count > 0) then return true; else return false; end end); end,
  [8] = function(e, data) for i = 1, data[2] do local t = create_thing(data[3], data[4], data[5], data[6], data[7]); if (data[1] ~= -1) then e.ThingBuffers[data[1]][#e.ThingBuffers[data[1]] + 1] = t; end end end,
  [9] = function(e, data) e_cache_map.XZ.X = data[5]; e_cache_map.XZ.Z = data[6]; local count = data[1]; ProcessMap(SQUARE, 0, 0, data[7], e_cache_map.Pos, function(me) ProcessMapWho(me, function(t) if (t.Type == data[2] or data[2] == -1) then if (t.Model == data[3] or data[3] == -1) then if (t.Owner == data[4] or data[4] == -1) then delete_thing_type(t); count = count - 1 if (count > 0) then return true; else return false; end end end end return true; end); if (count > 0) then return true; else return false; end end); end,
  [10] = function(e, data) e_cache_map.XZ.X = data[4]; e_cache_map.XZ.Z = data[5]; process_shape_map_elements(e_cache_map.Pos, data[1], data[3], data[2], SHME_MODE_SET_PERM); end,
  [11] = function(e, data) e_cache_map.XZ.X = data[2]; e_cache_map.XZ.Z = data[3]; process_shape_map_elements(e_cache_map.Pos, 0, 0, data[1], SHME_MODE_REMOVE_PERM); end,
  [12] = function(e, data) set_players_allied(data[1], data[2]); end,
  [13] = function(e, data) set_players_enemies(data[1], data[2]); end,
  [14] = function(e, data) for i = 0,7 do e.CmdCache[i] = {}; end e.CmdCurrIdx = 0; end,
  [15] = function(e, data) e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[1]; e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[2]; e.CmdCache[e.CmdCurrIdx][#e.CmdCache[e.CmdCurrIdx] + 1] = data[3]; e.CmdCurrIdx = e.CmdCurrIdx + 1; end,
  [16] = function(e, data) construct_command_buffer(); local num_cmds = Engine.CmdCurrIdx - 1; for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then remove_all_persons_commands(t); t.Flags = bit32.bor(t.Flags, TF_RESET_STATE); for j = 0, num_cmds do add_persons_command(t, e_cache_cmd[j + 1], j); end end end end,
  [17] = function(e, data) dialog_queue_msg(data[1], data[2], data[3], data[4], data[5], data[6]); end,
  [18] = function(e, data) cinema_set_size(data[1]); end,
  [19] = function(e, data) cinema_start_raise(data[1]); end,
  [20] = function(e, data) cinema_start_fade(data[1]); end,
  [21] = function(e, data) Music.Play(data[1], data[2]); end,
  [22] = function(e, data) Music.Stop(); end,
  [23] = function(e, data) e_cache_map.XZ.X = data[1]; e_cache_map.XZ.Z = data[2]; map_idx_to_world_coord3d(e_cache_map.Pos, e_cache_c3d); Camera.setCoords(e_cache_c3d); Camera.setAngle(data[3]); end,
  [24] = function(e, data) e_cache_map.XZ.X = data[1]; e_cache_map.XZ.Z = data[2]; trigger_trigger_thing_at_map_pos(e_cache_map.Pos); end,
  [25] = function(e, data) for i,t in ipairs(e.ThingBuffers[data[1]]) do if (t.Type == T_PERSON) then set_person_new_state(t, data[2]); end end end,
  [26] = function(e, data) Skin(data[1], data[2]); end,
  [27] = function(e, data) e_cache_map.XZ.X = data[1]; e_cache_map.XZ.Z = data[2]; map_idx_to_world_coord3d(e_cache_map.Pos, e_cache_c3d); FoW.Cover(e_cache_c3d, data[3], data[4]); end,
  [28] = function(e, data) e_cache_map.XZ.X = data[1]; e_cache_map.XZ.Z = data[2]; map_idx_to_world_coord3d(e_cache_map.Pos, e_cache_c3d); FoW.Uncover(e_cache_c3d, data[4], data[3]); end,
  [29] = function(e, data) Mods.setBetaTribe(data[1], data[2]); Mods.setBadgeBeta(data[1], data[2]); end,
  [30] = function(e, data) end,
  [31] = function(e, data) end,
  [32] = function(e, data) end,
};


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
  toggle_panel(0);
  Engine.IsPanelShown = true;
end

function e_hide_panel()
  toggle_panel(1);
  Engine.IsPanelShown = false;
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
  Timing.start("Engine_Process");
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
  
  Timing.stop("Engine_Process");
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

function e_is_ready()
  return (not Engine.IsExecuting);
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

function e_thing_buffer_to_table(_idx, _tabl)
  
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
    --e_toggle_pause();
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
  
  cinema_render();
  
  if (is_game_active()) then
    dialog_render_frame();
  end
  
  local y = 0;
  DrawTextStr(gui_width, y, "=====MISC STUFF=====");
  y = y + CharHeight('A');
  DrawTextStr(gui_width, y, string.format("Camera Angle: %i", Camera.getAngle()));
  y = y + CharHeight('A');
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
  DrawTextStr(gui_width, y, string.format("Panel Shown: %s", Engine.IsPanelShown));
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
  y = y + CharHeight('A');
  
  DrawTextStr(gui_width, y, "=====CINEMA INFO=====");
  y = y + CharHeight('A');
  
  local c = Engine.Cinema;
  
  DrawTextStr(gui_width, y, string.format("Size: %i", c.Size));
  y = y + CharHeight('A');
  DrawTextStr(gui_width, y, string.format("State: %i", c.State));
  y = y + CharHeight('A');
  DrawTextStr(gui_width, y, string.format("Draw: %s", c.Draw));
  y = y + CharHeight('A');
end