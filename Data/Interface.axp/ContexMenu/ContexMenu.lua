
--��������ʧ��ʱ���Զ��ر��������
local objCared = -1;

local g_MenuType = "";

--ͬ�˳�Ա�˵�
local g_LeagueMemberID = -1;

local currentSelectChannal = "1";
local currentIndex;
local currentGuildListIndex;
local currentSelectMember = 0;
local g_showType = "";
local g_Voteinfo_index = 1;

local g_Menu_ObjName = "";
local g_Menu_ObjId = 0;
--OnLoad
function ContexMenu_PreLoad()
	this:RegisterEvent("SHOW_CONTEXMENU");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("HIDE_CONTEXMENU_SPEAKER");
end

function ContexMenu_OnLoad()
    local strTip = GetDictionaryString( "Tip_PVP_Peace" )
    PVP_Peace:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_Moral" )
    PVP_Moral:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_FreeForAll" )
    PVP_FreeforAll:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_FreeForTeam" )
    PVP_FreeforTeam:SetToolTip( strTip )
    
    --strTip = GetDictionaryString( "Tip_PVP_FreeForGuild" )
    strTip = GetDictionaryString( "TM_20080311_16" )
    PVP_FreeforGuild:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_Peace" )
    PVP_Peace_Before21:SetToolTip( strTip )
end

