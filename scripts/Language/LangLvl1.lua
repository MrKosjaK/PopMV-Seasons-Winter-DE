local a = 
{
  StrDlgGeneralText1 = "In the beginning...",
  StrDlgGeneralText2 = "Somewhere in distant cold and harsh environment...",
  StrDlgGeneralText3 = "A group of people decided to go camping...",
  StrDlgGeneralText4 = "Some time later...",
  StrDlgStoryTellerText1 = "Alright folks... We're at the designated point, let's setup a temporary camp here.",
  StrDlgStoryTellerText2 = "Bring some wood piles for campfire to tell the stories, and some for watch tower.",
  StrDlgStoryTellerText3 = "Today i'll be reading you a story of a humble woman leading her tribe into a new venture...",
  StrDlgStoryTellerText4 = "Ahem... Chapter 1... Tiyao's search for forbidden knowledge has began somewhere in northean areas of Blue region...",
  StrDlgBravesText1 = "Roger that!",
};

function a.get_str(key)
  return a[key];
end

return a;