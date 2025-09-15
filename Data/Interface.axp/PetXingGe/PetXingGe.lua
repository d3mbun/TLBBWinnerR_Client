
local Guid_Pet_H = -1
local Guid_Pet_L = -1
local Index_Pet = -1
local SelectPetName = ""
local UITYPE_ZHUANXING = 800108
local CareNpcID = -1
--===============================================
-- OnLoad()
--===============================================
function PetXingGe_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- ��Ҵ��б�ѡ��һֻ����
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- ������ϵ��������ݷ����仯����������һֻ����
	this : RegisterEvent( "DELETE_PET" )							-- ������ϼ���һֻ����
	this : RegisterEvent( "OBJECT_CARED_EVENT" )					-- ���� NPC �Ĵ��ںͷ�Χ
	this : RegisterEvent("UNIT_MONEY");
end

--===============================================
-- OnLoad()
--===============================================
function PetXingGe_OnLoad()
	PetXingGe_FormReset()
end

--===============================================
-- OnEvent()
--===============================================
function PetXingGe_OnEvent(event)
	
	if event == "UI_COMMAND" then
		local CommandType = tonumber( arg0 )
		if UITYPE_ZHUANXING == CommandType then
			local npcObjId = Get_XParam_INT( 0 )
			PetXingGe_OnUICommand( CommandType, tonumber( npcObjId ) )
		end		
	
	elseif event == "REPLY_MISSION_PET" then
		--AxTrace( 3, 3, "REPLY_MISSION_PET" )
		PetXingGe_OnSelectPet( tonumber( arg0 ) )

	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- ���� NPC �Ĵ��ںͷ�Χ
		Pet : ShowPetList( 0 )
		if tonumber( arg0 ) ~= CareNpcID then
			return
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		local MAX_OBJ_DISTANCE = 3.0
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetXingGe_Cancel_Clicked()
		end
				
	end
end

function PetXingGe_OnUICommand( CommandType, NpcObjID )
	local Type = tonumber( CommandType )
	if Type == UITYPE_ZHUANXING then
		PetXingGe_FormReset()
		PetXingGe_BeginCareObject( NpcObjID )
		this:Show()	
	end

end

function PetXingGe_OnSelectPet( PetIndex )
	if PetIndex < 0 then
		return
	end
	
	Index_Pet = PetIndex
	SelectPetName = Pet : GetPetList_Appoint( PetIndex )
	Guid_Pet_H, Guid_Pet_L = Pet : GetGUID( PetIndex )
	
	--AxTrace( 3, 3, "PetXingGe_OnSelectPet"..(Guid_Pet_H)..(Guid_Pet_L) )
	
	PetXingGe_Pet1_Text : SetText( SelectPetName )
	-- ����������
	Pet : SetPetLocation( PetIndex, 3 )
				
end

function PetXingGe_SelectPet_Clicked()
	-- ��һ���ٿ����������
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

function PetXingGe_FormReset()
	--AxTrace( 3, 3, "PetXingGe_FormReset" )
	Guid_Pet_H = -1
	Guid_Pet_L = -1
	Index_Pet  = -1
	SelectPetName = ""
	PetXingGe_Pet1_Text : SetText( SelectPetName )
end

function PetXingGe_Cancel_Clicked()
	PetXingGe_StopCareObject()
	this:Hide()
end

function PetXingGe_OnHidden()
	if Index_Pet > 0 then
		Pet : SetPetLocation( Index_Pet, -1 )
	end
	
	Pet : ShowPetList( 0 )
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function PetXingGe_BeginCareObject( objCaredId )
	CareNpcID = DataPool : GetNPCIDByServerID( objCaredId )
	if CareNpcID == -1 then
		this : Hide()
		return
	end

	this : CareObject( CareNpcID, 1, "PetXingGe" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function PetXingGe_StopCareObject()
	this : CareObject( CareNpcID, 0, "PetXingGe" )
	Pet : ShowPetList( 0 )
	CareNpcID = -1
end

function PetXingGe_OK_Clicked()
	
	if ( ( Index_Pet >= 0 ) and ( Guid_Pet_H >= 0 ) and ( Guid_Pet_L >= 0 ) ) then
		PetXingGe_ZhuanXing( Index_Pet, Guid_Pet_H, Guid_Pet_L )
		--PetXingGe_Cancel_Clicked()
	else
		PushDebugMessage("#{INTERFACE_XML_958}");
		return;
	end
	
end

function PetXingGe_ZhuanXing( parmPetIndex, parmPetH, parmPetL )
	
	--AxTrace( 3, 3, "PetXingGe_ZhuanXing("..(parmPetIndex)..(parmPetH)..(parmPetL)..")" )
	
	if (-1 == parmPetIndex ) then
		PushDebugMessage("#{INTERFACE_XML_958}");
		return;
	end
		
	local hid, lid = Pet:GetGUID( parmPetIndex );
	
	if hid == parmPetH and lid == parmPetL then
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ZhuanXingdian");
		Set_XSCRIPT_ScriptID( UITYPE_ZHUANXING );
		
		Set_XSCRIPT_Parameter( 0, hid );
		Set_XSCRIPT_Parameter( 1, lid );
		Set_XSCRIPT_ParamCount( 2 )
		
		Send_XSCRIPT();
		
		--AxTrace( 3, 3, "Set_XSCRIPT_Parameter("..(hid)..(lid)..")" )
		
	end
end
