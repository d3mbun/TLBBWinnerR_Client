local g_InitiativeClose = 0;

--±³°ü¼°Æä±àºÅ
local PACK_BUTTONS_NUM = 5;
local PACK_BUTTONS = {};

--¸ñ×Ó¼°Æä±àºÅ
local GRID_BUTTONS_NUM = 60;
local GRID_BUTTONS = {};

--Êµ¼ÊÃ¿¸ö±³°ü¾ßÓÐµÄ¸ñ×ÓÊý
local nUsedGrid = {};

--µ±Ç°´ò¿ªµÄ×âÁÞÏä
local g_CurrentRentBox = 1;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Bank_Select2 = 0;
--===============================================
-- OnLoad()
--===============================================
function Bank_PreLoad()

	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("UPDATE_BANK");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");

end
	
function Bank_OnLoad()

	GRID_BUTTONS[1]  = Bank_Item1;
	GRID_BUTTONS[2]  = Bank_Item2;
	GRID_BUTTONS[3]  = Bank_Item3;
	GRID_BUTTONS[4]  = Bank_Item4;
	GRID_BUTTONS[5]  = Bank_Item5;
	GRID_BUTTONS[6]  = Bank_Item6;
	GRID_BUTTONS[7]  = Bank_Item7;
	GRID_BUTTONS[8]  = Bank_Item8;
	GRID_BUTTONS[9]  = Bank_Item9;
	GRID_BUTTONS[10] = Bank_Item10;
	GRID_BUTTONS[11] = Bank_Item11;
	GRID_BUTTONS[12] = Bank_Item12;
	GRID_BUTTONS[13] = Bank_Item13;
	GRID_BUTTONS[14] = Bank_Item14;
	GRID_BUTTONS[15] = Bank_Item15;
	GRID_BUTTONS[16] = Bank_Item16;
	GRID_BUTTONS[17] = Bank_Item17;
	GRID_BUTTONS[18] = Bank_Item18;
	GRID_BUTTONS[19] = Bank_Item19;
	GRID_BUTTONS[20] = Bank_Item20;
	
	GRID_BUTTONS[21]  = Bank_Item21;
	GRID_BUTTONS[22]  = Bank_Item22;
	GRID_BUTTONS[23]  = Bank_Item23;
	GRID_BUTTONS[24]  = Bank_Item24;
	GRID_BUTTONS[25]  = Bank_Item25;
	GRID_BUTTONS[26]  = Bank_Item26;
	GRID_BUTTONS[27]  = Bank_Item27;
	GRID_BUTTONS[28]  = Bank_Item28;
	GRID_BUTTONS[29]  = Bank_Item29;
	GRID_BUTTONS[30] = Bank_Item30;
	GRID_BUTTONS[31] = Bank_Item31;
	GRID_BUTTONS[32] = Bank_Item32;
	GRID_BUTTONS[33] = Bank_Item33;
	GRID_BUTTONS[34] = Bank_Item34;
	GRID_BUTTONS[35] = Bank_Item35;
	GRID_BUTTONS[36] = Bank_Item36;
	GRID_BUTTONS[37] = Bank_Item37;
	GRID_BUTTONS[38] = Bank_Item38;
	GRID_BUTTONS[39] = Bank_Item39;
	GRID_BUTTONS[40] = Bank_Item40;
	
	GRID_BUTTONS[41]  = Bank_Item41;
	GRID_BUTTONS[42]  = Bank_Item42;
	GRID_BUTTONS[43]  = Bank_Item43;
	GRID_BUTTONS[44]  = Bank_Item44;
	GRID_BUTTONS[45]  = Bank_Item45;
	GRID_BUTTONS[46]  = Bank_Item46;
	GRID_BUTTONS[47]  = Bank_Item47;
	GRID_BUTTONS[48]  = Bank_Item48;
	GRID_BUTTONS[49]  = Bank_Item49;
	GRID_BUTTONS[50] = Bank_Item50;
	GRID_BUTTONS[51] = Bank_Item51;
	GRID_BUTTONS[52] = Bank_Item52;
	GRID_BUTTONS[53] = Bank_Item53;
	GRID_BUTTONS[54] = Bank_Item54;
	GRID_BUTTONS[55] = Bank_Item55;
	GRID_BUTTONS[56] = Bank_Item56;
	GRID_BUTTONS[57] = Bank_Item57;
	GRID_BUTTONS[58] = Bank_Item58;
	GRID_BUTTONS[59] = Bank_Item59;
	GRID_BUTTONS[60] = Bank_Item60;
										 
	PACK_BUTTONS[1]  = Bank_patulousBox_1;
	PACK_BUTTONS[2]  = Bank_patulousBox_2;
	PACK_BUTTONS[3]  = Bank_patulousBox_3;
	PACK_BUTTONS[4]  = Bank_patulousBox_4;
	PACK_BUTTONS[5]  = Bank_patulousBox_5;

end										