function ContexMenu_OnEvent(event)
	AxTrace(1, 0, "chat_private contex menu enter: " .. arg0 );
	
	if ( event == "SHOW_CONTEXMENU" ) then
		g_showType = arg0;
	
		if(arg0 == "other_player") then
			this:TransAllWindowText();
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			
			ContexMenu_OtherPlayer:SetPopMenuPos(arg2, arg3);
			if Player : GetData( "GUILD" ) == -1 then
				OtherPlayer_InviteToGuild : Disable()
			else
				OtherPlayer_InviteToGuild : Enable()
			end

		--	local menuItem = "�������    "
		--	if Player : GetData( "GUILD" ) == -1 then
		--		menuItem = "#cefefef�������    "
		--	end

		--	OtherPlayer_InviteToGuild : SetText( menuItem )
			ContexMenu_OtherPlayer:Show();
		
			return;
		end

		-------------------------------------------------------------------------------------------------------------------------
		--
		--  ����Ƕӳ��򿪵Ĳ˵�
		--
		if(arg0 == "Team_Leader") then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			
			if( Player:InTeamFollowMode() ) then
				ContexMenu_TeamFollowLeader:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamFollowLeader:Show();
			else
				ContexMenu_TeamLeader:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamLeader:Show();
			end
			
			AxTrace(0, 0, "Th�c �n �i tr߷ng menu enter:  " ..tostring( arg4 ) );
			currentSelectMember = tonumber( arg4 );

			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- �����������Ա�򿪵Ĳ˵�.
		--
		if(arg0 == "Team_Member") then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			if( Player:InTeamFollowMode() ) then
				ContexMenu_TeamFollowMember:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamFollowMember:Show();
			else
				ContexMenu_TeamMember:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamMember:Show();
			end
			currentSelectMember = arg4;
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- ����Ƕ�Ա��ս���޵��Ҽ������˵�
		-- add by WTT
		--
		if(arg0 == "Team_Member_Pet") then
			ContexMenuFrame_Close();
			this:Show();
			
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");			

			-- ����λ�ò���ʾ
			ContexMenu_MemberPetMenu:SetPopMenuPos(arg2, arg3);
			ContexMenu_MemberPetMenu:Show();
			
			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- ���Լ��������
		--
		if(arg0 == "player") then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			
			local horse =  GetRideStatic( 1 );
			if( tonumber( horse ) == 0 ) then
				Myself_DisbondRide:Disable();
			elseif( tonumber( horse ) == 1 ) then
				Myself_DisbondRide:Enable();
				Myself_DisbondRide:SetText("Xin m�i c�ng c��i");
			else
				Myself_DisbondRide:Enable();
				Myself_DisbondRide:SetText("H�y b� c�ng c��i");
			end
			
			local Level = Player:GetData( "LEVEL" );
			
			if( Level > 20 ) then
				ContexMenu_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode" );
			else
				ContexMenu_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode_Before21" );
			end
			ContexMenu_Self:Show();
			ContexMenu_Self:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		
	  --------------------------------------------------------------------------------------------------------------------------
		--
		-- �Լ��ж���, ֻ�򿪰�̯��ť����
		--
		if(arg0 == "player_in_team") then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			local horse =  GetRideStatic( 1 );
			if( tonumber( horse ) == 0 ) then
				Myself_InTeam_DisbondRide:Disable();
			elseif( tonumber( horse ) == 1 ) then
				Myself_InTeam_DisbondRide:Enable();
				Myself_InTeam_DisbondRide:SetText("Xin m�i c�ng c��i");
			else
				Myself_InTeam_DisbondRide:Enable();
				Myself_InTeam_DisbondRide:SetText("H�y b� c�ng c��i");
			end
		
			local Level = Player:GetData( "LEVEL" );
			
			if( Level > 20 ) then
				ContexMenu_Self_InTeam_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode" );
			else
				ContexMenu_Self_InTeam_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode_Before21" );
			end
			
			ContexMenu_Self_In_Team:Show();
			ContexMenu_Self_In_Team:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- �����������ģ��, �����ĶԻ���
		--
		if(arg0 == "other_team_member") then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			
			local horse =  GetRideStatic( 0 );
			if( tonumber( horse ) == 0 ) then
				ContexMenu_Model_Open_Other_Invite_Ride:Disable();
			elseif( tonumber( horse ) == 1 ) then
				ContexMenu_Model_Open_Other_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Invite_Ride:SetText("Xin m�i c�ng c��i");
			else
				ContexMenu_Model_Open_Other_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Invite_Ride:SetText("H�y b� c�ng c��i");
			end
			
			if Player : GetData( "GUILD" ) == -1 then
				ContexMenu_Model_Open_Other_InviteToGuild : Disable()
			else
				ContexMenu_Model_Open_Other_InviteToGuild : Enable()
			end

			ContexMenu_Model_Open_Other:Show();
			ContexMenu_Model_Open_Other:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- ����������ҵ������Ľ���
		--
		if(arg0 == "other_not_team_member") then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

		
			local horse =  GetRideStatic( 0 );
			AxTrace( 1,0, "GetRideStatic="..tostring( horse ) );
			if( tonumber( horse ) == 0 ) then
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:Disable();
			elseif( tonumber( horse ) == 1 ) then
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:SetText("Xin m�i c�ng c��i");
			else
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:SetText("H�y b� c�ng c��i");
			end
			
			if Player : GetData( "GUILD" ) == -1 then
				ContexMenu_Model_Open_Other_Not_teammer_InviteToGuild : Disable()
			else
				ContexMenu_Model_Open_Other_Not_teammer_InviteToGuild : Enable()
			end

			ContexMenu_Model_Open_Other_Not_teammer:Show();
			ContexMenu_Model_Open_Other_Not_teammer:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- ��������, ���������, �����Ĳ˵�
		--
		if(arg0 == "other_team_member_me_not_teamer") then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			local horse =  GetRideStatic( 0 );
			AxTrace( 1,0, "GetRideStatic="..tostring( horse ) );
			if( tonumber( horse ) == 0 ) then
				ContexMenu_Model_Open_Other_teammer_me_Ride:Disable();
			elseif( tonumber( horse ) == 1 ) then
				ContexMenu_Model_Open_Other_teammer_me_Ride:Enable();
				ContexMenu_Model_Open_Other_teammer_me_Ride:SetText("Xin m�i c�ng c��i");
			else
				ContexMenu_Model_Open_Other_teammer_me_Ride:Enable();
				ContexMenu_Model_Open_Other_teammer_me_Ride:SetText("H�y b� c�ng c��i");
			end
			
			if Player : GetData( "GUILD" ) == -1 then
				ContexMenu_Model_Open_Other_teammer_me_InviteToGuild : Disable()
			else
				ContexMenu_Model_Open_Other_teammer_me_InviteToGuild : Enable()
			end
			ContexMenu_Model_Open_Other_teammer_me_not_teammer:Show();
			ContexMenu_Model_Open_Other_teammer_me_not_teammer:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- ����������������, �����Ĳ˵�
		--		
		if(arg0 == "chat_private") then
			ContexMenu_HideAll();
			this:Show();
			--����NPC
			g_MenuType = arg1;
			if(tonumber(arg4)==1)then
				ContexMenu_ChatBoard:Show();
				ContexMenu_ChatBoard:SetPopMenuPos(arg2,arg3);
			else
				ContexMenu_ChatBoard_NoToushu:Show();
				ContexMenu_ChatBoard_NoToushu:SetPopMenuPos(arg2,arg3);
			end
			
			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- �������ͶƱ�˺� , �����Ĳ˵�
		--
		if(arg0 == "findfrind_vote") then
			ContexMenu_HideAll();
			this:Show();
			g_MenuType = arg1;
			g_Voteinfo_index = tonumber(arg4);   --�����ǵڼ���
			ContexMenu_FindFriend_VoteInfo:Show();
			ContexMenu_FindFriend_VoteInfo:SetPopMenuPos(arg2,arg3);

			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- ��������б���
		--
		if( arg0 == "friendmenu" ) then
			currentSelectChannal = arg2;
			currentIndex = arg3;
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			if( tonumber( arg2 ) == 5 ) then
				ContexMenu_BlackListMenu:Show();
				ContexMenu_BlackListMenu:SetPopMenuPos(arg4,arg5);
			elseif( tonumber( arg2 ) == 6 ) then
				ContexMenu_EnmeyListMenu:Show();
				ContexMenu_EnmeyListMenu:SetPopMenuPos(arg4,arg5);
			else
				ContexMenu_FriendMenu:Show();
				ContexMenu_FriendMenu:SetPopMenuPos(arg4,arg5);
			end
			return;
		end

