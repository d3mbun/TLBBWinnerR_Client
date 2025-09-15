
local NewbieGift_Send = 0
local NewbieGift_Info = {}

local BUTTON_GIFT = {}
local FRAME_GIFT = {}
local ITEM_GIFT = {}
local NUM_GIFT = {}

local Item_Array = {}
local Num_Array = {}

function NewbieGift_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function NewbieGift_OnLoad()
	
	FRAME_GIFT[1] = NewbieGift_Gift1
	FRAME_GIFT[2] = NewbieGift_Gift2
	FRAME_GIFT[3] = NewbieGift_Gift3
	FRAME_GIFT[4] = NewbieGift_Gift4
	FRAME_GIFT[5] = NewbieGift_Gift5
	FRAME_GIFT[6] = NewbieGift_Gift6
	FRAME_GIFT[7] = NewbieGift_Gift7
	FRAME_GIFT[8] = NewbieGift_Gift8
	FRAME_GIFT[9] = NewbieGift_Gift9
	
	BUTTON_GIFT[1] = NewbieGift_Gift1RC
	BUTTON_GIFT[2] = NewbieGift_Gift2RC
	BUTTON_GIFT[3] = NewbieGift_Gift3RC
	BUTTON_GIFT[4] = NewbieGift_Gift4RC
	BUTTON_GIFT[5] = NewbieGift_Gift5RC
	BUTTON_GIFT[6] = NewbieGift_Gift6RC
	BUTTON_GIFT[7] = NewbieGift_Gift7RC
	BUTTON_GIFT[8] = NewbieGift_Gift8RC
	BUTTON_GIFT[9] = NewbieGift_Gift9RC
	
	ITEM_GIFT[1] = {}
	ITEM_GIFT[1][1] = NewbieGift_Gift1Item1
	ITEM_GIFT[1][2] = NewbieGift_Gift1Item2
	ITEM_GIFT[1][3] = NewbieGift_Gift1Item3
	ITEM_GIFT[1][4] = NewbieGift_Gift1Item4
	ITEM_GIFT[1][5] = NewbieGift_Gift1Item5
	ITEM_GIFT[2] = {}
	ITEM_GIFT[2][1] = NewbieGift_Gift2Item1
	ITEM_GIFT[2][2] = NewbieGift_Gift2Item2
	ITEM_GIFT[2][3] = NewbieGift_Gift2Item3
	ITEM_GIFT[2][4] = NewbieGift_Gift2Item4
	ITEM_GIFT[2][5] = NewbieGift_Gift2Item5
	ITEM_GIFT[3] = {}
	ITEM_GIFT[3][1] = NewbieGift_Gift3Item1
	ITEM_GIFT[3][2] = NewbieGift_Gift3Item2
	ITEM_GIFT[3][3] = NewbieGift_Gift3Item3
	ITEM_GIFT[3][4] = NewbieGift_Gift3Item4
	ITEM_GIFT[3][5] = NewbieGift_Gift3Item5
	ITEM_GIFT[4] = {}
	ITEM_GIFT[4][1] = NewbieGift_Gift4Item1
	ITEM_GIFT[4][2] = NewbieGift_Gift4Item2
	ITEM_GIFT[4][3] = NewbieGift_Gift4Item3
	ITEM_GIFT[4][4] = NewbieGift_Gift4Item4
	ITEM_GIFT[4][5] = NewbieGift_Gift4Item5
	ITEM_GIFT[5] = {}
	ITEM_GIFT[5][1] = NewbieGift_Gift5Item1
	ITEM_GIFT[5][2] = NewbieGift_Gift5Item2
	ITEM_GIFT[5][3] = NewbieGift_Gift5Item3
	ITEM_GIFT[5][4] = NewbieGift_Gift5Item4
	ITEM_GIFT[5][5] = NewbieGift_Gift5Item5
	ITEM_GIFT[6] = {}
	ITEM_GIFT[6][1] = NewbieGift_Gift6Item1
	ITEM_GIFT[6][2] = NewbieGift_Gift6Item2
	ITEM_GIFT[6][3] = NewbieGift_Gift6Item3
	ITEM_GIFT[6][4] = NewbieGift_Gift6Item4
	ITEM_GIFT[6][5] = NewbieGift_Gift6Item5
	ITEM_GIFT[7] = {}
	ITEM_GIFT[7][1] = NewbieGift_Gift7Item1
	ITEM_GIFT[7][2] = NewbieGift_Gift7Item2
	ITEM_GIFT[7][3] = NewbieGift_Gift7Item3
	ITEM_GIFT[7][4] = NewbieGift_Gift7Item4
	ITEM_GIFT[7][5] = NewbieGift_Gift7Item5
	ITEM_GIFT[8] = {}
	ITEM_GIFT[8][1] = NewbieGift_Gift8Item1
	ITEM_GIFT[8][2] = NewbieGift_Gift8Item2
	ITEM_GIFT[8][3] = NewbieGift_Gift8Item3
	ITEM_GIFT[8][4] = NewbieGift_Gift8Item4
	ITEM_GIFT[8][5] = NewbieGift_Gift8Item5
	ITEM_GIFT[9] = {}
	ITEM_GIFT[9][1] = NewbieGift_Gift9Item1
	ITEM_GIFT[9][2] = NewbieGift_Gift9Item2
	ITEM_GIFT[9][3] = NewbieGift_Gift9Item3
	ITEM_GIFT[9][4] = NewbieGift_Gift9Item4
	ITEM_GIFT[9][5] = NewbieGift_Gift9Item5
	
	NUM_GIFT[1] = {}
	NUM_GIFT[1][1] = NewbieGift_Gift1Item1_Num
	NUM_GIFT[1][2] = NewbieGift_Gift1Item2_Num
	NUM_GIFT[1][3] = NewbieGift_Gift1Item3_Num
	NUM_GIFT[1][4] = NewbieGift_Gift1Item4_Num
	NUM_GIFT[1][5] = NewbieGift_Gift1Item5_Num
	NUM_GIFT[2] = {}
	NUM_GIFT[2][1] = NewbieGift_Gift2Item1_Num
	NUM_GIFT[2][2] = NewbieGift_Gift2Item2_Num
	NUM_GIFT[2][3] = NewbieGift_Gift2Item3_Num
	NUM_GIFT[2][4] = NewbieGift_Gift2Item4_Num
	NUM_GIFT[2][5] = NewbieGift_Gift2Item5_Num
	NUM_GIFT[3] = {}
	NUM_GIFT[3][1] = NewbieGift_Gift3Item1_Num
	NUM_GIFT[3][2] = NewbieGift_Gift3Item2_Num
	NUM_GIFT[3][3] = NewbieGift_Gift3Item3_Num
	NUM_GIFT[3][4] = NewbieGift_Gift3Item4_Num
	NUM_GIFT[3][5] = NewbieGift_Gift3Item5_Num
	NUM_GIFT[4] = {}
	NUM_GIFT[4][1] = NewbieGift_Gift4Item1_Num
	NUM_GIFT[4][2] = NewbieGift_Gift4Item2_Num
	NUM_GIFT[4][3] = NewbieGift_Gift4Item3_Num
	NUM_GIFT[4][4] = NewbieGift_Gift4Item4_Num
	NUM_GIFT[4][5] = NewbieGift_Gift4Item5_Num
	NUM_GIFT[5] = {}
	NUM_GIFT[5][1] = NewbieGift_Gift5Item1_Num
	NUM_GIFT[5][2] = NewbieGift_Gift5Item2_Num
	NUM_GIFT[5][3] = NewbieGift_Gift5Item3_Num
	NUM_GIFT[5][4] = NewbieGift_Gift5Item4_Num
	NUM_GIFT[5][5] = NewbieGift_Gift5Item5_Num
	NUM_GIFT[6] = {}
	NUM_GIFT[6][1] = NewbieGift_Gift6Item1_Num
	NUM_GIFT[6][2] = NewbieGift_Gift6Item2_Num
	NUM_GIFT[6][3] = NewbieGift_Gift6Item3_Num
	NUM_GIFT[6][4] = NewbieGift_Gift6Item4_Num
	NUM_GIFT[6][5] = NewbieGift_Gift6Item5_Num
	NUM_GIFT[7] = {}
	NUM_GIFT[7][1] = NewbieGift_Gift7Item1_Num
	NUM_GIFT[7][2] = NewbieGift_Gift7Item2_Num
	NUM_GIFT[7][3] = NewbieGift_Gift7Item3_Num
	NUM_GIFT[7][4] = NewbieGift_Gift7Item4_Num
	NUM_GIFT[7][5] = NewbieGift_Gift7Item5_Num
	NUM_GIFT[8] = {}
	NUM_GIFT[8][1] = NewbieGift_Gift8Item1_Num
	NUM_GIFT[8][2] = NewbieGift_Gift8Item2_Num
	NUM_GIFT[8][3] = NewbieGift_Gift8Item3_Num
	NUM_GIFT[8][4] = NewbieGift_Gift8Item4_Num
	NUM_GIFT[8][5] = NewbieGift_Gift8Item5_Num
	NUM_GIFT[9] = {}
	NUM_GIFT[9][1] = NewbieGift_Gift9Item1_Num
	NUM_GIFT[9][2] = NewbieGift_Gift9Item2_Num
	NUM_GIFT[9][3] = NewbieGift_Gift9Item3_Num
	NUM_GIFT[9][4] = NewbieGift_Gift9Item4_Num
	NUM_GIFT[9][5] = NewbieGift_Gift9Item5_Num