--===============================================
-- OnEvent
--===============================================
function Bank_OnEvent(event)

	if(event == "TOGLE_BANK") then
		this:Show();
		g_InitiativeClose = 0;
		
		--¹ØÐÄNPC
		objCared = Bank:GetNpcId();
		this:CareObject(objCared, 1, "Bank");
		
		local nRentNum = Bank:GetRentBoxNum();
		if nRentNum == 1 then
			Bank_Select_1:Enable()
			Bank_Item_Set_1:Enable()
			
			Bank_Select_2:Disable()
			Bank_Select_3:Disable()
			Bank_Item_Set_2:Disable()
			Bank_Item_Set_3:Disable()
		elseif nRentNum == 2 then
			Bank_Select_1:Enable()
			Bank_Select_2:Enable()
			Bank_Item_Set_1:Enable()
			Bank_Item_Set_2:Enable()
			
			Bank_Select_3:Disable()
			Bank_Item_Set_3:Disable()
		elseif nRentNum == 3 then
			Bank_Select_1:Enable()
			Bank_Select_2:Enable()
			Bank_Select_3:Enable()
			Bank_Item_Set_1:Enable()
			Bank_Item_Set_2:Enable()
			Bank_Item_Set_3:Enable()
		end
		
		g_CurrentRentBox = 1;
		Bank_UpdateFrame(g_CurrentRentBox);
		
	elseif(event == "UPDATE_BANK")  then
		Bank_UpdateFrame(g_CurrentRentBox);
	
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();
			Bank:Close();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "Bank");
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		Bank_UpdateFrame(g_CurrentRentBox);

	end
end

--===============================================
-- Bank_UpdateFrame
--===============================================
function Bank_UpdateFrame(nIndex)

	Bank:SetCurRentIndex(nIndex);	
	--´¦Àí½ðÇ®
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Bank:GetBankMoney();
	Bank_Money:SetProperty("MoneyNumber", tostring(nMoney));	
		
	--»ñµÃÕâ¸ö±³°ü¿ÉÒÔÊ¹ÓÃµÄ¸ñ×ÓÊý
	local nBeginIndex,nGridNum = Bank:GetRentBoxInfo(nIndex);
	
	--µãÁÁÕâÐ©¿ÉÒÔÊ¹ÓÃµÄ¸ñ×Ó£¬ÖÃ»Ò²»ÄÜÊ¹ÓÃµÄ¸ñ×Ó
	for i=1, 60 do
		GRID_BUTTONS[i]:Show();
	end

	--´ÓÊý¾Ý³ØÖÐÊ¹ÓÃÊý¾ÝÌîÈë±³°üÄÚµÄÎïÆ·
	local nTotalNum = GetActionNum("bankitem");
	
	local nActIndex = nBeginIndex;
	local i = 1;
	local M = 0;
	for i = 1, 60  do
		local theAction, bLocked = Bank:EnumItem(nActIndex);
		nActIndex = nActIndex+1;

		if theAction:GetID() ~= 0 then
			GRID_BUTTONS[i]:SetActionItem(theAction:GetID());
			if(bLocked == true) then 
				GRID_BUTTONS[i]:Disable();
			else
				GRID_BUTTONS[i]:Enable();
			end
		else
			GRID_BUTTONS[i]:SetActionItem(-1);
			
			if Bank_Select2 == 0 then
				if i >= 1 and i <= 20 then
					M = 1
				end
				if i >= 21 and i <= 40 then
					if M == 0 then
						M = 2
					end
				end
				if i >= 41 and i <= 60 then
					if M == 0 then
						M = 3
					end
				end
				Bank:SetCurRentIndex(M);
			end
		end
	end
	
	if Bank_Select2 ~= 0 then
		Bank:SetCurRentIndex(Bank_Select2)
	end
end

function Bank_Select(nIndex)
	if nIndex <= 0 or nIndex >= 4 then
		PushDebugMessage("Thao không hþp l®, vui lòng liên h® GM!")
		return
	else
		Bank_Select2 = nIndex;
		Bank:SetCurRentIndex(Bank_Select2)
	end
end

--===============================================
-- ´ò¿ª´æÇ®µÄ¶Ô»°¿ò
--===============================================
function Bank_Save_Clicked()
	Bank:OpenSaveFrame();
end

--===============================================
-- ´ò¿ªÈ¡Ç®µÄ¶Ô»°¿ò
--===============================================
function Bank_Get_Clicked()
	Bank:OpenGetFrame();
end


--===============================================
-- µã»÷×âÁÞÏäµÄ²Ù×÷ 
--===============================================
function Bank_patulousBox_Clicked(nIndex)

	g_CurrentRentBox = nIndex;
	--AxTrace(0, 0, "Bank:g_CurrentRentBox =  " .. g_CurrentRentBox);
	Bank_UpdateFrame(nIndex);

end

--===============================================
-- µã»÷¹Ø±Õ
--===============================================
function Bank_Close_Clicked()
	if(g_InitiativeClose == 1)  then
		return;
	end
	
	this:CareObject(objCared, 0, "Bank");
	this:Hide();
	Bank:Close();
end


--========================================================================
--
-- ÉèÖÃ¶þ¼¶ÃÜÂë¡£
--
--========================================================================
function Bank_SuperPassword_Clicked()

		Player:SetSupperPassword();
end;