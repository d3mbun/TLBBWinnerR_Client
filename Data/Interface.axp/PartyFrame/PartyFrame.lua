--***********************************************************************************************************************************************
--***********************************************************************************************************************************************
--
-- ×é¶ÓÁÐ±í¿òµÄÖ÷Òª½Å±¾ÊÂ¼þ
-- 
--
--
--************************************************************************************************************************************************
--************************************************************************************************************************************************



--------------------------------------------------------------------------------------------------------------------------------------------------
--
-- ¾Ö²¿±äÁ¿µÄ¶¨Òå.
--
local PARTYFRAMEs = {};
local PARTY_HP = {};
local PARTY_MP = {};
local PARTY_FRAME = {};
local PARTY_NAME  = {};
local Portrait_ToolTips = {};
local UnLink_flag = {};					-- µôÏß±ê¼Ç
local Porttrait_Mask = {};			-- »ÒµôÃÉ×Ó

-- ÏÔÊ¾hpµÄtext
local HP_Text_Tip = {};

local	MemberName;
local strIconIndex;
local HPValue;
local HPMax;
local MPValue;
local MPMax;
local Fammily;
local Level;
local Anger;
local DeadLink;
local Dead;
local sex;

-- ÏÔÊ¾¶ÓÓÑËùÖÐµÄbuf
local PARTY_BUFF_MAX = 12;
local PARTY_IMPACT_CTL = {};

-- ¶ÓÓÑ³öÕ½ÕäÊÞ°´Å¥
local Team_Member_Pet_Button = {};
-- ¶ÓÓÑµÄ³öÕ½ÕäÊÞÏÔÊ¾ÐÅÏ¢
local PetPortrait_ToolTips = {};

--***********************************************************************************************************************************************
--
-- 
--
--
--************************************************************************************************************************************************
function PartyFrame_PreLoad()

	--AxTrace( 0,0, "partyframe_Preload");
	this:RegisterEvent("TEAM_ENTER_MEMBER");				-- ×¢²á¶ÓÔ±¼ÓÈëÊÂ¼þ
	this:RegisterEvent("TEAM_UPDATE_MEMBER");				-- ×¢²á¶ÓÔ±¸üÐÂÊÂ¼þ
	this:RegisterEvent("TEAM_HIDE_ALL_PLAYER");			-- Òþ²ØËùÓÐ¶ÓÔ±ÊÂ¼þ
	this:RegisterEvent("TEAM_REFRESH_DATA");				-- ¸üÐÂÄ³Ò»¸ö¶ÓÔ±µÄÊÂ¼þ
	this:RegisterEvent("ON_TEAM_UPDATE_PARTYFRAME");			-- ¸üÐÂPartyFrame½çÃæ			add by WTT
	
end

