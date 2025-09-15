
local RIGHTBAR_2_BUTTONS = {};
local RIGHTBAR_2_BUTTON_NUM = 10;

function FunctionBarRight_2_PreLoad()
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("ACTION_UPDATE");
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_BAR4");
	this:RegisterEvent("CLEAR_CHAT_ACTION_BAR");
	this:RegisterEvent("OPEN_RIGHT_BAR_2");
end

function FunctionBarRight_2_OnLoad()
	RIGHTBAR_2_BUTTONS[21] = FunctionBarRight_2_Button_Action1;
	RIGHTBAR_2_BUTTONS[22] = FunctionBarRight_2_Button_Action2;
	RIGHTBAR_2_BUTTONS[23] = FunctionBarRight_2_Button_Action3;
	RIGHTBAR_2_BUTTONS[24] = FunctionBarRight_2_Button_Action4;
	RIGHTBAR_2_BUTTONS[25] = FunctionBarRight_2_Button_Action5;
	RIGHTBAR_2_BUTTONS[26] = FunctionBarRight_2_Button_Action6;
	RIGHTBAR_2_BUTTONS[27] = FunctionBarRight_2_Button_Action7;
	RIGHTBAR_2_BUTTONS[28] = FunctionBarRight_2_Button_Action8;
	RIGHTBAR_2_BUTTONS[29] = FunctionBarRight_2_Button_Action9;
	RIGHTBAR_2_BUTTONS[30] = FunctionBarRight_2_Button_Action10;
end

-- OnEvent
function FunctionBarRight_2_OnEvent(event)
	--Mod by Makute
	if event == "CHAT_ADJUST_MOVE_CTL" then
		FunctionBarRight_2_FixSkill10(arg0, arg1)
	end
	
	if event == "OPEN_RIGHT_BAR_2" then
		if arg0 == "1" then
			this:Show()
		else
			this:Hide()
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();

	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		if( tonumber(arg1) >= 21 and tonumber(arg1) <= 30 )  then
			local nIndex = tonumber(arg1) ;
			
			RIGHTBAR_2_BUTTONS[nIndex] : SetActionItem(tonumber(arg2));
			RIGHTBAR_2_BUTTONS[nIndex] : Bright();
			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							RIGHTBAR_2_BUTTONS[nIndex] : Bright();
					else
							RIGHTBAR_2_BUTTONS[nIndex] : Gloom();
					end
						
				end
				
			end
			
		end
	elseif( event == "ACTION_UPDATE" ) then
		FunctionBarRight_2_ActionUpdate();

	-- Ð¶ÔØË«ÈËÐÝÏÐ¶¯×÷°üÊ±£¬Í¬Ê±É¾³ýÍÏ¶¯µ½FunctionBarRight_2ÉÏµÄ°´Å¥ÐÅÏ¢	
	elseif (event == "UNINSTALL_CHAT_ACTION_BAR4") then
		FunctionBarRight_2_UnInstallChatActionButton(tonumber(arg0));

	-- ÇåÀí¹ýÆÚµÄË«ÈËÐÝÏÐ¶¯×÷°üÔÚÖ÷²Ëµ¥ÉÏµÄ°´Å¥
	elseif (event == "CLEAR_CHAT_ACTION_BAR") and (tostring(arg0)== "FunctionBarRight_2") then
		FunctionBarRight_2_ClearChatActionButton(tonumber(arg1), tonumber(arg2), tonumber(arg3));
	end
	
end

function FunctionBarRight_2_ActionUpdate()
	for j=1,10 do
		RIGHTBAR_2_BUTTONS[j+20]:SetNewFlash();
	end
end

function FunctionBarRight_2_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		
		RIGHTBAR_2_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("Các hÕ không ðßþc làm nhß v§y")
		return;
	end
end

function FunctionBarRight_2_UnInstallChatActionButton(index)

	if (index < 0) or (index > 4) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex = DataPool : Get_RMB_ChatActionInfo(index);
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 then
		local tmpItem = -1
		-- Çå¿Õ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, RIGHTBAR_2_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = RIGHTBAR_2_BUTTONS[i+10]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- ±éÀúµ±Ç°¶¯×÷°üÖÐµÄÃ¿Ò»¸öActionItem£¬¿´¿´ÊÇ·ñÓÐºÍµ±Ç°ActionItemµÄIDÏàµÈµÄ¡£
		  	for j = 1, actionCount do
					local theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						RIGHTBAR_2_BUTTONS[i+10] : SetActionItem(-1);				-- È¡Ïû°´Å¥ÉÏµÄActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+9);			-- É¾³ýMainMenuBarÖÐ±£´æµÄActionItem¶ÔÓ¦¼ÇÂ¼£¨±àºÅ¶ÔÓ¦DragName£©
					end
				end
		  end
		end
	end	

	-- ³¹µ×Ð¶ÔØ¸Ã¶¯×÷°ü
	DataPool : UnInstall_RMB_ChatAction(index , 5)

end

function FunctionBarRight_2_ClearChatActionButton(index, nID, nData)

	if (index < 0) or (index > 4) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex = DataPool : Get_RMB_ChatActionInfo(index);
	--PushDebugMessage ("FunctionBarRight_2 : actionID = "..actionID..", actionCount = "..actionCount..", actionMinIndex = "..actionMinIndex)
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 then
		local tmpItem = -1
		-- Çå¿Õ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, RIGHTBAR_2_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = RIGHTBAR_2_BUTTONS[i+10]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- ±éÀúµ±Ç°¶¯×÷°üÖÐµÄÃ¿Ò»¸öActionItem£¬¿´¿´ÊÇ·ñÓÐºÍµ±Ç°ActionItemµÄIDÏàµÈµÄ¡£
		  	for j = 1, actionCount do
					local theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						RIGHTBAR_2_BUTTONS[i+10] : SetActionItem(-1);							-- È¡Ïû°´Å¥ÉÏµÄActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+9);			-- É¾³ýMainMenuBarÖÐ±£´æµÄActionItem¶ÔÓ¦¼ÇÂ¼£¨±àºÅ¶ÔÓ¦DragName£©
					end
				end
		  end
		end
	end

	-- ÉèÖÃ¿Í»§¶ËµÄ¶¯×÷°üÐÂÊý¾Ý
	DataPool : Set_RMB_ChatAction(index, nID, nData);

end

function FunctionBarRight_2_FixSkill10(arg0, arg1)
	if tonumber(arg1) >= 630 then
		FunctionBarRight_2_Button_Action10:SetProperty("Position", "x:0.1363636 y:0.956897");
	else
		FunctionBarRight_2_Button_Action10:SetProperty("Position", "x:-1.55 y:0.856322");
	end
end