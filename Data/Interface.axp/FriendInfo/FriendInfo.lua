local IsShow = 0;

local g_name = "";
--===============================================
-- OnLoad()
--===============================================
function FriendInfo_PreLoad()

	this:RegisterEvent("TOGLE_FRIEND_INFO");
	this:RegisterEvent("UPDATE_FRIEND_INFO");
end

function FriendInfo_OnLoad()

end

function FriendInfoSiLiao_Clicked(itemname)
	 Talk:ContexMenuTalk(g_name);
end
--===============================================
-- OnEvent()
--===============================================
function FriendInfo_OnEvent( event )
	
	if ( event == "TOGLE_FRIEND_INFO" ) then
			if( tonumber(arg0) == -1 ) then
				FriendInfo_OnHide();
				return;
			end
			FriendInfo_Show( -1, -1 );
	
	elseif( event == "UPDATE_FRIEND_INFO" ) then
		FriendInfo_Update( arg0, arg1 );
	end

end


--===============================================
-- UpdateFrame()
-- µÚ¼¸¸öÆµµÀµÄµÚ¼¸¸öÈË
--===============================================
function FriendInfo_Update( nChannel, nIndex )
	g_name = "";
	if(IsShow == 1)then
		AxTrace( 0,0,"channel="..tostring(nChannel).."    nIndex"..tostring( nIndex ) );
		local strFaceImage = DataPool:GetFriend( nChannel, nIndex, "PORTRAIT" );
		if( nChannel== -1 ) then
			FriendInfo_PlayerHead:SetProperty("Image", "");
			FriendInfo_PlayerHead:SetProperty("Image", "");
			FriendInfo_ID:SetText( "ID:");
			FriendInfo_Name:SetText( "H÷ tên: " );
			FriendInfo_Level:SetText( "C¤p: " );
			FriendInfo_MenPai:SetText( "Phái:  ");
			FriendInfo_FriendlyGrade:SetText( "Häo hæu: " );
			FriendInfo_Confraternity:SetText( "Bang Hµi: ");
			FriendInfo_GuildLeague:SetText( "#{TM_20080311_30}");
			FriendInfo_Explain:SetText( "Tâm trÕng: " );
			FriendInfo_Relation:SetText( "Quan h®: " );
			FriendInfo_Agname:SetText( "Danh hi®u: " );
			FriendInfo_Locus:SetText( "V¸ trí: " );
			FriendInfo_TeamInfo:SetText( "Nhóm: " );
			
			FriendInfo_Join:SetText( "M¶i vào nhóm" );
			FriendInfo_Join:Disable();
	
		else
			g_name = DataPool:GetFriend( nChannel, nIndex, "NAME"  ) ;
			FriendInfo_PlayerHead:SetProperty("Image", tostring(strFaceImage));
			FriendInfo_ID:SetText( "ID:"..tostring( DataPool:GetFriend( nChannel, nIndex, "ID_TEXT" ) ) );
			FriendInfo_Name:SetText( "H÷ tên: "..DataPool:GetFriend( nChannel, nIndex, "NAME"  ) );
			FriendInfo_Level:SetText( "C¤p: "..tostring( DataPool:GetFriend( nChannel, nIndex, "LEVEL" ) ) );
			if DataPool:GetFriend( nChannel, nIndex, "MENPAI_TYPE" )==10 then
				FriendInfo_MenPai:SetText( "Phái: Mµ Dung");
			else
				FriendInfo_MenPai:SetText( "Phái: "..DataPool:GetFriend( nChannel, nIndex, "MENPAI_TEXT" ) );
			end

			if( tonumber( nChannel ) == 6 ) then 
				FriendInfo_FriendlyGrade:SetText( "Häo hæu: " );
			else
				FriendInfo_FriendlyGrade:SetText( "Häo hæu: "..tostring( DataPool:GetFriend( nChannel, nIndex, "FRIENDSHIP" ) ) );
			end
			FriendInfo_Confraternity:SetText( "Bang Hµi: "..DataPool:GetFriend( nChannel, nIndex, "GUID_NAME" ) );
			FriendInfo_GuildLeague:SetText( "#{TM_20080311_30}"..DataPool:GetFriend( nChannel, nIndex, "GUILD_LEAGUE_NAME" ) );
			if DataPool:GetFriend( nChannel, nIndex, "MOOD" ) == "ß€›]ÏëºÃ£¡" then 
				FriendInfo_Explain:SetText( "Tâm trÕng: VçnChßaNghîRa" );
			else
				FriendInfo_Explain:SetText( "Tâm trÕng: "..DataPool:GetFriend( nChannel, nIndex, "MOOD" ) );
			end
			
			if( tonumber( nChannel ) == 6 ) then 
				FriendInfo_Relation:SetText( "Quan h®: Giao ác" );
			else
				FriendInfo_Relation:SetText( "Quan h®: "..DataPool:GetFriend( nChannel, nIndex, "RELATION_TEXT" ) );
			end
			
			
			FriendInfo_Agname:SetText( "Danh hi®u: "..DataPool:GetFriend( nChannel, nIndex, "TITLE" ) );
			FriendInfo_Locus:SetText( "V¸ trí: "..DataPool:GetFriend( nChannel, nIndex, "SCENE" ) );
			FriendInfo_TeamInfo:SetText( "Nhóm: "..DataPool:GetFriend( nChannel, nIndex, "TEAM_NUMBER" ) );
			local TeamNumber = DataPool:GetFriend( nChannel, nIndex, "TEAM_NUMBER" );
			FriendInfo_Join:Enable();
			if( TeamNumber == "Chßa l§p ðµi" ) then
				FriendInfo_Join:SetText( "M¶i Vào" );
			else
				FriendInfo_Join:SetText( "Xin Vào" );
			end
		end
		if( tonumber( nChannel ) == 5 ) then 
			FriendInfo_Join:Hide();
			FriendInfo_Groupinge:Hide();
			FriendInfo_Correspondence:Hide();
		else
			FriendInfo_Join:Show();
			FriendInfo_Groupinge:Show();
			FriendInfo_Correspondence:Show();
		end
		this:Show();
	end;
	
