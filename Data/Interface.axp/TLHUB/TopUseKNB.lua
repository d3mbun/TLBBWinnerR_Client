TopUseKNB_Index = -1;
TopUseKNB_Array = {}
TopUseKNB_Menpai = {"Thiªu Lâm","Minh Giáo","Cái Bang","Võ Ðang","Nga My","Tinh Túc","Thiên Long","Thiên S½n","Tiêu Dao","Chßa Có"}

function TopUseKNB_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("MAINTARGET_CHANGED");
end

function TopUseKNB_OnLoad()

end

function TopUseKNB_OnEvent(event)
	
	-- PushEvent("UI_COMMAND",1020001)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 1024001 then

		if this:IsVisible() then
			this:Hide();
			return;
		end
		TopUseKNB_OnShow()
		this:Show();
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 1024002 then
		for i = 1, 10 do
			TopUseKNB_Array[i] = Get_XParam_STR(i)
		end
		TopUseKNB_Update()
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		TopUseKNB_OnHidden();
		return;
	end
end

function TopUseKNB_OnShow()
	TopUseKNB_List:RemoveAllItem()
	TopUseKNB_Update_Clicked()
end

TopUseKNB_Var = 0
TopUseKNB_VarStr = {"dxyy","fhj","wtdh","gamma","yszl","wldx","cy","dbxs","dxgg","rwgg","rwyy","qpfg","cztb","sdh","qpms","ksfw","miwu"}

function TopUseKNB_Update()
	TopUseKNB_List:RemoveAllItem()
	for i = 1, 10 do
		CharName = string.sub(TopUseKNB_Array[i],string.find(TopUseKNB_Array[i],"-")+1,string.find(TopUseKNB_Array[i],"=")-1);
	
		if CharName ~= "@Name" then		
			CharID = string.sub(TopUseKNB_Array[i],1,string.find(TopUseKNB_Array[i],"-")-1);
			CharUseKNB = string.sub(TopUseKNB_Array[i],string.find(TopUseKNB_Array[i],"=")+1,string.find(TopUseKNB_Array[i],":")-1);
			
			local MoneyValue = tonumber(CharUseKNB);
			local ValueLengh = string.len(MoneyValue);
			if MoneyValue >= 1000 and MoneyValue <= 999999 then
				MoneyValue = string.sub(MoneyValue,1,ValueLengh-3).."."..string.sub(MoneyValue,ValueLengh-2,ValueLengh-0)
			elseif MoneyValue >= 1000000 and MoneyValue <= 999999999 then
				MoneyValue = string.sub(MoneyValue,1,ValueLengh-6).."."..string.sub(MoneyValue,ValueLengh-5,ValueLengh-3).."."..string.sub(MoneyValue,ValueLengh-2,ValueLengh-0)
			end
			
			CharMenp = string.sub(TopUseKNB_Array[i],string.find(TopUseKNB_Array[i],":")+1,string.find(TopUseKNB_Array[i],"+")-1);
			CharMenpStr = TopUseKNB_Menpai[tonumber(CharMenp)+1]
			CharTime = string.sub(TopUseKNB_Array[i],string.find(TopUseKNB_Array[i],"+")+1,string.len(TopUseKNB_Array[i]));
			
			TopUseKNB_List:AddNewItem(" "..i,0,i-1)
			TopUseKNB_List:AddNewItem(" "..TopUseKNB_Dec2Hex(tostring(CharID)),1,i-1)
			TopUseKNB_List:AddNewItem(" "..CharName,2,i-1)
			TopUseKNB_List:AddNewItem(" "..CharMenpStr,3,i-1)
			TopUseKNB_List:AddNewItem(" "..MoneyValue,4,i-1)
			TopUseKNB_List:AddNewItem(" "..CharTime,5,i-1)
		end
	end
end

function TopUseKNB_Update_Clicked()
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045002)
	Set_XSCRIPT_Parameter(0,7)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

function TopUseKNB_Dec2Hex(s)
	s = string.format("%x", s)
	return string.upper(s)
end

function TopUseKNB_Help()
	PushDebugMessage("Bäng Xªp HÕng")
end

function TopUseKNB_OnHidden()
	
	this:Hide()
end