--------------------------------------------------------------------------------------------------------------------------
		--
		-- ��������б���
		--
		if( arg0 == "groupingmenu" ) then
			AxTrace( 0,0, "show groping menu" );
			currentSelectChannal = arg2;
			currentIndex = arg3;
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			ContexMenu_GroupingMenu:Show();
			ContexMenu_GroupingMenu:SetPopMenuPos(arg4,arg5);
			return;
		end
--------------------------------------------------------------------------------------------------------------------------
		--
		-- ��ͼ���Լ�����Ĳ˵�
		--
		if( arg0 == "my_pet" ) then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			ContexMenu_MyPetMenu:Show();
			ContexMenu_MyPetMenu:SetPopMenuPos(arg2,arg3);
			return;
		end
		
		if( arg0 == "my_pet_from_petframe" ) then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			ContexMenu_MyPetMenuFromPetFrame:Show();
			ContexMenu_MyPetMenuFromPetFrame:SetPopMenuPos(arg2,arg3);
			return;
		end
--------------------------------------------------------------------------------------------------------------------------
		--
		-- ��ͼ����������Ĳ˵�
		--
		if( arg0 == "other_pet" ) then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			ContexMenu_OtherPetMenu:Show();
			ContexMenu_OtherPetMenu:SetPopMenuPos(arg2,arg3);
			return;
		end		
--------------------------------------------------------------------------------------------------------------------------
		--
		-- pkģʽ�˵�
		--
		if( arg0 == "PKmode" ) then
			ContexMenuFrame_Close();
			this:Show();
			--����NPC
			--objCared = tonumber(arg1);
			--this:CareObject(objCared, 1, "ContexMenu");
			if(tonumber(arg1)==0)then
				AxTrace(0, 1, "arg1="..tonumber(arg1));
				Menu_PVPMode_Before21:Show();
				Menu_PVPMode_Before21:SetPopMenuPos(arg2,arg3);
			else
				Menu_PVPMode:Show();
				Menu_PVPMode:SetPopMenuPos(arg2,arg3);
			end
			
			return;
		end
--------------------------------------------------------------------------------------------------------------------------
		--
		-- ����Ա
		--
		if( arg0 == "GUILDLIST" ) then
			currentGuildListIndex = arg2;
			if(tonumber(arg5)==0)  then
				return;
			elseif(tonumber(arg5)==1) then
				ContexMenuFrame_Close();
				this:Show();
				ContexMenu_GuildList:Show();
				ContexMenu_GuildList:SetPopMenuPos(arg3,arg4);
			elseif(tonumber(arg5)==2) then
				return;		
			end
			
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			return;
		end
		
		--ͬ�˳�Ա
		if arg0 == "GuildLeagueMember" then
				g_LeagueMemberID = tonumber(arg1);
				ContexMenuFrame_Close();
				this:Show();
				ContexMenu_GuildLeagueMember:Show();
				ContexMenu_GuildLeagueMember:SetPopMenuPos(arg2,arg3);			
		end
