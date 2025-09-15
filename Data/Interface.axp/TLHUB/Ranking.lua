Ranking_Index = -1;
Ranking_Array = {}
Ranking_Menpai = {"Thiªu Lâm","Minh Giáo","Cái Bang","Võ Ðang","Nga My","Tinh Túc","Thiên Long","Thiên S½n","Tiêu Dao","Chßa Có"}

function Ranking_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("MAINTARGET_CHANGED");
end

function Ranking_OnLoad()

end

function Ranking_OnEvent(event)
	
	-- PushEvent("UI_COMMAND",1020001)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 1003001 then

		if this:IsVisible() then
			this:Hide();
			return;
		end
		Ranking_OnShow()
		this:Show();
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 1003002 then
		for i = 1, 10 do
			Ranking_Array[i] = Get_XParam_STR(i)
		end
		Ranking_Update()
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		Ranking_OnHidden();
		return;
	end
end

function Ranking_OnShow()
	Ranking_List:RemoveAllItem()
	Ranking_Update_Clicked()
	-- for i = 1, 10 do
		-- Ranking_List:AddNewItem(i,0,i-1)
		-- Ranking_List:AddNewItem("3C336082",1,i-1)
		-- Ranking_List:AddNewItem("Nimda "..i,2,i-1)
		-- Ranking_List:AddNewItem("99",3,i-1)
		-- Ranking_List:AddNewItem("2020-05-14_19:59:59",4,i-1)
	-- end
end

function Ranking_Update()
	Ranking_List:RemoveAllItem()
	for i = 1, 10 do
		CharName = string.sub(Ranking_Array[i],string.find(Ranking_Array[i],"-")+1,string.find(Ranking_Array[i],"=")-1);
	
		if CharName ~= "@Name" then		
			CharID = string.sub(Ranking_Array[i],1,string.find(Ranking_Array[i],"-")-1);
			CharLevel = string.sub(Ranking_Array[i],string.find(Ranking_Array[i],"=")+1,string.find(Ranking_Array[i],":")-1);
			CharMenp = string.sub(Ranking_Array[i],string.find(Ranking_Array[i],":")+1,string.find(Ranking_Array[i],"+")-1);
			CharMenpStr = Ranking_Menpai[tonumber(CharMenp)+1]
			CharTime = string.sub(Ranking_Array[i],string.find(Ranking_Array[i],"+")+1,string.len(Ranking_Array[i]));
			
			Ranking_List:AddNewItem(" "..i,0,i-1)
			Ranking_List:AddNewItem(" "..Ranking_Dec2Hex(tostring(CharID)),1,i-1)
			Ranking_List:AddNewItem(" "..CharName,2,i-1)
			Ranking_List:AddNewItem(" "..CharMenpStr,3,i-1)
			Ranking_List:AddNewItem(" "..CharLevel,4,i-1)
			Ranking_List:AddNewItem(" "..CharTime,5,i-1)
		end
	end
end

function Ranking_Update_Clicked()
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045002)
	Set_XSCRIPT_Parameter(0,5)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

function Ranking_Dec2Hex(s)
	s = string.format("%x", s)
	return string.upper(s)
end

function Ranking_Help()
	PushDebugMessage("Bäng Xªp HÕng")
end

function Ranking_OnHidden()
	
	this:Hide()
end