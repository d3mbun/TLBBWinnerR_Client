--   PlayerList   
--   PlayerList_List
local pl = {}
local MAX_PLAYER_IDX = 16


local g_PlayerList_Frame_UnifiedXPosition;
local g_PlayerList_Frame_UnifiedYPosition;

function PlayerList_PreLoad()

	this:RegisterEvent("PLAYERLIST_SHOW");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end


function PlayerList_OnLoad()

	pl = {	
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY"},		
	   }
	
	   g_PlayerList_Frame_UnifiedXPosition	= PlayerList_Frame:GetProperty("UnifiedXPosition");
		 g_PlayerList_Frame_UnifiedYPosition	= PlayerList_Frame:GetProperty("UnifiedYPosition");
	
end


function PlayerList_OnEvent( event )

	if ( event == "PLAYERLIST_SHOW" ) then
		if( this:IsVisible() ) then
			PlayerList_Hide();
		else
			PlayerList_Show();
		end
	elseif( event == "ADJEST_UI_POS" ) then
		PlayerList_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		PlayerList_ResetPos()
		
	end
end

function PlayerList_Update(flag)
	
	
	PlayerList_List:ClearListBox();
	local color = "";
	local color_real = "";
	local icostr = "";
	if flag == false then
		color = "#cFF0000"
	elseif flag == true then
		color = "#c00FF00"
	end


	
	for i = 1 ,MAX_PLAYER_IDX do
		if (pl[i].id ~= -1) then
			local na = pl[i].name
			if na == "" then na = "N/A" end

			local lv = pl[i].level
			
			local bp = pl[i].guild
			if bp == "" then bp = "N/A" end
			
			local mp = pl[i].menpai
			if mp == "" then mp= "Kh鬾g" end
			
			if pl[i].iconstr == "ENEMY" then
				icostr="#-18"
				color_real = color
			elseif pl[i].iconstr == "FLAG" then
				icostr="#-22"
				color_real = color.."#b"
			else
				icostr="#-17"
				color_real = color
			end

			local str = string.format("%s%s%-14s#cFFFFFF%4d c#r #c00B0F0%-14s#cFFFF00%6s",icostr, color_real ,na ,lv, bp, mp);	
			PlayerList_List:AddItem( str, i, "FFFFFFFF", 4 );
		end
	end
	
end

--选择目标
function PlayerList_PlayerSelect(isAttack )
	local idx = PlayerList_List:GetFirstSelectItem();
	
	if idx < 1 or idx > MAX_PLAYER_IDX then
		return
	end

	local iii = PlayerList_Item_Check4:GetCheck()

	if isAttack == 1 and pl[idx].isFriend == false and iii == 1 then 
		SetMainTargetFromList(pl[idx].id , pl[idx].isFriend ,true)
	else
		SetMainTargetFromList(pl[idx].id , pl[idx].isFriend ,false)
	end
end

--关闭
function PlayerList_Hide()
	this:Hide();
end

--弹出
function PlayerList_Show()
	
	PlayerList_ChannalChange(false);
	PlayerList_EnmeyList:SetCheck(1);
	PlayerList_PlayerList1:SetCheck(0);
	
	if tonumber(Variable:GetVariable("DBAttack")) == 1 then
		PlayerList_Item_Check4:SetCheck( 1 )
	else
		PlayerList_Item_Check4:SetCheck( 0 )
	end
	this:Show();
end

--友好敌对切换
function PlayerList_ChannalChange( flag )
	
	UpdatePlayerList(flag);
	
	for i = 1 ,MAX_PLAYER_IDX do
		pl[i].id = -1;
	end

	for i=1, MAX_PLAYER_IDX   do
		pl[i].id , pl[i].name , pl[i].level , pl[i].guild , pl[i].menpai ,pl[i].iconstr = GetPlayerFromList(i - 1) ;
		pl[i].isFriend = flag;
	end 
	PlayerList_Update(flag);
end

--帮助
function PlayerList_OnHelp()
	Helper:GotoHelper("*PlayerList");
end

--右键菜单
function PlayerList_OpenMenu()

end


function PlayerList_DBAttack_Clicked()

	local temp = PlayerList_Item_Check4:GetCheck();

	Variable:SetVariable("DBAttack",tostring(temp), 0);

end

function PlayerList_ResetPos()
	PlayerList_Frame:SetProperty("UnifiedXPosition", g_PlayerList_Frame_UnifiedXPosition);
	PlayerList_Frame:SetProperty("UnifiedYPosition", g_PlayerList_Frame_UnifiedYPosition);

end