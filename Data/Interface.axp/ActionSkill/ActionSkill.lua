local Current_Xinfa_Name,Current_Xinfa_Level;

local Current_Xinfa = 1;
local Current_Skill = -1;
local Current_Nuqi = -1;

--local XINFA_LEVEL = {};
local XINFA_INDEX = {};
local XINFA_BUTTONS_NUM = 8;
local XINFA_BUTTONS = {};

local SKILL_INDEX = {};
local SKILL_BUTTONS_NUM = 5;
local SKILL_BUTTONS = {};


--√≈≈…÷˜ Ù–‘±Ì
local MenPai_MainAttr = {
[1] = {image = "set:UIIcons image:Ice_Repellency_Normal", Tooltip = "MPZSX_20071221_11" },
[2] = {image = "set:UIIcons image:Fire_Repellency_Normal", Tooltip = "MPZSX_20071221_12" },
[3] = {image = "set:UIIcons image:Thunder_Repellency_Normal", Tooltip = "MPZSX_20071221_13" },
[4] = {image = "set:UIIcons image:Poison_Repellency_Normal", Tooltip = "MPZSX_20071221_14" } };

local MenPai_UsedAttr = {
[0] = {image = "set:Menpaishuxing image:Shuxing_Dark", Tooltip = "MPZSX_20071221_13", },			--…Ÿ¡÷
[1] = {image = "set:Menpaishuxing image:Shuxing_Fire", Tooltip = "MPZSX_20071221_12",},				--√˜ΩÃ
[2] = {image = "set:Menpaishuxing image:Shuxing_PoisonFire", Tooltip = "MPZSX_20071221_15",},		--ÿ§∞Ô
[3] = {image = "set:Menpaishuxing image:Shuxing_DarkIce", Tooltip = "MPZSX_20071221_16",},			--Œ‰µ±
[4] = {image = "set:Menpaishuxing image:Shuxing_IceDark", Tooltip = "MPZSX_20071221_17",},			--∂Î·“
[5] = {image = "set:Menpaishuxing image:Shuxing_Poison", Tooltip = "MPZSX_20071221_14",},			--–«Àﬁ
[6] = {image = "set:Menpaishuxing image:Shuxing_FIPD", Tooltip = "MPZSX_20071221_18",},				--ÃÏ¡˙
[7] = {image = "set:Menpaishuxing image:Shuxing_Ice", Tooltip = "MPZSX_20071221_11",},				--ÃÏ…Ω
[8] = {image = "set:Menpaishuxing image:Shuxing_FirePoison", Tooltip = "MPZSX_20071221_19",},		--Â–“£
[9] = {image = "", Tooltip = "KhÙng cÛ",},															--Œﬁ√≈≈…
[10]= {image = "set:Menpaishuxing image:Shuxing_Dark", Tooltip = "MPZSX_20071221_13", },			--ƒΩ»›
};


-- ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
local g_ActionSkill_Frame_UnifiedXPosition;
local g_ActionSkill_Frame_UnifiedYPosition;

function ActionSkill_PreLoad()
	this:RegisterEvent("TOGLE_SKILL_BOOK");
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("TOGLE_LIFE_PAGE");
	this:RegisterEvent("SKILL_UPDATE");
	this:RegisterEvent("CLOSE_SKILL_BOOK");
	this:RegisterEvent("JOIN_NEW_MENPAI");
    this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS")

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function ActionSkill_OnLoad()
	XINFA_BUTTONS[1] = ActionSkill_Xinfa1;
	XINFA_BUTTONS[2] = ActionSkill_Xinfa2;
	XINFA_BUTTONS[3] = ActionSkill_Xinfa3;
	XINFA_BUTTONS[4] = ActionSkill_Xinfa4;
	XINFA_BUTTONS[5] = ActionSkill_Xinfa5;
	XINFA_BUTTONS[6] = ActionSkill_Xinfa6;
	XINFA_BUTTONS[7] = ActionSkill_Xinfa7;
	XINFA_BUTTONS[8] = ActionSkill_Xinfa8;

	SKILL_BUTTONS[1] = ActionSkill_Zhaoshi1;
	SKILL_BUTTONS[2] = ActionSkill_Zhaoshi2;
	SKILL_BUTTONS[3] = ActionSkill_Zhaoshi3;
	SKILL_BUTTONS[4] = ActionSkill_Zhaoshi4;
	SKILL_BUTTONS[5] = ActionSkill_Zhaoshi5;

	ActionSkill_SetTabColor();

	-- ±£¥ÊΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
	g_ActionSkill_Frame_UnifiedXPosition	= ActionSkill_Frame : GetProperty("UnifiedXPosition");
	g_ActionSkill_Frame_UnifiedYPosition	= ActionSkill_Frame : GetProperty("UnifiedYPosition");

