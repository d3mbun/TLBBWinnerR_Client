TopDonate_Index = -1;
TopDonate_Array = {}
TopDonate_Menpai = {"Thiªu Lâm","Minh Giáo","Cái Bang","Võ Ðang","Nga My","Tinh Túc","Thiên Long","Thiên S½n","Tiêu Dao","Chßa Có"}

function TopDonate_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("MAINTARGET_CHANGED");
end

function TopDonate_OnLoad()

end

function TopDonate_OnEvent(event)
	
	-- PushEvent("UI_COMMAND",1020001)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 1023001 then

		if this:IsVisible() then
			this:Hide();
			return;
		end
		TopDonate_OnShow()
		this:Show();
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 1023002 then
		for i = 1, 10 do
			TopDonate_Array[i] = Get_XParam_STR(i)
		end
		TopDonate_Update()
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		TopDonate_OnHidden();
		return;
	end
end

function TopDonate_OnShow()
	TopDonate_List:RemoveAllItem()
	TopDonate_Update_Clicked()
end

TopDonate_Var = 0
TopDonate_VarStr = {"dxyy","fhj","wtdh","gamma","yszl","wldx","cy","dbxs","dxgg","rwgg","rwyy","qpfg","cztb","sdh","qpms","ksfw","miwu"}

function TopDonate_Update()
	TopDonate_List:RemoveAllItem()
	for i = 1, 10 do
		CharName = string.sub(TopDonate_Array[i],string.find(TopDonate_Array[i],"-")+1,string.find(TopDonate_Array[i],"=")-1);
	
		if CharName ~= "@Name" then		
			CharID = string.sub(TopDonate_Array[i],1,string.find(TopDonate_Array[i],"-")-1);
			CharDonate = string.sub(TopDonate_Array[i],string.find(TopDonate_Array[i],"=")+1,string.find(TopDonate_Array[i],":")-1);
			
			local MoneyValue = tonumber(CharDonate);
			local ValueLengh = string.len(MoneyValue);
			if MoneyValue >= 1000 and MoneyValue <= 999999 then
				MoneyValue = string.sub(MoneyValue,1,ValueLengh-3).."."..string.sub(MoneyValue,ValueLengh-2,ValueLengh-0)
			elseif MoneyValue >= 1000000 and MoneyValue <= 999999999 then
				MoneyValue = string.sub(MoneyValue,1,ValueLengh-6).."."..string.sub(MoneyValue,ValueLengh-5,ValueLengh-3).."."..string.sub(MoneyValue,ValueLengh-2,ValueLengh-0)
			end
			
			CharMenp = string.sub(TopDonate_Array[i],string.find(TopDonate_Array[i],":")+1,string.find(TopDonate_Array[i],"+")-1);
			CharMenpStr = TopDonate_Menpai[tonumber(CharMenp)+1]
			CharTime = string.sub(TopDonate_Array[i],string.find(TopDonate_Array[i],"+")+1,string.len(TopDonate_Array[i]));
			
			TopDonate_List:AddNewItem(" "..i,0,i-1)
			TopDonate_List:AddNewItem(" "..TopDonate_Dec2Hex(tostring(CharID)),1,i-1)
			TopDonate_List:AddNewItem(" "..CharName,2,i-1)
			TopDonate_List:AddNewItem(" "..CharMenpStr,3,i-1)
			TopDonate_List:AddNewItem(" "..MoneyValue,4,i-1)
			TopDonate_List:AddNewItem(" "..CharTime,5,i-1)
		end
	end
end

function TopDonate_Update_Clicked()
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045002)
	Set_XSCRIPT_Parameter(0,6)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

function TopDonate_Dec2Hex(s)
	s = string.format("%x", s)
	return string.upper(s)
end

function TopDonate_Help()
	PushDebugMessage("Bäng Xªp HÕng")
end

function TopDonate_OnHidden()
	
	this:Hide()
end