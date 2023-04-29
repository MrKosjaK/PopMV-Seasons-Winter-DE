local a = 
{
  StrDlgGeneralText1 = "In the beginning...",
  StrDlgGeneralText2 = "Somewhere in distant cold and harsh environment...",
  StrDlgGeneralText3 = "A group of people decided to go camping...",
  StrDlgStoryTellerText1 = "Alright folks... We're at the designated point, let's setup a temporary camp here!",
};

function a.get_str(key)
  return a[key];
end

return a;