--------------------------------------------------------------------------------------------------------------------------
		--�����Ҽ��˵�For"��Ա�б�"
		--add by xindefeng
		if( arg0 == "OfficialPopMenu" ) then
			currentGuildListIndex = arg2
			local type = tonumber(arg5)--ѡ������
			if(type == 0)  then	--�Լ�
				return;
			elseif(type == 1) then	--����
				ContexMenuFrame_Close();
				this:Show();
				ContexMenu_OfficialPopMenu:Show();
				ContexMenu_OfficialPopMenu:SetPopMenuPos(arg3,arg4);
			elseif(type == 2) then	--������
				return
			end
			
			--����NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu")

			return
		end
		if( arg0 == "TrustFriend" ) then
			
			ContexMenuFrame_Close();
			this:Show();
			ContexMenu_TrustFriendMenu:Show();
			ContexMenu_TrustFriendMenu:SetPopMenuPos(arg1,arg2);
			
			g_Menu_ObjName	= arg3;
			g_Menu_ObjId	= arg4;
						
			return
		end
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1=="destroy") then
			ContexMenuFrame_Close();

			--ȡ������
			this:CareObject(objCared, 0, "ContexMenu");
		end
	elseif(event == "HIDE_CONTEXMENU_SPEAKER")then
		if(this:IsVisible() and g_showType == "chat_private" and g_MenuType == "speaker") then
			ContexMenuFrame_Close();
		end
	end
end
function ContexMenuFrame_Close()
	ContexMenu_HideAll();
	this:Hide();
	this:CareObject(objCared, 0, "ContexMenu");
end

function ContexMenuFrame_Clicked()
	ContexMenuFrame_Close();
	
end

function ContexMenu_HideAll()

	Menu_PVPMode:ClosePopMenu();
	Menu_PVPMode_Before21:ClosePopMenu();

	-- �����������
	ContexMenu_OtherPlayer:ClosePopMenu();

	-- ����npc
	ContexMenu_NPC:ClosePopMenu();

	-- ���ضӳ��˵�
	ContexMenu_TeamLeader:ClosePopMenu();

	-- ���ض���
	ContexMenu_TeamMember:ClosePopMenu();

	-- �����Խ�����˵�
	ContexMenu_Self:ClosePopMenu();
	
	-- �����Լ��Ѿ��ڶ�����, �򿪰�̯�˵�
	ContexMenu_Self_In_Team:ClosePopMenu();
	
	-- ��������, �Ѿ������Ҳ˵�.
	ContexMenu_Model_Open_Other:ClosePopMenu();
	
	-- ���ط������Ҳ˵�
	ContexMenu_Model_Open_Other_Not_teammer:ClosePopMenu();
	
	-- ���ط�����������˵�
	ContexMenu_Model_Open_Other_teammer_me_not_teammer:ClosePopMenu();
	
	-- �������촰�ڲ˵�
	ContexMenu_ChatBoard:ClosePopMenu();
	
	ContexMenu_FriendMenu:ClosePopMenu();
	ContexMenu_EnmeyListMenu:ClosePopMenu();
	
	-- ������ӽ����ϵĶ������ް�ť�Ҽ��˵�
	ContexMenu_MemberPetMenu:ClosePopMenu();
	
	-- �����Լ����ﴰ�ڲ˵�
	ContexMenu_MyPetMenu:ClosePopMenu();
	
	-- �����������ﴰ�ڲ˵�
	ContexMenu_OtherPetMenu:ClosePopMenu();
	
	-- ������Ӹ���˵���
	ContexMenu_TeamFollowLeader:ClosePopMenu();
	
	-- ���ض���.
	ContexMenu_TeamFollowMember:ClosePopMenu();
	
	ContexMenu_BlackListMenu:ClosePopMenu();

	ContexMenu_GroupingMenu:ClosePopMenu();
	--����
	ContexMenu_GuildList:ClosePopMenu();
	--ͬ�˳�Ա
	ContexMenu_GuildLeagueMember:ClosePopMenu();
		
	--��Ա�б��Ҽ��˵�--add by xindefeng
	ContexMenu_OfficialPopMenu:ClosePopMenu();
		
	--new
	ContexMenu_MyPetMenuFromPetFrame:ClosePopMenu();

	--
	ContexMenu_ChatBoard_NoToushu:ClosePopMenu();
	--FindFriend_Voteinfo
	ContexMenu_FindFriend_VoteInfo:ClosePopMenu();
	
	ContexMenu_TrustFriendMenu : ClosePopMenu();
end

function ContexMenu_OtherPlayer_Clicked(itemname)

	AxTrace(0,0,"itemname = "..itemname)
	if(itemname == "zudui") then
		if(Target:IsPresent()) then
			Target:SendTeamRequest();
		end
	elseif(itemname == "tanwei") then
		StallBuy:OpenStall();
	elseif(itemname == "siliao") then
		--
	elseif( itemname == "Ride" ) then
		InviteRide();
	end
	ContexMenuFrame_Close();
end

--����
function ContexMenu_Exchange_Clicked()
	Exchange:SendExchangeApply();
	ContexMenuFrame_Close();
end