end
-- OnEvent
function ActionSkill_OnEvent(event)

	if ( event == "TOGLE_SKILL_BOOK" ) then
			local selfUnionPos = Variable:GetVariable("SkillUnionPos");
			if(selfUnionPos ~= nil) then
				ActionSkill_Frame:SetProperty("UnifiedPosition", selfUnionPos);
			end
			ActionSkill_Open();
			ActionSkill_Update();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2014092002) then
		local xx = Get_XParam_INT(0)
		if tonumber(xx) == nil then
			return
		end
		ActionSkill_doskill(xx)		
	    return		
	elseif( event == "SKILL_UPDATE" and this:IsVisible()) then
		ActionSkill_Update();
	elseif ( event == "TOGLE_LIFE_PAGE" ) then
		ActionSkill_Close();
	elseif ( event == "TOGLE_COMMONSKILL_PAGE" ) then
		ActionSkill_Close();
	elseif ( event == "CLOSE_SKILL_BOOK" ) then
		ActionSkill_Close();
	elseif( event == "ACTION_UPDATE" ) then
		ActionSkill_NewSkillStudy();

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	elseif (event == "ADJEST_UI_POS" ) then
		-- ∏¸–¬±≥∞¸ΩÁ√ÊŒª÷√
		ActionSkill_Frame_On_ResetPos()

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ∏¸–¬±≥∞¸ΩÁ√ÊŒª÷√	
		ActionSkill_Frame_On_ResetPos()

	end
end
function ActionSkill_doskill(idso)
	local itemid = 0
	local nSumSkill = GetActionNum("skill");
	for i=1, nSumSkill do
	
		theAction = EnumAction(i-1, "skill");
		if theAction:GetID() ~= -1  then
			if theAction:GetDefineID() == idso and itemid == 0 then
				itemid = theAction:GetID()
			else
				if itemid ~= 0 then
					break
				end
			end
		end
			
	end
	if itemid == 0 then
		return
	end

	local itemseid = ActionSkill_ZhaoshiTarget:GetActionItem()		
	ActionSkill_ZhaoshiTarget:SetActionItem(itemid)
	ActionSkill_ZhaoshiTarget:DoAction();
	ActionSkill_ZhaoshiTarget:SetActionItem(itemseid)

end

--—ßª·¡À–¬ººƒ‹¡À
function ActionSkill_NewSkillStudy()
	for i=1,6 do
		XINFA_BUTTONS[i]:SetNewFlash();
	end
	for i=1,5 do
		SKILL_BUTTONS[i]:SetNewFlash();
	end
end

function ActionSkill_OnShown()
	ActionSkill_Update();
end

function ActionSkill_Clear()
	Current_Xinfa = -1;

	for i=1, XINFA_BUTTONS_NUM do
		XINFA_BUTTONS[i]:SetActionItem(-1);
		XINFA_INDEX[i] = -1;
--		XINFA_LEVEL[i] : SetText("");
	end

--	for i=1, NUQI_BUTTONS_NUM do
--		NUQI_BUTTONS[i]:SetActionItem(-1);
--		NUQI_INDEX[i] = -1;
--	end

	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetActionItem(-1);
		SKILL_INDEX[i] = -1;
	end

end

function ActionSkill_Update()

	local i;
	ActionSkill_Use : Hide();
	ActionSkill_Explain : SetText("");
	ActionSkill_Name : SetText("");
	ActionSkill_LifeSkill : SetCheck(0);
	ActionSkill_CommonlySkill : SetCheck(0);
	ActionSkill_ActionSkill : SetCheck(1);
--œ‘ æ–ƒ∑®
	for i=1, XINFA_BUTTONS_NUM do
		local theAction = EnumAction(i-1, "xinfa");

		if theAction:GetID() ~= 0 then
			XINFA_BUTTONS[i]:SetActionItem(theAction:GetID());


			XINFA_INDEX[i] = theAction:GetID();
			local nXinfaId = LifeAbility : GetLifeAbility_Number(XINFA_INDEX[i]);
			local nXinfa_level = Player:GetXinfaInfo(nXinfaId,"level");

			local str = "BotRight "..tostring(nXinfa_level);
			AxTrace(0,1,"botright="..str)
			XINFA_BUTTONS[i]:SetProperty("CornerChar",str);
			AxTrace(0,1,"property="..XINFA_BUTTONS[i]:GetProperty("CornerChar"))

		else
			XINFA_BUTTONS[i]:SetActionItem(-1);
			XINFA_INDEX[i] = -1;
