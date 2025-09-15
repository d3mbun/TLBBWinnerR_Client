local nKey = -1
local nDetail = -1

local SHOP_KEY = {}
local SHOP_KEY_ID = {}

local SHOP_DETAIL = {}
local SHOP_DETAIL_ID = {}

local SHOP_ITEM = {}
local SHOP_ITEM_NUM = {}
local SHOP_ITEM_NAME = {}
local SHOP_ITEM_PRICE = {}
local SHOP_ITEM_MASK = {}

local ShopItem_Page = -1;
local ShopItem_Current = -1;
local ShopItem_Money = -1;
local ShopCustom_Money = {"Ngân Lßşng", "Thi®n Ác", "Sß Ğ°", "C¯ng Hiªn", "Nguyên Bäo", "Ği¬m T£ng", "Ği¬m Môn Phái", "Giao TØ", "Nguyên Bäo Khóa"}

local ShopItem_TimeArray = {}

function ShopCustom_PreLoad()
	this:RegisterEvent("OPEN_YUANBAOSHOP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UPDATE_BOOTH");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("CLOSE_BOOTH");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("TOGGLE_YUANBAOSHOP");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UPDATE_ZENGDIAN");
	this:RegisterEvent("UI_COMMAND");
end

function ShopCustom_OnLoad()
	SHOP_KEY[01] = ShopCustom_Button01
	SHOP_KEY[02] = ShopCustom_Button02
	SHOP_KEY[03] = ShopCustom_Button03
	SHOP_KEY[04] = ShopCustom_Button04
	SHOP_KEY[05] = ShopCustom_Button05
	SHOP_KEY[06] = ShopCustom_Button06
	SHOP_KEY[07] = ShopCustom_Button07
	SHOP_KEY[08] = ShopCustom_Button08
	SHOP_KEY[09] = ShopCustom_Button09
	SHOP_KEY[10] = ShopCustom_Button10
	SHOP_KEY[11] = ShopCustom_Button11
	SHOP_KEY[12] = ShopCustom_Button12
	
	SHOP_DETAIL[01] = ShopCustom_Detail01
	SHOP_DETAIL[02] = ShopCustom_Detail02
	SHOP_DETAIL[03] = ShopCustom_Detail03
	SHOP_DETAIL[04] = ShopCustom_Detail04
	SHOP_DETAIL[05] = ShopCustom_Detail05
	SHOP_DETAIL[06] = ShopCustom_Detail06
	SHOP_DETAIL[07] = ShopCustom_Detail07
	SHOP_DETAIL[08] = ShopCustom_Detail08
	SHOP_DETAIL[09] = ShopCustom_Detail09
	SHOP_DETAIL[10] = ShopCustom_Detail10
	
	SHOP_ITEM[01] = ShopCustom_Item01
	SHOP_ITEM[02] = ShopCustom_Item02
	SHOP_ITEM[03] = ShopCustom_Item03
	SHOP_ITEM[04] = ShopCustom_Item04
	SHOP_ITEM[05] = ShopCustom_Item05
	SHOP_ITEM[06] = ShopCustom_Item06
	SHOP_ITEM[07] = ShopCustom_Item07
	SHOP_ITEM[08] = ShopCustom_Item08
	SHOP_ITEM[09] = ShopCustom_Item09
	SHOP_ITEM[10] = ShopCustom_Item10
	SHOP_ITEM[11] = ShopCustom_Item11
	SHOP_ITEM[12] = ShopCustom_Item12
	SHOP_ITEM[13] = ShopCustom_Item13
	SHOP_ITEM[14] = ShopCustom_Item14
	SHOP_ITEM[15] = ShopCustom_Item15
	SHOP_ITEM[16] = ShopCustom_Item16
	SHOP_ITEM[17] = ShopCustom_Item17
	SHOP_ITEM[18] = ShopCustom_Item18
	SHOP_ITEM[19] = ShopCustom_Item19
	SHOP_ITEM[20] = ShopCustom_Item20
	
	SHOP_ITEM_NUM[01] = ShopCustom_Item01_Num
	SHOP_ITEM_NUM[02] = ShopCustom_Item02_Num
	SHOP_ITEM_NUM[03] = ShopCustom_Item03_Num
	SHOP_ITEM_NUM[04] = ShopCustom_Item04_Num
	SHOP_ITEM_NUM[05] = ShopCustom_Item05_Num
	SHOP_ITEM_NUM[06] = ShopCustom_Item06_Num
	SHOP_ITEM_NUM[07] = ShopCustom_Item07_Num
	SHOP_ITEM_NUM[08] = ShopCustom_Item08_Num
	SHOP_ITEM_NUM[09] = ShopCustom_Item09_Num
	SHOP_ITEM_NUM[10] = ShopCustom_Item10_Num
	SHOP_ITEM_NUM[11] = ShopCustom_Item11_Num
	SHOP_ITEM_NUM[12] = ShopCustom_Item12_Num
	SHOP_ITEM_NUM[13] = ShopCustom_Item13_Num
	SHOP_ITEM_NUM[14] = ShopCustom_Item14_Num
	SHOP_ITEM_NUM[15] = ShopCustom_Item15_Num
	SHOP_ITEM_NUM[16] = ShopCustom_Item16_Num
	SHOP_ITEM_NUM[17] = ShopCustom_Item17_Num
	SHOP_ITEM_NUM[18] = ShopCustom_Item18_Num
	SHOP_ITEM_NUM[19] = ShopCustom_Item19_Num
	SHOP_ITEM_NUM[20] = ShopCustom_Item20_Num
	
	SHOP_ITEM_NAME[01] = ShopCustom_ItemInfo01_Text
	SHOP_ITEM_NAME[02] = ShopCustom_ItemInfo02_Text
	SHOP_ITEM_NAME[03] = ShopCustom_ItemInfo03_Text
	SHOP_ITEM_NAME[04] = ShopCustom_ItemInfo04_Text
	SHOP_ITEM_NAME[05] = ShopCustom_ItemInfo05_Text
	SHOP_ITEM_NAME[06] = ShopCustom_ItemInfo06_Text
	SHOP_ITEM_NAME[07] = ShopCustom_ItemInfo07_Text
	SHOP_ITEM_NAME[08] = ShopCustom_ItemInfo08_Text
	SHOP_ITEM_NAME[09] = ShopCustom_ItemInfo09_Text
	SHOP_ITEM_NAME[10] = ShopCustom_ItemInfo10_Text
	SHOP_ITEM_NAME[11] = ShopCustom_ItemInfo11_Text
	SHOP_ITEM_NAME[12] = ShopCustom_ItemInfo12_Text
	SHOP_ITEM_NAME[13] = ShopCustom_ItemInfo13_Text
	SHOP_ITEM_NAME[14] = ShopCustom_ItemInfo14_Text
	SHOP_ITEM_NAME[15] = ShopCustom_ItemInfo15_Text
	SHOP_ITEM_NAME[16] = ShopCustom_ItemInfo16_Text
	SHOP_ITEM_NAME[17] = ShopCustom_ItemInfo17_Text
	SHOP_ITEM_NAME[18] = ShopCustom_ItemInfo18_Text
	SHOP_ITEM_NAME[19] = ShopCustom_ItemInfo19_Text
	SHOP_ITEM_NAME[20] = ShopCustom_ItemInfo20_Text
	
	SHOP_ITEM_PRICE[01] = ShopCustom_ItemInfo01_GB
	SHOP_ITEM_PRICE[02] = ShopCustom_ItemInfo02_GB
	SHOP_ITEM_PRICE[03] = ShopCustom_ItemInfo03_GB
	SHOP_ITEM_PRICE[04] = ShopCustom_ItemInfo04_GB
	SHOP_ITEM_PRICE[05] = ShopCustom_ItemInfo05_GB
	SHOP_ITEM_PRICE[06] = ShopCustom_ItemInfo06_GB
	SHOP_ITEM_PRICE[07] = ShopCustom_ItemInfo07_GB
	SHOP_ITEM_PRICE[08] = ShopCustom_ItemInfo08_GB
	SHOP_ITEM_PRICE[09] = ShopCustom_ItemInfo09_GB
	SHOP_ITEM_PRICE[10] = ShopCustom_ItemInfo10_GB
	SHOP_ITEM_PRICE[11] = ShopCustom_ItemInfo11_GB
	SHOP_ITEM_PRICE[12] = ShopCustom_ItemInfo12_GB
	SHOP_ITEM_PRICE[13] = ShopCustom_ItemInfo13_GB
	SHOP_ITEM_PRICE[14] = ShopCustom_ItemInfo14_GB
	SHOP_ITEM_PRICE[15] = ShopCustom_ItemInfo15_GB
	SHOP_ITEM_PRICE[16] = ShopCustom_ItemInfo16_GB
	SHOP_ITEM_PRICE[17] = ShopCustom_ItemInfo17_GB
	SHOP_ITEM_PRICE[18] = ShopCustom_ItemInfo18_GB
	SHOP_ITEM_PRICE[19] = ShopCustom_ItemInfo19_GB
	SHOP_ITEM_PRICE[20] = ShopCustom_ItemInfo20_GB
	
	SHOP_ITEM_MASK[01] = ShopCustom_Item01_Mask
	SHOP_ITEM_MASK[02] = ShopCustom_Item02_Mask
	SHOP_ITEM_MASK[03] = ShopCustom_Item03_Mask
	SHOP_ITEM_MASK[04] = ShopCustom_Item04_Mask
	SHOP_ITEM_MASK[05] = ShopCustom_Item05_Mask
	SHOP_ITEM_MASK[06] = ShopCustom_Item06_Mask
	SHOP_ITEM_MASK[07] = ShopCustom_Item07_Mask
	SHOP_ITEM_MASK[08] = ShopCustom_Item08_Mask
	SHOP_ITEM_MASK[09] = ShopCustom_Item09_Mask
	SHOP_ITEM_MASK[10] = ShopCustom_Item10_Mask
	SHOP_ITEM_MASK[11] = ShopCustom_Item11_Mask
	SHOP_ITEM_MASK[12] = ShopCustom_Item12_Mask
	SHOP_ITEM_MASK[13] = ShopCustom_Item13_Mask
	SHOP_ITEM_MASK[14] = ShopCustom_Item14_Mask
	SHOP_ITEM_MASK[15] = ShopCustom_Item15_Mask
	SHOP_ITEM_MASK[16] = ShopCustom_Item16_Mask
	SHOP_ITEM_MASK[17] = ShopCustom_Item17_Mask
	SHOP_ITEM_MASK[18] = ShopCustom_Item18_Mask
	SHOP_ITEM_MASK[19] = ShopCustom_Item19_Mask
	SHOP_ITEM_MASK[20] = ShopCustom_Item20_Mask
