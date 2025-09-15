local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_uicmd = 0;

local g_NewbieCardActivation_Frame_UnifiedXPosition;
local g_NewbieCardActivation_Frame_UnifiedYPosition;

function NewbieCardActivation_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("NewUserCard_Check_Result");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function NewbieCardActivation_OnLoad()
g_NewbieCardActivation_Frame_UnifiedXPosition	= NewbieCardActivation_Frame:GetProperty("UnifiedXPosition");
g_NewbieCardActivation_Frame_UnifiedYPosition	= NewbieCardActivation_Frame:GetProperty("UnifiedYPosition");
end


function NewbieCardActivation_OnEvent(event)
	if(event == "UI_COMMAND" and not this:IsVisible()) then
		if
		(tonumber(arg0) == 20161231 )
		then
			objCared = Get_XParam_INT(0);
			objCared = Target:GetServerId2ClientId(objCared);
			NewUserCard_SetText(tonumber(arg0));
			this:CareObject(objCared, 1, "NewUserCard");
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
			g_uicmd = tonumber(arg0);
		end
	elseif(event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0:"..arg0.." arg1:"..arg1.." arg2:"..arg2.." objCared:"..objCared);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--»Áπ˚∫ÕNPCµƒæ‡¿Î¥Û”⁄“ª∂®æ‡¿ÎªÚ’ﬂ±ª…æ≥˝£¨◊‘∂Øπÿ±’
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Guild_Create_Close();
		end

	elseif(event == "NewUserCard_Check_Result")then
		local result = tonumber(arg0)
		if(tonumber(arg0)== 0) then
			NewUserCard_Close();
			return;
		end
		if(tonumber(arg0)== 1 or tonumber(arg0)== 2) then
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			NewbieCardActivation_Input:SetSelected( 0, -1 );
			return;
		end
	elseif( event == "ADJEST_UI_POS" ) then
		NewbieCardActivation_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		NewbieCardActivation_ResetPos()

	end

end

function NewUserCard_Open_Click()
	local cardNum = NewbieCardActivation_Input:GetText();
	if (0 == string.len(cardNum)) then
		PushDebugMessage("#{CFK_081027_2}");
		return;
	end


	local firstbyte = string.byte(cardNum)
	--588ø®
	-- if (g_uicmd == 2004 and (firstbyte ==83 or firstbyte == 84)) then --¥Û–¥ S T
	-- 	PushDebugMessage("#{CFK_081027_1}");
	-- 	return;
	-- end
	-- if(g_uicmd == 2004 and firstbyte ~= 116 and firstbyte ~= 115 ) then     --588≤∆∏ªø®'t','s''T','S'
	-- 	PushDebugMessage("#{CFK_081027_2}");
	-- 	return;
	-- end
	--
	-- --666ø® c
	-- if (g_uicmd == 20080819 and firstbyte == 67) then
	-- 	PushDebugMessage("#{CFK_081027_1}");
	-- 	return;
	-- end
	-- if (g_uicmd == 20080819 and firstbyte ~= 99) then
	-- 	PushDebugMessage("#{CFK_081027_2}");
	-- 	return;
	-- end
	--
	-- --π®≤ ‘∆¥¶≈≈≥˝≤∆∏ªø®
	-- if (firstbyte==83 or firstbyte==84 or firstbyte==115 or firstbyte==116) and g_uicmd~=2004 then
	--   PushDebugMessage("#{CFK_081027_2}");
	-- 	return;
	-- elseif (g_uicmd == 20090714 and firstbyte ~= 121) then			-- SNSø® y
	-- 	PushDebugMessage("#{SNS_090713_5}");
	-- 	return;
	-- elseif g_uicmd == 20090819 or g_uicmd == 20090828 then
	-- 	if firstbyte ~= 122  then
	-- 		PushDebugMessage("#{SNS_090713_5}");
	-- 		return;
	-- 	end
	-- end
	-- if ( firstbyte==67 or firstbyte==99) and g_uicmd~=20080819 then
	--   PushDebugMessage("#{CFK_081027_2}");
	-- 	return;
	-- end
	-- if (g_uicmd == 20161231) then
	-- 	--body...
	-- end

	NewUserCard(cardNum, 0);
end

function NewUserCard_Close()
	this:Hide();
	this:CareObject(objCared, 0, "NewUserCard");
	g_uicmd = 0;
end

function NewUserCard_SetText(uicmd)
	-- if uicmd == 2004 then
	-- 	NewbieCardActivation_DragTitle:SetText("#{INTERFACE_XML_73}");
	-- 	NewbieCardActivation_Text:SetText("#{INTERFACE_XML_536}");
	-- elseif uicmd == 20080819 then--666≤∆∏ªø®
	-- 	NewbieCardActivation_DragTitle:SetText("#{INTERFACE_XML_73}");
	-- 	NewbieCardActivation_Text:SetText("#{INTERFACE_XML_536}");
--	elseif uicmd == 2005 then
--		NewbieCardActivation_DragTitle:SetText("º§ªÓ");
--		NewbieCardActivation_Text:SetText("«Î‘⁄œ¬√Êµƒ ‰»ÎøÚƒ⁄ ‰»Îƒ˙ªÒµ√µƒCD-Key");
	-- elseif uicmd == 2006 then
	-- 	NewbieCardActivation_DragTitle:SetText("#{CJ_20080321_01}");
	-- 	NewbieCardActivation_Text:SetText("#{CJ_20080321_02}");
--	elseif uicmd == 2007 then
--		NewbieCardActivation_DragTitle:SetText("º§ªÓ");
--		NewbieCardActivation_Text:SetText("«Î‘⁄œ¬√Êµƒ ‰»ÎøÚƒ⁄ ‰»Îƒ˙ªÒµ√µƒCD-Key");
	-- elseif uicmd == 2008 then
	-- 	NewbieCardActivation_DragTitle:SetText("KÌch ho’t");
	-- 	NewbieCardActivation_Text:SetText("Xin h„y nhßp CD-Key m‡ c·c h’ nhßn ﬂ˛c v‡o Ù dﬂæi ‚y");
--	elseif uicmd == 2007950 then
--		NewbieCardActivation_DragTitle:SetText("#{CB_XUBAO_LINGQU_2}");
--		NewbieCardActivation_Text:SetText("#{CB_XUBAO_LINGQU_3}");
  -- elseif uicmd == 20090714 then
	-- 	NewbieCardActivation_DragTitle:SetText("#{SNS_XML_05}");
	-- 	NewbieCardActivation_Text:SetText("#{SNS_XML_06}");
	-- elseif uicmd == 20090819 then
	-- 	NewbieCardActivation_DragTitle:SetText("#{FXHZ_xml_XX(01)}");
	-- 	NewbieCardActivation_Text:SetText("#{FXHZ_xml_XX(08)}");
	-- elseif uicmd == 20090828 then
	-- 	NewbieCardActivation_DragTitle:SetText("#{RXCFK_XML_2}");
	-- 	NewbieCardActivation_Text:SetText("#{RXCFK_XML_3}");
	-- end

	if (uicmd == 20161231) then
		NewbieCardActivation_DragTitle:SetText("#{INTERFACE_XML_73}");
		NewbieCardActivation_Text:SetText("            #{CB_XUBAO_LINGQU_3}");
	end

	NewbieCardActivation_Input:SetText("");
end

function NewbieCardActivation_ResetPos()
	NewbieCardActivation_Frame:SetProperty("UnifiedXPosition", g_NewbieCardActivation_Frame_UnifiedXPosition);
	NewbieCardActivation_Frame:SetProperty("UnifiedYPosition", g_NewbieCardActivation_Frame_UnifiedYPosition);

end
