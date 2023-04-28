MVMod().DarkFog = true; -- enforce.
MVMod().RegenFog = true; -- enforce.
FENEW.hideNewGame();
FENEW.hideTutorial();
Difficulty.Process(false);
Mods.Lock();

function OnScript(level)
  if (level == 1) then
    AddScript("Level1.lua");
  end
end

function OnFrameCredits()
  return false;
end