--����
function ContexMenu_OtherPlayer_Follow_Clicked()
	Target:Follow();
	ContexMenuFrame_Close();
end

-- �������
function ContexMenu_InviteToGuild_Clicked()
	if Player : GetData( "GUILD" ) == -1 then
		return
	end

	Guild : InviteToGuild()
	ContexMenuFrame_Close()
end

--��õ�廨
function ContexMenu_GiveRose_Clicked()
	 ContexMenuFrame_Clicked();
	 
	local nGUID = GetTargetPlayerGUID();
	
	AxTrace(0,0,"nGUID:"..nGUID);
	
	if( tonumber( nGUID ) == -1 ) then	
	--	return;
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GiveRose" )
		Set_XSCRIPT_ScriptID( 006673 )
		Set_XSCRIPT_Parameter( 0, tonumber( nGUID ) )
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()


	ContexMenuFrame_Close()
end

--*******************************************************************************************************************************
--
-- ����������
--
--*******************************************************************************************************************************
function ContexMenu_OtherPlayer_Apply_Clicked()

		if(Target:IsPresent()) then
			Target:SendTeamApply();
		end
		
		ContexMenuFrame_Close();

end



--*******************************************************************************************************************************
--
-- �뿪����
--
--*******************************************************************************************************************************
function ContexMenu_LeaveTeam_Clicked()
	Player:LeaveTeam();
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- ��ɢ����
--
--*******************************************************************************************************************************
function ContexMenu_DismissTeam_Clicked()

	Player:OpenDismissTeamMsgbox();			-- �򿪽�ɢ����Ķ���ȷ�ϴ���			add by WTT	20090218	
	ContexMenuFrame_Close();
end


--*******************************************************************************************************************************
--
-- �߳���ǰѡ�еĶ�Ա.
--
--*******************************************************************************************************************************
function ContexMenu_KickTeamMember_Clicked()
	AxTrace( 0,0, "current select = "..tostring( currentSelectMember ) );
	Player:KickTeamMember(currentSelectMember);
	ContexMenuFrame_Close();
end


--*******************************************************************************************************************************
--
-- �Լ���������
--
--*******************************************************************************************************************************
function ContexMenu_SelfCreateTeam_Clicked()
	Player:CreateTeamSelf();
	ContexMenuFrame_Close();
	
end

--*******************************************************************************************************************************
--
-- ����Ϊ�ӳ�
--
--*******************************************************************************************************************************
function ContexMenu_AppointLeader_Clicked()
	AxTrace( 0,0, "current select = "..tostring( currentSelectMember ) );
	Player:AppointLeader(currentSelectMember);
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- ȡ������
--
--*******************************************************************************************************************************
function ContexMenu_StopFollow_Clicked()
	Player:StopFollow();
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- ��̯
--
--*******************************************************************************************************************************
function ContexMenu_StallSale_Clicked()
	PlayerPackage:OpenStallSaleFrame();
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- ˽��
--
--*******************************************************************************************************************************

function ContexMenu_ChatBoard_Private_Talk_Clicked()
	 ContexMenuFrame_Clicked();
	 Talk:ContexMenuTalk();
	 ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_CheckInfo_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_Invite_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end
	ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_Apply_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	if(nil ~= szName) then
		Target:SendTeamApply(szName);
	end
	ContexMenuFrame_Close();
end
function ContexMenu_GetCurrentFriendTeam()
	local nCurrentTeam = Friend:GetCurrentTeam();
	if( nCurrentTeam == 5 or nCurrentTeam == 6 ) then
		nCurrentTeam = 0;
	end
	return nCurrentTeam;
	
end
function ContexMenu_ChatBoard_AddFriend_Clicked()
	 ContexMenuFrame_Clicked();
	 DataPool:AddFriend( ContexMenu_GetCurrentFriendTeam(), Talk:HandleMenuAction("Name") );
	 ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_PingBi_Clicked()
	ContexMenuFrame_Clicked();
	Talk:HandleMenuAction("PingBi");
	ContexMenuFrame_Close();
end

function ContexMenu_ChatBoard_Toushu_Clicked()
	ContexMenuFrame_Clicked();
	Talk:HandleMenuAction("Toushu");
	ContexMenuFrame_Close();
end

function ContexMenu_ChatBoard_WaiGua_Clicked()
	ContexMenuFrame_Clicked();
	Talk:HandleMenuAction("WaiGua");
	ContexMenuFrame_Close();
end


function send_detail()
	Target:Close_Before_TargetEquip_UI();
	Target:SendAskDetail();
	ContexMenuFrame_Close();
	
	--������Ŀ����Ϣ
	CacheMainTarget();
