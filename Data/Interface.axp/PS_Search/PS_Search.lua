--PS_Search.lua

local PAGE_ITEM = 0;
local PAGE_PET  = 1;

local g_CurPage;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Search_PreLoad()
	this:RegisterEvent("OPEN_FIND_SHOP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_FIND_SHOP");

end

--===============================================
-- OnLoad
--===============================================
function PS_Search_OnLoad()
	g_CurPage = PAGE_ITEM;
end

--===============================================
-- OnEvent
--===============================================
function PS_Search_OnEvent(event)

	if(event == "OPEN_FIND_SHOP")  then
		this:Show();
		PS_Search_UpdateFrame(g_CurPage)
		
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Search");
	
	elseif(event == "OBJECT_CARED_EVENT")   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Search");
		end	
	
	elseif ( event == "PS_CLOSE_FIND_SHOP" )    then
		this:Hide();
		
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "PS_Search");

	end
	
end

--===============================================
-- µã»÷Ñ¡ÔñÁÐ±í
--===============================================
function PS_Search_List_Selected()
	
	local nSelect = PS_Search_List:GetFirstSelectItem();
	if( nSelect == -1 )   then
		return;
	end
	
	if(g_CurPage == PAGE_ITEM)    then			--ÎïÆ·Ò³
		PlayerShop:FindShop("item",nSelect+1);
	
	elseif(g_CurPage == PAGE_PET) then			--ÕäÊÞÒ³
		PlayerShop:FindShop("pet",nSelect+1);
		
	end

end

--===============================================
-- UpdateFrame
--===============================================
function PS_Search_UpdateFrame(nPage)
	
	PS_Search_SetTabColor(nPage);
	PS_Search_List:ClearListBox();
	if(nPage == PAGE_ITEM)    then					--ÎïÆ·Ò³
		PS_Search_List:AddItem("V§t ph¦m",0)
		PS_Search_List:AddItem("Bäo thÕch",1)
		PS_Search_List:AddItem("Vû khí",2)
		PS_Search_List:AddItem("Giáp trø",3)
		PS_Search_List:AddItem("V§t li®u",4)
		
		PS_Search_All:SetText("Toàn bµ V§t ph¦m");

	elseif(nPage == PAGE_PET) then 					--ÕäÊÞÒ³
		PS_Search_List:AddItem("Trân Thú",0)

		PS_Search_All:SetText("Toàn bµ Trân thú");
		
	end
end

--===============================================
-- ChangeTabIndex
--===============================================
function PS_Search_ChangeTabIndex(nPage)
	g_CurPage = nPage;
	PS_Search_UpdateFrame(nPage)
end

--===============================================
-- Ñ¡Ò»Àà
--===============================================
function PS_Search_All_Clicked()
	
	if(g_CurPage == PAGE_ITEM)    then			--ÎïÆ·Ò³
		PlayerShop:FindShop("item", -1);
	
	elseif(g_CurPage == PAGE_PET) then			--ÕäÊÞÒ³
		PlayerShop:FindShop("pet", -1);
		
	end
	
end

--===============================================
-- TabÉÏµÄ×ÖÌåÑÕÉ«
--===============================================
function PS_Search_SetTabColor(nPage)

	local   selColor = "#e010101#Y";
	local noselColor = "#e010101";

	if( nPage == PAGE_ITEM )		then
		PS_Search_Check_Item:SetText(selColor.. "V§t ph¦m");
		PS_Search_Check_Pet:SetText(noselColor.. "Thú");
	elseif( nPage == PAGE_PET )	then
		PS_Search_Check_Item:SetText(noselColor.. "V§t ph¦m");
		PS_Search_Check_Pet:SetText(selColor.. "Thú");
	end

end

--===============================================
-- Close
--===============================================
function PS_Search_Close_Clicked()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Search");
	
end