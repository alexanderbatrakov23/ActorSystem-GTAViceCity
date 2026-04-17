#include <a_vicemp>
#include <keysdefine>
#include <custommenu>

#define MAX_PLAYER_ACTORS 30

#define ACTOR_MOVE_SPEED 0.1
#define ACTOR_ROTATE_SPEED 2.0

#define COLOR_GREEN 0x00FF00FF
#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_BLUE 0x0000FFFF
#define COLOR_ORANGE 0xFF9900FF
#define COLOR_PURPLE 0xC2A2DAFF

enum actorInfo
{
    bool:actorActive,
    actorId,
    Float:actorX,
    Float:actorY,
    Float:actorZ,
    Float:actorA,
    actorSkin,
    actorName[32],
    actorMessage[128]
}

new PlayerActors[MAX_PLAYERS][MAX_PLAYER_ACTORS][actorInfo];
new CurrentActor[MAX_PLAYERS];
new ActorMenuState[MAX_PLAYERS];
new ActorMenuPage[MAX_PLAYERS];
new EditingActorMode[MAX_PLAYERS];
new Text3D:ActorLabel[MAX_PLAYERS][MAX_PLAYER_ACTORS];

new ActorSkins[] = {
    5007, 5008, 5009, 5010, 5011, 5012, 5013, 5014, 5015, 5016,
    5017, 5018, 5019, 5020, 5021, 5022, 5023, 5024, 5025, 5026,
    5027, 5028, 5029, 5030, 5031, 5032, 5033, 5034, 5035, 5036,
    5037, 5038, 5039, 5040, 5041, 5042, 5043, 5044, 5045, 5046,
    5047, 5048, 5049, 5050, 5051, 5052, 5053, 5054, 5055, 5056,
    5057, 5058, 5059, 5060, 5061, 5062, 5063, 5064, 5065, 5066,
    5067, 5068, 5069, 5070, 5071, 5072, 5073, 5074, 5075, 5076,
    5077, 5078, 5079, 5080, 5081, 5082, 5083, 5084, 5085, 5086,
    5087, 5088, 5089, 5090, 5091, 5092, 5093, 5094, 5095, 5096,
    5097, 5098, 5099, 5100, 5101, 5102, 5103, 5104, 5105, 5106,
    5107, 5108, 5109, 5110, 5111, 5112, 5113, 5114, 5115, 5116,
    5117, 5118, 5119, 5120, 5121, 5122, 5123, 5124, 5125, 5126,
    5127, 5128, 5129, 5130, 5131, 5132, 5133, 5134, 5135, 5136,
    5137, 5138, 5139, 5140, 5141, 5142, 5143, 5144, 5145, 5146,
    5147, 5148, 5149, 5150, 5151, 5152, 5153, 5154, 5155, 5156,
    5157, 5158, 5159, 5160, 5161, 5162, 5163, 5164, 5165, 5166,
    5167, 5168, 5169, 5170, 5171, 5172, 5173, 5174, 5175, 5176,
    5177, 5178, 5179, 5180, 5181, 5182, 5183, 5184, 5185, 5186,
    5187, 5188, 5189, 5190, 5191, 5192, 5193, 5194, 5195, 5196,
    5197, 5198, 5199, 5200, 5201, 5202, 5203, 5204, 5205, 5206,
    5207, 5208, 5209, 5210, 5211, 5212, 5213, 5214, 5215, 5216,
    5217, 5218, 5219, 5220, 5221, 5222, 5223, 5224, 5225, 5226,
    5227, 5228, 5229, 5230, 5231, 5232, 5233, 5234, 5235, 5236,
    5237, 5238, 5239, 5240, 5241, 5242, 5243, 5244, 5245, 5246,
    5247, 5248, 5249, 5250, 5251, 5252, 5253, 5254, 5255, 5256,
    5257, 5258, 5259, 5260, 5261, 5262, 5263, 5264, 5265, 5266,
    5267, 5268, 5269, 5270, 5271, 5272, 5273, 5274, 5275, 5276,
    5277, 5278, 5279, 5280, 5281, 5282, 5283, 5284, 5285, 5286,
    5287, 5288, 5289, 5290, 5291, 5292, 5293, 5294, 5295, 5296,
    5297, 5298, 5299, 5300, 5301, 5302, 5303, 5304, 5305, 5306,
    5307, 5308, 5309, 5310, 5311, 5312, 5313, 5314, 5315, 5316,
    5317, 5318, 5319, 5320, 5321, 5322, 5323, 5324, 5325, 5326,
    5327, 5328, 5329, 5330, 5331, 5332, 5333, 5334, 5335, 5336,
    5337, 5338, 5339, 5340, 5341, 5342, 5343, 5344, 5345, 5346,
    5347, 5348, 5349, 5350, 5351, 5352, 5353, 5354, 5355, 5356,
    5357, 5358, 5359, 5360, 5361, 5362, 5363, 5364, 5365, 5366,
    5367, 5368, 5369, 5370, 5371, 5372, 5373, 5374, 5375, 5376,
    5377, 5378, 5379, 5380, 5381, 5382, 5383, 5384, 5385, 5386,
    5387, 5388, 5389, 5390, 5391, 5392, 5393, 5394, 5395, 5396,
    5397, 5398, 5399, 5400, 5401, 5402, 5403, 5404, 5405, 5406,
    5407, 5408, 5409, 5410, 5411, 5412, 5413, 5414, 5415, 5416,
    5417, 5418, 5419, 5420, 5421, 5422, 5423, 5424, 5425, 5426,
    5427, 5428, 5429, 5430, 5431, 5432, 5433, 5434, 5435, 5436,
    5437, 5438, 5439, 5440, 5441, 5442, 5443, 5444, 5445, 5446,
    5447, 5448, 5449, 5450, 5451, 5452, 5453, 5454, 5455, 5456,
    5457, 5458, 5459, 5460, 5461, 5462, 5463, 5464, 5465, 5466,
    5467, 5468, 5469, 5470, 5471, 5472, 5473, 5474, 5475, 5476,
    5477, 5478, 5479, 5480, 5481, 5482, 5483, 5484, 5485, 5486,
    5487, 5488, 5489, 5490, 5491, 5492, 5493, 5494, 5495, 5496,
    5497, 5498, 5499, 5500, 5501, 5502, 5503, 5504, 5505, 5506,
    5507, 5508, 5509, 5510, 5511, 5512, 5513, 5514, 5515, 5516,
    5517, 5518, 5519, 5520, 5521, 5522, 5523, 5524, 5525, 5526,
    5527, 5528, 5529, 5530, 5531, 5532, 5533, 5534, 5535, 5536,
    5537, 5538, 5539, 5540, 5541, 5542, 5543, 5544, 5545, 5546,
    5547, 5548, 5549, 5550, 5551, 5552, 5553, 5554, 5555, 5556,
    5557, 5558, 5559, 5560, 5561, 5562, 5563, 5564, 5565, 5566,
    5567, 5568, 5569, 5570, 5571, 5572, 5573, 5574, 5575, 5576,
    5577, 5578, 5579, 5580, 5581, 5582, 5583, 5584, 5585, 5586,
    5587, 5588, 5589, 5590, 5591, 5592, 5593, 5594, 5595, 5596,
    5597, 5598, 5599, 5600, 5601, 5602, 5603, 5604, 5605, 5606,
    5607, 5608, 5609, 5610, 5611, 5612, 5613, 5614, 5615, 5616,
    5617, 5618, 5619, 5620, 5621, 5622, 5623, 5624, 5625, 5626,
    5627, 5628, 5629, 5630, 5631, 5632, 5633, 5634, 5635, 5636,
    5637, 5638, 5639, 5640, 5641, 5642, 5643, 5644, 5645, 5646,
    5647, 5648, 5649, 5650, 5651, 5652, 5653, 5654, 5655, 5656,
    5657, 5658, 5659, 5660, 5661, 5662, 5663, 5664, 5665, 5666,
    5667, 5668, 5669, 5670, 5671, 5672, 5673, 5674, 5675, 5676,
    5677, 5678, 5679, 5680, 5681
};

