local i = 0;
local max_index = 3;
local max_size = 400;
--根据目前的宽度只能显示20个汉字，如果以后修改宽度的话，这里也可以适当加长。

function DebugListBox_PreLoad()
	this:RegisterEvent("APPLICATION_INITED");
	this:RegisterEvent("NEW_DEBUGMESSAGE");

end

function DebugListBox_OnLoad()

--  FadingFrame_SetFadeInTime(this, 0.5);
--	FadingFrame_SetHoldTime(this, 1.0);
--	FadingFrame_SetFadeOutTime(this, 2.0);

end

function DebugListBox_OnEvent(event)
	if ( event == "APPLICATION_INITED" ) then
		this:Show();
		DebugListBox_ListBox : ClearListBox();

	return;
	elseif (event == "NEW_DEBUGMESSAGE") then
		DebugListBox_Update(arg0);
		return;
	end
end

function DebugListBox_OnShown()

end

function DebugListBox_Update(arg0)
	this:Show();
	local str;
	AxTrace(0,5,"listbox = " .. arg0)
	local fontcolor,extencolor;
	fontcolor,extencolor = DataPool:GetUIColor(1000);
	arg0=string.gsub(arg0,"15级以下不允许进行金钱交易。","#{GMGameInterface_Script_Exchange_Info_ExchangeFailedUnder15}")
	arg0=string.gsub(arg0,"距离太远，无法选中该玩家。","#{GMGameInterface_Script_Character_Info_TooFarToSelect}")
	arg0=string.gsub(arg0,"物品已加锁！","#{Item_Locked}")
	
	if(fontcolor == "-1") then
		fontcolor = "00FFFF";
	end

	if(extencolor == "-1") then
		extencolor = "010101";
	end
	
	if(string.len(arg0) > max_size) then
		if(DataPool:Check_StringCode(string.sub(arg0,1,max_size)) == 0) then
				str = string.sub(arg0,1,max_size-1);
				AxTrace(0,1,"Error str = "..str)
		else
				str = string.sub(arg0,1,max_size);
				AxTrace(0,1,"Right str = "..str)
		end
		
		DebugListBox_ListBox:AddInfo( "#c"..fontcolor .. "#e" .. extencolor .. str );
		return;
	end
	DebugListBox_ListBox:AddInfo( "#c"..fontcolor.."#e" .. extencolor .. arg0 );
end
