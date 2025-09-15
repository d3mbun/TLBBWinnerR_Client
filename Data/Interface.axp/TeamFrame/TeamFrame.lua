--*--------------------------------------------------------------------------------------------------------------------
--* ×é¶ÓÏà¹ØµÄlua½Å±¾
--* 1, ÑûÇë½çÃæ.
--* 2, ¶ÓÔ±´ò¿ª¶ÓÎéĞÅÏ¢½çÃæ.
--* 3, ¶Ó³¤´ò¿ª¶ÓÎéĞÅÏ¢½çÃæ.
--* 4, ¶Ó³¤´ò¿ªÉêÇëÕß½çÃæ.
--*
--*---------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------
-- È«¾ÖĞèÒªÓÃµ½µÄ±äÁ¿.
--
local g_iTeamInfoType = 4;				-- ²Ù×÷ÀàĞÍ
																	-- 0 : ´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò
																	-- 1 : ´ò¿ªÉêÇë¶Ô»°¿ò
																	-- 2 : ´ò¿ªÑûÇë¶Ô»°¿ò.
																	-- 3 : ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.
																	-- 4 : ·Ç×é¶ÓÍæ¼Ò´ò¿ª½çÃæ
																	-- -1: ¹Ø±Õ½çÃæ

-----------------------------------------------------------------------------------------------------------------------
-- ÑûÇë½çÃæ
--
local g_iTeamCount_Invite   = 0;	-- ÑûÇë¶ÓÎéµÄ¸öÊı.
local g_iCurShowTeam_Invite = 0;	-- ÔÚ½çÃæÉÏÏÔÊ¾µÄ¶ÓÎé
																	-- -1 : Ã»ÓĞÏÔÊ¾µÄ¶ÓÎé.


------------------------------------------------------------------------------------------------------------------------
-- ¶ÓÔ±´ò¿ª¶ÓÎéĞÅÏ¢½çÃæ
--



------------------------------------------------------------------------------------------------------------------------
-- ¶Ó³¤´ò¿ª¶ÓÎéĞÅÏ¢½çÃæ
--
local g_iTeamMemberCount_Team = 0;	-- µ±Ç°¶ÓÎéÖĞ¶ÓÔ±µÄ¸öÊı.
local g_iCurSel_Team = -1;						-- µ±Ç°Ñ¡ÔñµÄ¶ÓÔ±.


------------------------------------------------------------------------------------------------------------------------
-- ¶Ó³¤´ò¿ªÉêÇëÕß½çÃæ
--
local g_iSel = -1;									-- ÔÚ½çÃæÉÏÑ¡ÔñµÄ¶ÓÔ±
																	-- -1 : Ã»ÓĞÑ¡Ôñ¶ÓÔ±.


local g_iCurPageShowCount  = 6; 	-- µ±Ç°Ò³ÃæÏÔÊ¾µÄÉêÇëÈËµÄ¸öÊı.
local g_iMemberCount_Apply = 0;		-- ½çÃæ´ò¿ªÊ±, ¶ÓÔ±µÄ¸öÊı.
local g_iCurSel_Apply      = 0;   -- µ±Ç°Ñ¡ÔñµÄÉêÇëÕß.(µ±Ç°Ò³ÃæµÄË÷Òı)
local g_iCurShowPage_Apply = 0;   -- µ±Ç°Ñ¡ÔñµÄÒ³Ãæ.
local g_iCurSelApply_Apply = 0;   -- µ±Ç°Ñ¡ÔñµÄË÷Òı, (´ÓÍ·¿ªÊ¼)


local g_iRealSelApplyIndex      = 0;	-- µ±Ç°Êµ¼ÊÑ¡ÔñµÄÉêÇëÕßµÄË÷Òı
local g_iRealSelInvitorIndex    = 0;	-- µ±Ç°Êµ¼ÊÑ¡ÔñµÄÑûÇë¶ÓÎéË÷Òı
local g_iRealSelTeamMemberIndex = 0;  -- µ±Ç°Êµ¼ÊÑ¡ÔñµÄÑûÇë¶ÓÎéµÄË÷Òı
--local g_iRealSelInvitorIndexPingbi = 0;	-- µ±Ç°Êµ¼ÊÑ¡ÔñµÄÑûÇë¶ÓÎéË÷Òı,ÆÁ±Î°´Å¥ÓÃµ½

------------------------------------------------------------------------------------------------------------------------
-- ½çÃæ¿Ø¼ş
--
local g_Team_PlayerInfo_Name   = {};
local g_Team_PlayerInfo_School = {};
local g_Team_PlayerInfo_Level  = {};

local g_Team_PlayerInfo_Dead = {};
local g_Team_PlayerInfo_Deadlink = {};

local g_Team_Ui_Model_Disable = {};

-------------------------------------------------------------------------------------------------------------------------
-- Ä£ĞÍ½çÃæ
--
local g_TeamFrame_FakeObject = {};


function Team_Frame_PreLoad()

	-- ´ò¿ª´°¿Ú½çÃæ
	this:RegisterEvent("TEAM_OPEN_TEAMINFO_DLG");
	
	-- Ë¢ĞÂ¶ÓÔ±ĞÅÏ¢
	this:RegisterEvent("TEAM_REFRESH_MEMBER");
	
	-- Ö÷½ÇÀë¿ª³¡¾°
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	-- ÓĞ¶ÓÎéÊÂ¼ş, ÑûÇë, ÉêÇë
	this:RegisterEvent("TEAM_NOTIFY_APPLY");
	--ÖØÖÃ
	this:RegisterEvent("RESET_ALLUI");
	
	-- È·ÈÏ½âÉ¢¶ÓÎé			add by WTT	20090212
--	this:RegisterEvent("CONFIRM_DISMISS_TEAM");

end

function Team_Frame_OnLoad()
	-- ±£´æ
	g_Team_PlayerInfo_Name[0] = Team_PlayerInfo1_Name;
	g_Team_PlayerInfo_Name[1] = Team_PlayerInfo2_Name;
	g_Team_PlayerInfo_Name[2] = Team_PlayerInfo3_Name;
	g_Team_PlayerInfo_Name[3] = Team_PlayerInfo4_Name;
	g_Team_PlayerInfo_Name[4] = Team_PlayerInfo5_Name;
	g_Team_PlayerInfo_Name[5] = Team_PlayerInfo6_Name;

	g_Team_PlayerInfo_School[0] = Team_PlayerInfo1_School;
	g_Team_PlayerInfo_School[1] = Team_PlayerInfo2_School;
	g_Team_PlayerInfo_School[2] = Team_PlayerInfo3_School;
	g_Team_PlayerInfo_School[3] = Team_PlayerInfo4_School;
	g_Team_PlayerInfo_School[4] = Team_PlayerInfo5_School;
	g_Team_PlayerInfo_School[5] = Team_PlayerInfo6_School;

	g_Team_PlayerInfo_Level[0] = Team_PlayerInfo1_Level;
	g_Team_PlayerInfo_Level[1] = Team_PlayerInfo2_Level;
	g_Team_PlayerInfo_Level[2] = Team_PlayerInfo3_Level;
	g_Team_PlayerInfo_Level[3] = Team_PlayerInfo4_Level;
	g_Team_PlayerInfo_Level[4] = Team_PlayerInfo5_Level;
	g_Team_PlayerInfo_Level[5] = Team_PlayerInfo6_Level;

	g_TeamFrame_FakeObject[0] = TeamFrame_FakeObject1;
	g_TeamFrame_FakeObject[1] = TeamFrame_FakeObject2;
	g_TeamFrame_FakeObject[2] = TeamFrame_FakeObject3;
	g_TeamFrame_FakeObject[3] = TeamFrame_FakeObject4;
	g_TeamFrame_FakeObject[4] = TeamFrame_FakeObject5;
	g_TeamFrame_FakeObject[5] = TeamFrame_FakeObject6;

	-- ËÀÍö±ê¼Ç
	g_Team_PlayerInfo_Dead[0] = Team_Die_Icon1;
	g_Team_PlayerInfo_Dead[1] = Team_Die_Icon2;
	g_Team_PlayerInfo_Dead[2] = Team_Die_Icon3;
	g_Team_PlayerInfo_Dead[3] = Team_Die_Icon4;
	g_Team_PlayerInfo_Dead[4] = Team_Die_Icon5;
	g_Team_PlayerInfo_Dead[5] = Team_Die_Icon6;

	-- µôÏß±ê¼Ç
	g_Team_PlayerInfo_Deadlink[0] = Team_Downline_Icon1;
	g_Team_PlayerInfo_Deadlink[1] = Team_Downline_Icon2;
	g_Team_PlayerInfo_Deadlink[2] = Team_Downline_Icon3;
	g_Team_PlayerInfo_Deadlink[3] = Team_Downline_Icon4;
	g_Team_PlayerInfo_Deadlink[4] = Team_Downline_Icon5;
	g_Team_PlayerInfo_Deadlink[5] = Team_Downline_Icon6;
	
	
	-- ui Òş²ØÄ£ĞÍ
	g_Team_Ui_Model_Disable[0] = Team_Model1_Disable;
	g_Team_Ui_Model_Disable[1] = Team_Model2_Disable;
	g_Team_Ui_Model_Disable[2] = Team_Model3_Disable;
	g_Team_Ui_Model_Disable[3] = Team_Model4_Disable;
	g_Team_Ui_Model_Disable[4] = Team_Model5_Disable;
	g_Team_Ui_Model_Disable[5] = Team_Model6_Disable;
	

	Team_Die_Icon1:Hide();
	Team_Die_Icon2:Hide();
	Team_Die_Icon3:Hide();
	Team_Die_Icon4:Hide();
	Team_Die_Icon5:Hide();
	Team_Die_Icon6:Hide();


	Team_Downline_Icon1:Hide();
	Team_Downline_Icon2:Hide();
	Team_Downline_Icon3:Hide();
	Team_Downline_Icon4:Hide();
	Team_Downline_Icon5:Hide();
	Team_Downline_Icon6:Hide();

	Team_Exp_Mode:ComboBoxAddItem( "Phân ph¯i ğ«u", 0 );
	Team_Exp_Mode:ComboBoxAddItem( "Phân ph¯i riêng", 1 );
	Team_Exp_Mode:ComboBoxAddItem( "Mô thÑc thu¥n thú", 2 );
	