end

function FriendInfo_Show( arg_0, arg_1 )
		
	--FriendInfo_Update( Friend:GetCurrentTeam() ,Friend:GetCurrentSelect());
	--this:Show();
	IsShow = 1;
end

function FriendInfo_OnHide()
	this:Hide();
	IsShow = 0;
end

function FriendInfo_WriteMail()
	if(g_name == "") then
		return;
	end
	local group,index = DataPool:GetFriendByName(g_name);
	if(tonumber(group) ~=-1 and tonumber(index)~=-1)then
		DataPool:OpenMail( g_name );
	else
		PushDebugMessage("Thao tác th¤t bÕi, V¸ häo hæu này không t°n tÕi.")
		FriendInfo_OnHide();
	end
end

function FriendInfo_OnHelp()
end

function FriendInfo_OnHistroy()
	if(g_name == "") then
		return;
	end
	local group,index = DataPool:GetFriendByName(g_name);
	if(tonumber(group) ~=-1 and tonumber(index)~=-1)then
		DataPool:OpenHistroy(tonumber(group) ,tonumber(index) );
	else
		PushDebugMessage("Thao tác th¤t bÕi, V¸ häo hæu này không t°n tÕi.")
		FriendInfo_OnHide();
	end
	
end

function FriendInfo_OnJoin()
	if(g_name == "") then
		return;
	end
	local group,index = DataPool:GetFriendByName(g_name);
	if(tonumber(group) ~=-1 and tonumber(index)~=-1)then
		local TeamNumber = DataPool:GetFriend(tonumber(group) ,tonumber(index), "TEAM_NUMBER" );
		if( TeamNumber == "Chßa l§p ðµi" ) then
			Friend:InviteTeam( DataPool:GetFriend(tonumber(group) ,tonumber(index), "NAME"  ) );
		else
			Friend:AskTeam( DataPool:GetFriend(tonumber(group) ,tonumber(index), "NAME"  ) );
		end
	else
		PushDebugMessage("Thao tác th¤t bÕi, V¸ häo hæu này không t°n tÕi.")
		FriendInfo_OnHide();
	end

	
end

function FriendInfo_OnGroup()
	if(g_name == "") then
		return;
	end
	local group,index = DataPool:GetFriendByName(g_name);
	if(tonumber(group) ~=-1 and tonumber(index)~=-1)then
		Friend:OpenGrouping(tonumber(group) ,tonumber(index)  );
	else
		PushDebugMessage("Thao tác th¤t bÕi, V¸ häo hæu này không t°n tÕi.")
		FriendInfo_OnHide();
	end
	
end

function FriendInfo_OnDelete()
	if(g_name == "") then
		return;
	end
	local group,index = DataPool:GetFriendByName(g_name);
	if(tonumber(group) ~=-1 and tonumber(index)~=-1)then
		DataPool:AskDelFriend( tonumber(group) ,tonumber(index) );
	else
		PushDebugMessage("Thao tác th¤t bÕi, V¸ häo hæu này không t°n tÕi.")
	end
	
	FriendInfo_OnHide();
end