function PartyFrame_OnLoad()
	
	
	PARTYFRAMEs[1] = PartyFrame1;
	PARTYFRAMEs[2] = PartyFrame2;
	PARTYFRAMEs[3] = PartyFrame3;
	PARTYFRAMEs[4] = PartyFrame4;
	PARTYFRAMEs[5] = PartyFrame5;

	PARTY_HP[1] = PartyFrame_HP1;
	PARTY_HP[2] = PartyFrame_HP2;
	PARTY_HP[3] = PartyFrame_HP3;
	PARTY_HP[4] = PartyFrame_HP4;
	PARTY_HP[5] = PartyFrame_HP5;

	--PARTY_MP[1] = PartyFrame_MP1;
	--PARTY_MP[2] = PartyFrame_MP2;
	--PARTY_MP[3] = PartyFrame_MP3;
	--PARTY_MP[4] = PartyFrame_MP4;
	--PARTY_MP[5] = PartyFrame_MP5;

	PARTY_FRAME[1] = PartyFrame_Party1;
	PARTY_FRAME[2] = PartyFrame_Party2;
	PARTY_FRAME[3] = PartyFrame_Party3;
	PARTY_FRAME[4] = PartyFrame_Party4;
	PARTY_FRAME[5] = PartyFrame_Party5;
	
	--PARTY_NAME[1] = Name1;
	--PARTY_NAME[2] = Name2;
	--PARTY_NAME[3] = Name3;
	--PARTY_NAME[4] = Name4;
	--PARTY_NAME[5] = Name5;
	
	Portrait_ToolTips[1] = Portrait_Icon1;
	Portrait_ToolTips[2] = Portrait_Icon2;
	Portrait_ToolTips[3] = Portrait_Icon3;
	Portrait_ToolTips[4] = Portrait_Icon4;
	Portrait_ToolTips[5] = Portrait_Icon5;
	
	HP_Text_Tip[1] = PartyFrame_HP_Text1;
	HP_Text_Tip[2] = PartyFrame_HP_Text2;
	HP_Text_Tip[3] = PartyFrame_HP_Text3;
	HP_Text_Tip[4] = PartyFrame_HP_Text4;
	HP_Text_Tip[5] = PartyFrame_HP_Text5;
	
	--2006Äê5ÔÂ20ÈÕ, ÐÞ¸ÄµôÏßÐÅÏ¢¹¦ÄÜ
	UnLink_flag[1] = Team_Leader_Flag2;
	UnLink_flag[2] = Team_Leader2_Flag2;
	UnLink_flag[3] = Team_Leader3_Flag2;
	UnLink_flag[4] = Team_Leader4_Flag2;
	UnLink_flag[5] = Team_Leader5_Flag2;
	
	
	--2006Äê5ÔÂ20ÈÕ, ÐÞ¸ÄËÀÍöÃÉ×Ó
	Porttrait_Mask[1] = Portrait_Icon1_Mask;
	Porttrait_Mask[2] = Portrait_Icon2_Mask;
	Porttrait_Mask[3] = Portrait_Icon3_Mask;
	Porttrait_Mask[4] = Portrait_Icon4_Mask;
	Porttrait_Mask[5] = Portrait_Icon5_Mask;
	
	
	PARTY_IMPACT_CTL[1] = {
												PartyFrame_1_Buff1,
												PartyFrame_1_Buff2,
												PartyFrame_1_Buff3,
												PartyFrame_1_Buff4,
												PartyFrame_1_Buff5,
												PartyFrame_1_Buff6,
												PartyFrame_1_Buff7,
												PartyFrame_1_Buff8,
												PartyFrame_1_Buff9,
												PartyFrame_1_Buff10,
												PartyFrame_1_Buff11,
												PartyFrame_1_Buff12,
											};
	PARTY_IMPACT_CTL[2] = {
												PartyFrame_2_Buff1,
												PartyFrame_2_Buff2,
												PartyFrame_2_Buff3,
												PartyFrame_2_Buff4,
												PartyFrame_2_Buff5,
												PartyFrame_2_Buff6,
												PartyFrame_2_Buff7,
												PartyFrame_2_Buff8,
												PartyFrame_2_Buff9,
												PartyFrame_2_Buff10,
												PartyFrame_2_Buff11,
												PartyFrame_2_Buff12,
											};
	PARTY_IMPACT_CTL[3] = {
												PartyFrame_3_Buff1,
												PartyFrame_3_Buff2,
												PartyFrame_3_Buff3,
												PartyFrame_3_Buff4,
												PartyFrame_3_Buff5,
												PartyFrame_3_Buff6,
												PartyFrame_3_Buff7,
												PartyFrame_3_Buff8,
												PartyFrame_3_Buff9,
												PartyFrame_3_Buff10,
												PartyFrame_3_Buff11,
												PartyFrame_3_Buff12,
											};
	PARTY_IMPACT_CTL[4] = {
												PartyFrame_4_Buff1,
												PartyFrame_4_Buff2,
												PartyFrame_4_Buff3,
												PartyFrame_4_Buff4,
												PartyFrame_4_Buff5,
												PartyFrame_4_Buff6,
												PartyFrame_4_Buff7,
												PartyFrame_4_Buff8,
												PartyFrame_4_Buff9,
												PartyFrame_4_Buff10,
												PartyFrame_4_Buff11,
												PartyFrame_4_Buff12,
											};
	PARTY_IMPACT_CTL[5] = {
												PartyFrame_5_Buff1,
												PartyFrame_5_Buff2,
												PartyFrame_5_Buff3,
												PartyFrame_5_Buff4,
												PartyFrame_5_Buff5,
												PartyFrame_5_Buff6,
												PartyFrame_5_Buff7,
												PartyFrame_5_Buff8,
												PartyFrame_5_Buff9,
												PartyFrame_5_Buff10,
												PartyFrame_5_Buff11,
												PartyFrame_5_Buff12,
											};
							
											
	Team_Leader2_Flag:Hide();
	Team_Leader3_Flag:Hide();
	Team_Leader4_Flag:Hide();
	Team_Leader5_Flag:Hide();
	
	-- µÚ1ÖÁ5ºÅ¶ÓÓÑµÄ³öÕ½³èÎï°´Å¥
	-- add by WTT
	Team_Member_Pet_Button[1] = Team_Pet_Button;
	Team_Member_Pet_Button[2] = Team_Pet2_Button;
	Team_Member_Pet_Button[3] = Team_Pet3_Button;
	Team_Member_Pet_Button[4] = Team_Pet4_Button;
	Team_Member_Pet_Button[5] = Team_Pet5_Button;
	
	-- ÕäÊÞÍ·ÏñÉÏµÄ¸¡¶¯ÐÅÏ¢
	-- add by WTT
	PetPortrait_ToolTips[1]= Team_Pet_Button;
	PetPortrait_ToolTips[2]= Team_Pet2_Button;
	PetPortrait_ToolTips[3]= Team_Pet3_Button;
	PetPortrait_ToolTips[4]= Team_Pet4_Button;
	PetPortrait_ToolTips[5]= Team_Pet5_Button;
	