--			XINFA_LEVEL[i] : SetText("√ª”–");
		end
	end


	if(Current_Xinfa ~= -1 and XINFA_BUTTONS[Current_Xinfa] ~= -1) then
		ActionSkill_Update_Cliecked(Current_Xinfa,1);
	elseif(Current_Skill ~= -1 and SKILL_BUTTONS[Current_Skill] ~= -1) then
		ActionSkill_Update_Cliecked(Current_Skill,2);
	end
	ActionSkill_UpdateMenPaiText();		--∏¸–¬œ‘ æŒƒ◊÷£¨»Áπ˚ÕÊº“∏ƒ±‰¡À√≈≈…
end

function ActionSkill_Update_Cliecked(nIndex, Actiontype)
	local i;
	local theAction;
	local strName,strName2;

	if(Actiontype == 1) then

		if(XINFA_INDEX[nIndex] == -1) then
			return;
		end;

		--ActionSkill_Zhaoshi_Frame:Hide();
		ActionSkill_ZhaoshiTarget:Hide();
		--ActionSkill_Xinfa_Frame:Show();
		ActionSkill_XinfaTarget:Show();
		ActionSkill_Use : Hide();

		ActionSkill_XinfaTarget:SetActionItem(XINFA_INDEX[nIndex]);

		local nXinfaId = LifeAbility : GetLifeAbility_Number(XINFA_INDEX[nIndex]);

		strName = Player:GetXinfaInfo(nXinfaId,"name");
		Current_Xinfa_Name = strName;
	 	strName2= Player:GetXinfaInfo(nXinfaId,"level");
	 	Current_Xinfa_Level = strName2;

		ActionSkill_Name : SetText( strName .."\n" .. "T‚m ph·p: " .. strName2);
		ActionSkill_Name : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
		ActionSkill_Name : SetProperty("VertFormatting","VertCentred")
		ActionSkill_XinfaTarget : Enable();
--		XINFA_LEVEL[nIndex] : SetText(tostring(strName2));
		AxTrace(0,1,"XINFA_LEVEL["..nIndex.."] C§p="..strName2);
--		AxTrace(0,1,"GET XINFA_LEVEL["..nIndex.."] µ»º∂="..XINFA_LEVEL[nIndex]:GetText());

	 	strName = Player:GetXinfaInfo(nXinfaId,"explain");
	 	ActionSkill_Explain : SetText(strName);

		for i=1, XINFA_BUTTONS_NUM do
			local theAction = EnumAction(i-1, "xinfa");

			if theAction:GetID() ~= 0 then
				XINFA_BUTTONS[i]:SetActionItem(theAction:GetID());
				XINFA_INDEX[i] = theAction:GetID();
				local nXinfaId = LifeAbility : GetLifeAbility_Number(XINFA_INDEX[i]);
				local nXinfa_level = Player:GetXinfaInfo(nXinfaId,"level");

--				XINFA_LEVEL[i] : SetText(tostring(nXinfa_level));
--				XINFA_LEVEL[i] : Show();
--				AxTrace(0,1,"XINFA_LEVEL["..i.."] µ»º∂="..nXinfa_level);
			else
				XINFA_BUTTONS[i]:SetActionItem(-1);
				XINFA_INDEX[i] = -1;