end

function ShopCustom_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 1021001 then 

		-- if this:IsVisible() then
			-- this:Hide();
			-- return;
		-- end
		
		local Type = Get_XParam_STR(0)
		
		if Type == "0" then
			local ShopKey = Get_XParam_STR(1)
			local ShopKeyID = Get_XParam_STR(2)
			ShopCustom_UpdateShopKey(ShopKey, ShopKeyID)
			
		elseif Type == "1" then
			local ShopDetail = Get_XParam_STR(1)
			local ShopDetailID = Get_XParam_STR(2)
			ShopCustom_UpdateShopDetail(ShopDetail, ShopDetailID)
			
		elseif Type == "2" then
			ShopItem_Page = Get_XParam_STR(1)
			ShopItem_Money = Get_XParam_STR(2)
			
			local ShopItem_ID = Get_XParam_STR(3)
			local ShopItem_Num = Get_XParam_STR(4)
			local ShopItem_Price = Get_XParam_STR(5)
			local ShopItem_Time = Get_XParam_STR(6)
			ShopCustom_UpdateItem(ShopItem_ID, ShopItem_Num, ShopItem_Price, ShopItem_Time)
		end
		
		this:Show();
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 1021002 then
		ShopCustom_Hidden()
	end

	if ( event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEAVE_WORLD") then
		ShopCustom_Hidden()
	end

	if event == "UPDATE_YUANBAO" then
		-- ShopCustom_YuanbaoText:SetText("#YNguyên Bäo: "..tostring(Player:GetData("YUANBAO")))
		local YuanbaoMD = DataPool:GetPlayerMission_DataRound(310)
		ShopCustom_YuanbaoText:SetText("#YNguyên Bäo: "..tostring(YuanbaoMD))
	end

	if event == "UPDATE_ZENGDIAN" then
		ShopCustom_ZengdianText:SetText("#GĞi¬m T£ng: "..tostring(Player:GetData("ZENGDIAN")))
	end
end

function ShopCustom_Update()
	
	
end

function ShopCustom_UpdatePageUI(ShopItem_Page)
	local ShopItem_Page_Array = ShopCustom_StringSplit(ShopItem_Page, ",")
	local First = 1;
	local Last = tonumber(ShopItem_Page_Array[2]);
	ShopItem_Current = tonumber(ShopItem_Page_Array[1]);
	
	ShopCustom_UpPage:Enable()
	ShopCustom_DownPage:Enable()
	ShopCustom_CurrentlyPage:SetText(ShopItem_Current.."/"..Last)
	
	if ShopItem_Current == First then
		ShopCustom_UpPage:Disable()
	end
	
	if ShopItem_Current == Last then
		ShopCustom_DownPage:Disable()
	end
end

function ShopCustom_UpdateShopKey(ShopKey, ShopKeyID)
	for i = 1, 12 do
		SHOP_KEY[i]:Hide()
	end
	
	local ShopKey_Array = ShopCustom_StringSplit(ShopKey,",")
	SHOP_KEY_ID = ShopCustom_StringSplit(ShopKeyID,",")
	
	for i = 1, table.getn(ShopKey_Array) do
		SHOP_KEY[i]:SetText(ShopKey_Array[i])
		SHOP_KEY[i]:SetCheck(0)
		SHOP_KEY[i]:Show()
	end
	
	local Rand = math.random(100,400)
	local Icon = "";
	if Rand >= 100 and Rand <= 200 then
		Icon = math.random(101,136)
	elseif Rand >= 201 and Rand <= 300 then
		Icon = math.random(201,236)
	elseif Rand >= 301 and Rand <= 400 then
		Icon = math.random(301,333)
	end
	ShopCustom_FunnyText:SetText("#"..Icon)
	
	for i = 1, 10 do
		SHOP_DETAIL[i]:Hide()
	end
	
	for i = 1, 20 do
		SHOP_ITEM[i]:SetActionItem(-1)
		SHOP_ITEM_NUM[i]:SetText("")
		SHOP_ITEM_NAME[i]:SetText("")
		SHOP_ITEM_PRICE[i]:SetText("")
		SHOP_ITEM_MASK[i]:Hide()
	end
	
	ShopCustom_CurrentlyPage:SetText("")
	ShopCustom_UpPage:Disable()
	ShopCustom_DownPage:Disable()
	
	----------------
	SHOP_KEY[01]:SetCheck(1)
	nDetail = -1;
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045060)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_Parameter(1,tonumber(SHOP_KEY_ID[1]))
	Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