public OnFilterScriptInit()
{
    print("\n=========================================");
    print("Actor System with Custom Menu v1.0");
    print("Developer by Alexander");
    print("=========================================\n");
    return 1;
}

public OnFilterScriptExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        DestroyPlayerActors(i);
        UnloadCustomMenuTextDraws(i);
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    CurrentActor[playerid] = -1;
    ActorMenuState[playerid] = 0;
    ActorMenuPage[playerid] = 0;
    EditingActorMode[playerid] = 0;

    for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
    {
        PlayerActors[playerid][i][actorActive] = false;
        PlayerActors[playerid][i][actorId] = -1;
        format(PlayerActors[playerid][i][actorName], 32, "Актер");
        format(PlayerActors[playerid][i][actorMessage], 128, " ");
    }
    LoadActorsFromFile(playerid);
    LoadCustomMenuTextdraws(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    DestroyPlayerActors(playerid);
    UnloadCustomMenuTextDraws(playerid);
    return 1;
}

public OnPlayerKeyPress(playerid, key)
{
    if(key == WK_KEY_M)
    {
        ShowActorMainMenu(playerid);
        return 1;
    }

    if(key == WK_KEY_1)
    {
        SelectPreviousActor(playerid);
        return 1;
    }

    if(key == WK_KEY_2)
    {
        SelectNextActor(playerid);
        return 1;
    }

    if(key == WK_KEY_3)
    {
        if(ActorMenuState[playerid] == 2)
        {
            if(ActorMenuPage[playerid] > 0)
            {
                ActorMenuPage[playerid]--;
                HideCustomMenuForPlayer(playerid);
                ClearCustomMenuTempDate(playerid);
                SetTimerEx("ShowActorSelectionMenuEx", 100, 0, "d", playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_YELLOW, "Это первая страница");
            }
        }
        else
        {
            ActorMenuPage[playerid] = 0;
            ShowActorSelectionMenu(playerid);
        }
        return 1;
    }

    if(key == WK_KEY_4)
    {
        if(ActorMenuState[playerid] == 2)
        {
            new totalActors = sizeof(ActorSkins);
            new maxPage = (totalActors + 6) / 7 - 1;

            if(ActorMenuPage[playerid] < maxPage)
            {
                ActorMenuPage[playerid]++;
                HideCustomMenuForPlayer(playerid);
                ClearCustomMenuTempDate(playerid);
                SetTimerEx("ShowActorSelectionMenuEx", 100, 0, "d", playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_YELLOW, "Это последняя страница");
            }
        }
        else
        {
            ActorMenuPage[playerid] = 1;
            ShowActorSelectionMenu(playerid);
        }
        return 1;
    }

    if(key == WK_KEY_L)
    {
        DeleteCurrentActor(playerid);
        return 1;
    }

    if(key == WK_KEY_Z)
    {
        InteractWithActor(playerid);
        return 1;
    }
    if(key == WK_KEY_5)
    {
        TogglePlayerControllable(playerid, false);
        return 1;
    }
    if(key == WK_KEY_6)
    {
        TogglePlayerControllable(playerid, true);
        return 1;
    }
    if(key == WK_KEY_H)
	{
	    if(EditingActorMode[playerid])
	    {
	        if(CurrentActor[playerid] != -1)
	        {
	            new actorIndex = CurrentActor[playerid];
	            if(PlayerActors[playerid][actorIndex][actorActive])
	            {
	                ToggleActorArrow(PlayerActors[playerid][actorIndex][actorId], false);
	            }
	        }

	        EditingActorMode[playerid] = 0;
	        SendClientMessage(playerid, COLOR_RED, "========== РЕЖИМ ПЕРЕМЕЩЕНИЯ АКТЕРА ВЫКЛЮЧЕН ==========");
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_YELLOW, "Режим редактирования не активен");
	    }
	    return 1;
	}

    if(EditingActorMode[playerid] && CurrentActor[playerid] != -1)
    {
        new actorIndex = CurrentActor[playerid];
        if(!PlayerActors[playerid][actorIndex][actorActive]) return 1;

        new Float:x, Float:y, Float:z, Float:a;
        x = PlayerActors[playerid][actorIndex][actorX];
        y = PlayerActors[playerid][actorIndex][actorY];
        z = PlayerActors[playerid][actorIndex][actorZ];
        a = PlayerActors[playerid][actorIndex][actorA];

        if(key == WK_KEY_W)
        {
            x += ACTOR_MOVE_SPEED * floatsin(-a, degrees);
            y += ACTOR_MOVE_SPEED * floatcos(-a, degrees);
        }
        else if(key == WK_KEY_S)
        {
            x -= ACTOR_MOVE_SPEED * floatsin(-a, degrees);
            y -= ACTOR_MOVE_SPEED * floatcos(-a, degrees);
        }
        else if(key == WK_KEY_A)
        {
            x += ACTOR_MOVE_SPEED * floatsin(-a - 90.0, degrees);
            y += ACTOR_MOVE_SPEED * floatcos(-a - 90.0, degrees);
        }
        else if(key == WK_KEY_D)
        {
            x += ACTOR_MOVE_SPEED * floatsin(-a + 90.0, degrees);
            y += ACTOR_MOVE_SPEED * floatcos(-a + 90.0, degrees);
        }
        else if(key == WK_KEY_SPACE)
        {
            z += ACTOR_MOVE_SPEED;
        }
        else if(key == WK_KEY_CTRL)
        {
            z -= ACTOR_MOVE_SPEED;
        }
        else if(key == WK_KEY_Q)
        {
            a -= ACTOR_ROTATE_SPEED;
        }
        else if(key == WK_KEY_E)
        {
            a += ACTOR_ROTATE_SPEED;
        }
        else
        {
            return 1;
        }

        SetActorPos(PlayerActors[playerid][actorIndex][actorId], x, y, z);
        SetActorFacingAngle(PlayerActors[playerid][actorIndex][actorId], a);

        PlayerActors[playerid][actorIndex][actorX] = x;
        PlayerActors[playerid][actorIndex][actorY] = y;
        PlayerActors[playerid][actorIndex][actorZ] = z;
        PlayerActors[playerid][actorIndex][actorA] = a;

        UpdateActorLabel(playerid, actorIndex);

        new msg[128];
        format(msg, sizeof(msg), "Актер #%d: X: %.2f Y: %.2f Z: %.2f Угол: %.2f",
            actorIndex + 1, x, y, z, a);
        SendClientMessage(playerid, COLOR_WHITE, msg);
    }

    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PlayerCustomMenuCreated[playerid] == 1)
    {
        OnPlayerChangeKeyCustomMenu(playerid, newkeys);
        return 1;
    }
    return 1;
}