end
--*******************************************************************************************************************************
--
--����
--*******************************************************************************************************************************
function ContexMenu_OnDelFriend()
	DataPool:AskDelFriend( tonumber( currentSelectChannal ), tonumber( currentIndex ) );
	Friend:Close();
	ContexMenuFrame_Close();
end

function ContexMenu_OnSendMail()
	AxTrace( 0,0, "Truy�n tin" );
	local name =  DataPool:GetFriend( tonumber( currentSelectChannal ), tonumber( currentIndex ), "NAME" );
	DataPool:OpenMail( name );
	
	ContexMenuFrame_Close();
	
end

function ContexMenu_AddFriend()
	AxTrace( 0,0, "AddFriend by traget" );
	DataPool:AddFriend( ContexMenu_GetCurrentFriendTeam() );
	ContexMenuFrame_Close();
end 

function ContexMenu_InviteAddFriend()
	DataPool:InviteAddFriend();
	ContexMenuFrame_Close();
end 
function ContexMenu_InviteAddFriendByFriendList()
	DataPool:InviteAddFriendByFriendList(Friend:GetCurrentTeam(), Friend:GetCurrentSelect());
	ContexMenuFrame_Close();
end

function ContexMenu_InviteAddFriendByteam()
	local guid = DataPool:GetTeamMemGUIDByUIIndex( tonumber( currentSelectMember ) );
	if( tonumber( guid ) == -1 ) then	
		return;
	end
	DataPool:InviteAddFriendByteam(guid);
	ContexMenuFrame_Close();
end

function ContexMenu_AddFriendTeamate()
	
	AxTrace( 0,0,"AddFrined by Index" );
	local guid = DataPool:GetTeamMemGUIDByUIIndex( tonumber( currentSelectMember ) );
	if( tonumber( guid ) == -1 ) then	
		return;
	end
	DataPool:AddFriend( ContexMenu_GetCurrentFriendTeam(), tonumber( guid ) );
	ContexMenuFrame_Close();

end 
function ContexMenu_ThrowBlackList()
	DataPool:ThrowToBlackList( tonumber( currentSelectChannal ), tonumber( currentIndex ) );
	Friend:Close();
	ContexMenuFrame_Close();
end

function ContexMenu_ThrowList( nGroup )
	AxTrace( 0,0,"current team = "..tostring( currentSelectChannal ) );
	if( tonumber( currentSelectChannal )  == 8 ) then
		local name =  DataPool:GetFriend( tonumber( currentSelectChannal ), tonumber( currentIndex ), "NAME" );
		DataPool:AddFriend( nGroup, name, tonumber( 1 ) );
		AxTrace( 0,0,"add current friend name = "..name );
		
		if( tonumber( nGroup )  == 5 ) then
		    PushDebugMessage("T�m th�i kh�ng th� cho v�o danh s�ch �en");
		end
	else
		DataPool:ThrowToList( tonumber( currentSelectChannal ), tonumber( currentIndex ), tonumber( nGroup ) );
	end
	Friend:Close();
	ContexMenuFrame_Close();
end

function ContexMenu_OnPrivate()
	--local name =  DataPool:GetFriend( tonumber( currentSelectChannal ), tonumber( currentIndex ), "NAME" );
	local name = Target:GetName();
	Talk:ContexMenuTalk( name );
	ContexMenuFrame_Close();
end

------���ѽ������������ѡ������-----
function ContexMenu_OnSelectThePlayer()
  local szName = Talk:HandleMenuAction("Name");
  if(nil == szName) then
    szName=DataPool:GetFriend( tonumber( currentSelectChannal ), tonumber( currentIndex ), "NAME" );
  end
  
	if(nil ~= szName) then
		Target:SelectThePlayer(szName);
	end
  
  --PushDebugMessage("aaaa")
	ContexMenuFrame_Close();
end

---���ɹ�����ѡ������----
function ContexMenu_GuildList_OnSelectThePlayer()
  local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
 
	if(nil ~= szName) then
		Target:SelectThePlayer(szName);
	end
  --PushDebugMessage("aaaa")
	ContexMenuFrame_Close();
end

function ContexMenu_GuildList_Private_Talk_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	Talk:ContexMenuTalk( szName );
	ContexMenuFrame_Close();	
end;
function ContexMenu_GuildList_CheckInfo_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
	ContexMenuFrame_Close();	
end;
function ContexMenu_GuildList_AddFriend_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	 DataPool:AddFriend( ContexMenu_GetCurrentFriendTeam(), szName );
	 ContexMenuFrame_Close();