end

--****************************************************************************************************************
--
-- ÊÂ¼þÈë¿Ú
--
--****************************************************************************************************************
function PartyFrame_OnEvent(event)
	
	--AxTrace( 0,0, "eventÃæ");
	----------------------------------------------------------------------------------------------------------------
	--
	-- Òþ²ØËùÓÐ¶ÓÓÑ½çÃæ
	if ( event == "TEAM_HIDE_ALL_PLAYER" ) then
	
		--AxTrace( 0,0, "É¾³ýËùÓÐ½çÃæ");
		Hide_All_Play_Func();
		return;
	end


	-----------------------------------------------------------------------------------------------------------------
	--
	-- ¸üÐÂËùÓÐ¶ÓÓÑ½çÃæ.
	if( event == "TEAM_REFRESH_DATA" ) then
	
		Refresh_All_Member_Info_Func();
			return;
	end



	------------------------------------------------------------------------------------------------------------------
	--
	-- ÓÐÐÂµÄ¶ÓÔ±½øÈë
	if ( event == "TEAM_ENTER_MEMBER" ) then
		Refresh_All_Member_Info_Func();
		return;

	end
	
	
	
	--------------------------------------------------------------------------------------------------------------------
	--
	-- ¸üÐÂ¶ÓÔ±ÐÅÏ¢.
	if ( event == "TEAM_UPDATE_MEMBER" ) then
			Refresh_All_Member_Info_Func();
		return;

	end
	
	--------------------------------------------------------------------------------------------------------------------
	--
	-- ¸üÐÂPartyFrame½çÃæ
	-- add by WTT
	if ( event == "ON_TEAM_UPDATE_PARTYFRAME" ) then
		Refresh_All_Member_Info_Func();
		return;
	end
	
	
end


