local g = gnsi();
local a = 
{
  _timers = {};
};

function a.start(_key)
  a._timers[_key] = 0.0;
  Timer.Start();
end

function a.stop(_key)
  if (a._timers[_key] ~= nil) then
    a._timers[_key] = Timer.Stop();
  end
end

function a.render_all()
  --Log("" .. #Timing._timers);
  local y = 0;
  local x = g.ScreenW;
  local t = "";
  for k,v in pairs(a._timers) do
    t = string.format("%s : %.03fms", k, v);
    DrawTextStr(x - string_width(t), y, t);
    y = y + CharHeight('A');
  end
end

return a;