end
function ContexMenu_GuildList_Invite_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_GuildList_Apply_Clicked()

	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	if(nil ~= szName) then
		Target:SendTeamApply(szName);
	end
	ContexMenuFrame_Close();

end
function ContexMenu_GuildList_OnSendMail()
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	DataPool:OpenMail( szName );
	
	ContexMenuFrame_Close();
end

--ͬ�˳�Ա�����ϸ��Ϣ����
function ContexMenu_GuildLeagueMember_DetailInfo_Clicked()
	Guild:AskAnyGuildDetailInfo(g_LeagueMemberID) --��ѯָ��ID�����ϸ��Ϣ
	Guild:CloseKickGuildBox()
	
	ContexMenuFrame_Close();
end

function ContexFriend_OnPrivate()
	local name =  DataPool:GetFriend( tonumber( currentSelectChannal ), tonumber( currentIndex ), "NAME" );
	Talk:ContexMenuTalk( name );
	ContexMenuFrame_Close();
end

function ContexMenu_PetHandle( order )
	if( order == nil ) then
		return;
	end
	
	local action = {};
	action[1] = "feed";
	action[2] = "dome";
	action[3] = "relax";
	action[4] = "detail";
	
	Pet:HandlePetMenuItem(action[order]);
	
	ContexMenuFrame_Close();
end

function ContexMenu_PetHandleSelf(order)
	if( order == nil ) then
		return;
	end
	
	local action = {};
	action[1] = "feed";
	action[2] = "dome";
	action[3] = "relax";
	action[4] = "detail";
	
	Pet:HandlePetMenuItemSelf(action[order]);
	
	ContexMenuFrame_Close();
end

function ContexMenu_OtherPlayer_Challenge()
	DataPool:Challenge();
end


function ContexMenu_ShowFriendInfo()
	DataPool:ShowFriendInfo( Friend:GetCurrentTeam(), Friend:GetCurrentSelect() );
	ContexMenuFrame_Close();
end

function ContexMenu_OnGroupChange()
	Friend:OpenGrouping( tostring( Friend:GetCurrentTeam() ), tostring( Friend:GetCurrentSelect() ) );
	ContexMenuFrame_Close();
end

function ContexMenu_OnFriendInfo()
	DataPool:ShowFriendInfo( Friend:GetCurrentTeam(), Friend:GetCurrentSelect() );
	ContexMenuFrame_Close();
end

function ContexMenu_OnFriendHistroy()
	DataPool:OpenHistroy( Friend:GetCurrentTeam(), Friend:GetCurrentSelect() );
	ContexMenuFrame_Close();
end

function ContexMenu_OnAskTeam()
			Friend:AskTeam( DataPool:GetFriend( Friend:GetCurrentTeam(), Friend:GetCurrentSelect(), "NAME"  ) );
end


function ContexMenu_OnInviteTeam()
			Friend:InviteTeam( DataPool:GetFriend( Friend:GetCurrentTeam(), Friend:GetCurrentSelect(), "NAME"  ) );

end









function ContexMenu_PVP_Peace_Clicked()
	Player:ChangePVPMode( 0 );
	ContexMenuFrame_Close();
end

function ContexMenu_PVP_Moral_Clicked()
	Player:ChangePVPMode( 2 );
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_FreeforAll_Clicked()
	ShowAcceptChangePVPMode( 1 );
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_FreeforTeam_Clicked()
	ShowAcceptChangePVPMode( 3 );
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_FreeforGuild_Clicked()
	ShowAcceptChangePVPMode( 4 );
	ContexMenuFrame_Close();
end
function ContexMenu_AboutPK_Clicked()
	ShowAcceptChangePVPMode( 5 );
	ContexMenuFrame_Close();
end

function ContexMenu_PVP_Duel_Clicked()
	Player:PVP_Duel();
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_Challenge_Clicked()
	--if CheckPhoneMibaoAndMinorPassword() == 0 then
	--	ContexMenuFrame_Close();
	--	return
	--end
	Player:PVP_Challenge( 1 );     --1Ϊ������սȷ�϶Ի���
	ContexMenuFrame_Close();
end


function ContexMenu_ChangePVPMode_Clicked()	
    ShowChangePVPMode();
    --ContexMenuFrame_Close();
end


function ContexMenu_OnPrivate_FromInc()
	local name = DataPool:GetTeamMemberInfo(tonumber( currentSelectMember ));
	Talk:ContexMenuTalk( name );
	ContexMenuFrame_Close();
end