--				XINFA_LEVEL[i] : SetText("√ª”–");
			end
		end

		for i=1, SKILL_BUTTONS_NUM do
			SKILL_BUTTONS[i]:SetActionItem(-1);
			SKILL_INDEX[i] = -1;
		end

		local nSumSkill = GetActionNum("skill");
		local nSkillIndex = 1;
		--AxTrace(0, 0, "nSumSkill=" .. nSumSkill);
		for i=1, nSumSkill do
			theAction = EnumAction(i-1, "skill");
			--AxTrace(0, 0, "i-1 ="..(i-1).. " skill nXinfaId =" .. nXinfaId .." GetOwnerXinfa ="..theAction:GetOwnerXinfa() );
			if theAction:GetOwnerXinfa() == XINFA_INDEX[nIndex] and (theAction:GetDefineID() < 788 or theAction:GetDefineID() > 796) then
				SKILL_BUTTONS[nSkillIndex]:SetActionItem(theAction:GetID());
				SKILL_INDEX[nSkillIndex] = theAction:GetID();
				nSkillIndex = nSkillIndex+1;
			end
		end

		if(Current_Xinfa ~= -1) then
			XINFA_BUTTONS[Current_Xinfa] : SetPushed(0);
		elseif(Current_Skill ~= -1) then
			SKILL_BUTTONS[Current_Skill] : SetPushed(0);
		elseif(Current_Nuqi ~= -1) then
			NUQI_BUTTONS[Current_Nuqi] : SetPushed(0);
		end;

		Current_Xinfa = nIndex;
		Current_Skill = -1;
		Current_Nuqi = -1;

		XINFA_BUTTONS[Current_Xinfa]:SetPushed(1);

		--±Íº«
	elseif(Actiontype == 2) then

		if(SKILL_INDEX[nIndex] == -1) then
			return;
		end;

		if(Current_Skill ~= -1) then
			SKILL_BUTTONS[Current_Skill] : SetPushed(0);
		end

		Current_Skill = nIndex;
--		Current_Xinfa = -1;
		Current_Nuqi = -1;

		SKILL_BUTTONS[Current_Skill]:SetPushed(1);

		--ActionSkill_Xinfa_Frame:Hide();
		ActionSkill_XinfaTarget:Hide();
		--ActionSkill_Zhaoshi_Frame:Show();
		ActionSkill_ZhaoshiTarget:Show();

		ActionSkill_ZhaoshiTarget:SetActionItem(SKILL_INDEX[nIndex]);
		local nSkillId = LifeAbility : GetLifeAbility_Number(SKILL_INDEX[nIndex]);

		if( Player:GetSkillInfo(nSkillId,"passivity") == 1) then
	 		ActionSkill_Use : Hide();
	 	else
		 	ActionSkill_Use : Show();
		end

		strName = Player:GetSkillInfo(nSkillId,"name");

	 	if( Player:GetSkillInfo(nSkillId,"learn") ) then
--	 		strName2 = "“—æ≠—ßª·";
	 		ActionSkill_Name : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	 		ActionSkill_Name : SetProperty("VertFormatting","TopAligned")
	 		ActionSkill_ZhaoshiTarget : Enable();
	 	else
--		 	strName2 = "…–Œ¥—ßª·";
		 	ActionSkill_Name : SetProperty("TextColours","tl:FFFF0000 tr:FFFF0000 bl:FFFF0000 br:FFFF0000");
		 	ActionSkill_Name : SetProperty("VertFormatting","TopAligned")
		 	ActionSkill_ZhaoshiTarget : Disable();
		end

		if nil ~= strName then
			ActionSkill_Name : SetText( strName );

	 	end
	 	strName = Player:GetSkillInfo(nSkillId,"explain");
	 	strName2 = Player:GetSkillInfo(nSkillId,"skilldata");
	 	if nil~=strName or nil~=strName2 then
	 		ActionSkill_Explain : SetText(strName.."\n"..strName2);
	 	end

	elseif(Actiontype == 3) then

		if(NUQI_INDEX[nIndex] == -1) then
			return;
		end;

		if(Current_Xinfa ~= -1) then
			XINFA_BUTTONS[Current_Xinfa] : SetPushed(0);
		elseif(Current_Skill ~= -1) then
			SKILL_BUTTONS[Current_Skill] : SetPushed(0);
		elseif(Current_Nuqi ~= -1) then
			NUQI_BUTTONS[Current_Nuqi] : SetPushed(0);
		end;

		Current_Nuqi = nIndex;
		Current_Xinfa = -1;
		Current_Skill = -1;

		NUQI_BUTTONS[Current_Nuqi]:SetPushed(1);

		--ActionSkill_Xinfa_Frame:Hide();
		ActionSkill_XinfaTarget:Hide();
		--ActionSkill_Zhaoshi_Frame:Show();
		ActionSkill_ZhaoshiTarget:Show();

		ActionSkill_ZhaoshiTarget:SetActionItem(NUQI_INDEX[nIndex]);
		local nNuqiId = LifeAbility : GetLifeAbility_Number(NUQI_INDEX[nIndex]);

		if( Player:GetSkillInfo(nSkillId,"passivity") == 1) then
	 		ActionSkill_Use : Hide();
	 	else
		 	ActionSkill_Use : Show();
		end

		strName = Player:GetSkillInfo(nNuqiId,"name");

	 	if( Player:GetSkillInfo(nNuqiId,"learn") ) then