end

function ShopCustom_UpdateShopDetail(ShopDetail, ShopDetailID)
	for i = 1, 10 do
		SHOP_DETAIL[i]:Hide()
	end
	
	local ShopDetail_Array = ShopCustom_StringSplit(ShopDetail,",")
	SHOP_DETAIL_ID = ShopCustom_StringSplit(ShopDetailID,",")
	for i = 1, table.getn(ShopDetail_Array) do
		SHOP_DETAIL[i]:SetText(ShopDetail_Array[i])
		SHOP_DETAIL[i]:SetCheck(0)
		SHOP_DETAIL[i]:Show()
	end
	
	for i = 1, 20 do
		SHOP_ITEM[i]:SetActionItem(-1)
		SHOP_ITEM_NUM[i]:SetText("")
		SHOP_ITEM_NAME[i]:SetText("")
		SHOP_ITEM_PRICE[i]:SetText("")
		SHOP_ITEM_MASK[i]:Hide()
	end
	
	ShopCustom_CurrentlyPage:SetText("")
	ShopCustom_UpPage:Disable()
	ShopCustom_DownPage:Disable()
	
	----------------
	SHOP_DETAIL[01]:SetCheck(1)
	nDetail = 1;
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045060)
	Set_XSCRIPT_Parameter(0,2)
	Set_XSCRIPT_Parameter(1,tonumber(SHOP_DETAIL_ID[1]))
	Set_XSCRIPT_Parameter(2,1)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
