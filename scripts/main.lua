MVMod().DarkFog = true; -- enforce.
MVMod().RegenFog = true; -- enforce.
FENEW.hideNewGame();
FENEW.hideTutorial();
FoW.UncoverReincSite(false);
Difficulty.Process(false);
Mods.Lock();

function OnScript(level)
  AddScript(string.format("Level%i.lua", level));
end

function OnFrameCredits()
  return false;
end