--	 		strName2 = "“—æ≠—ßª·";
	 		ActionSkill_Name : SetProperty("TextColor","FFEFEFEF");
	 		ActionSkill_ZhaoshiTarget : Enable();
	 	else
--		 	strName2 = "…–Œ¥—ßª·";
		 	ActionSkiActionSkill_Name : SetProperty("TextColor","FFFF0000");
		 	ActionSkill_ZhaoshiTarget : Disable();
		end

	 	ActionSkill_Name : SetText( strName .."\n" .. "K€ nÂng PhÁn nµ");

	 	strName = Player:GetSkillInfo(nNuqiId,"explain");
	 	strName2 = Player:GetSkillInfo(nNuqiId,"skilldata");
	 	ActionSkill_Explain : SetText(strName.."\n"..strName2);
	end

end

function ActionSkill_Button_Clicked()

--	if (Current_Skill ~= -1) or (Current_Nuqi ~= -1) then
	if (Current_Skill ~= -1) then
		ActionSkill_ZhaoshiTarget:DoAction();
	end

end


function Action_Common_Page_Switch()
	OpenCommonSkillPage();
	ActionSkill_OnClose();
	ActionSkill_CommonlySkill : SetCheck(0);
	ActionSkill_LifeSkill : SetCheck(0);
	ActionSkill_ActionSkill : SetCheck(1);
end

function Action_Life_Page_Switch()
	OpenLifePage();
	ActionSkill_OnClose();
	ActionSkill_CommonlySkill : SetCheck(0);
	ActionSkill_LifeSkill : SetCheck(0);
	ActionSkill_ActionSkill : SetCheck(1);
end

function ActionSkill_SetTabColor()

	--AxTrace(0,0,tostring(idx));
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = ActionSkill_CommonlySkill,
								ActionSkill_ActionSkill,
								ActionSkill_LifeSkill,
							};

	local TAB_TEXT = {
		[0] = "SΩ c§p",
		"MÙn ph·i",
		"NghÆ",
	};

	tab[0]:SetText(noselColor..TAB_TEXT[0]);
	tab[1]:SetText(selColor..TAB_TEXT[1]);
	tab[2]:SetText(noselColor..TAB_TEXT[2]);
end

function ActionSkill_OnClose()
	Variable:SetVariable("SkillUnionPos", ActionSkill_Frame:GetProperty("UnifiedPosition"), 1);
	ActionSkill_Close();
end

function ActionSkill_ClearStaticImage()
	ActionSkill_MenPai_ICON : SetProperty("Tooltip", "");
	ActionSkill_MenPai_ICON : SetProperty("Image","");
end

function ActionSkill_UpdateMenPaiText()
	local menpaiID = Player : GetData("MEMPAI");		--ªÒ»°ÕÊº“√≈≈…ID
	if menpaiID ~= nil and menpaiID >=0 and menpaiID <=10 then
		if (menpaiID == 9) then
			ActionSkill_ClearStaticImage();
			ActionSkill_MenPai_Attr_Intro : SetText(""); --“ª∞„¿¥Àµ’‚¿Ô≤ªª·±ªµ˜µΩ
			return;
		end
		local	str = GetDictionaryString( "MPZSX_20071221_0" .. (menpaiID +1) );
		ActionSkill_MenPai_Attr_Intro : SetText("#Y" .. str);
		--ActionSkill_ClearStaticImage();

		ActionSkill_MenPai_ICON : SetToolTip(GetDictionaryString(MenPai_UsedAttr[menpaiID].Tooltip));
		ActionSkill_MenPai_ICON : SetProperty("Image",MenPai_UsedAttr[menpaiID].image);
	end
end


function ActionSkill_Open()
	--ActionSkill_UpdateMenPaiText();
	this:Show();
end
function ActionSkill_Close()
	this:Hide();
end

--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ActionSkill_Frame_On_ResetPos()

	ActionSkill_Frame : SetProperty("UnifiedXPosition", g_ActionSkill_Frame_UnifiedXPosition);
	ActionSkill_Frame : SetProperty("UnifiedYPosition", g_ActionSkill_Frame_UnifiedYPosition);

end