end

function ShopCustom_UpdateItem(ShopItem_ID, ShopItem_Num, ShopItem_Price, ShopItem_Time)
	local ShopItem_ID_Array = ShopCustom_StringSplitID(ShopItem_ID)
	local ShopItem_Num_Array = ShopCustom_StringSplit(ShopItem_Num,",")
	local ShopItem_Price_Array = ShopCustom_StringSplit(ShopItem_Price,",")
	local ShopItem_Time_Array = ShopCustom_StringSplit(ShopItem_Time,",")
	
	ShopItem_TimeArray = ShopItem_Time_Array;
	
	for i = 1, 20 do
		SHOP_ITEM[i]:SetActionItem(-1)
		SHOP_ITEM_NUM[i]:SetText("")
		SHOP_ITEM_NAME[i]:SetText("")
		SHOP_ITEM_PRICE[i]:SetText("")
		SHOP_ITEM_MASK[i]:Hide()
	end
	
	for i = 1, table.getn(ShopItem_ID_Array) do
		local Index = GemMelting:UpdateProductAction(tonumber(ShopItem_ID_Array[i]));
		SHOP_ITEM[i]:SetActionItem(Index:GetID());
		if ShopItem_Num_Array[i] ~= "1" then
			SHOP_ITEM_NUM[i]:SetText("#e010101#W"..ShopItem_Num_Array[i])
		end
		
		if ShopItem_Num_Array[i] == "0" then
			SHOP_ITEM_MASK[i]:Show()
		end
		
		SHOP_ITEM_NAME[i]:SetText("#{_ITEM"..ShopItem_ID_Array[i].."}")
		
		if ShopItem_Money == "1" then
			SHOP_ITEM_PRICE[i]:SetText(ShopCustom_Money[tonumber(ShopItem_Money)]..": "..ShopItem_Price_Array[i].."#-02")
		elseif ShopItem_Money == "8" then
			SHOP_ITEM_PRICE[i]:SetText(ShopCustom_Money[tonumber(ShopItem_Money)]..": "..ShopItem_Price_Array[i].."#-14")
		else
			SHOP_ITEM_PRICE[i]:SetText(ShopCustom_Money[tonumber(ShopItem_Money)]..": "..ShopItem_Price_Array[i])
		end
	end
	
	ShopCustom_UpdatePageUI(ShopItem_Page)