ShowActorMainMenu(playerid)
{
    CreatePlayerCustomMenu(playerid, 8);

    SetPlayerStringCustomMenu(playerid, 0, "Меню управления актерами");
    SetPlayerStringCustomMenu(playerid, 1, "Создать актера");
    SetPlayerStringCustomMenu(playerid, 2, "Выбрать актера");
    SetPlayerStringCustomMenu(playerid, 3, "Удалить актера");
    SetPlayerStringCustomMenu(playerid, 4, "Установить имя");
    SetPlayerStringCustomMenu(playerid, 5, "Установить сообщение");
    SetPlayerStringCustomMenu(playerid, 6, "Режим перемещения");
    SetPlayerStringCustomMenu(playerid, 7, "Сохранить актеров");
    SetPlayerStringCustomMenu(playerid, 8, "Загрузить актеров");

    ActorMenuState[playerid] = 1;
    ShowCustomMenuForPlayer(playerid);
    SendClientMessage(playerid, COLOR_WHITE, "Используйте стрелки для навигации, Enter - выбор, Пробел - выход");
    SendClientMessage(playerid, COLOR_YELLOW, "Клавиши: 1/2 - выбор актера, 3/4 - скины, H - сброс позиции");
    return 1;
}

ShowActorSelectionMenu(playerid)
{
    new totalActors = sizeof(ActorSkins);
    new startIdx = ActorMenuPage[playerid] * 7;
    new menuItems = 0;

    if(startIdx + 7 > totalActors)
        menuItems = totalActors - startIdx;
    else
        menuItems = 7;

    if(menuItems <= 0)
    {
        SendClientMessage(playerid, COLOR_RED, "Нет актеров для отображения");
        return 0;
    }

    CreatePlayerCustomMenu(playerid, menuItems + 1);

    new title[64];
    format(title, sizeof(title), "Выберите актера (Стр. %d/%d)", ActorMenuPage[playerid] + 1, (totalActors + 6) / 7);
    SetPlayerStringCustomMenu(playerid, 0, title);

    for(new i = 0; i < menuItems; i++)
    {
        new skinId = ActorSkins[startIdx + i];
        new itemName[32];
        format(itemName, 32, "Скин %d", skinId);
        SetPlayerStringCustomMenu(playerid, i + 1, itemName);
    }

    ActorMenuState[playerid] = 2;
    ShowCustomMenuForPlayer(playerid);
    return 1;
}