--***********************************************************************************************************************************************
--
-- ÏÔÊ¾Ò»¸öÐÂ¼ÓÈëµÄ¶ÓÔ±
--
--************************************************************************************************************************************************
function PartyFrame_UpdatePage(index)

	
	--AxTrace( 0,0, "ÏÔÊ¾¶ÓÓÑ!" .. tostring(index));
	if((index < 1) or (index > 5)) then
			--AxTrace( 0,0, "½çÃæË÷Òý³öÏÖÒì³£!");
			return;
	end
		
	this:Show();
	
	--ÏÔÊ¾ÐÂ¼ÓÈë¶ÓÓÑµÄÍ·Ïñ
	PARTYFRAMEs[index]:Show();
	
	--ÏÔÊ¾ÐÂ¼ÓÈë¶ÓÓÑµÄÕäÊÞ°´Å¥
	PetButton_Show (index);

	--AxTrace( 0,0, "ÏÔÊ¾¶ÓÓÑÍê±Ï!" .. tostring(index));
	
end



--***********************************************************************************************************************************************
--
-- µ±ÓÒ¼üµã»÷´°¿ÚµÄÊ±ºò, µ¯³ö²Ëµ¥
--
--************************************************************************************************************************************************
function Show_Team_Func(index)
	
	PartyFrame_SelectAsTarget(index)
	Show_Team_Func_Menu(index);
end


--***********************************************************************************************************************************************
--
-- Òþ²Ø¶ÓÁÐ´°¿Ú
--
--************************************************************************************************************************************************
function Hide_All_Play_Func()
	
	local index = 1;
	while (index < 6) do 
		
			PARTYFRAMEs[index]:Hide();
			Team_Member_Pet_Button[index]:Hide();

			index = index + 1;
			
	end
	
	Team_Leader_Flag:Hide();
	PartyFrame_ClerAllBufInfo();
	
end