end

function ShopCustom_KeySelected(nIndex)
	if nIndex == nKey then
		return
	end
	nKey = nIndex;
	nDetail = -1;
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045060)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_Parameter(1,tonumber(SHOP_KEY_ID[nKey]))
	Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
end

function ShopCustom_DetailSelected(nIndex)
	if nIndex == nDetail then
		return
	end
	nDetail = nIndex;
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045060)
	Set_XSCRIPT_Parameter(0,2)
	Set_XSCRIPT_Parameter(1,tonumber(SHOP_DETAIL_ID[nDetail]))
	Set_XSCRIPT_Parameter(2,1)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
end

function ShopCustom_Item_Clicked(nIndex)
	local Index = SHOP_ITEM[nIndex]:GetActionItem()
	if Index == -1 then
		return
	end
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045060)
	Set_XSCRIPT_Parameter(0,3)
	Set_XSCRIPT_Parameter(1,tonumber(SHOP_DETAIL_ID[nDetail]))
	Set_XSCRIPT_Parameter(2,ShopItem_Current)
	Set_XSCRIPT_Parameter(3,nIndex)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT();
end

function ShopCustom_Up()
	ShopItem_Current = ShopItem_Current - 1
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045060)
	Set_XSCRIPT_Parameter(0,2)
	Set_XSCRIPT_Parameter(1,tonumber(SHOP_DETAIL_ID[nDetail]))
	Set_XSCRIPT_Parameter(2,ShopItem_Current)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
end

function ShopCustom_Down()
	ShopItem_Current = ShopItem_Current + 1
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045060)
	Set_XSCRIPT_Parameter(0,2)
	Set_XSCRIPT_Parameter(1,tonumber(SHOP_DETAIL_ID[nDetail]))
	Set_XSCRIPT_Parameter(2,ShopItem_Current)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
end

function ShopCustom_FittingEQ()
	-- RestoreShopFitting();
	-- this:Show();
	MouseCmd_ShopFittingSet();
end

function ShopCustom_Hidden()
	nKey = -1
	nDetail = -1
	this:Hide()
end

local ShowTime = 0;

function ShopCustom_Item_Hover(nIndex)
	ShowTime = ShopItem_TimeArray[nIndex]
end

function ShopCustom_Item_Leave()
	ShowTime = 0;
end

function GlobalShowTime()
	return ShowTime
end

function ShopCustom_StringSplit(FullString, Separator)
	local SplitIndex = 1
	local SplitTemp = 1;
	local SplitArray = {}
	for i = 1, string.len(FullString) do
		if string.sub(FullString,i,i) == Separator then
			SplitArray[SplitIndex] = string.sub(FullString,SplitTemp,i-1)
			SplitIndex = SplitIndex + 1;
			SplitTemp = i + 1;
		end
	end
	return SplitArray;
end

function ShopCustom_StringSplitID(FullString)
	local SplitMax = string.len(FullString)/8
	local SplitArray = {}
	
	for i = 1, SplitMax do
		SplitArray[i] = string.sub(FullString,(i-1)*8+1,i*8)
	end
	
	return SplitArray;
end

function ShopCustom_OpenWeb()
	GameProduceLogin:OpenURL( "https://tlbbwinner.com/" )
end

function ShopCustom_TradeKNB()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(45002)
		Set_XSCRIPT_Parameter(0, 3)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function ShopCustom_CardKNB()
	PushEvent("UI_COMMAND",1022001)
end