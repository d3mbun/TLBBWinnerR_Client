
local MAIN_2_BUTTONS = {};
local MAIN_2_BUTTON_NUM = 20;

local MAIN_2_ANIMATES = {};
local MAIN_2_ANIMATE_NUM = 20;

function MainMenuBar_2_PreLoad()
	this:RegisterEvent("OPEN_MENUBAR_2");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("ACTION_UPDATE");
end

function MainMenuBar_2_OnLoad()
	MAIN_2_BUTTONS[31] = MainMenuBar_2_Button_Action1
	MAIN_2_BUTTONS[32] = MainMenuBar_2_Button_Action2
	MAIN_2_BUTTONS[33] = MainMenuBar_2_Button_Action3
	MAIN_2_BUTTONS[34] = MainMenuBar_2_Button_Action4
	MAIN_2_BUTTONS[35] = MainMenuBar_2_Button_Action5
	MAIN_2_BUTTONS[36] = MainMenuBar_2_Button_Action6
	MAIN_2_BUTTONS[37] = MainMenuBar_2_Button_Action7
	MAIN_2_BUTTONS[38] = MainMenuBar_2_Button_Action8
	MAIN_2_BUTTONS[39] = MainMenuBar_2_Button_Action9
	MAIN_2_BUTTONS[40] = MainMenuBar_2_Button_Action10
	MAIN_2_BUTTONS[41] = MainMenuBar_2_Button_Action11
	MAIN_2_BUTTONS[42] = MainMenuBar_2_Button_Action12
	MAIN_2_BUTTONS[43] = MainMenuBar_2_Button_Action13
	MAIN_2_BUTTONS[44] = MainMenuBar_2_Button_Action14
	MAIN_2_BUTTONS[45] = MainMenuBar_2_Button_Action15
	MAIN_2_BUTTONS[46] = MainMenuBar_2_Button_Action16
	MAIN_2_BUTTONS[47] = MainMenuBar_2_Button_Action17
	MAIN_2_BUTTONS[48] = MainMenuBar_2_Button_Action18
	MAIN_2_BUTTONS[49] = MainMenuBar_2_Button_Action19
	MAIN_2_BUTTONS[50] = MainMenuBar_2_Button_Action20
	
	MAIN_2_ANIMATES[31] = MainMenuBar_2_Button_Action1_Mask
	MAIN_2_ANIMATES[32] = MainMenuBar_2_Button_Action2_Mask
	MAIN_2_ANIMATES[33] = MainMenuBar_2_Button_Action3_Mask
	MAIN_2_ANIMATES[34] = MainMenuBar_2_Button_Action4_Mask
	MAIN_2_ANIMATES[35] = MainMenuBar_2_Button_Action5_Mask
	MAIN_2_ANIMATES[36] = MainMenuBar_2_Button_Action6_Mask
	MAIN_2_ANIMATES[37] = MainMenuBar_2_Button_Action7_Mask
	MAIN_2_ANIMATES[38] = MainMenuBar_2_Button_Action8_Mask
	MAIN_2_ANIMATES[39] = MainMenuBar_2_Button_Action9_Mask
	MAIN_2_ANIMATES[40] = MainMenuBar_2_Button_Action10_Mask
	MAIN_2_ANIMATES[41] = MainMenuBar_2_Button_Action11_Mask
	MAIN_2_ANIMATES[42] = MainMenuBar_2_Button_Action12_Mask
	MAIN_2_ANIMATES[43] = MainMenuBar_2_Button_Action13_Mask
	MAIN_2_ANIMATES[44] = MainMenuBar_2_Button_Action14_Mask
	MAIN_2_ANIMATES[45] = MainMenuBar_2_Button_Action15_Mask
	MAIN_2_ANIMATES[46] = MainMenuBar_2_Button_Action16_Mask
	MAIN_2_ANIMATES[47] = MainMenuBar_2_Button_Action17_Mask
	MAIN_2_ANIMATES[48] = MainMenuBar_2_Button_Action18_Mask
	MAIN_2_ANIMATES[49] = MainMenuBar_2_Button_Action19_Mask
	MAIN_2_ANIMATES[50] = MainMenuBar_2_Button_Action20_Mask
end


-- OnEvent
function MainMenuBar_2_OnEvent(event)
	if ( event == "OPEN_MENUBAR_2" ) then
		
		AxTrace(0,0,"OPEN_MENUBAR_2" .. arg0)
			
		if arg0 == "1" then
			this:Show()
			MainMenuBar_2_PlayAnimate()
		else
			this:Hide()
		end
		-- ÏÔÊ¾¾­Ñé
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		
		AxTrace(0,0,"arg1 =" .. tostring(arg1))
	
		if( tonumber(arg1) >= 31 and tonumber(arg1) <= 50 )  then
			local nIndex = tonumber(arg1) ;

			MAIN_2_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			MAIN_2_BUTTONS[nIndex]:Bright();
			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
				
					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
				
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							MAIN_2_BUTTONS[nIndex]:Bright();
					else
							MAIN_2_BUTTONS[nIndex]:Gloom();
					end
				end
			end
		end
		
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		MainMenuBar_2_AdjustMoveCtl(arg0, arg1);
	elseif( event == "ACTION_UPDATE" ) then
		MainMenuBar_2_NewSkillStudy();
	end
	
end

function MainMenuBar_2_NewSkillStudy()
	for j=1,20 do
		MAIN_2_BUTTONS[j+30]:SetNewFlash();
	end
end

function MainMenuBar_2_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		local commonid = LifeAbility:GetLifeAbility_Number(MAIN_2_BUTTONS[nIndex]:GetActionItem());
		if commonid == 21 then
			local buff_num = Player:GetBuffNumber();
			for i = 0, buff_num do
				local szToolTips = Player:GetBuffToolTipsByIndex(i);
				local Stick = string.find(szToolTips,"Thú CßŞi");
				if Stick then
					Player:DispelBuffByIndex( i )
					return
				end
			end
		end
		MAIN_2_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("Các hÕ không ğßşc làm nhß v§y")
		return;
	end
end

function MainMenuBar_2_AdjustMoveCtl( screenWidth, screenHeight )
	local currWidth = MainMenuBar_2_Frame:GetProperty("AbsoluteWidth");
	MainMenuBar_2_Frame:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}");
end

function MainMenuBar_2_PlayAnimate()
	for j=1,20 do
		MAIN_2_ANIMATES[j+30]:Show();
		MAIN_2_ANIMATES[j+30]:Play(true);
	end
end