ShowActorListMenu(playerid)
{
    new count = 0;

    for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
    {
        if(PlayerActors[playerid][i][actorActive])
            count++;
    }

    if(count == 0)
    {
        SendClientMessage(playerid, COLOR_RED, "У вас нет созданных актеров!");
        return 0;
    }

    new menuItems = (count > 7) ? 7 : count;
    CreatePlayerCustomMenu(playerid, menuItems + 1);

    SetPlayerStringCustomMenu(playerid, 0, "Ваши актеры");

    new itemIndex = 1;
    for(new i = 0; i < MAX_PLAYER_ACTORS && itemIndex <= menuItems; i++)
    {
        if(PlayerActors[playerid][i][actorActive])
        {
            new itemName[64];
            format(itemName, 64, "%s", PlayerActors[playerid][i][actorName]);
            SetPlayerStringCustomMenu(playerid, itemIndex, itemName);
            itemIndex++;
        }
    }

    if(count > 7)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "Показаны первые 7 актеров.");
    }

    ActorMenuState[playerid] = 3;
    ShowCustomMenuForPlayer(playerid);
    return 1;
}

ShowActorNameMenu(playerid)
{
    CreatePlayerCustomMenu(playerid, 1);

    SetPlayerStringCustomMenu(playerid, 0, "Введите имя для актера");
    SetPlayerStringCustomMenu(playerid, 1, "Напишите имя в чат");

    ActorMenuState[playerid] = 6;
    ShowCustomMenuForPlayer(playerid);
    SendClientMessage(playerid, COLOR_YELLOW, "Введите имя для актера (не более 31 символа):");
    return 1;
}

ShowActorMessageMenu(playerid)
{
    CreatePlayerCustomMenu(playerid, 1);

    SetPlayerStringCustomMenu(playerid, 0, "Введите сообщение для актера");
    SetPlayerStringCustomMenu(playerid, 1, "Напишите текст в чат");

    ActorMenuState[playerid] = 4;
    ShowCustomMenuForPlayer(playerid);
    SendClientMessage(playerid, COLOR_YELLOW, "Введите сообщение, которое будет показываться при нажатии Z:");
    return 1;
}