--***********************************************************************************************************************************************
--
-- ÏÔÊ¾¶ÓÔ±ÐÅÏ¢
--
--************************************************************************************************************************************************
function Show_Team_Member_Info_Func(index)
	
		--AxTrace( 0,0, "¿ªÊ¼µÃµ½¶ÓÓÑÐÅÏ¢Íê±Ï!" .. tostring(index));
		-- µÃµ½¶ÓÔ±µÄ¸öÊý
		local iMemCount = DataPool:GetTeamMemberCount();
		--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊý!" .. tostring(iMemCount));
				
		if((iMemCount < 1)and(iMemCount > 5)) then
		
			--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊýÒì³£" .. tostring(iMemCount));
			return;
		end
		
		-- µÃµ½¶ÓÔ±µÄÏêÏ¸ÐÅÏ¢
		MemberName
		, strIconIndex
		, HPValue
		, HPMax
		, MPValue
		, MPMax 
		, Fammily
		, Level
		, Anger
		, DeadLink
		, Dead
		, sex
		, ScenceName
		= DataPool:GetTeamMemberInfo( index );
		
		--AxTrace( 0,0, "µÃµ½¶ÓÓÑÐÅÏ¢Íê±Ï!" .. tostring(index));
		-- ÉèÖÃÃû×Ö.
		--PARTY_NAME[index]:SetText(MemberName);
		
		-- ÉèÖÃhp
		if(-1 ~= HPValue) then
			PARTY_HP[index]:SetProgress(tonumber(HPValue), tonumber(HPMax));
		else
			PARTY_HP[index]:SetProgress(1, 1);
		end;
		--AxTrace( 0,0, "µ±Ç°ÑªÖµ!" .. tostring(HPValue));
		--AxTrace( 0,0, "ÑªÖµ×î´ó!" .. tostring(HPMax));
		
		-- ÉèÖÃmp
		--PARTY_MP[index]:SetProgress(tonumber(MPValue), tonumber(MPMax));
		--AxTrace( 0,0, "µ±Ç°Ä§·¨!" .. tostring(MPValue));
		--AxTrace( 0,0, "Ä§·¨×î´ó!" .. tostring(MPMax));
		
		
		Show_Leader_Flag_Func();
		
		-- ÉèÖÃtooltips
		local bDead = "Không";
		local bDeadLink = "Không";
			
		Portrait_ToolTips[index]:SetProperty("Image", "set:PlayerFrame_Icon image:Icon_xiaoyao");
		Portrait_ToolTips[index]:SetProperty("Image", strIconIndex);
	
		--if(0 ~= Dead) then
		--	bDead = "ÊÇ"
		--	Portrait_ToolTips[index]:SetProperty("Image", "set:TeamFrame5 image:Die_Icon");
		--end	
		
		--if(0 ~= DeadLink) then
		--	bDeadLink = "ÊÇ"
		--	AxTrace( 0,0, "ÉèÖÃµôÏßÐÅÏ¢");
		--	Portrait_ToolTips[index]:SetProperty("Image", "set:TeamFrame5 image:Downline_Icon");
		--end
		
		AxTrace( 0,0, "ÐÕt ðßþc tin tÑc chiªn hæu kªt thúc!" .. tostring(index));
		if(0 ~= Dead) then
			bDead = "Có"
			--Portrait_ToolTips[tonumber(index)]:Disable();
			Porttrait_Mask[index]:Show();
		else
		
			--Portrait_ToolTips[tonumber(index)]:Eable();
			Porttrait_Mask[index]:Hide();
		end	
		
		if(0 == DeadLink) then
		
			UnLink_flag[tonumber(index)]:Hide();
		else
		
			bDeadLink = "Có"
			UnLink_flag[tonumber(index)]:Show();
		end
		
		
		--local strInfo = "\n Ãû×Ö: "  
		--								.. tostring(MemberName)
		--      					.. "\n ÃÅÅÉ:"
		--								.. tostring(Fammily)
		--								.. "\n µÈ¼¶:"
		--								.. tostring(Level)
		--								.. " \n hp:"
		--								.. tostring(HPValue) .. "/" .. tostring(HPMax)
		--								.. " \n mp:"
		--								.. tostring(MPValue) .. "/" .. tostring(MPMax)
		--								.. " \n Å­Æø:"
		--								.. tostring(Anger)
		--								.. " \n ¶ÏÏß:"
		--								.. tostring(bDeadLink)
		--								.. " \n ËÀÍö:"
		--								.. tostring(bDead);
		
		--AxTrace( 0,0, "fmaily  " .. tostring(Fammily));
		local strMenPai = "";
		-- µÃµ½ÃÅÅÉÃû³Æ.
		if(0 == Fammily) then
			strMenPai = "Thiªu Lâm";
	
		elseif(1 == Fammily) then
			strMenPai = "Minh Giáo";
	
		elseif(2 == Fammily) then
			strMenPai = "Cái Bang";
	
		elseif(3 == Fammily) then
			strMenPai = "Võ Ðang";
	
		elseif(4 == Fammily) then
			strMenPai = "Nga My";
	
		elseif(5 == Fammily) then
			strMenPai = "Tinh Túc";
	
		elseif(6 == Fammily) then
			strMenPai = "Thiên Long";
	
		elseif(7 == Fammily) then
			strMenPai = "Thiên S½n";
	
		elseif(8 == Fammily) then
			strMenPai = "Tiêu Dao";
	
		elseif(9 == Fammily) then
			strMenPai = "Không có";
		end
	
		local strInfo = tostring(MemberName)
		      					.. "\n"
										.. tostring(strMenPai).."  "
										.. tostring(Level).." c¤p"
										.. "\nÐang ·: "
										.. ScenceName;
									
										
		Portrait_ToolTips[index]:SetToolTip(strInfo);
		
		if(-1 == HPValue) then
		
			-- ¿ç³¡¾°µÄÇé¿ö¡£
			PARTY_HP[index]:SetToolTip("Chßa biªt");
		else
		
			PARTY_HP[index]:SetToolTip(tostring(HPValue).."/"..tostring(HPMax));
		end;	
		
		PartyFrame_ClerBufInfo(index);
		PartyFrame_UpdateBufInfo(index);

		-- ÏÔÊ¾¶ÓÔ±³öÕ½ÕäÊÞÍ¼±ê
		PetButton_Show(index);
	
