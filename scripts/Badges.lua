Badges =
{
  Items = {},
  DrawInfo =
  {
    Menu = 
    {
      Draw = false,
      Area = TbRect.new(),
      CurrDescription = {}, -- just lines without any tag formatting and such.
      CurrTitle = nil,
      IProgressCurr = 0,
      IProgressMax = 0
    },
    Completion =
    {
      Draw = false,
      DrawCount = 0,
      Area = TbRect.new(),
      Text = nil
    }
  }
}

-- we'll be loading achievements info from files
function b_load_data_info(filename)
  --local f = io.open(filename, "r");
  
  --Log(f:read("*a"));
  
  --IniReader.SetPath("..\\Achievements\\INI_TEST.ini");
  
  --IniWriter.WriteInteger("General", "TestKey", 40);
  
  --f:close();
end

-- loads achievement progression
function b_load_progression()

end

-- this one also saves global achievements
function b_save_progression()

end

-- increments achievement progression by 1
function b_increment_progression(achievement_key)

end

-- sets achievement progression by specified value
function b_set_progression(achievement_key, value)

end

-- check if specified achievement is completed
function b_is_complete(achievement_key)

end

-- initializes GUI menu, sorts all items and such
function b_init_menu()

end

-- render menu.
function b_render_menu()

end

-- handle key
function b_toggle_menu()

end