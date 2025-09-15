
local RIGHTBAR_BUTTONS = {};
local RIGHTBAR_BUTTON_NUM = 10;


function FunctionBarRight_PreLoad()
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("ACTION_UPDATE");
end

function FunctionBarRight_OnLoad()
	RIGHTBAR_BUTTONS[11] = FunctionBarRight_Button_Action1;
	RIGHTBAR_BUTTONS[12] = FunctionBarRight_Button_Action2;
	RIGHTBAR_BUTTONS[13] = FunctionBarRight_Button_Action3;
	RIGHTBAR_BUTTONS[14] = FunctionBarRight_Button_Action4;
	RIGHTBAR_BUTTONS[15] = FunctionBarRight_Button_Action5;
	RIGHTBAR_BUTTONS[16] = FunctionBarRight_Button_Action6;
	RIGHTBAR_BUTTONS[17] = FunctionBarRight_Button_Action7;
	RIGHTBAR_BUTTONS[18] = FunctionBarRight_Button_Action8;
	RIGHTBAR_BUTTONS[19] = FunctionBarRight_Button_Action9;
	RIGHTBAR_BUTTONS[20] = FunctionBarRight_Button_Action10;
end


-- OnEvent
function FunctionBarRight_OnEvent(event)
	--Mod by Makute
	if event == "CHAT_ADJUST_MOVE_CTL" then
		FunctionBarRight_FixSkill10(arg0, arg1)
	end
	
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();
		-- ÏÔÊ¾¾­Ñé
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		if( tonumber(arg1) >= 11 and tonumber(arg1) <= 20 )  then
			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			local nIndex = tonumber(arg1) ;
			
			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			RIGHTBAR_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			RIGHTBAR_BUTTONS[nIndex]:Bright();
			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
						RIGHTBAR_BUTTONS[nIndex] : Bright();
					else
						RIGHTBAR_BUTTONS[nIndex] : Gloom();
					end
						
				end
				
			end
			
		end
	elseif( event == "ACTION_UPDATE" ) then
		FunctionBarRight_ActionUpdate();
	end
	
	end
function FunctionBarRight_ActionUpdate()
	for j=1,10 do
		RIGHTBAR_BUTTONS[j+10]:SetNewFlash();
	end
end

function FunctionBarRight_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		local commonid = LifeAbility:GetLifeAbility_Number(RIGHTBAR_BUTTONS[nIndex]:GetActionItem());
		if commonid == 21 then
			local buff_num = Player:GetBuffNumber();
			for i = 0, buff_num do
				local szToolTips = Player:GetBuffToolTipsByIndex(i);
				local Stick = string.find(szToolTips,"Thú CßÞi");
				if Stick then
					Player:DispelBuffByIndex( i )
					return
				end
			end
		end
		RIGHTBAR_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("Các hÕ không ðßþc làm nhß v§y")
		return;
	end
end

function FunctionBarRight_FixSkill10(arg0, arg1)
	if tonumber(arg1) >= 630 then
		FunctionBarRight_Button_Action10:SetProperty("Position", "x:0.1363636 y:0.956897");
	else
		FunctionBarRight_Button_Action10:SetProperty("Position", "x:-1.6 y:0.856322");
	end
end