end


--***********************************************************************************************************************************************
--
-- ¸üÐÂËùÓÐ¶ÓÔ±ÐÅÏ¢
--
--************************************************************************************************************************************************
function Refresh_All_Member_Info_Func()
	
		-- ÏÈÒþ²ØµôËùÓÐµÄ¶ÓÔ±.
		Hide_All_Play_Func();
		
		-- µÃµ½¶ÓÔ±µÄ¸öÊý
		local iMemCount = DataPool:GetTeamMemberCount();
		--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊý!" .. tostring(iMemCount));
		
		-- 
		if((iMemCount < 1)or(iMemCount > 6)) then
		
			--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊýÒì³£" .. tostring(iMemCount));
			return;
		end
						
		for index = 1, iMemCount - 1 do
			
				-- ÏÔÊ¾Ò»¸ö¶ÓÔ±
				PartyFrame_UpdatePage(index);
				
				-- ÏÔÊ¾¶ÓÔ±µÄÏêÏ¸ÐÅÏ¢
				Show_Team_Member_Info_Func(index);
				
				-- ÏÔÊ¾¶ÓÔ±µÄÕäÊÞ°´Å¥
				PetButton_Show(index);

		end
		
		Show_Leader_Flag_Func();
	
end


--***********************************************************************************************************************************************
--
-- ÏÔÊ¾¶Ó³¤ÐÅÏ¢
--
--************************************************************************************************************************************************
function Show_Leader_Flag_Func()

	-- ÏÔÊ¾¶Ó³¤±ê¼Ç
	local iIsLeader = DataPool:IsTeamLeader();
	if (1 == iIsLeader) then
		
		Team_Leader_Flag:Show();
	end
		
end


--***********************************************************************************************************************************************
--
-- Ñ¡Ôñ¶ÓÓÑ×÷Îªtarget(Í¬ÓÎÏ·ÖÐ, ÓÒ¼üµã»÷Ò»¸öÄ£ÐÍÐ§¹ûÒ»Ñù)
--
--************************************************************************************************************************************************
function PartyFrame_SelectAsTarget(UIIndex)

	--AxTrace( 0,0, "Ñ¡ÔñÍ·Ïñ");
	DataPool:SelectAsTargetByUIIndex(UIIndex);
	-- PushDebugMessage(UIIndex)
end;


--***********************************************************************************************************************************************
--
-- Êó±êÒÆÈëÊÂ¼þ
--
--************************************************************************************************************************************************

function PartyFrame_HP_Text_MouseEnter(UIIndex)

	
		-- µÃµ½¶ÓÔ±µÄÏêÏ¸ÐÅÏ¢
		--MemberName
		--, strIconIndex
		--, HPValue
		--, HPMax
		--, MPValue
		--, MPMax 
		--, Fammily
		--, Level
		--, Anger
		--, DeadLink
		--, Dead
		--, sex
		--= DataPool:GetTeamMemberInfo( UIIndex );
	--AxTrace( 0,0, "party frame enter"..tostring(UIIndex));
	--local ShowHpTipText = "";
	
	--if(-1 == HPValue) then
	
	--	ShowHpTipText = "Î´Öª";
	--else
	
	--	ShowHpTipText = tostring(HPValue).."/"..tostring(HPMax);
	--end;
	--HP_Text_Tip[UIIndex]:SetText(ShowHpTipText);
	
end;

--***********************************************************************************************************************************************
--
-- Êó±êÒÆ³öÊÂ¼þ
--
--************************************************************************************************************************************************

function PartyFrame_HP_Text_MouseLeave(UIIndex)

	--AxTrace( 0,0, "party frame out"..tostring(UIIndex));
	--HP_Text_Tip[UIIndex]:SetText("");
