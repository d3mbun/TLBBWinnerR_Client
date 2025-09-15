local g_nSelect_Index = -1;
local g_PreSelect = -1;
local g_PetIndex  = {};
local PET_MAX_NUMBER = 10	--×î´óÕäÊÞÐ¯´øÉÏÏÞ --add by xindefeng

--===============================================
-- OnLoad()
--===============================================
function PetList_PreLoad()
	this:RegisterEvent("OPEN_PET_LIST");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("CLOSE_PET_LIST");
	this:RegisterEvent("UPDATE_PET_LIST");
	this:RegisterEvent("CLOSE_MISSION_REPLY");
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("TOGGLE_PETLIST");

	this:RegisterEvent("UPDATE_PET_PAGE");
	
	this:RegisterEvent("CLOSE_PET_FRAME");

end

function PetList_OnLoad()

	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end

end

--===============================================
-- OnEvent()
--===============================================
function PetList_OnEvent(event)
	if(event == "OPEN_PET_LIST") then
		this:Show();
		PetList_UpdateFrame();
		PetList_Frame:SetProperty("UnifiedXPosition","{1.0,-215}");
		PetList_Frame:SetProperty("UnifiedYPosition","{0.0,201}");
	elseif(event == "REPLY_MISSION") then
		this:Show();
		PetList_Frame:SetProperty("UnifiedXPosition","{0.0,604}");
		PetList_Frame:SetProperty("UnifiedYPosition","{0.0,71}");
		PetList_UpdateFrame();
	
	elseif( event == "OPEN_EXCHANGE_FRAME" )  then
		this:Show();
		PetList_UpdateFrame();
		PetList_Frame:SetProperty("UnifiedXPosition","{0.0,588}");
		PetList_Frame:SetProperty("UnifiedYPosition","{0.0,1}");
	
	elseif ( event == "CLOSE_MISSION_REPLY" ) then
		PetList_Refuse_Click();
	elseif ( event == "CLOSE_PET_LIST" ) then
		PetList_Refuse_Click();
	elseif ( event == "UPDATE_PET_LIST" ) then
		PetList_UpdateFrame();

	elseif ( event == "UPDATE_PET_PAGE" ) then
		PetList_UpdateFrame();
		
	elseif ( event == "TOGGLE_PETLIST" ) then
--		this:TogleShow();
	elseif ( event == "CLOSE_PET_FRAME" ) then
		PetList_Refuse_Click();
	end

end

--===============================================
-- ¸üÐÂ½çÃæ
--===============================================
function PetList_UpdateFrame()

	PetList_List:ClearListBox();
	local nPetCount = Pet:GetPet_Count();
	local PetInListIndex = 0;
	for	i=1, PET_MAX_NUMBER do	--modify by xindfeng
		local szPetName,szOn = Pet:GetPetList_Appoint(i-1);
		local strToolTips = "";
		
		if(szPetName ~= "")   then
			if( szOn ~= "on_packa" )  then 
				szPetName = "#c808080" .. szPetName;
			end
			if(PlayerPackage:IsPetLock(i-1) == 1)    then
			    local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i-1);
				if( nUnlockElapsedTime == 0 ) then
					szPetName = szPetName.. "  #-05";
					
					strToolTips =  "Ðã khóa" ;
				else
					szPetName = szPetName.. "  #-10";
					
					local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);			
					strToolTips = strLeftTime ;
				end
			end
			PetList_List:AddItem(szPetName, i-1);
			PetList_List:SetItemTooltip( PetInListIndex, strToolTips );
			PetInListIndex = PetInListIndex + 1 ;
		end
	end

end

--===============================================
-- Ñ¡Ôñ
--===============================================
function PetList_Choose_Click()
	g_nSelect_Index = PetList_List:GetFirstSelectItem();
	if( g_nSelect_Index == -1 )  then
		return;
	end

	if g_PreSelect ~= -1 then
		if g_PreSelect ~= PetList_List:GetFirstSelectItem() then
			Pet:SetPetLocation(g_PreSelect,-1);
		end
	end
	
	g_PreSelect = g_nSelect_Index;
	
	Pet:SetPetLocation(g_nSelect_Index,1)

	local NeedCheckLock = 1
	if IsWindowShow("PetSkillStudy") or IsWindowShow("PetSavvy") or IsWindowShow("PetSavvyGGD") or IsWindowShow("PetXingGe") or IsWindowShow("PetProcreate") or IsWindowShow("PetZhengYou") or IsWindowShow("PetFriendSearch") or IsWindowShow("PetLevelup") or IsWindowShow("PetStudyNewSkill") then
		NeedCheckLock = 0
	end

	if NeedCheckLock == 1 and PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
		PushDebugMessage("Ðã thêm khóa v¾i Trân Thú")
		return;
	end

	Exchange:AddPet(g_nSelect_Index);
end

--===============================================
-- ·ÅÆú
--===============================================
function PetList_Refuse_Click()
	if g_nSelect_Index ~= -1 then
		Pet:SetPetLocation(g_nSelect_Index,-1);
	end
	this:Hide();
end

--===============================================
-- Ñ¡ÖÐÁÐ±íÖÐµÄÕäÊÞ
--===============================================
function PetList_List_Selected()
	g_nSelect_Index = PetList_List:GetFirstSelectItem();
end

--===============================================
--¸ù¾ÝÑ¡ÔñµÄÕäÊÞ£¬ÏÔÊ¾ÏàÓ¦µÄÏêÏ¸ÐÅÏ¢
--===============================================
function PetList_ShowTargetPet()
	g_nSelect_Index = PetList_List:GetFirstSelectItem();

	if( -1 == g_nSelect_Index ) then
		return;
	end
	Pet:ShowTargetPet(g_nSelect_Index);

end
