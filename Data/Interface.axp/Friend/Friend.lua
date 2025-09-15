
local currentList = 1;
local FRIEND_TAB_TEXT = {};
--===============================================
-- OnLoad()
--===============================================
function Friend_PreLoad()

	this:RegisterEvent("TOGLE_FRIEND");

	this:RegisterEvent("UPDATE_FRIEND");

	this:RegisterEvent("UPDATE_FRIEND_INFO");

	this:RegisterEvent("MOOD_CHANGE");
	this:RegisterEvent("AGNAME_CHANGE");
	

end

function Friend_OnLoad()
	FRIEND_TAB_TEXT = {
		"1",
		"2",
		"3",
		"4",
		"B¤t hæu",
		"Thù nhân",
		[8] = "BÕn",
	};
end

--===============================================
-- OnEvent()
--===============================================
function Friend_OnEvent( event )
	
	if ( event == "TOGLE_FRIEND" ) then
		if( arg0 == "2" ) then
			AxTrace( 0,0, "Open Friend Window" );
			if( this:IsVisible() ) then
				Friend_Hide();
			else
				Friend_Show();
			end
		elseif ( arg0 == "1" ) then
			Friend_Show();
		else
			Friend_Hide();
		end
		
		Friend_UpdateAgname();
	elseif( event == "UPDATE_FRIEND" ) then
		
		if( tonumber( arg0 ) == currentList ) then
			Friend_Update();
		end
	elseif( event == "UPDATE_FRIEND_INFO" ) then
		if( tonumber( arg0 ) == currentList ) then
			UpdateFriendInfo( tonumber( arg0 ), tonumber( arg1 ) );
		end
	elseif( event == "MOOD_CHANGE" ) then
		Friend_TargetExplain:SetText( DataPool:GetMood() );
	elseif( event == "AGNAME_CHANGE" ) then
		Friend_UpdateAgname();
	end

end
function Friend_UpdateAgname()
	Friend_Agname_Text:SetText( Player:GetCurrentAgname() );
end
--===============================================
-- UpdateFrame()
--===============================================
function UpdateFriendInfo( nChannel, nIndex )
	if( this:IsVisible() ) then
		local name = DataPool:GetFriend( nChannel, nIndex, "NAME" );
		local emotion = DataPool:GetFriend( nChannel, nIndex, "MOOD" );
		local friendship = DataPool:GetFriend( nChannel, nIndex, "FRIENDSHIP" );
		local relationtype = DataPool:GetFriend( nChannel, nIndex, "RELATION_TYPE" );
	
		local namecolor = "#cC4B299";
		local moodColor = "#cFFCC7A";
		if( DataPool:GetFriend( nChannel, nIndex, "ONLINE" ) ) then
			if( nChannel == 6 ) then
				namecolor="#cFF0000";					--[2007/11/26 liboyu] #c800000----->#cFF0000
			else
				if( relationtype == 7 or relationtype == 8) then
					namecolor = "#cFF6600";	
				elseif( relationtype == 3 ) then
					namecolor = "#cF246F0";		
				elseif( relationtype == 2 ) then
					namecolor = "#c007EFF";		
				elseif( friendship >= 10 ) then  --[2007/08/28 YangJun]
						namecolor = "#c00FF00";		
				elseif( friendship >= 1 ) then	--[2007/08/28 YangJun]
						namecolor = "#c00C800";		
				elseif( friendship == 0 ) then	--[2007/08/28 YangJun]
						namecolor = "#cFFFFFF";		
				end
			end
			if(emotion == "ß€›]ÏëºÃ£¡") then 
				emotion="VçnChßaNghîRa"
			end
				AxTrace( 0, 0, "current index="..tostring( nIndex ).."  current string="..name.."___"..emotion );
				Friend_List:SetListItemText( nIndex, namecolor..name.."#r"..moodColor..emotion);			
		else
			if( nChannel == 6 ) then
				namecolor="#cc7b299";
			end
			Friend_List:SetListItemText( nIndex, namecolor..name);
		end
	end
end


function Friend_Update()

	local friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	Friend_List:ClearListBox();
	AxTrace( 0,0,"for start = "..tostring( friendnumber ).."   current   channel="..tostring( currentList ) );
	local index=0;
	while index < friendnumber  do
		AxTrace( 0,0,"i="..tostring( index ) );
		AxTrace( 0,0,"add item on "..tostring( index ) );
		Friend_List:AddItem( "", index, "FFFFFFFF", 4 );
		AxTrace( 0,0,"update item on "..tostring( index ) );
		UpdateFriendInfo( currentList, index );
		index = index + 1;
	end
	
end