end;

function PartyFrame_ClerAllBufInfo()
	local i;
	for i = 1, 5 do
		PartyFrame_ClerBufInfo( i );
	end
end

function PartyFrame_ClerBufInfo( idx )
	if(idx == nil) then return; end
	if(idx < 1 or idx > 5) then return; end
	
	local i = 0;
	while i < PARTY_BUFF_MAX do
		--AxTrace(0,0,"PartyFrame_ClerBufInfo:"..idx);
		PARTY_IMPACT_CTL[idx][i+1]:SetToolTip("");
		PARTY_IMPACT_CTL[idx][i+1]:Hide();
		i = i + 1;
	end
end

function PartyFrame_UpdateBufInfo( idx )
	if(idx < 1 or idx > 5) then return; end
	local nBuffNum = DataPool:GetTeamMemBufNum(idx);
	if(nBuffNum > PARTY_BUFF_MAX) then nBuffNum = PARTY_BUFF_MAX; end
	
	local i = 0;
	local m = 0;
	while i < nBuffNum do
		local szIconName;
		local szTipInfo;
		
		szIconName,szTipInfo = DataPool:GetTeamMemBufInfo(idx, i);
		if szTipInfo ~= "TTPS" and m <= 11 then
			if type(szTipInfo) == "string" then
				PARTY_IMPACT_CTL[idx][m+1]:SetProperty("ShortImage", szIconName);
				PARTY_IMPACT_CTL[idx][m+1]:Show();
				PARTY_IMPACT_CTL[idx][m+1]:SetToolTip(szTipInfo);
				m = m + 1;
			end
		end
		i = i + 1;
	end
	
	while m < PARTY_BUFF_MAX do
		PARTY_IMPACT_CTL[idx][m+1]:SetToolTip("");
		PARTY_IMPACT_CTL[idx][m+1]:Hide();
		m = m + 1;
	end
end

--***********************************************************************************************************************************************
--
-- ÏÔÊ¾¶ÓÔ±µÄÕäÊÞ°´Å¥
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_Show(UIIndex)
	
	-- ÏÔÊ¾ÕäÊÞ°´Å¥
	Team_Member_Pet_Button[UIIndex]:Show();

	return
	
end

--***********************************************************************************************************************************************
--
-- Êó±êµ¥»÷£º´ò¿ª¶ÓÓÑ³öÕ½ÕäÊÞµÄ×ÊÁÏ
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_ToggleTargetPetPage(UIIndex)

	--PushDebugMessage ("PetFlag_ToggleTargetPetPage "..UIIndex);		
	
	-- Ê×ÏÈÍ¨¹ýUIË÷ÒýÀ´Ñ¡ÖÐ¶ÓÓÑµÄÕäÊÞ×÷Îªµ±Ç°Ñ¡ÖÐÄ¿±ê
	local iFindFightingPet = DataPool:SelectTeamMemPetAsTargetByUIIndex(UIIndex);
	
	-- Èç¹ûÕÒ²»µ½¶ÓÓÑµÄ³öÕ½ÕäÊÞ
	if (iFindFightingPet == -1) then
	
		PushDebugMessage ("#{ZSAN_90311_2}");			-- ¶ÓÓÑ²»ÔÚ¸½½ü£¬»òÕßÎÞ³öÕ½ÕäÊÞ£¬ÎÞ·¨²é¿´ÕäÊÞÐÅÏ¢¡£
		
	-- Èç¹ûÄÜÕÒµ½¶ÓÓÑµÄ³öÕ½ÕäÊÞ
	else
	
		-- ²é¿´¶ÓÓÑ³öÕ½ÕäÊÞµÄÏêÏ¸ÐÅÏ¢
		Pet:HandlePetMenuItem("detail");
	
	end
	
	-- ¸üÐÂµ±Ç°µÄPartyFrame½çÃæ
	Update_PartyFrame_Menu ();
	
end