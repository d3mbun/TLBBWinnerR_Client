--MissionObjDel.lua
--����������Ʒ�Ի���

local	g_btnItem				--��Ʒ��
local	g_txtItem				--��Ʒ����
local	g_posItem	= -1	--��Ʒ�ڱ����е�λ��

local	MAX_OBJ_DISTANCE	= 3.0
local	g_objCared 				= -1

function MissionObjDel_PreLoad()
	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent( "UPDATE_MISOBJDEL" )
	
	this:RegisterEvent( "OBJECT_CARED_EVENT" )
	this:RegisterEvent( "PACKAGE_ITEM_CHANGED" )
end

function MissionObjDel_OnLoad()
	g_btnItem	= MissionObjDel_Item
	g_txtItem	= MissionObjDel_Item_Explain
end

function MissionObjDel_OnEvent( event )
	--�򿪽���
	if( event == "UI_COMMAND" and tonumber(arg0) == 42 ) then
		MissionObjDel_OnOpen()
		
		local	xx		= Get_XParam_INT( 0 )
		g_objCared	= DataPool : GetNPCIDByServerID( xx )
		AxTrace( 0, 1, "xx="..xx .. " objCared="..g_objCared )
		if g_objCared == -1 then
				PushDebugMessage( "S� li�u truy�n l�i c�a m�y ch� c� v�n �." )
				return
		end

		BeginCareObject_MisObjDel( g_objCared )
		return
	end

	--��Ʒ��ק������
	if( event == "UPDATE_MISOBJDEL" ) then
		AxTrace( 0, 1, "arg0="..arg0 )
		if arg0 ~= nil then
			MissionObjDel_Clear()
			MissionObjDel_Update( tonumber(arg0) )
		end
		return
	end
	
	--����NPC
	if( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if( tonumber(arg0) ~= g_objCared ) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if( arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" ) then
			MissionObjDel_OnClose()
		end
		return
	end
	
	--���������Ʒ�����仯
	if( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		if( arg0 ~= nil and -1 == tonumber(arg0) ) then
			return
		end

		if( arg0 ~= nil and g_posItem == tonumber(arg0) ) then
				MissionObjDel_Clear()
				MissionObjDel_Update( tonumber(arg0) )
		end
		return
	end
end

--�򿪽���
function MissionObjDel_OnOpen()
	this:Show()
end

--�رս���
function MissionObjDel_OnClose()
	this:Hide()
	
	StopCareObject_MisObjDel( g_objCared )
	g_objCared	= -1
end

--���ٰ�ť
function MissionObjDel_OnDestroy()
	if g_posItem ~= -1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 124 )
			Set_XSCRIPT_Function_Name( "OnDestroy" )
			Set_XSCRIPT_Parameter( 0, g_posItem )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	else
		PushDebugMessage( "M�i cho nhi�m v� v�t ph�m ti�u h�y v�o khung v�t ph�m" )
	end
end

--ȡ����ť
function MissionObjDel_OnCancel()
	MissionObjDel_OnClose()
end

--������Ʒ
function MissionObjDel_Clear()
	g_btnItem : SetActionItem( -1 );
	g_txtItem : SetText( "C�n ti�u h�y nhi�m v� v�t ph�m" )
	LifeAbility : Lock_Packet_Item( g_posItem, 0 )
	g_posItem	= -1
end

--ˢ����Ʒ
function MissionObjDel_Update( pos_taskitem )
	local	pos	= tonumber( pos_taskitem )
	local	theAction	= EnumAction( pos, "packageitem" )
	
	if theAction:GetID() ~= 0 then
		if LifeAbility : GetItem_Class( pos ) ~= 4 then
			PushDebugMessage( "Ch� ���c ti�u h�y nhi�m v� v�t ph�m" )
			return
		end

		g_btnItem : SetActionItem( theAction:GetID() )
		g_txtItem : SetText( theAction:GetName() )
		if g_posItem ~= -1 then
			LifeAbility : Lock_Packet_Item( g_posItem, 0 )
		end

		--�ڱ�������ס�����Ʒ
		g_posItem	= pos
		LifeAbility : Lock_Packet_Item( g_posItem, 1 )

	else
		MissionObjDel_Clear()
		return
	end

end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_MisObjDel( objCaredId )
	this:CareObject( objCaredId, 1, "MissionObjDel" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_MisObjDel( objCaredId )
	this:CareObject( objCaredId, 0, "MissionObjDel" )
end

function MissionObjDel_OnHide()
	MissionObjDel_Clear();
end
