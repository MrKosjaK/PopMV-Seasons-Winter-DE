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
  StrDlgBravesText2 = "As You wish, almighty Tiyao!",
  StrDlgTiyaoText1 = "We're getting closer to our target. Although, I'm more than sure Ikani or Chumara are going to get in our way.",
  StrDlgTiyaoText2 = "It's a good idea to prepare first before we strike our enemy.",
  StrDlgTiyaoText3 = "Get to work my followers! This is your time to shine! We'll show them what we made of.",
};

function a.get_str(key)
  return a[key];
end

return a;