public OnPlayerEnterCustomMenu(playerid, playercustommenuid)
{
    new id = playercustommenuid;

    if(ActorMenuState[playerid] == 1)
    {
        HideCustomMenuForPlayer(playerid);
        ClearCustomMenuTempDate(playerid);

        if(id == 1)
        {
            ActorMenuPage[playerid] = 0;
            SetTimerEx("ShowActorSelectionMenuEx", 100, 0, "d", playerid);
        }
        else if(id == 2)
        {
            if(HasAnyActor(playerid))
                SetTimerEx("ShowActorListMenuEx", 100, 0, "d", playerid);
            else
                SendClientMessage(playerid, COLOR_RED, "У вас нет созданных актеров!");
        }
        else if(id == 3)
        {
            if(CurrentActor[playerid] != -1)
                ShowActorDeleteConfirmation(playerid);
            else
                SendClientMessage(playerid, COLOR_RED, "Нет выбранного актера!");
        }
        else if(id == 4)
        {
            if(CurrentActor[playerid] != -1)
                ShowActorNameMenu(playerid);
            else
                SendClientMessage(playerid, COLOR_RED, "Сначала выберите актера!");
        }
        else if(id == 5)
        {
            if(CurrentActor[playerid] != -1)
                ShowActorMessageMenu(playerid);
            else
                SendClientMessage(playerid, COLOR_RED, "Сначала выберите актера!");
        }
        else if(id == 6)
        {
            if(CurrentActor[playerid] != -1)
            {
                ToggleActorEditMode(playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "Сначала выберите актера!");
            }
        }
        else if(id == 7)
        {
            SaveActorsToFile(playerid);
        }
        else if(id == 8)
        {
            LoadActorsFromFile(playerid);
        }
    }
    else if(ActorMenuState[playerid] == 2)
    {
        new totalActors = sizeof(ActorSkins);
        new selectedSkin = ActorMenuPage[playerid] * 7 + (id - 1);

        if(selectedSkin >= 0 && selectedSkin < totalActors)
        {
            HideCustomMenuForPlayer(playerid);
            ClearCustomMenuTempDate(playerid);

            CreateActorWithSkin(playerid, ActorSkins[selectedSkin]);
        }
        else
        {
            SendClientMessage(playerid, COLOR_RED, "Неверный выбор");
            HideCustomMenuForPlayer(playerid);
            ClearCustomMenuTempDate(playerid);
        }
    }
    else if(ActorMenuState[playerid] == 3)
    {
        new count = 0;
        new selectedIdx = -1;

        for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
        {
            if(PlayerActors[playerid][i][actorActive])
            {
                count++;
                if(count == id)
                {
                    selectedIdx = i;
                    break;
                }
            }
        }

        if(selectedIdx != -1)
        {
            CurrentActor[playerid] = selectedIdx;
            HideCustomMenuForPlayer(playerid);
            ClearCustomMenuTempDate(playerid);

            ShowActorInfo(playerid, selectedIdx);
            SendClientMessage(playerid, COLOR_GREEN, "Актер выбран!");
        }
        else
        {
            HideCustomMenuForPlayer(playerid);
            ClearCustomMenuTempDate(playerid);
        }
    }
    else if(ActorMenuState[playerid] == 5)
    {
        HideCustomMenuForPlayer(playerid);
        ClearCustomMenuTempDate(playerid);

        if(id == 1)
        {
            DeleteCurrentActor(playerid);
        }
    }

    return 1;
}

ToggleActorEditMode(playerid)
{
    if(CurrentActor[playerid] == -1)
    {
        SendClientMessage(playerid, COLOR_RED, "Сначала выберите актера!");
        return 0;
    }

    EditingActorMode[playerid] = !EditingActorMode[playerid];

    new actorIndex = CurrentActor[playerid];
    if(PlayerActors[playerid][actorIndex][actorActive])
    {
        if(EditingActorMode[playerid])
        {
            ToggleActorArrow(PlayerActors[playerid][actorIndex][actorId], true);

            SendClientMessage(playerid, COLOR_GREEN, "========== РЕЖИМ ПЕРЕМЕЩЕНИЯ АКТЕРА ВКЛЮЧЕН ==========");
            SendClientMessage(playerid, COLOR_WHITE, "W/S - вперед/назад | A/D - влево/вправо");
            SendClientMessage(playerid, COLOR_WHITE, "Пробел - вверх | Ctrl - вниз | Q/E - поворот");
            SendClientMessage(playerid, COLOR_YELLOW, "H - выключить режим | Z - взаимодействие");
            SendClientMessage(playerid, COLOR_YELLOW, "5 - заморозить себя | 6 - разморозить себя");
        }
        else
        {
            ToggleActorArrow(PlayerActors[playerid][actorIndex][actorId], false);

            SendClientMessage(playerid, COLOR_RED, "========== РЕЖИМ ПЕРЕМЕЩЕНИЯ АКТЕРА ВЫКЛЮЧЕН ==========");
        }
    }
    return 1;
}

public OnPlayerExitCustomMenu(playerid)
{
    HideCustomMenuForPlayer(playerid);
    ClearCustomMenuTempDate(playerid);
    ActorMenuState[playerid] = 0;
    ActorMenuPage[playerid] = 0;
    SendClientMessage(playerid, COLOR_WHITE, "Меню закрыто");
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(ActorMenuState[playerid] == 6 && CurrentActor[playerid] != -1)
    {
        new actorIndex = CurrentActor[playerid];
        if(PlayerActors[playerid][actorIndex][actorActive])
        {
            if(strlen(text) > 31)
            {
                SendClientMessage(playerid, COLOR_RED, "Имя слишком длинное! Максимум 31 символ.");
                return 0;
            }

            format(PlayerActors[playerid][actorIndex][actorName], 32, text);

            UpdateActorLabel(playerid, actorIndex);

            HideCustomMenuForPlayer(playerid);
            ClearCustomMenuTempDate(playerid);

            new msg[128];
            format(msg, 128, "Имя для актера #%d установлено: \"%s\"", actorIndex + 1, text);
            SendClientMessage(playerid, COLOR_GREEN, msg);

            ActorMenuState[playerid] = 0;
            return 0;
        }
    }

    if(ActorMenuState[playerid] == 4 && CurrentActor[playerid] != -1)
    {
        new actorIndex = CurrentActor[playerid];
        if(PlayerActors[playerid][actorIndex][actorActive])
        {
            format(PlayerActors[playerid][actorIndex][actorMessage], 128, text);

            UpdateActorLabel(playerid, actorIndex);

            HideCustomMenuForPlayer(playerid);
            ClearCustomMenuTempDate(playerid);

            new msg[128];
            format(msg, 128, "Сообщение для актера #%d установлено: \"%s\"", actorIndex + 1, text);
            SendClientMessage(playerid, COLOR_GREEN, msg);

            ActorMenuState[playerid] = 0;
            return 0;
        }
    }
    return 1;
}