end

function NewbieGift_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 1026001 then --Open

		if this:IsVisible() then
			this:Hide();
			return;
		end
		NewbieGift_Update()
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 1026002 then --Update
		for i = 1, 9 do
			NewbieGift_Info[i] = Get_XParam_STR(i)
		end
		
		NewbieGift_ShowItem()
		this:Show();
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		NewbieGift_OnHidden();
		return;
	end
end

function NewbieGift_ShowItem()
	local CharData = DataPool:GetPlayerMission_DataRound(298)
	local CharDataLen = string.len(CharData)
	if CharDataLen < 9 then
		for i = 1, 9 - CharDataLen do
			CharData = "0"..CharData;
		end
	end
	
	local CharLevel = Player:GetData("LEVEL")
	
	for i = 1, 9 do
		-- PushDebugMessage(NewbieGift_Info[i])
		if NewbieGift_Info[i] == "0" then
			FRAME_GIFT[i]:Hide()
		else			
			Item_Array[1] = string.sub(NewbieGift_Info[i],01,08)
			Item_Array[2] = string.sub(NewbieGift_Info[i],09,16)
			Item_Array[3] = string.sub(NewbieGift_Info[i],17,24)
			Item_Array[4] = string.sub(NewbieGift_Info[i],25,32)
			Item_Array[5] = string.sub(NewbieGift_Info[i],33,40)
			
			Num_Array[1] = string.sub(NewbieGift_Info[i],41,43)
			Num_Array[2] = string.sub(NewbieGift_Info[i],44,46)
			Num_Array[3] = string.sub(NewbieGift_Info[i],47,49)
			Num_Array[4] = string.sub(NewbieGift_Info[i],50,52)
			Num_Array[5] = string.sub(NewbieGift_Info[i],53,55)
			
			for j = 1, 5 do
				if Item_Array[j] == "88888888" then
					ITEM_GIFT[i][j]:SetActionItem(-1)
					NUM_GIFT[i][j]:SetText("")
				else
					local Index = GemMelting:UpdateProductAction(tonumber(Item_Array[j]));
					ITEM_GIFT[i][j]:SetActionItem(Index:GetID())
					NUM_GIFT[i][j]:SetText("#e010101#W"..tonumber(Num_Array[j]))
					
					ITEM_GIFT[i][j]:Show()
					NUM_GIFT[i][j]:Show()
				end
			end

			if string.sub(CharData,i,i) == "1" then
				BUTTON_GIFT[i]:SetText("XONG")
				BUTTON_GIFT[i]:Disable()
				for j = 1, 5 do
					ITEM_GIFT[i][j]:Disable()
				end
			else
				local NeedLevel = i*10
				if CharLevel >= NeedLevel then
					BUTTON_GIFT[i]:Enable()
				else
					BUTTON_GIFT[i]:Disable()
				end
				
				BUTTON_GIFT[i]:SetText("Lv "..NeedLevel)
				for j = 1, 5 do
					ITEM_GIFT[i][j]:Enable()
				end
			end
			
			FRAME_GIFT[i]:Show()
		end
	end
	
	
end

function NewbieGift_Update()
	NewbieGift_GiftCodeEdit:SetText("Nh§p vào GiftCode!");
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnCreateItem")
	Set_XSCRIPT_ScriptID(045050)
	Set_XSCRIPT_Parameter(0,9)
	Set_XSCRIPT_Parameter(1,1)
	Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
end

function NewbieGift_GiftRC(nIndex)
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnCreateItem")
	Set_XSCRIPT_ScriptID(045050)
	Set_XSCRIPT_Parameter(0,9)
	Set_XSCRIPT_Parameter(1,2)
	Set_XSCRIPT_Parameter(2,nIndex)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
end

function NewbieGift_GiftCodeSend_Clicked()
	local CardNum = NewbieGift_GiftCodeEdit:GetText();
	if string.len(CardNum) == 0 then
		PushDebugMessage("#{CFK_081027_2}");
		return
	end
	
	NewUserCard(CardNum, 0);
end

function NewbieGift_Help()
	PushDebugMessage("")
end

function NewbieGift_OnHidden()
	this:Hide()
end