--add:lby20071207��Ӱ����������Ϣ�в���28818
function ContexMenu_ChatBoard_LookPos_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	
	if(nil ~= szName) then
	
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			Friend:SetCurrentSelect( nIndex );
			DataPool:LookupOtherParticularInfo( szName );
		else
			DataPool:LookupOtherParticularInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end

----add:lby20071207��Ӱ���ٹ�ϵ��Ϣ�в���28818
function ContexMenu_OnFriendInfoEx()
	DataPool:LookupOtherParticularInfo( Friend:GetCurrentTeam(), Friend:GetCurrentSelect() );
	ContexMenuFrame_Close();
end

--"��Ա�б�":�����ʼ�--add by xindefeng
function ContexMenu_OfficialPopMenu_SendMail_Clicked()
	ContexMenuFrame_Close()	--�ص��˵�

	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--��ȡ�Է�����
	if(nil ~= szName) then
		DataPool:OpenMail(szName)
	end
end

--"��Ա�б�":˽��--add by xindefeng
function ContexMenu_OfficialPopMenu_PrivateTalk_Clicked()
	ContexMenuFrame_Close()	--�ص��˵�
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--��ȡ�Է�����
	Talk:ContexMenuTalk(szName)
end

--"��Ա�б�":�鿴��ϸ--add by xindefeng
function ContexMenu_OfficialPopMenu_CheckInfo_Clicked()
	ContexMenuFrame_Close()	--�ص��˵�
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--��ȡ�Է�����
	if(nil ~= szName) then
		if(Friend:IsPlayerIsFriend(szName) == 1) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end	
end

--"��Ա�б�":��Ϊ����--add by xindefeng
function ContexMenu_OfficialPopMenu_AddFriend_Clicked()
	ContexMenuFrame_Close()	--�ص��˵�
		
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--��ȡ�Է�����
	DataPool:AddFriend(ContexMenu_GetCurrentFriendTeam(), szName)	--��Ϊ����
end

--"��Ա�б�":�������--add by xindefeng
function ContexMenu_OfficialPopMenu_Invite_Clicked()
	ContexMenuFrame_Close()	--�ص��˵�
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--��ȡ�Է�����
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end	
end

--"��Ա�б�":�������--add by xindefeng
function ContexMenu_OfficialPopMenu_Apply_Clicked()
	ContexMenuFrame_Close()	--�ص��˵�
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--��ȡ�Է�����
	if(nil ~= szName) then
		Target:SendTeamApply(szName)
	end
end

function ContexMenu_FindFriend_VoteInfo_Talk_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	Talk:ContexMenuTalk( szName );
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_CheckInfo_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_AddFriend_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	 DataPool:AddFriend( ContexMenu_GetCurrentFriendTeam(), szName );
	 ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_Invite_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_Apply_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	if(nil ~= szName) then
		Target:SendTeamApply(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_CFindFriend_VoteInfo_PingBi_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	FindFriendDataPool:ContexMenuPingbiOrTousu("PINGBI", szName);
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_Toushu_Clicked()
end

function ContexMenu_FindFriend_VoteInfo_LookPos_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);

	if(nil ~= szName) then

		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			Friend:SetCurrentSelect( nIndex );
			DataPool:LookupOtherParticularInfo( szName );
		else
			DataPool:LookupOtherParticularInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end


-- xiehong 2009-5-20 TrustFriend Begin---------------------------------

function ContexMenu_InviteToMyTeam()

	Friend : InviteTeam( g_Menu_ObjName );
	ContexMenuFrame_Close();
	
end

function ContextMenu_AddFriend()

	DataPool : AddFriend( ContexMenu_GetCurrentFriendTeam(), g_Menu_ObjName );
	ContexMenuFrame_Close();
	
end

function ContextMenu_WantToBeFriend()

	DataPool : InviteAddFriendByteam( g_Menu_ObjId );
	ContexMenuFrame_Close();
	
end

function ContexMenu_SetChatTarget()

	Talk:ContexMenuTalk( g_Menu_ObjName );
	ContexMenuFrame_Close();
	
end

function ContexMenu_SendMail()

	DataPool : OpenMail( g_Menu_ObjName );
	ContexMenuFrame_Close();
	
end

function ContexMenu_ShowInfo()

	if( Friend:IsPlayerIsFriend( g_Menu_ObjName ) == 1 ) then
		DataPool:ShowFriendInfo( g_Menu_ObjName );
	else
		DataPool:ShowChatInfo( g_Menu_ObjName );
	end
	
	ContexMenuFrame_Close();
	
end

-- xiehong 2009-5-20 TrustFriend End---------------------------------