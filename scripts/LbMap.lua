local c_me = nil;
local c_xz = MapPosXZ.new();
local c_c3d = Coord3D.new();

function xz_to_c3d(_x, _z)
  c_xz.XZ.X = _x;
  c_xz.XZ.Z = _z;
  map_idx_to_world_coord3d(c_xz.Pos, c_c3d);
  return c_c3d;
end

function count_things_at_map_xz(_type, _model, _owner, _x, _z)
  local count = 0;
  c_xz.XZ.X = _x;
  c_xz.XZ.Z = _z;
  c_me = MAP_ELEM_IDX_2_PTR(c_xz.Pos);
  ProcessMapWho(c_me, function(t)
    if (t.Type == _type or _type == -1) then
      if (t.Model == _model or _model == -1) then
        if (t.Owner == _owner or _owner == -1) then
          count = count + 1;
          return true;
        end
      end
    end
    return true;
  end);
  
  return count;
end

function does_map_xz_contain_a_thing(_type, _model, _owner, _x, _z)
  local result = false;
  c_xz.XZ.X = _x;
  c_xz.XZ.Z = _z;
  c_me = MAP_ELEM_IDX_2_PTR(c_xz.Pos);
  ProcessMapWho(c_me, function(t)
    if (t.Type == _type or _type == -1) then
      if (t.Model == _model or _model == -1) then
        if (t.Owner == _owner or _owner == -1) then
          result = true;
          return false;
        end
      end
    end
    return true;
  end);
  
  return result;
end