function Friend_Show()
	local Mood = DataPool:GetMood();	
	local mailnumber = DataPool:GetMailNumber();
	if( mailnumber > 0 ) then
		if( Variable:GetVariable( "IsInfoBrowerShow" ) == "False" ) then
			return;
		end
	end
	this:Show();
	if(Mood == "ß€›]ÏëºÃ£¡") then 
	Mood= "VçnChßaNghîRa"
	end
	AxTrace( 0,0, "current mood = "..Mood );
	Friend_TargetName:SetText( "#Y Tâm trÕng:" );
	Friend_TargetExplain:SetText( Mood );
	Friend_Update();
	local channel = Friend:GetCurrentTeam();
	if( channel == 1 ) then
		Friend_Tab1:SetCheck( 1 );
		Friend_SetTabColor(1);
	elseif( channel == 2 ) then
		Friend_Tab2:SetCheck( 1 );
		Friend_SetTabColor(2);
	elseif( channel == 3 ) then
		Friend_Tab3:SetCheck( 1 );
		Friend_SetTabColor(3);
	elseif( channel == 4 ) then
		Friend_Tab4:SetCheck( 1 );
		Friend_SetTabColor(4);
	elseif( channel == 8 ) then
		Friend_Temporary:SetCheck( 1 );
		Friend_SetTabColor(7);
	elseif( channel == 5 ) then
		Friend_BlackList:SetCheck( 1 );
		Friend_SetTabColor(5);
	elseif( channel == 6 ) then
		Friend_EnmeyList:SetCheck( 1 );
		Friend_SetTabColor(6);
	end
end

function Friend_Hide()
	this:Hide();
end

function Friend_ChannalChange( channal )
	currentList = channal;
	Friend:SetCurrentTeam( channal );
	Friend_SetTabColor(channal);
	Friend_Update();
	AxTrace( 0, 0, "current select channal = "..tostring( currentList ) );
end

function Friend_FriendSelect()

	if( Friend:GetCurrentTeam() == 5 ) then
		return;
	end
	
	local index = Friend_List:GetFirstSelectItem();
	if( tonumber( index ) == -1 ) then
		return;
	end
	if( Friend:GetCurrentTeam() == 6 ) then
		PushDebugMessage("Cùng v¾i ð¯i phß½ng quan h® thù nhân, có th¬ sØ døng chuµt phäi ð¬ m· giao di®n.");		
		return;
	end
	Friend:SetCurrentSelect( tonumber( index ) );
	
	local name =  DataPool:GetFriend( Friend:GetCurrentTeam(), tonumber( index ), "NAME" );	
	DataPool:OpenMail( name );
end

function Friend_AddNewFriend()
	if( Target:IsPresent() ) then
		DataPool:AddFriend( Friend:GetCurrentTeam() );
	else
		PrepearAddFriend();
	end
end

function Friend_EditMood()
	DataPool:EditMood();
	
end

function Friend_DelFriend()
	local index = Friend_List:GetFirstSelectItem();
	if( index > -1 ) then
		DataPool:AskDelFriend( currentList, index );
	end
end

function Friend_OpenMenu()
	local index = Friend_List:GetFirstSelectItem();
	Friend:SetCurrentSelect( tonumber( index ) );
	if( index > -1 ) then
		Friend:OpenMenu( tostring( currentList ), tostring( index ) );
	end
end

--ÏÔÊ¾×Ô¼ºµÄÐÄÇé
function Friend_ViewMood_Clicked()
	if(DataPool:GetMood() == "ß€›]ÏëºÃ£¡") then 
	DataPool:SetMood( "VçnChßaNghîRa" );
	end
	Friend:ViewFeel();
end

--Êó±ê½øÈë°´Å¥
function Friend_ViewMood_MouseEnter()
		--ÏÔÊ¾tooltips
		if( Friend:IsMoodInHead() == 1)   then
			Friend_ViewMood:SetToolTip("Sau khi nh¤p vào bi¬u tßþng này, nµi dung tâm trÕng hi¬n th¸ trên avatar s¨ ðßþc ¦n ði.");
		else
			Friend_ViewMood:SetToolTip("Sau khi nh¤p vào bi¬u tßþng này, nµi dung tâm trÕng s¨ ðßþc th¬ hi®n trên avatar");
		end
end

function Friend_SetTabColor(idx)
	if(idx == nil or idx < 1 or idx > 8) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 1;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								Friend_Tab1,
								Friend_Tab2,
								Friend_Tab3,
								Friend_Tab4,
								Friend_BlackList,
								Friend_EnmeyList,
								[8] = Friend_Temporary,
							};
	
	while i < 9 do
		if(i ~= 7) then
			if(i == idx) then
				tab[i]:SetText(selColor..FRIEND_TAB_TEXT[i]);
			else
				tab[i]:SetText(noselColor..FRIEND_TAB_TEXT[i]);
			end
		end
		i = i + 1;
	end
end

function Friend_Search()
	local nNumber = Player:GetData( "LEVEL" );
	if(nNumber~=nil and nNumber>=10) then
		FriendSearcher:OpenFriendSearch();
	else
		PushDebugMessage("C¤p ðµ cüa các hÕ không ðü, ðªn c¤p 10 các hÕ m¾i có th¬ sØ døng tính nång tìm bÕn");
	end;
	
end

function Friend_SystemInfo()
	DataPool:OpenSystemHistroy();
end

function Friend_OnHelp()
	Helper:GotoHelper("*Friend" );
end

function Friend_EnmeyList_OnClicked()
end