local StrTable =
{
  ["STR_DIALOG_TEXT_1"] = "Hello, Traveler! Isn't it a beautiful day to murder some enemy tribes? Get some action going on.",
  ["STR_DIALOG_TEXT_2"] = "What are you wainting for?",
}

function get_text_str(_key)
  return StrTable[_key];
end