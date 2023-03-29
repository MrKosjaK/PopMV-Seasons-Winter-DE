require(get_script_dir() .. "Common");

e_allocate_thing_buffers(2);

function _OnRegenerate(level)
  --Engine:queue_command(ENGINE_CMD_PLACE_BLDG_SHAPE, 12, M_BUILDING_DRUM_TOWER, TRIBE_BLUE, G_RANDOM(4), 112, 118);
  e_queue_command(E_CMD_CLEAR_COMMAND_CACHE, 0);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 110, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 104, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 100, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 96, 118);
  e_queue_command(E_CMD_SET_NEXT_COMMAND, 1, CMD_GOTO_POINT, 90, 118);
  e_queue_command(E_CMD_SPAWN_THINGS, 2, 1, 12, T_PERSON, M_PERSON_BRAVE, TRIBE_BLUE, 122, 118);
  e_queue_command(E_CMD_DISPATCH_COMMANDS, 12, 1);
  
  e_start();
end

function _OnTurn(turn)
  --Engine:process_execution();
  if (turn == 1) then
    dialog_queue_msg("The world is one of the smallest worlds in existence and consists of three islands. The player gets the largest island, which is also the southern island. This island contains one Stone Head, which has unlimited uses of Landbridge, as well as two Small Huts. The middle island is the second largest of the three and has another Stone Head, this time containing four uses of Lightning. These can be used to quickly end the level if the player chooses to. Also, the Vault of Knowledge containing the Warrior Training Hut is guarded by a lone Brave. Finally, the northern island contains the small Dakini settlement of one Large Hut and a Warrior Training Hut.", 1, 360);
    dialog_queue_msg("The level consists of one large island with the player on the east side and the Matak on the west side. There is a hill separating the two sides of the island with an entrance on both sides, with a small lake in the centre. It is possible to reach the top of the hill from the Matak side. There is also a small patch of land off to the side of the starting settlement with a Stone Head containing the Tornado spell, which has three uses. The Totem Pole in the small valley between the two tribes will activate a Landbridge so the player can access the Stone Head. The Vault of Knowledge is halfway in the Matak settlement and is slightly guarded. The Matak begin with their entire settlement complete, bar the Shaman's Guard Tower. Blue tribe begins with one empty Large Hut.", 1, 480);
    dialog_queue_msg("Pressure Point is identicle to the Single Player level, Middle Ground. However most players do not worship the Stone Head which grants you Armageddon unlike the computer players do in Single Player. This is a level which goes in depth on defending with towers. You each start with a good shaped, bunky base with many wildies spread over the terrain.", 1, 150);
    dialog_queue_msg("Linked isles is a three player map that's very similar to the single player level Building Bridges. It is found in the Map pack 'The Beginning'.", 1, 150);
    dialog_queue_msg("This map is basicly the same as two crabs just with three crabs.", 1, 150);
    dialog_queue_msg("Face Off is a commonly played map as games can end up short or long. The level focuses on a high hill which is the only path to other bases unless landbridge is used.", 1, 150);
    dialog_queue_msg("This is a common map played in multiplayer and is known for the lack of land there is on the map. Tree farming is popular on this level, since you have limited trees.", 1, 150);
    dialog_queue_msg("The Journey Begins is the first level featured in the single player campaign Populous: The Beginning and its demo version.", 1, 200);
  end
end