forward ShowActorSelectionMenuEx(playerid);
public ShowActorSelectionMenuEx(playerid)
{
    ShowActorSelectionMenu(playerid);
}

forward ShowActorListMenuEx(playerid);
public ShowActorListMenuEx(playerid)
{
    ShowActorListMenu(playerid);
}

CreateActorWithSkin(playerid, skinid)
{
    new freeSlot = -1;
    for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
    {
        if(!PlayerActors[playerid][i][actorActive])
        {
            freeSlot = i;
            break;
        }
    }

    if(freeSlot == -1)
    {
        SendClientMessage(playerid, COLOR_RED, "Вы достигли максимального количества актеров (30)!");
        return 0;
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new Float:angle;
    GetPlayerFacingAngle(playerid, angle);

    x += 2.0 * floatsin(-angle, degrees);
    y += 2.0 * floatcos(-angle, degrees);

    new newActorId = CreateActor(skinid, x, y, z, angle);

    PlayerActors[playerid][freeSlot][actorActive] = true;
    PlayerActors[playerid][freeSlot][actorId] = newActorId;
    PlayerActors[playerid][freeSlot][actorX] = x;
    PlayerActors[playerid][freeSlot][actorY] = y;
    PlayerActors[playerid][freeSlot][actorZ] = z;
    PlayerActors[playerid][freeSlot][actorA] = angle;
    PlayerActors[playerid][freeSlot][actorSkin] = skinid;

    new defaultName[32];
    format(defaultName, 32, "Актер %d", freeSlot + 1);
    format(PlayerActors[playerid][freeSlot][actorName], 32, defaultName);
    format(PlayerActors[playerid][freeSlot][actorMessage], 128, " ");

    if(EditingActorMode[playerid])
    {
        if(CurrentActor[playerid] != -1 && PlayerActors[playerid][CurrentActor[playerid]][actorActive])
        {
            ToggleActorArrow(PlayerActors[playerid][CurrentActor[playerid]][actorId], false);
        }
        ToggleActorArrow(newActorId, true);
    }

    CurrentActor[playerid] = freeSlot;

    CreateActorLabel(playerid, freeSlot);

    new msg[128];
    format(msg, 128, "Создан актер #%d [Скин: %d]", freeSlot + 1, skinid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    SendClientMessage(playerid, COLOR_YELLOW, "Используйте меню (M) чтобы установить имя, сообщение или переместить актера");

    return 1;
}

InteractWithActor(playerid)
{
    new foundActorId = -1;
    new actorIndex = -1;

    for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
    {
        if(PlayerActors[playerid][i][actorActive])
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0,
                PlayerActors[playerid][i][actorX],
                PlayerActors[playerid][i][actorY],
                PlayerActors[playerid][i][actorZ]))
            {
                foundActorId = PlayerActors[playerid][i][actorId];
                actorIndex = i;
                break;
            }
        }
    }

    if(actorIndex == -1)
    {
        SendClientMessage(playerid, COLOR_RED, "Рядом нет актеров!");
        return 0;
    }

    if(strlen(PlayerActors[playerid][actorIndex][actorMessage]) > 0)
    {
        new msg[256];
        format(msg, 256, "%s говорит: %s",
            PlayerActors[playerid][actorIndex][actorName],
            PlayerActors[playerid][actorIndex][actorMessage]);

        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i, 20.0,
                PlayerActors[playerid][actorIndex][actorX],
                PlayerActors[playerid][actorIndex][actorY],
                PlayerActors[playerid][actorIndex][actorZ]))
            {
                SendClientMessage(i, COLOR_PURPLE, msg);
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_YELLOW, "У этого актера нет сообщения. Установите его через меню (M -> Установить сообщение)");
    }

    return 1;
}