end

function Team_StateUpdate()
	-- Òş²Ø¸úËæ°´Å¥
	AxTrace( 0,0,"LoÕi hình nhóm==="..tostring(g_iTeamInfoType));
	Team_Follow_Button:Hide();

	if( Player:InTeamFollowMode() ) then
		Team_AbortTeamFollow_Button:Show();
	else
		Team_AbortTeamFollow_Button:Hide();
	end
	--ÓÉÓÚÉ¾µôÁË3µÄÀàĞÍ£¬ËùÓĞ3µÄÀàĞÍ¶¼±ä³É0
	if( g_iTeamInfoType == 3 ) then
		g_iTeamInfoType = 0;
	end
	if( 0 == g_iTeamInfoType) then
	-- ´ò¿ª¶ÓÎéĞÅÏ¢
		-- Ìî³ä×Ô¼ºµÄĞÅÏ¢
		DataPool:SetSelfInfo();
		-- ÏÔÊ¾½çÃæ
		local leader = Player:IsLeader();
		
		if( leader == 1 ) then
			AxTrace( 0,0, "TeamFrame_OpenLeaderTeamInfo = "..tonumber( leader ) );	
			TeamFrame_OpenLeaderTeamInfo();
		else
			AxTrace( 0,0, "TeamFrame_OpenTeamInfo = "..tonumber( leader ) );
			TeamFrame_OpenTeamInfo();
		end
		-- Ñ¡ÔñµÚÒ»¸ö
		SelectPos(0);
		Team_Button_Frame6:Hide();
		

	elseif(1 == g_iTeamInfoType) then
	-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ÏÔÊ¾½çÃæ
		ShwoLeaderFlat(0);
		TeamFrame_OpenApplyList();
		Team_Update_ExpMode( -1 );
			-- Ñ¡ÔñµÚÒ»¸ö
		SelectPos(0);
		
	elseif(2 == g_iTeamInfoType) then
	-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		ClearInfo();
		-- ÏÔÊ¾½çÃæ
		TeamFrame_OpenInvite();
		Team_Update_ExpMode( -1 );
			-- Ñ¡ÔñµÚÒ»¸ö
		SelectPos(0);

	elseif(3 == g_iTeamInfoType) then
	-- ¶Ó³¤´ò¶ÓÎéÁĞ±í

		-- Ìî³ä×Ô¼ºµÄĞÅÏ¢
		DataPool:SetSelfInfo();
		-- ÏÔÊ¾½çÃæ
		
		-- Ñ¡ÔñµÚÒ»¸ö
		SelectPos(0);
		
		-- Òş²Ø×îºóÒ»¸ö°´Å¥
		Team_Button_Frame6:Hide();
		
	elseif(4 == g_iTeamInfoType) then
	-- ·Ç×é¶ÓÍæ¼Ò´ò¿ª½çÃæ
		TeamFrame_OpenCreateTeamSelf();
		Team_Update_ExpMode( -1 );
	end

		
end

function Team_Frame_OnEvent(event)


	
	--ShwoLeaderFlat(0);
	---------------------------------------------------------------------------------------------
	--
	-- ´ò¿ª½çÃæÊÂ¼ş.
	--
	if ( event == "TEAM_OPEN_TEAMINFO_DLG" ) then

		--Òş²ØuiÄ£ĞÍÃÉ×Ó.
		HideUIModelDisable();
		-- µÃµ½´ò¿ªµÄ¶Ô»°¿òµÄÏÔÊ¾ÀàĞÍ.
		local iShow = tonumber(arg0);
		AxTrace( 0,0, "LoÕi hình nhóm==="..tostring(g_iTeamInfoType).."   "..tostring( iShow ));
		if(-1 == iShow) then
		
			Team_Close();
			return;
		elseif( 4 == iShow ) then
			if(this:IsVisible()) then
			else
				return;
			end
		elseif( 3 == iShow ) then
			
		else
			-- Èç¹û°´Å¥²»ÉÁË¸.	
			-- Èç¹ûµ±Ç°½çÃæÊÇ´ò¿ªµÄ. Ôò¹Ø±Õ½çÃæ
			if(this:IsVisible()) then
			
				Team_Close();
				return;
			end;
		end;
		-- Èç¹û½çÃæÃ»ÓĞ´ò¿ª¾Í·µ»Ø.
		-- Èç¹û½çÃæ´ò¿ª, ¾ÍË¢ĞÂÊı¾İ.
--		if DataPool:GetApplyMemberCount() > 0 then
	--		g_iTeamInfoType = 1;
		--end
		Team_StateUpdate();
		return;

	end


	------------------------------------------------------------------------------------
	--
	-- Ë¢ĞÂ¶ÓÔ±ĞÅÏ¢ÊÂ¼ş
	--
	if(event == "TEAM_REFRESH_MEMBER") then
		AxTrace( 0,0, "TEAM_REFRESH_MEMBER"..tostring( arg0 ) );
		if (this:IsVisible()) then
			if( tonumber( arg0 ) == 100 ) then
				Team_Update_ExpMode( 0 );	
				return;
			end;
		end;
		if(this:IsVisible()) then
		
			-- Ö»Òª´°¿Ú´ò¿ªÊ±, ²ÅË¢ĞÂ½çÃæÊı¾İ		
			-- ¼ÙÈçµ±Ç°½çÃæ´ò¿ª¶ÓÔ±ĞÅÏ¢.
			if(g_iTeamInfoType == 0) then
				-- Çå¿Õ½çÃæ
				ClearUIModel();
				-- µÃµ½ÒªË¢ĞÂ¶ÓÔ±µÄÎ»ÖÃ
				local iMemberIndex = tonumber(arg0);
				if((iMemberIndex >= 0) and (iMemberIndex < 6)) then
					ShwoLeaderFlat(1);
					-- Ë¢ĞÂ¶ÓÔ±ĞÅÏ¢.
					TeamFrame_RefreshTeamMember_Team(iMemberIndex);
				end;
				-- Ë¢ĞÂuiÄ£ĞÍ
				RefreshUIModel();
			end
			return;
		end;-- if(this:IsVisible()) then
	end;


	------------------------------------------------------------------------------------------
	--
	-- Àë¿ª³¡¾°ÊÂ¼ş
	--
	if( event == "PLAYER_LEAVE_WORLD") then
		Team_Close();
		return;
	end
	
	
	-------------------------------------------------------------------------------------------
	--
	-- ÓĞ¶ÓÎéÊÂ¼ş, ÑûÇë, ÉêÇë
	--
	if( event == "TEAM_NOTIFY_APPLY") then
		g_iTeamInfoType = tonumber(arg0);
		AxTrace( 0,0, "TEAM_NOTIFY_APPLY"..tostring( arg0 ) );
		if( this:IsVisible() ) then
			--Òş²ØuiÄ£ĞÍÃÉ×Ó.
			-- 0 : ´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò
			-- 1 : ´ò¿ªÉêÇë¶Ô»°¿ò
			-- 2 : ´ò¿ªÑûÇë¶Ô»°¿ò.
			-- 3 : ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.
			-- -1: ¹Ø±Õ½çÃæ
--			if DataPool:GetApplyMemberCount() > 0 then
	--			g_iTeamInfoType = 1;
		--	end
			Team_StateUpdate();
		end
		return;
	end
	if( event == "RESET_ALLUI") then
		g_iTeamInfoType = 4;
		return;
	end
	
	
	----------------------------------------------------------------------------------------------
	--
	-- È·ÈÏ½âÉ¢¶ÓÎé			add by WTT	20090212
	--
--	if ( event == "CONFIRM_DISMISS_TEAM" )	then
	--	Team_Confirm_Dismiss_Team();
		--return;	
	--end
	
end



