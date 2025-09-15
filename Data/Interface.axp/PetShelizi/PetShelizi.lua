--  PetShelizi
--  Á¶ÖÆÕäÊÞÉáÀû×Ó

local Guid_Pet_H = -1
local Guid_Pet_L = -1
local Index_Pet = -1
local UITYPE_SHELIZI = 8050191
local UITYPE_SHELIZI_NOTIFY = 8050192
local CareNpcID = -1
local minLevel=30
local Pet_DBName=""
local slzExp = 0
local needmoney = 0

function PetShelizi_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- Íæ¼Ò´ÓÁÐ±íÑ¡¶¨Ò»Ö»ÕäÊÞ
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- Íæ¼ÒÉíÉÏµÄÕäÊÞÊý¾Ý·¢Éú±ä»¯£¬°üÀ¨Ôö¼ÓÒ»Ö»ÕäÊÞ
	this : RegisterEvent( "DELETE_PET" )							-- Íæ¼ÒÉíÉÏ¼õÉÙÒ»Ö»ÕäÊÞ
	this : RegisterEvent( "OBJECT_CARED_EVENT" )						-- ¹ØÐÄ NPC µÄ´æÔÚºÍ·¶Î§
	this : RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		
end




function PetShelizi_OnLoad()
	PetShelizi_FormReset()
end

function PetShelizi_OnEvent(event)
--	if event == "UI_COMMAND" then
--		
--		local CommandType = tonumber( arg0 )
--		if UITYPE_SHELIZI == CommandType then
--			local npcObjId = Get_XParam_INT( 0 )
--			PetShelizi_OnUICommand( CommandType, tonumber( npcObjId ) )
--		end
--		
--		if UITYPE_SHELIZI_NOTIFY == CommandType then
--			slzExp = Get_XParam_INT( 0 )
--			needmoney = math.floor(slzExp /100)
--			if needmoney < 1 then
--				needmoney = 1
--			end
--			PetShelizi_Demand_Money:SetProperty("MoneyNumber", needmoney)
--			
--			Guid_Pet_H, Guid_Pet_L = Pet : GetGUID( Index_Pet )
--			PetShelizi_Pet1_Text : SetText(tostring(Pet_DBName))
--			
--			Pet : SetPetLocation( Index_Pet, 3 )
--			PetShelizi_OK:Enable()
--		end
--	elseif (event == "UNIT_MONEY") then
--		PetShelizi_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
--		
--	elseif (event == "MONEYJZ_CHANGE") then
--		PetShelizi_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
--	elseif event == "REPLY_MISSION_PET" and this : IsVisible() then
--		
--		PetShelizi_OnSelectPet( tonumber( arg0 ) )
--
--	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- ¹ØÐÄ NPC µÄ´æÔÚºÍ·¶Î§
--		Pet : ShowPetList( 0 )
--		if tonumber( arg0 ) ~= CareNpcID then
--			return
--		end
--
--		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»òÕß±»É¾³ý£¬×Ô¶¯¹Ø±Õ
--		local MAX_OBJ_DISTANCE = 3.0
--		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
--			
--
--			PetShelizi_Cancel_Clicked()
--		end
--				
--	end
end

function PetShelizi_OnUICommand( CommandType, NpcObjID )
--	local Type = tonumber( CommandType )
--	if Type == UITYPE_SHELIZI then
--		PetShelizi_FormReset()
--		PetShelizi_BeginCareObject( NpcObjID )
--		PetShelizi_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
--		PetShelizi_Demand_Money:SetProperty("MoneyNumber", 0);
--		this:Show()
--		Pet : ShowPetList( 1 )
--	end

end


function PetShelizi_SelectPet_Clicked()

	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

function PetShelizi_OnSelectPet( PetIndex )
	if PetIndex < 0 then
		return
	end
	
	PetShelizi_FormReset()

	Index_Pet = PetIndex
	local petGen , petDBName = Pet:GetPetTypeName(Index_Pet)
	local strName , strName2 = Pet:GetName(Index_Pet)
	
	if petGen == 1 then
		strName2 = "Ð¶i thÑ 2 "..petDBName;
	end

	Pet_DBName = strName2	

	local guidPetH, guidPetL = Pet : GetGUID( PetIndex )
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetShelizi" )
		Set_XSCRIPT_ScriptID( 805019 )
		Set_XSCRIPT_Parameter( 0, guidPetH )
		Set_XSCRIPT_Parameter( 1, guidPetL )
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
end

function PetShelizi_OnHidden()
	if Index_Pet > 0 then
		Pet : SetPetLocation( Index_Pet, -1 )
	end
	
	Pet : ShowPetList( 0 )
	Pet : ClearSheliziPet();
end

function PetShelizi_FormReset()
	Guid_Pet_H = -1
	Guid_Pet_L = -1
	Index_Pet  = -1
	Pet_DBName = ""
	slzExp = 0
	needmoney =0
	PetShelizi_Demand_Money:SetProperty("MoneyNumber", needmoney)
	PetShelizi_Pet1_Text : SetText( Pet_DBName )
	PetShelizi_OK:Disable()
end



--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function PetShelizi_BeginCareObject( objCaredId )
	CareNpcID = DataPool : GetNPCIDByServerID( objCaredId )
	if CareNpcID == -1 then
		this : Hide()
		return
	end

	this : CareObject( CareNpcID, 1, "PetShelizi" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function PetShelizi_StopCareObject()
	this : CareObject( CareNpcID, 0, "PetShelizi" )
	Pet : ShowPetList( 0 )
	CareNpcID = -1
end


function PetShelizi_Cancel_Clicked()
	PetShelizi_FormReset()
	PetShelizi_StopCareObject()
	this:Hide()
end

function PetShelizi_OK_Clicked()
	PetShelizi_Check()
end

function PetShelizi_Check()
	
	if Guid_Pet_H == -1 or Guid_Pet_L == -1 then
		return
	end
--	·Å¿ªµÈ¼¶ÏÞÖÆ
	-- ÅÐ¶¨ÕäÊÞµÄµÈ¼¶ÊÇ·ñ´óÓÚµÈÓÚ30
--	local Level = Pet : GetLevel( Index_Pet )
--	if Level < minLevel then
--		PushDebugMessage("#{ZSKSSJ_081113_08}")
--		return
--	end
	--ÊÇ·ñÔÚ°²È«Ê±¼ä 
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if needmoney > selfMoney then
		PushDebugMessage("#{no_money}")
		return
	end

	PetShelizi_Notify(slzExp)

end

function PetShelizi_Notify(AllExp)
	

	local isNotify = Pet:PetToShelizi(Index_Pet , AllExp)
	if isNotify == 0 then
		return
	end
	
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetShelizi_Done" )
		Set_XSCRIPT_ScriptID( 805019 )
		Set_XSCRIPT_Parameter( 0, Guid_Pet_H )
		Set_XSCRIPT_Parameter( 1, Guid_Pet_L )
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()

	PetShelizi_Cancel_Clicked()
end