DeleteCurrentActor(playerid)
{
    if(CurrentActor[playerid] == -1)
    {
        SendClientMessage(playerid, COLOR_RED, "Нет выбранного актера!");
        return 0;
    }

    new actorIndex = CurrentActor[playerid];
    if(PlayerActors[playerid][actorIndex][actorActive])
    {
        if(EditingActorMode[playerid])
        {
            ToggleActorArrow(PlayerActors[playerid][actorIndex][actorId], false);
        }

        DestroyActor(PlayerActors[playerid][actorIndex][actorId]);
        DestroyActorLabel(playerid, actorIndex);

        PlayerActors[playerid][actorIndex][actorActive] = false;
        PlayerActors[playerid][actorIndex][actorId] = -1;

        SendClientMessage(playerid, COLOR_GREEN, "Актер удален!");

        if(EditingActorMode[playerid])
        {
            EditingActorMode[playerid] = 0;
            SendClientMessage(playerid, COLOR_RED, "Режим перемещения выключен");
        }

        SelectNextActor(playerid);
    }
    return 1;
}

SelectNextActor(playerid)
{
    if(CurrentActor[playerid] == -1)
    {
        for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
        {
            if(PlayerActors[playerid][i][actorActive])
            {
                CurrentActor[playerid] = i;

                if(EditingActorMode[playerid])
                {
                    ToggleActorArrow(PlayerActors[playerid][i][actorId], true);
                }

                ShowActorInfo(playerid, i);
                return 1;
            }
        }
        SendClientMessage(playerid, COLOR_RED, "У вас нет актеров!");
        return 0;
    }

    new next = CurrentActor[playerid] + 1;
    for(new i = next; i < MAX_PLAYER_ACTORS; i++)
    {
        if(PlayerActors[playerid][i][actorActive])
        {
            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][CurrentActor[playerid]][actorId], false);
            }

            CurrentActor[playerid] = i;

            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][i][actorId], true);
            }

            ShowActorInfo(playerid, i);
            return 1;
        }
    }

    for(new i = 0; i < CurrentActor[playerid]; i++)
    {
        if(PlayerActors[playerid][i][actorActive])
        {
            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][CurrentActor[playerid]][actorId], false);
            }

            CurrentActor[playerid] = i;

            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][i][actorId], true);
            }

            ShowActorInfo(playerid, i);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_RED, "Нет других актеров!");
    return 0;
}

SelectPreviousActor(playerid)
{
    if(CurrentActor[playerid] == -1)
    {
        for(new i = MAX_PLAYER_ACTORS - 1; i >= 0; i--)
        {
            if(PlayerActors[playerid][i][actorActive])
            {
                CurrentActor[playerid] = i;

                if(EditingActorMode[playerid])
                {
                    ToggleActorArrow(PlayerActors[playerid][i][actorId], true);
                }

                ShowActorInfo(playerid, i);
                return 1;
            }
        }
        SendClientMessage(playerid, COLOR_RED, "У вас нет актеров!");
        return 0;
    }

    new prev = CurrentActor[playerid] - 1;
    for(new i = prev; i >= 0; i--)
    {
        if(PlayerActors[playerid][i][actorActive])
        {
            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][CurrentActor[playerid]][actorId], false);
            }

            CurrentActor[playerid] = i;

            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][i][actorId], true);
            }

            ShowActorInfo(playerid, i);
            return 1;
        }
    }

    for(new i = MAX_PLAYER_ACTORS - 1; i > CurrentActor[playerid]; i--)
    {
        if(PlayerActors[playerid][i][actorActive])
        {
            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][CurrentActor[playerid]][actorId], false);
            }

            CurrentActor[playerid] = i;

            if(EditingActorMode[playerid])
            {
                ToggleActorArrow(PlayerActors[playerid][i][actorId], true);
            }

            ShowActorInfo(playerid, i);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_RED, "Нет других актеров!");
    return 0;
}

ShowActorDeleteConfirmation(playerid)
{
    CreatePlayerCustomMenu(playerid, 3);

    new confirmMsg[64];
    format(confirmMsg, 64, "Удалить актера #%d (%s)?",
        CurrentActor[playerid] + 1,
        PlayerActors[playerid][CurrentActor[playerid]][actorName]);
    SetPlayerStringCustomMenu(playerid, 0, confirmMsg);
    SetPlayerStringCustomMenu(playerid, 1, "Да");
    SetPlayerStringCustomMenu(playerid, 2, "Нет");

    ActorMenuState[playerid] = 5;
    ShowCustomMenuForPlayer(playerid);
}

CreateActorLabel(playerid, index)
{
    new label[128];

    format(label, sizeof(label), "%s", PlayerActors[playerid][index][actorName]);

    ActorLabel[playerid][index] = Create3DTextLabel(
        label,
        0xFFD700FF,
        PlayerActors[playerid][index][actorX],
        PlayerActors[playerid][index][actorY],
        PlayerActors[playerid][index][actorZ] + 1.2,
        20.0,
        0,
        1
    );
}

UpdateActorLabel(playerid, index)
{
    DestroyActorLabel(playerid, index);
    CreateActorLabel(playerid, index);
}

DestroyActorLabel(playerid, index)
{
    if(IsValid3DTextLabel(ActorLabel[playerid][index]))
    {
        Delete3DTextLabel(ActorLabel[playerid][index]);
        ActorLabel[playerid][index] = Text3D:INVALID_3DTEXT_ID;
    }
}