------------------------------------------------------------------------------------------------------------------
-- µã»÷ÈËÎïÊÂ¼ş
--
function TeamFrame_Select1()

	g_iSel = 0;
	
	--AxTrace( 0,0, "sel+++=Í¬ÒâÉêÇë+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	--FlashTeamButton(0);
	if(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄÉêÇëÕß
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);


	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		-- g_iRealSelInvitorIndex = g_iSel;
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;
		
	elseif(0 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

		if(0 == g_iTeamMemberCount_Team) then

			-- Èç¹û¶ÓÎé¸öÊıÊÇ0, ·µ»Ø.
			return;
		end
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Disable();
			-- ½ûÖ¹¶Ó³¤ÈÎÃü°´Å¥
			Team_Button_Frame4:Disable();
		end
		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		--SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
	end

end

------------------------------------------------------------------------------------------------------------------
-- µã»÷ÈËÎïÊÂ¼ş
--
function TeamFrame_Select2()

	g_iSel = 1;

	--AxTrace( 0,0, "sel=="..tostring(g_iSel));
	--FlashTeamButton(1);
	if(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄÉêÇëÕß
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ½ûÖ¹¶Ó³¤ÈÎÃü°´Å¥
			Team_Button_Frame4:Enable();
		end
	end

end

------------------------------------------------------------------------------------------------------------------
-- µã»÷ÈËÎïÊÂ¼ş
--
function TeamFrame_Select3()

	g_iSel = 2;
	--FlashTeamButton(2);
	--AxTrace( 0,0, "sel+++=Í¬ÒâÉêÇë+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄÉêÇëÕß
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ½ûÖ¹¶Ó³¤ÈÎÃü°´Å¥
			Team_Button_Frame4:Enable();
		end

	end

end




------------------------------------------------------------------------------------------------------------------
-- µã»÷ÈËÎïÊÂ¼ş
--
function TeamFrame_Select4()

	g_iSel = 3;
	--FlashTeamButton(3);
	--AxTrace( 0,0, "sel+++=Í¬ÒâÉêÇë+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄÉêÇëÕß
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ½ûÖ¹¶Ó³¤ÈÎÃü°´Å¥
			Team_Button_Frame4:Enable();
		end
	end

end

------------------------------------------------------------------------------------------------------------------
-- µã»÷ÈËÎïÊÂ¼ş
--
function TeamFrame_Select5()

	g_iSel = 4;
	--FlashTeamButton(0);
	--AxTrace( 0,0, "sel+++=Í¬ÒâÉêÇë+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄÉêÇëÕß
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ½ûÖ¹¶Ó³¤ÈÎÃü°´Å¥
			Team_Button_Frame4:Enable();
		end
		
	end

end

------------------------------------------------------------------------------------------------------------------
-- µã»÷ÈËÎïÊÂ¼ş
--
function TeamFrame_Select6()

	g_iSel = 5;
	--FlashTeamButton(1);
	--AxTrace( 0,0, "sel+++=Í¬ÒâÉêÇë+++"..tostring(g_iSel).."==="..tostring(g_iTeamInfoType));
	if(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄÉêÇëÕß
		TeamFrame_SetCurSelectedApply_Apply(g_iSel);

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		
--		g_iRealSelInvitorIndexPingbi = g_iSel;

	elseif(0 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

		-- ¼ÇÂ¼µ±Ç°Ñ¡ÖĞµÄÈËÎï
		-- SetCurSelMember(g_iSel);
		g_iRealSelTeamMemberIndex = g_iSel;
		
		local leader = Player:IsLeader();
		if(leader == 1)then
			Team_Button_Frame3:Enable();
			-- ½ûÖ¹¶Ó³¤ÈÎÃü°´Å¥
			Team_Button_Frame4:Enable();
		end

	end





end


------------------------------------------------------------------------------------------------------------------
-- °´Å¥ Team_Follow µã»÷ÊÂ¼ş
--
function Team_Button_Team_Follow_Click()

	if( 0 == g_iTeamInfoType) then
		-- ´ò¿ª¶ÓÎéĞÅÏ¢
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			Player:TeamFrame_AskTeamFollow();
			Team_Close();
		end

	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

	elseif(3 == g_iTeamInfoType) then
		

	end

end




------------------------------------------------------------------------------------------------------------------
-- °´Å¥0µã»÷ÊÂ¼ş
--
function Team_Button_Frame0_Click()

	if( 0 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í
		local leader = Player:IsLeader();
		if( leader == 1 ) then
				-- µÃµ½ÉêÇëÈËµÄ¸öÊı.
			iMemberCount_Apply = DataPool:GetApplyMemberCount();
			if(0 == iMemberCount_Apply) then
				return;
			end
			TeamFrame_OpenApplyList();
		end
	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤×é¶ÓÁĞ±í

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.
	end
end



------------------------------------------------------------------------------------------------------------------
-- °´Å¥1µã»÷ÊÂ¼ş
--
function Team_Button_Frame1_Click()

	if( 0 == g_iTeamInfoType) then
		-- ´ò¿ª¶ÓÎéĞÅÏ¢
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			Player:DismissTeam();			-- ´ò¿ª½âÉ¢¶ÓÎéµÄ¶ş´ÎÈ·ÈÏ´°¿Ú			add by WTT	20090212		
			Team_Close();
		end
	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÎéÁĞ±í
		DataPool:SetSelfInfo();
		TeamFrame_OpenLeaderTeamInfo();

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.
	end

end

------------------------------------------------------------------------------------------------------------------
-- °´Å¥2µã»÷ÊÂ¼ş
--
function Team_Button_Frame2_Click()

	if( 0 == g_iTeamInfoType) then
		-- ´ò¿ª¶ÓÎéĞÅÏ¢
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			Player:LeaveTeam();
			Team_Close();
		end
	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- Ç°·­Ò³
		TeamFrame_PageUp_Apply();

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.
	end

end


------------------------------------------------------------------------------------------------------------------
-- °´Å¥3µã»÷ÊÂ¼ş
--
function Team_Button_Frame3_Click()

	if( 0 == g_iTeamInfoType) then
		-- ´ò¿ª¶ÓÎéĞÅÏ¢
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			if((-1 == g_iSel) or (0 == g_iSel))then

			-- Èç¹ûÔÚ½çÃæÉÏÃ»ÓĞÑ¡ÔñÒ»¸ö¶ÓÔ±¾Í·µ»Ø
			-- »òÕßÑ¡ÖĞµÄÊÇ×Ô¼º(¶Ó³¤), Ò²·µ»Ø.
			return;
			end

			-- Ìß³öÒ»¸ö¶ÓÔ±.
			--Player:KickTeamMember();
			
			local iTeamCount = DataPool:GetTeamMemberCount();
			--AxTrace( 0,0, "µ±Ç°Ñ¡Ôñ"..tostring(g_iSel).."¶ÓÓÑ¸öÊı"..tostring(iTeamCount));
			if(iTeamCount <= g_iSel) then
			
				return;
			end;
			Player:KickTeamMember(g_iRealSelTeamMemberIndex);
			
			Team_Close();
		end
	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- Ïòºó·­Ò³
		TeamFrame_PageDown_Apply();

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ÏòÇ°·­Ò³
		TeamFrame_PageUp();

	elseif(3 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

		--AxTrace( 0,0, "µ±Ç°Ñ¡Ôñ==="..tostring(g_iSel));
		

	end


end

------------------------------------------------------------------------------------------------------------------
-- °´Å¥4µã»÷ÊÂ¼ş
--
function Team_Button_Frame4_Click()


	if( 0 == g_iTeamInfoType) then
		-- ´ò¿ª¶ÓÎéĞÅÏ¢
		local leader = Player:IsLeader();
		if( leader == 1 ) then
			local iTeamCount = DataPool:GetTeamMemberCount();
		
			if((-1 == g_iSel) or (0 == g_iSel))then

				AxTrace( 0,0, "Trß·ng"..tostring(g_iSel));
				-- Èç¹ûÔÚ½çÃæÉÏÃ»ÓĞÑ¡ÔñÒ»¸ö¶ÓÔ±¾Í·µ»Ø
				-- »òÕßÑ¡ÖĞµÄÊÇ×Ô¼º(¶Ó³¤), Ò²·µ»Ø.
						
				return;
			end

			
			if( iTeamCount <= g_iSel) then
			
				AxTrace( 0,0, "Trß·ng"..tostring(g_iSel).."  "..tostring(iTeamCount));
				return;
			end;
			
			AxTrace( 0,0, "Trß·ng"..tostring(g_iSel));
			-- ÌáÉı¶Ó³¤.
			-- Player:AppointLeader();
			Player:AppointLeader(g_iRealSelTeamMemberIndex);
			Team_Close();

		else
			Player:LeaveTeam();
			Team_Close();
		end

	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		DataPool:ClearAllApply();
		-- ÉèÖÃÏÂÒ»´Î¶Ó³¤´ò¿ª½çÃæÊÇ²é¿´¶ÓÎéĞÅÏ¢
		--DataPool:SetTeamFrameOpenFlag(3);
		g_iTeamInfoType = 0;
		Team_Close();


	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- Ïòºó·­Ò³
		TeamFrame_PageDown();
	end



end

------------------------------------------------------------------------------------------------------------------
-- °´Å¥5µã»÷ÊÂ¼ş
--
function Team_Button_Frame5_Click()


	if( 0 == g_iTeamInfoType) then
		-- ´ò¿ª¶ÓÎéĞÅÏ¢
		--SendAddFriendMsg();
		
	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		if((-1 == g_iSel))then

			-- Èç¹ûÔÚ½çÃæÉÏÃ»ÓĞÑ¡ÔñÒ»¸ö¶ÓÔ±¾Í·µ»Ø
			-- »òÕßÑ¡ÖĞµÄÊÇ×Ô¼º(¶Ó³¤), Ò²·µ»Ø.
			return;
		end

		-- Í¬ÒâÉêÇëÕß¼ÓÈë¶ÓÎé
		TeamFrame_AgreeJoinTeam_Apply();


	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- Í¬Òâ¼ÓÈë¶ÓÎé
		TeamFrame_AgreeJoinTeam_Invite();
		Team_Close();

	elseif(3 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.
	

	end


end

------------------------------------------------------------------------------------------------------------------
-- °´Å¥6µã»÷ÊÂ¼ş
--
function Team_Button_Frame6_Click()

	if( 0 == g_iTeamInfoType) then
	elseif(1 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ªÉêÇë¼ÓÈë¶ÓÎéÁĞ±í

		-- ¾Ü¾øÉêÇëÕß¼ÓÈë¶ÓÎé.
		TeamFrame_RejectJoinTeam_Apply();
		--DataPool:SetTeamFrameOpenFlag(3);
		if(g_iMemberCount_Apply <= 0) then
			
			g_iTeamInfoType = 0;
			Team_Close();
		end;	

	elseif(2 == g_iTeamInfoType) then
		-- ´ò¿ªÑûÇë¶Ô»°¿ò.

		-- ¾Ü¾ø¼ÓÈë¶ÓÎé.
		TeamFrame_RejectJoinTeam_Invite();
		--DataPool:SetTeamFrameOpenFlag(0);
		if(g_iTeamCount_Invite <= 0) then
		
			g_iTeamInfoType = 4;
			Team_Close();
		end
		
	elseif(3 == g_iTeamInfoType) then
		-- ¶Ó³¤´ò¿ª¶ÓÓÑĞÅÏ¢¶Ô»°¿ò.

	elseif(4 == g_iTeamInfoType) then
		-- ·Ç×é¶ÓÍæ¼Ò´ò¿ª½çÃæ
		Player:CreateTeamSelf();
		Team_Close();
	end

end



------------------------------------------------------------------------------------------------------------------
-- ´ò¿ª¶ÓÎéĞÅÏ¢
--
function TeamFrame_OpenTeamInfo()

		-- Çå¿Õui½çÃæ
		ClearUIModel();

		-- Òş²ØËÀÍö±ê¼Ç
		HideDeadFlag();

		-- Òş²ØµôÏß±ê¼Ç
		HideDeadLinkFlag();

		-- Òş²Ø¶Ó³¤±ê¼Ç
		ShwoLeaderFlat(0);


		g_iSel = -1;

		-- ÉèÖÃ¶Ô»°¿òµÄ²Ù×÷ÀàĞÍ
		g_iTeamInfoType = 0;
		g_iTeamInfoType  = 0;

		-- ÏÔÊ¾ÕıÈ·µÄÏÔÊ¾½çÃæ
		Team_Button_Frame0:Hide();
		Team_Button_Frame1:Hide();
		Team_Button_Frame2:Hide();
		Team_Button_Frame3:Hide();
		Team_Button_Frame4:Hide();
		Team_Button_Frame5:Hide();
		Team_Button_Frame6:Hide();
--		Team_Button_Frame7:Hide();

		-- ÉèÖÃ°´Å¥ÎÄ×Ö
		Team_Button_Frame4:Show();
		Team_Button_Frame5:Show();
		Team_Button_Frame6:Show();
		Team_Button_Frame4:Enable();
		Team_Button_Frame5:Enable();
		Team_Button_Frame6:Enable();
		Team_Button_Frame4:SetText("R¶i khöi");
		Team_Button_Frame5:SetText("Häo hæu");
		Team_Button_Frame6:SetText("M¶i kªt häo hæu");
		--Team_Button_Frame7:SetToolTip("");--Õâ¸ö½çÃæ²»ÏÔÊ¾tooltips
		Team_Name:SetText("#gFF0FA0Thông tin nhóm");

		Team_Update_ExpMode( 0 ); 
		-- µ±Ç°¶ÓÎéÖĞ¶ÓÔ±µÄ¸öÊı.
		g_iTeamMemberCount_Team = DataPool:GetTeamMemberCount();

		-- Èç¹û¶ÓÎé¸öÊıÊÇÁã, ²»ÏÔÊ¾½çÃæ.
		if(g_iTeamMemberCount_Team <= 0) then
			this:Hide();
			--Team_Close();

		end;

		-- ÉèÖÃµ±Ç°Ñ¡Ôñ,
		g_iCurSel_Team = 0;

		-- Çå¿Õ½çÃæ
		for i = 0, 5 do
			g_Team_PlayerInfo_Name[i]:SetText("");
			g_Team_PlayerInfo_School[i]:SetText("");
			g_Team_PlayerInfo_Level[i]:SetText("");

		end;

		-- Ë¢ĞÂÃ¿¸ö¶ÓÔ±.

		-- ÏÔÊ¾¶Ó³¤±ê¼Ç
		if(g_iTeamMemberCount_Team > 0) then
			ShwoLeaderFlat(1);
		end;

		for i = 0, g_iTeamMemberCount_Team - 1 do

			TeamFrame_RefreshTeamMember_Team(i);

		end;
		Team_Show();
end


------------------------------------------------------------------------------------------------------------------
--
-- ·Ç×é¶ÓÍæ¼Ò´ò¿ª½çÃæ
--
function TeamFrame_OpenCreateTeamSelf()

		-- Çå¿Õui½çÃæ
		ClearUIModel();

		-- Òş²ØËÀÍö±ê¼Ç
		HideDeadFlag();

		-- Òş²ØµôÏß±ê¼Ç
		HideDeadLinkFlag();

		-- Òş²Ø¶Ó³¤±ê¼Ç
		ShwoLeaderFlat(0);

		-- ÏÔÊ¾ÕıÈ·µÄÏÔÊ¾½çÃæ
		Team_Button_Frame0:Hide();
		Team_Button_Frame1:Hide();
		Team_Button_Frame2:Hide();
		Team_Button_Frame3:Hide();
		Team_Button_Frame4:Hide();
		Team_Button_Frame5:Hide();
		Team_Button_Frame6:Hide();
--		Team_Button_Frame7:Hide();

		-- ÉèÖÃ°´Å¥ÎÄ×Ö
		Team_Button_Frame6:Show();
		Team_Button_Frame6:Enable();
		Team_Button_Frame6:SetText("Tñ l§p ğµi");
		Team_Name:SetText("#gFF0FA0Nhóm");

		-- Çå¿Õ½çÃæ
		for i = 0, 5 do
			g_Team_PlayerInfo_Name[i]:SetText("");
			g_Team_PlayerInfo_School[i]:SetText("");
			g_Team_PlayerInfo_Level[i]:SetText("");

		end;
		
		SelectPos(0);
		Team_Show();
end


------------------------------------------------------------------------------------------------------------------
-- ´ò¿ªÉêÇëÁĞ±í
--
function TeamFrame_OpenApplyList()


	ShwoLeaderFlat(0);
	-- Çå¿Õui½çÃæ
	ClearUIModel();
	-- Çå¿Õ½çÃæ
	for i = 0, 5 do
		g_Team_PlayerInfo_Name[i]:SetText("");
		g_Team_PlayerInfo_School[i]:SetText("");
		g_Team_PlayerInfo_Level[i]:SetText("");

	end;

	-- ÉèÖÃ¶Ô»°¿òµÄ²Ù×÷ÀàĞÍ
	g_iTeamInfoType  = 1;
	g_iTeamInfoType = 1;
	

	-- ÏÔÊ¾ÕıÈ·µÄÏÔÊ¾½çÃæ
	Team_Button_Frame0:Hide();
	Team_Button_Frame1:Hide();
	Team_Button_Frame2:Hide();
	Team_Button_Frame3:Hide();
	Team_Button_Frame4:Hide();
	Team_Button_Frame5:Hide();
	Team_Button_Frame6:Hide();
--	Team_Button_Frame7:Hide();

	Team_Button_Frame1:Show();
	Team_Button_Frame2:Show();
	Team_Button_Frame3:Show();
	Team_Button_Frame4:Show();
	Team_Button_Frame5:Show();
	Team_Button_Frame6:Show();
--	Team_Button_Frame7:Show();
	
	Team_Button_Frame2:Enable();
	Team_Button_Frame2:Disable();
	Team_Button_Frame3:Disable();
	Team_Button_Frame4:Disable();
	Team_Button_Frame5:Disable();
	Team_Button_Frame6:Disable();
--	Team_Button_Frame7:Disable();
	
	Team_Button_Frame1:SetText("Tin tÑc nhóm");
	Team_Button_Frame2:SetText("Trß¾c");
	Team_Button_Frame3:SetText("Sau");
	Team_Button_Frame4:SetText("Xóa hªt danh sách");
	Team_Button_Frame5:SetText("Ğ°ng ı");
	Team_Button_Frame6:SetText("T× ch¯i");
	--Team_Button_Frame7:SetText("Che ngß¶i ch½i");
	--Team_Button_Frame7:SetToolTip("Che ngß¶i ch½i này");
	Team_Name:SetText("#gFF0FA0Danh sách ğ« ngh¸");


	-- µÃµ½ÉêÇëÈËµÄ¸öÊı.
	g_iMemberCount_Apply = DataPool:GetApplyMemberCount();
	--AxTrace(0, 0, "^^µÃµ½ÉêÇë¸öÊı"..tostring(g_iMemberCount_Apply))

	if(0 == g_iMemberCount_Apply) then
		this:Hide();
		return;
	end

	-- ÉèÖÃµ±Ç°ÏÔÊ¾µÄÒ³Ãæ.
	g_iCurShowPage_Apply = 0;

	-- ÉèÖÃµ±Ç°Ñ¡ÔñµÄÈËÎï.
	g_iCurSel_Apply = 0;

	-- Ë¢ĞÂµ±Ç°Ò³Ãæ.
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);

	-- ´ÓµÚ0Ò³¿ªÊ¼.
	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);


	-- ½ûÖ¹Ïòºó·­Ò³
	if(g_iCurShowPage_Apply < iPageCount) then
		Team_Button_Frame3:Enable();
	end

	Team_Button_Frame4:Enable();
	Team_Button_Frame5:Enable();
	Team_Button_Frame6:Enable();
--	Team_Button_Frame7:Enable();
	
	Team_Show();


end


------------------------------------------------------------------------------------------------------------------
-- ´ò¿ªÑûÇëĞÅÏ¢
--
function TeamFrame_OpenInvite()

	--Çå¿Õui½çÃæ
	ClearUIModel();

	g_iSel = -1;

	-- ÉèÖÃ¶Ô»°¿òµÄ²Ù×÷ÀàĞÍ
	g_iTeamInfoType = 2;
	g_iTeamInfoType  = 2;

	-- ÏÔÊ¾ÕıÈ·µÄÏÔÊ¾½çÃæ
	Team_Button_Frame0:Hide();
	Team_Button_Frame1:Hide();
	Team_Button_Frame2:Hide();
	Team_Button_Frame3:Hide();
	Team_Button_Frame4:Hide();
	Team_Button_Frame5:Hide();
	Team_Button_Frame6:Hide();
--	Team_Button_Frame7:Hide();

	Team_Button_Frame3:Show();
	Team_Button_Frame4:Show();
	Team_Button_Frame5:Show();
	Team_Button_Frame6:Show();
--	Team_Button_Frame7:Show();

	Team_Button_Frame3:Enable();
	Team_Button_Frame4:Enable();
	Team_Button_Frame5:Enable();
	Team_Button_Frame6:Enable();
--	Team_Button_Frame7:Enable();

	Team_Button_Frame3:SetText("Trß¾c");
	Team_Button_Frame4:SetText("Sau");
	Team_Button_Frame5:SetText("Ğ°ng ı");
	Team_Button_Frame6:SetText("T× ch¯i");
--	Team_Button_Frame7:SetText("Che ngß¶i ch½i");
--	Team_Button_Frame7:SetToolTip("Che ngß¶i ch½i này");
	Team_Name:SetText("#gFF0FA0L¶i m¶i khung cØa s± nói chuy®n");

	-- µÃµ½ÑûÇë¶ÓÎéµÄ¸öÊı.
	g_iTeamCount_Invite   = DataPool:GetInviteTeamCount();
	if( g_iTeamCount_Invite == 0 ) then
		this:Hide();
		return;
	end
	-- µ±Ç°Ñ¡ÔñµÄÈËÎï
	g_iCurShowTeam_Invite = 0;

	-- ½ûÖ¹ÏòÇ°·­Ò³
	if(0 == g_iCurShowTeam_Invite) then
		Team_Button_Frame3:Disable();
	end

	-- ½ûÖ¹Ïòºó·­Ò³
	if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then
		Team_Button_Frame4:Disable();
	end

	-- ÏÔÊ¾¶ÓÎéĞÅÏ¢
	TeamFrame_RefreshTeamInfo_Invite();

	if(0 == g_iTeamCount_Invite) then

		Team_Button_Frame5:Disable();
		Team_Button_Frame6:Disable();
	end;
	
	-- Òş²Ø¶Ó³¤±ê¼Ç
	ShwoLeaderFlat(1);
	Team_Show();
end


------------------------------------------------------------------------------------------------------------------
-- ´ò¿ª¶Ó³¤¶ÓÎéĞÅÏ¢
--
function TeamFrame_OpenLeaderTeamInfo()

	-- Çå¿Õui½çÃæ
	ClearUIModel();

	-- Òş²ØËÀÍö±ê¼Ç
	HideDeadFlag();

	-- Òş²ØµôÏß±ê¼Ç
	HideDeadLinkFlag();

	-- Òş²Ø¶Ó³¤±ê¼Ç
	ShwoLeaderFlat(0);

	g_iSel = -1;

	-- ÉèÖÃ¶Ô»°¿òµÄ²Ù×÷ÀàĞÍ
	g_iTeamInfoType = 0;
	
	Team_Follow_Button:Show();

	-- ÏÔÊ¾ÕıÈ·µÄÏÔÊ¾½çÃæ
	Team_Button_Frame0:Show();
	Team_Button_Frame1:Show();
	Team_Button_Frame2:Show();
	Team_Button_Frame3:Show();
	Team_Button_Frame4:Show();
	Team_Button_Frame5:Show();
	Team_Button_Frame6:Show();
--	Team_Button_Frame5:Hide();

	Team_Button_Frame0:Enable();
	Team_Button_Frame1:Enable();
	Team_Button_Frame2:Enable();
	if( g_iSel == -1 ) then
		Team_Button_Frame3:Disable();
	else
		Team_Button_Frame3:Enable();
	end
	Team_Button_Frame4:Enable();
	Team_Button_Frame5:Enable();
	Team_Button_Frame6:Enable();
	--Team_Button_Frame5:Disable();

	Team_Button_Frame0:SetText("Ğ« ngh¸");
	Team_Button_Frame1:SetText("Giäi tán");
	Team_Button_Frame2:SetText("R¶i khöi");
	Team_Button_Frame3:SetText("M¶i ra");
	Team_Button_Frame4:SetText("Trß·ng");
	Team_Button_Frame5:SetText("Häo hæu");
	Team_Button_Frame6:SetText("M¶i kªt häo hæu");
	--Team_Button_Frame7:SetToolTip("");--Õâ¸ö½çÃæ²»ÏÔÊ¾tooltips
	Team_Name:SetText("#gFF0FA0Thông tin nhóm");

	Team_Update_ExpMode( 1 );
	-- Òş²Ø¼ÓÎªºÃÓÑ
	Team_Button_Frame6:Hide();
	-- µ±Ç°¶ÓÎéÖĞ¶ÓÔ±µÄ¸öÊı.
	g_iTeamMemberCount_Team = DataPool:GetTeamMemberCount();
	if( g_iTeamMemberCount_Team <= 0 ) then
		this:Hide();
		return;
	end;
	-- ÉèÖÃµ±Ç°Ñ¡Ôñ,
	g_iCurSel_Team = 0;

	-- Çå¿Õ½çÃæ
	for i = 0, 5 do
		g_Team_PlayerInfo_Name[i]:SetText("");
		g_Team_PlayerInfo_School[i]:SetText("");
		g_Team_PlayerInfo_Level[i]:SetText("");

	end;

	-- ÏÔÊ¾¶Ó³¤±ê¼Ç
	if(g_iTeamMemberCount_Team > 0) then
		ShwoLeaderFlat(1);
	end;

	-- Ë¢ĞÂÃ¿¸ö¶ÓÔ±.
	for i = 0, g_iTeamMemberCount_Team - 1 do

		TeamFrame_RefreshTeamMember_Team(i);

	end;
	
	-- Ñ¡ÔñµÚÒ»¸ö
	SelectPos(0);
	Team_Show();
end



------------------------------------------------------------------------------------------------------------------
-- ´ò¿ªÑûÇë¶ÓÎéĞÅÏ¢
--
function TeamFrame_RefreshTeamInfo_Invite()

	for i = 0, 5 do
			g_Team_PlayerInfo_Name[i]:SetText("");
			g_Team_PlayerInfo_School[0]:SetText("");
			g_Team_PlayerInfo_Level[i]:SetText("");

	end

	-- µÃµ½¶ÓÓÑµÄ¸öÊı
	if(-1 == g_iCurShowTeam_Invite) then

		return;
	end

	local iTeamMemberCount = DataPool:GetInviteTeamMemberCount(g_iCurShowTeam_Invite);

	for MemberIndex = 0, iTeamMemberCount - 1 do
		-- ÏÔÊ¾Ò»¸ö¶ÓÔ±
		--ShwoLeaderFlat(1);
		TeamFrame_RefreshTeamMember_Invite(MemberIndex);
	end


end



-------------------------------------------------------------------------------------------------------------------
-- Ë¢ĞÂÄ³Ò»¸ö¶ÓÔ±µÄĞÅÏ¢, ´ò¿ª½çÃæ.
--
function TeamFrame_RefreshTeamMember_Invite(index)

		local szNick;		-- êÇ³Æ
		local iFamily;	-- ÃÅÅÉ
		local iLevel;	  -- µÈ¼¶
		local iCapID;		-- Ã±×Ó
		local iHead;		-- Í·
		local iArmourID;-- Éí×Ó
		local iCuffID;  -- »¤Íó
		local iFootID;	-- ÍÈ
		local iWeaponID;-- ÎäÆ÷

		-- µÃµ½¶ÓÔ±µÄÏêÏ¸ĞÅÏ¢
		szNick
		,iFamily
		,iLevel
		,iCapID
		,iHead
		,iArmourID
		,iCuffID
		,iFootID
		,iWeaponID
		= DataPool:GetInviteTeamMemberInfo( g_iCurShowTeam_Invite, index );


		g_Team_PlayerInfo_Name[index]:SetText(tostring(szNick));
		g_Team_PlayerInfo_School[index]:SetText(tostring(iFamily));
		g_Team_PlayerInfo_Level[index]:SetText(tostring(iLevel));

		local strModelName = DataPool:GetInviteTeamMemberUIModelName( g_iCurShowTeam_Invite, index);

		-- ÏÔÊ¾ÃÅÅÉĞÅÏ¢
		ShowFamily(index, iFamily);

		-- ÏÔÊ¾Ä£ĞÍ
		--AxTrace( 0,0, "==ÑûÇë¶ÓÎéµÄ¶ÓÔ±Ãû×Ö"..tostring(strModelName).."Î»ÖÃ"..tostring(index));
		g_TeamFrame_FakeObject[index]:SetFakeObject("");
		g_TeamFrame_FakeObject[index]:SetFakeObject(strModelName);

end



-------------------------------------------------------------------------------------------------------------------
-- ´ò¿ª¶ÓÎéÑûÇë½çÃæÏòÇ°·­Ò³
--
function TeamFrame_PageUp()

	-- ÏòÇ°·­Ò»Ò³
	g_iCurShowTeam_Invite = g_iCurShowTeam_Invite - 1;
	if(g_iCurShowTeam_Invite < 0) then
		g_iCurShowTeam_Invite = 0;
	end
	
	--AxTrace( 0,0, "µÃµ½ÑûÇë¶ÓÎéµÄ±àºÅ"..tostring(g_iCurShowTeam_Invite));
		
	-- ½ûÖ¹ÏòÇ°·­Ò³
	if(0 == g_iCurShowTeam_Invite) then
		Team_Button_Frame3:Disable();
	end

	-- ½ûÖ¹Ïòºó·­Ò³
	if(g_iCurShowTeam_Invite < (g_iTeamCount_Invite - 1)) then
		Team_Button_Frame4:Enable();
	end


	-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄ¶ÓÎé.
	g_iRealSelInvitorIndex = g_iCurShowTeam_Invite;
	
	ClearUIModel();
	-- Ë¢ĞÂµ±Ç°½çÃæ
	TeamFrame_RefreshTeamInfo_Invite();

end



-------------------------------------------------------------------------------------------------------------------
-- ´ò¿ª¶ÓÎéÑûÇë½çÃæÏòºó·­Ò³
--
function TeamFrame_PageDown()

	-- Ïòºó·­Ò»Ò³
	g_iCurShowTeam_Invite = g_iCurShowTeam_Invite + 1;
	if(g_iCurShowTeam_Invite >=  (g_iTeamCount_Invite - 1)) then
		g_iCurShowTeam_Invite = g_iCurShowTeam_Invite;
	end

	-- ½ûÖ¹Ïòºó·­Ò³
	if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then
		Team_Button_Frame4:Disable();
	end

	-- ÔÊĞíÇ°·­
	if(g_iCurShowTeam_Invite > 0) then
		Team_Button_Frame3:Enable();
	end

	-- ÉèÖÃµ±Ç°Ñ¡ÖĞµÄ¶ÓÎéË÷Òı.
	g_iRealSelInvitorIndex = g_iCurShowTeam_Invite;
	ClearUIModel();
	-- Ë¢ĞÂµ±Ç°½çÃæ
	TeamFrame_RefreshTeamInfo_Invite();

end



-------------------------------------------------------------------------------------------------------------------
-- ¶ÓÎéÑûÇë¾Ü¾ø¼ÓÈë¶ÓÎé
--
function TeamFrame_RejectJoinTeam_Invite()

		--AxTrace( 0,0, "ÑûÇë¶ÓÎé¸öÊı1"..tostring(g_iTeamCount_Invite));
		-- Ã»ÓĞÑûÇë¶ÓÎé·µ»Ø
		if(0 == g_iTeamCount_Invite) then

			return;
		end;

		-- ·¢ËÍ¾Ü¾ø¼ÓÈë¶ÓÎéÏûÏ¢.
		-- Player:RejectJoinTeam();
		--AxTrace( 0,0, "ÑûÇë¶ÓÎéÑ¡Ôñ1"..tostring(g_iRealSelInvitorIndex));
		Player:RejectJoinTeam(g_iRealSelInvitorIndex);

		g_iTeamCount_Invite = g_iTeamCount_Invite - 1;
		--AxTrace( 0,0, "ÑûÇë¶ÓÎé¸öÊı2"..tostring(g_iTeamCount_Invite));
		if(g_iTeamCount_Invite <= 0) then

			-- ¹Ø±Õ½çÃæ
			Team_Close();
			return;
		end

		--
		if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then

			g_iCurShowTeam_Invite = g_iTeamCount_Invite - 1;
		end

		-- ÉèÖÃµ±Ç°Ñ¡ÔñµÄ¶ÓÎé¡£		
		g_iRealSelInvitorIndex = g_iCurShowTeam_Invite;
		-- ½ûÖ¹ÏòÇ°·­Ò³
		if(0 == g_iCurShowTeam_Invite) then

			Team_Button_Frame3:Disable();

		else

			Team_Button_Frame3:Enable();

		end


		-- ½ûÖ¹Ïòºó·­Ò³
		if(g_iCurShowTeam_Invite >= (g_iTeamCount_Invite - 1)) then

			Team_Button_Frame4:Disable();

		else

			Team_Button_Frame4:Enable();

		end

		-- ÏÔÊ¾¶ÓÎéĞÅÏ¢
		TeamFrame_RefreshTeamInfo_Invite();


end


-------------------------------------------------------------------------------------------------------------------
-- ¶ÓÎéÑûÇë½çÃæÍ¬Òâ¼ÓÈë¶ÓÎé
--
function TeamFrame_AgreeJoinTeam_Invite()


		-- Ã»ÓĞÑûÇë¶ÓÎé·µ»Ø
		--AxTrace( 0,0, "ÑûÇë¶ÓÎé¸öÊı£½£½Í¬Òâ"..tostring(g_iTeamCount_Invite));
		if(0 == g_iTeamCount_Invite) then

			return;
		end;

		-- Í¬Òâ¼ÓÈë¶ÓÎé
		-- Player:AgreeJoinTeam();
		--AxTrace( 0,0, "ÑûÇë¶ÓÎéÑ¡Ôñ£½£½Í¬Òâ "..tostring(g_iRealSelInvitorIndex));
		Player:AgreeJoinTeam(g_iRealSelInvitorIndex);

		-- ¹Ø±Õ½çÃæ, ÏÂÒ»´Î´ò¿ªÊÇ×Ô½¨¶ÓÎé.
		g_iTeamInfoType = 4;
		
		-- Òş²Ø½çÃæ
		Team_Close();
end



--------------------------------------------------------------------------------------------------------------------
-- ¹Ø±Õ´°¿ÚÊÂ¼ş
--
function TeamFrame_CloseWindow()

	--if( g_iTeamInfoType == 1 ) then
		TeamFrame_RejectJoinTeam_Apply();
	--elseif(g_iTeamInfoType == 2) then
		--TeamFrame_RejectJoinTeam_Invite();
	--end
	
	Team_Close();


end



--------------------------------------------------------------------------------------------------------------------
-- Ë¢ĞÂ¶ÓÔ±ĞÅÏ¢, ´ò¿ªÆÕÍ¨½çÃæĞÅÏ¢
--
function TeamFrame_RefreshTeamMember_Team(index)

	local szNick;		-- êÇ³Æ
	local iFamily;	-- ÃÅÅÉ
	local iLevel;	  -- µÈ¼¶
	--local iCapID;		-- Ã±×Ó
	--local iHead;		-- Í·
	--local iArmourID;-- Éí×Ó
	--local iCuffID;  -- »¤Íó
	--local iFootID;	-- ÍÈ
	--local iWeaponID;-- ÎäÆ÷
	local bDeadlink;
	local bDead;
	local bSex;


	-- µÃµ½¶ÓÔ±µÄÏêÏ¸ĞÅÏ¢
	szNick
	,iFamily
	,iLevel
	--,iCapID
	--,iHead
	--,iArmourID
	--,iCuffID
	--,iFootID
	--,iWeaponID
	,bDead
	,bDeadlink
	,bSex
	= DataPool:GetTeamMemInfoByIndex( index );


	g_Team_PlayerInfo_Name[index]:SetText(tostring(szNick));
	g_Team_PlayerInfo_School[index]:SetText(tostring(iFamily));
	g_Team_PlayerInfo_Level[index]:SetText(tostring(iLevel));
	
	--AxTrace(0, 0, "ËÀÍöµôÏßĞÅÏ¢"..tostring(bDead)..tostring(bDead).."Ë÷Òı"..tostring(index));
	if(bDead > 0) then
		g_Team_PlayerInfo_Dead[index]:Show();
	end;

	if(bDeadlink > 0) then
		-- µôÏß±ê¼Ç
		g_Team_PlayerInfo_Deadlink[index]:Show();
	end;

	-- ÏÔÊ¾ÃÅÅÉĞÅÏ¢
	ShowFamily(index, iFamily);


	-- µÃµ½uiÄ£ĞÍĞÅÏ¢
	local strModelName = DataPool:GetTeamMemUIModelName(index);

	--AxTrace( 0,0, tostring(strModelName));
	-- ÏÔÊ¾Ä£ĞÍ
	g_TeamFrame_FakeObject[index]:SetFakeObject(strModelName);
	--AxTrace(0, 0, "Ë¢ĞÂ"..tostring(strModelName));
	
	
	local bIsInScene = DataPool:IsTeamMemberInScene(index);
	if(0 == bIsInScene) then
	
		--AxTrace( 0,0, "ÏÔÊ¾ÃÉ×Ó --"..tostring(index));
		g_Team_Ui_Model_Disable[index]:Show();
	else
	
		--AxTrace( 0,0, "Òş²ØÃÉ×Ó = "..tostring(index));
		g_Team_Ui_Model_Disable[index]:Hide();
	end;

end



--------------------------------------------------------------------------------------------------------------------
-- Ë¢ĞÂµ±Ç°Ò³ÃæĞÅÏ¢, ´ò¿ªÉêÇë½çÃæ
--
function TeamFrame_RefreshCurShowApplyPage_Apply(index)

	ClearUIModel();
	
	ShwoLeaderFlat(0);
	-- Çå¿Õ¾ÉµÄ½çÃæ.
	for iUI = 0, 5 do
			g_Team_PlayerInfo_Name[iUI]:SetText("");
			g_Team_PlayerInfo_School[iUI]:SetText("");
			g_Team_PlayerInfo_Level[iUI]:SetText("");

	end

	if(g_iMemberCount_Apply <= 0) then

		-- ¼ÓÈëÉêÇëÕßµÄ¸öÊıĞ¡ÓÚµÈÓÚ0 , ²»Ë¢ĞÂ½çÂôÅª
		return;

	end


	-- ¶ÓÔ±ĞÅÏ¢.
	local szNick;		-- êÇ³Æ
	local iFamily;	-- ÃÅÅÉ
	local iLevel;	  -- µÈ¼¶
	local iCapID;		-- Ã±×Ó
	local iHead;		-- Í·
	local iArmourID;-- Éí×Ó
	local iCuffID;  -- »¤Íó
	local iFootID;	-- ÍÈ
	local iWeaponID;-- ÎäÆ÷


	local iCurShowStart = index * g_iCurPageShowCount;
	local iCurShowEnd   = iCurShowStart + g_iCurPageShowCount;
	local iUIIndex = 0;

	if(iCurShowEnd > g_iMemberCount_Apply) then

		iCurShowEnd = g_iMemberCount_Apply;
	end;

	for i = iCurShowStart, iCurShowEnd - 1 do

		-- Ë¢ĞÂµ±Ç°½çÃæµÄÃ¿Ò»¸öÉêÇëÕßĞÅÏ¢.

		-- µÃµ½¶ÓÔ±µÄÏêÏ¸ĞÅÏ¢
		szNick
		,iFamily
		,iLevel
		,iCapID
		,iHead
		,iArmourID
		,iCuffID
		,iFootID
		,iWeaponID
		= DataPool:GetApplyMemberInfo(i);

		g_Team_PlayerInfo_Name[iUIIndex]:SetText(tostring(szNick));
		g_Team_PlayerInfo_School[iUIIndex]:SetText(tostring(iFamily));
		g_Team_PlayerInfo_Level[iUIIndex]:SetText(tostring(iLevel));

		-- ÏÔÊ¾ÃÅÅÉĞÅÏ¢
		ShowFamily(iUIIndex, iFamily);

		-- µÃµ½uiÄ£ĞÍĞÅÏ¢
		local strModelName = DataPool:GetApplyMemberUIModelName(i);

		-- ÏÔÊ¾Ä£ĞÍ
		g_TeamFrame_FakeObject[iUIIndex]:SetFakeObject(strModelName);

		iUIIndex = iUIIndex + 1;

	end
	
	SelectPos(0);

end



--------------------------------------------------------------------------------------------------------------------
-- ´ò¿ªÉêÇë½çÃæ, Ñ¡ÔñÒ»¸öÉêÇëÕß
--
function TeamFrame_SetCurSelectedApply_Apply(index)

	if(0 == g_iMemberCount_Apply) then

		--Èç¹ûÃ»ÓĞÉêÇëÕß, ·µ»Ø.
		return;
	end

	-- ×ª»»µ±Ç°Êµ¼ÊÑ¡ÔñµÄÉêÇëÕß.
	local iCurSelApply = g_iCurShowPage_Apply * g_iCurPageShowCount + index;

	-- Ë÷Òı³¬¹ı¶ÓÔ±¸öÊı·µ»Ø.
	--if(iCurSelApply >= g_iMemberCount_Apply) then

	--	return;
	--end;

	-- ÉèÖÃÑ¡ÖĞÉêÇëÕß
	-- Êµ¼ÊË÷Òı, ²»ÊÇ½çÃæË÷Òı
	g_iRealSelApplyIndex = iCurSelApply;       
	--DataPool:SetCurSelApply(iCurSelApply);
	g_iCurSelApply_Apply = iCurSelApply;
	
end


--------------------------------------------------------------------------------------------------------------------
-- ´ò¿ªÉêÇë½çÃæ, Í¬Òâ¼ÓÈë¶ÓÎé
--
function TeamFrame_AgreeJoinTeam_Apply(index)

	if(g_iCurSelApply_Apply >= g_iMemberCount_Apply) then
		
		return;
	end
	-- Í¬Òâ¼ÓÈë¶ÓÎé
	--Player:SendAgreeJoinTeam_Apply();
	Player:SendAgreeJoinTeam_Apply(g_iRealSelApplyIndex);
	
	g_iMemberCount_Apply = g_iMemberCount_Apply - 1;

	if(g_iMemberCount_Apply <= 0) then

		Team_Close();
		-- ÏÂ´Î´ò¿ª½çÃæÊÇ¶Ó³¤¿´µ½µÄ¶ÓÎéĞÅÏ¢
		--DataPool:SetTeamFrameOpenFlag(3);
		g_iTeamInfoType = 0;
	end

	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);

	if(g_iCurShowPage_Apply >= iPageCount) then

		-- ÉèÖÃĞÂµÄÏÔÊ¾Ò³
		g_iCurShowPage_Apply = iPageCount;

	end;

	-- É¾³ıÒ»¸öÉêÇëÕß
	DataPool:EraseApply(g_iCurSelApply_Apply);
	-- Ë¢ĞÂĞÂµÄÉêÇë½çÃæ
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);

end


--------------------------------------------------------------------------------------------------------------------
-- ´ò¿ªÉêÇë½çÃæ, ¾Ü¾ø¼ÓÈë¶ÓÎé
--
function TeamFrame_RejectJoinTeam_Apply(index)

	if(g_iCurSelApply_Apply >= g_iMemberCount_Apply) then
		
		return;
	end
	-- ·¢ËÍ¾Ü¾ø¼ÓÈë¶ÓÎéÏûÏ¢.
	--Player:SendRejectJoinTeam_Apply();
	Player:SendRejectJoinTeam_Apply(g_iRealSelApplyIndex);
	
	g_iMemberCount_Apply = g_iMemberCount_Apply - 1;

	if(g_iMemberCount_Apply <= 0) then

		Team_Close();
		-- ÏÂ´Î´ò¿ª½çÃæÊÇ¶Ó³¤¿´µ½µÄ¶ÓÎéĞÅÏ¢
		--DataPool:SetTeamFrameOpenFlag(3);
		g_iTeamInfoType = 0;
	end

	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);

	if(g_iCurShowPage_Apply >= iPageCount) then

		-- ÉèÖÃĞÂµÄÏÔÊ¾Ò³
		g_iCurShowPage_Apply = iPageCount;

	end;

	-- É¾³ıÒ»¸öÉêÇëÕß
	DataPool:EraseApply(g_iCurSelApply_Apply);
	-- Ë¢ĞÂĞÂµÄÉêÇë½çÃæ
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);
	Team_Show();
end



-------------------------------------------------------------------------------------------------------------------
-- ´ò¿ª¶ÓÎéÑûÇë½çÃæÏòÇ°·­Ò³
--
function TeamFrame_PageUp_Apply()

	-- ´ÓµÚ0Ò³¿ªÊ¼.
	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);


	-- ÏòÇ°·­Ò»Ò³
	g_iCurShowPage_Apply = g_iCurShowPage_Apply - 1;
	if(g_iCurShowPage_Apply < 0) then
		g_iCurShowPage_Apply = 0;
	end

	-- ½ûÖ¹ÏòÇ°·­Ò³
	--if(0 == g_iCurShowTeam_Invite) then
	if(0 == g_iCurShowPage_Apply) then
		Team_Button_Frame2:Disable();
	end

	-- ½ûÖ¹Ïòºó·­Ò³
	if(g_iCurShowPage_Apply < iPageCount) then
		Team_Button_Frame3:Enable();
	end


	ClearUIModel();
	-- Ë¢ĞÂµ±Ç°½çÃæ
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);


end



-------------------------------------------------------------------------------------------------------------------
-- ´ò¿ª¶ÓÎéÑûÇë½çÃæÏòºó·­Ò³
--
function TeamFrame_PageDown_Apply()

	-- ´ÓµÚ0Ò³¿ªÊ¼.
	local iPageCount = 0;
	iPageCount = (g_iMemberCount_Apply - 1) / g_iCurPageShowCount;
	iPageCount = math.floor(iPageCount);


	-- Ïòºó·­Ò»Ò³
	g_iCurShowPage_Apply = g_iCurShowPage_Apply + 1;
	if(g_iCurShowPage_Apply >=  iPageCount ) then

		g_iCurShowPage_Apply = iPageCount;
	end

	-- ½ûÖ¹Ïòºó·­Ò³
	if(g_iCurShowPage_Apply >= iPageCount) then
		Team_Button_Frame3:Disable();
	end

	-- ÔÊĞíÇ°·­
	if(g_iCurShowPage_Apply > 0) then
		Team_Button_Frame2:Enable();
	end

	ClearUIModel();
	-- Ë¢ĞÂµ±Ç°½çÃæ
	TeamFrame_RefreshCurShowApplyPage_Apply(g_iCurShowPage_Apply);

end


--------------------------------------------------------------------------------------------------------------------
--
-- Çå¿Õui½çÃæ
--
function ClearUIModel()

	g_TeamFrame_FakeObject[0]:SetFakeObject("");
	g_TeamFrame_FakeObject[1]:SetFakeObject("");
	g_TeamFrame_FakeObject[2]:SetFakeObject("");
	g_TeamFrame_FakeObject[3]:SetFakeObject("");
	g_TeamFrame_FakeObject[4]:SetFakeObject("");
	g_TeamFrame_FakeObject[5]:SetFakeObject("");

	HideUIModelDisable();
end;


--------------------------------------------------------------------------------------------------------------------
--
-- ÏÔÊ¾ÃÅÅÉ
--
function ShowFamily(MemIndex, Family)

	local strName = "Không có";

	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == Family) then
		strName = "Thiªu Lâm";

	elseif(1 == Family) then
		strName = "Minh Giáo";

	elseif(2 == Family) then
		strName = "Cái Bang";

	elseif(3 == Family) then
		strName = "Võ Ğang";

	elseif(4 == Family) then
		strName = "Nga My";

	elseif(5 == Family) then
		strName = "Tinh Túc";

	elseif(6 == Family) then
		strName = "Thiên Long";

	elseif(7 == Family) then
		strName = "Thiên S½n";

	elseif(8 == Family) then
		strName = "Tiêu Dao";

	elseif(9 == Family) then
		strName = "Không có";
		
	elseif(10 == Family) then
		strName = "Mµ Dung";
	end

	-- ÉèÖÃÏÔÊ¾µÄÃÅÅÉ.
	g_Team_PlayerInfo_School[MemIndex]:SetText(strName);

end;

function HideDeadFlag()

	-- ËÀÍö±ê¼Ç
	g_Team_PlayerInfo_Dead[0]:Hide();
	g_Team_PlayerInfo_Dead[1]:Hide();
	g_Team_PlayerInfo_Dead[2]:Hide();
	g_Team_PlayerInfo_Dead[3]:Hide();
	g_Team_PlayerInfo_Dead[4]:Hide();
	g_Team_PlayerInfo_Dead[5]:Hide();

end;

function HideDeadLinkFlag()

	-- µôÏß±ê¼Ç
	g_Team_PlayerInfo_Deadlink[0]:Hide();
	g_Team_PlayerInfo_Deadlink[1]:Hide();
	g_Team_PlayerInfo_Deadlink[2]:Hide();
	g_Team_PlayerInfo_Deadlink[3]:Hide();
	g_Team_PlayerInfo_Deadlink[4]:Hide();
	g_Team_PlayerInfo_Deadlink[5]:Hide();

end;

function ShwoLeaderFlat(bShow)

	if(0 == bShow) then

		Team_Captain_Icon:Hide();
	else

		Team_Captain_Icon:Show();
	end;

end;

function Team_Button_Abort_Team_Follow_Click()
	Player:StopFollow();
	Team_AbortTeamFollow_Button:Hide();
end

--Ã¿´Î´ò¿ª½çÃæÑ¡ÖĞ
function SelectPos(index)

		if(0 == index) then
			TeamFrame_Select1();
			Team_Model_1:SetCheck(1);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(1 == index) then
			TeamFrame_Select2();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(1);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(2 == index) then
			TeamFrame_Select3();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(1);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(3 == index) then
			TeamFrame_Select4();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(3);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(4 == index) then
			TeamFrame_Select5();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(1);
			Team_Model_6:SetCheck(0);
			return
		end;
		
		if(5 == index) then
			TeamFrame_Select6();
			Team_Model_1:SetCheck(0);
			Team_Model_2:SetCheck(0);
			Team_Model_3:SetCheck(0);
			Team_Model_4:SetCheck(0);
			Team_Model_5:SetCheck(0);
			Team_Model_6:SetCheck(1);
			return
		end;
		
		
end


function ClearInfo()

	ShwoLeaderFlat(0);
	HideDeadFlag();
	HideDeadLinkFlag();
	
	-- Çå¿Õ¾ÉµÄ½çÃæ.
	for iUI = 0, 5 do
			g_Team_PlayerInfo_Name[iUI]:SetText("");
			g_Team_PlayerInfo_School[iUI]:SetText("");
			g_Team_PlayerInfo_Level[iUI]:SetText("");
	end

end;

function RefreshUIModel()
	-- µ±Ç°¶ÓÎéÖĞ¶ÓÔ±µÄ¸öÊı.
	g_iTeamMemberCount_Team = DataPool:GetTeamMemberCount();
	if( g_iTeamMemberCount_Team <= 0 ) then
		return;
	end
	ClearUIModel();
	-- Ë¢ĞÂÃ¿¸ö¶ÓÔ±.
	for i = 0, g_iTeamMemberCount_Team - 1 do

		-- µÃµ½uiÄ£ĞÍĞÅÏ¢
		local strModelName = DataPool:GetTeamMemUIModelName(i);

		-- ÏÔÊ¾Ä£ĞÍ
		g_TeamFrame_FakeObject[i]:SetFakeObject(strModelName);
	end;

end;


----------------------------------------------------------------------------------------
--
-- Òş²ØÄ£ĞÍ.
--
function HideUIModelDisable()

	g_Team_Ui_Model_Disable[0]:Hide();
	g_Team_Ui_Model_Disable[1]:Hide();
	g_Team_Ui_Model_Disable[2]:Hide();
	g_Team_Ui_Model_Disable[3]:Hide();
	g_Team_Ui_Model_Disable[4]:Hide();
	g_Team_Ui_Model_Disable[5]:Hide();

end;


-----------------------------------------------------------------------------------------
--
-- ·¢ËÍ¼ÓÎªºÃÓÑÏûÏ¢
--
function SendAddFriendMsg()

		local iGUID = Player:GetTeamMemberGUID(g_iSel);
		if(-1 == iGUID) then
			
			return;
		end
		
		DataPool:AddFriend(Friend:GetCurrentTeam(), iGUID);
end;

function Team_ExpMode_change()
	local mode, nIndex = Team_Exp_Mode:GetCurrentSelect();
	DataPool:SetTeamExpMode(nIndex);
end


function Team_Update_ExpMode( isTeam )
	if( tonumber( isTeam ) == -1 ) then
		Team_Exp_Mode:Hide();
		Team_Exp_Mode_Text:Hide();
		return
	end
	local expMode = DataPool:GetTeamExpMode();
	
	local isLeader = Player:IsLeader();
	AxTrace( 0,0, "update expmode = "..tostring( expMode ).." Leader = "..tostring( isLeader ) );
	if( tonumber( isLeader ) == 0 ) then --²»ÊÇ¶Ó³¤
		if( expMode == 1 ) then
			Team_Exp_Mode_Text:SetText( "Phân ph¯i riêng" );
		elseif( expMode == 0 ) then
			Team_Exp_Mode_Text:SetText( "Phân ph¯i ğ«u" );
		else
			Team_Exp_Mode_Text:SetText( "Mô thÑc thu¥n thú" );
		end
		Team_Exp_Mode_Text:Show();
		Team_Exp_Mode:Hide();
	else
		Team_Exp_Mode:SetCurrentSelect( expMode );
		Team_Exp_Mode_Text:Hide();
		Team_Exp_Mode:Show();
	end
end


function Team_Close()

	--if( g_iTeamInfoType == 1 ) then
		--g_iTeamInfoType = 0;
--	elseif (g_iTeamInfoType == 2) then
		--if(g_iTeamCount_Invite <= 0) then                 --ÕâÑùĞ´ÊÇÎªÁË±ÜÃâÍ¬Ê±½Óµ½¶à¸öÑûÇë¡£
			--g_iTeamInfoType = 4;
		--end
	--end
	
	this:Hide();
end

function Team_Show()

	this:Show();
end

-- È·ÈÏ½âÉ¢¶ÓÎé
-- add by WTT		20090212
function Team_Confirm_Dismiss_Team ()

	Player:DismissTeam();						-- ½âÉ¢¶ÓÎé
	Team_Close();										-- ¹Ø±Õ×é¶Ó´°¿Ú

end