ShowActorInfo(playerid, index)
{
    new msg[256];
    format(msg, sizeof(msg),
        "Выбран актер #%d | Имя: %s | Позиция: %.2f, %.2f, %.2f | Угол: %.2f",
        index + 1,
        PlayerActors[playerid][index][actorName],
        PlayerActors[playerid][index][actorX],
        PlayerActors[playerid][index][actorY],
        PlayerActors[playerid][index][actorZ],
        PlayerActors[playerid][index][actorA]
    );
    SendClientMessage(playerid, COLOR_GREEN, msg);

    if(EditingActorMode[playerid])
    {
        SendClientMessage(playerid, COLOR_GREEN, "Режим перемещения активен! Используйте W,A,S,D для движения ");
    }
}

HasAnyActor(playerid)
{
    for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
    {
        if(PlayerActors[playerid][i][actorActive])
            return 1;
    }
    return 0;
}

DestroyPlayerActors(playerid)
{
    for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
    {
        if(PlayerActors[playerid][i][actorActive])
        {
            DestroyActor(PlayerActors[playerid][i][actorId]);
            DestroyActorLabel(playerid, i);

            PlayerActors[playerid][i][actorActive] = false;
            PlayerActors[playerid][i][actorId] = -1;
        }
    }
    CurrentActor[playerid] = -1;
}

SaveActorsToFile(playerid)
{
    new filename[64];
    GetPlayerName(playerid, filename, sizeof(filename));
    format(filename, sizeof(filename), "Actors_%s.ini", filename);

    new File:file = fopen(filename, io_write);
    if(file)
    {
        new count = 0;
        new line[512];

        for(new i = 0; i < MAX_PLAYER_ACTORS; i++)
        {
            if(PlayerActors[playerid][i][actorActive])
            {
                format(line, sizeof(line), "%d,%f,%f,%f,%f,%d,%s,%s\r\n",
                    PlayerActors[playerid][i][actorSkin],
                    PlayerActors[playerid][i][actorX],
                    PlayerActors[playerid][i][actorY],
                    PlayerActors[playerid][i][actorZ],
                    PlayerActors[playerid][i][actorA],
                    i,
                    PlayerActors[playerid][i][actorName],
                    PlayerActors[playerid][i][actorMessage]
                );
                fwrite(file, line);
                count++;
            }
        }
        fclose(file);

        new msg[128];
        format(msg, sizeof(msg), "Сохранено %d актеров в файл %s", count, filename);
        SendClientMessage(playerid, COLOR_GREEN, msg);
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "Ошибка при сохранении файла!");
    }
    return 1;
}

LoadActorsFromFile(playerid)
{
    new filename[64];
    GetPlayerName(playerid, filename, sizeof(filename));
    format(filename, sizeof(filename), "Actors_%s.ini", filename);

    new File:file = fopen(filename, io_read);
    if(file)
    {
        DestroyPlayerActors(playerid);

        new line[512];
        new skinid, slot;
        new Float:x, Float:y, Float:z, Float:a;
        new name[32], message[128];
        new count = 0;

        while(fread(file, line) && count < MAX_PLAYER_ACTORS)
        {
            new idx = 0;
            new parts[8][256];
            new partCount = 0;
            new strPos = 0;

            while(line[idx] != '\0' && line[idx] != '\r' && line[idx] != '\n' && partCount < 8)
            {
                if(line[idx] == ',')
                {
                    parts[partCount][strPos] = '\0';
                    partCount++;
                    strPos = 0;
                }
                else
                {
                    parts[partCount][strPos] = line[idx];
                    strPos++;
                }
                idx++;
            }

            if(strPos > 0 && partCount < 8)
            {
                parts[partCount][strPos] = '\0';
                partCount++;
            }

            if(partCount >= 8)
            {
                skinid = floatround(floatstr(parts[0]));
                x = floatstr(parts[1]);
                y = floatstr(parts[2]);
                z = floatstr(parts[3]);
                a = floatstr(parts[4]);
                slot = floatround(floatstr(parts[5]));
                format(name, 32, parts[6]);
                format(message, 128, parts[7]);

                new newActorId = CreateActor(skinid, x, y, z, a);

                PlayerActors[playerid][slot][actorActive] = true;
                PlayerActors[playerid][slot][actorId] = newActorId;
                PlayerActors[playerid][slot][actorX] = x;
                PlayerActors[playerid][slot][actorY] = y;
                PlayerActors[playerid][slot][actorZ] = z;
                PlayerActors[playerid][slot][actorA] = a;
                PlayerActors[playerid][slot][actorSkin] = skinid;
                format(PlayerActors[playerid][slot][actorName], 32, name);
                format(PlayerActors[playerid][slot][actorMessage], 128, message);

                CreateActorLabel(playerid, slot);
                count++;
            }
        }
        fclose(file);

        new msg[128];
        format(msg, sizeof(msg), "Загружено %d актеров из файла %s", count, filename);
        SendClientMessage(playerid, COLOR_GREEN, msg);

        if(count > 0)
        {
            CurrentActor[playerid] = 0;
            ShowActorInfo(playerid, 0);
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "Файл с актерами не найден!");
    }
    return 1;
}
