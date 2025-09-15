
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = { -1, -1, -1 }
local g_GemItemID = { -1, -1, -1 }

local g_ProductID = -1

local g_NeedItemPos = -1
local g_NeedItemID = -1

local g_NeedMoney = 0

local g_NotifyBind = 1

local g_GemMelting_GemItemCtrList = {}

local ObjCaredID = -1


function GemMelting_PreLoad()

	this:RegisterEvent("UPDATE_GEMMELTING");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")		--�����ռ� Vega
end

function GemMelting_OnLoad()

	g_GemMelting_GemItemCtrList[1] = GemMelting_GemItem1
	g_GemMelting_GemItemCtrList[2] = GemMelting_GemItem2
	g_GemMelting_GemItemCtrList[3] = GemMelting_GemItem3

end

function GemMelting_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 112237) then

		local xx = Get_XParam_INT(0);
		ObjCaredID = DataPool : GetNPCIDByServerID(xx);
		if ObjCaredID == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
			return
		end
		BeginCareObject_GemMelting()

		GemMelting_Clear()
		this:Show();

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemMelting_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		local NumArg0 = tonumber(arg0)
		if g_GemItemPos[1] == NumArg0 then
			Resume_Equip_GemMelting(1)
		elseif g_GemItemPos[2] == NumArg0 then
			Resume_Equip_GemMelting(2)
		elseif g_GemItemPos[3] == NumArg0 then
			Resume_Equip_GemMelting(3)
		elseif g_NeedItemPos == NumArg0 then
			Resume_Equip_GemMelting(4)
		end

	elseif( event == "UPDATE_GEMMELTING") then

		if arg0 == nil or arg1 == nil then
			return
		end
		GemMelting_Update(tonumber(arg0),tonumber(arg1));

	elseif( event == "UNIT_MONEY") then

		GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	elseif( event == "MONEYJZ_CHANGE") then

		GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )   --�����ռ� Vega

	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		local NumArg0 = tonumber(arg0)
		if NumArg0 == 61 then
			Resume_Equip_GemMelting(1)
		elseif NumArg0 == 62 then
			Resume_Equip_GemMelting(2)
		elseif NumArg0 == 63 then
			Resume_Equip_GemMelting(3)
		elseif NumArg0 == 64 then
			Resume_Equip_GemMelting(4)
		end

	end

end

--=========================================================
--���ý���
--=========================================================
function GemMelting_Clear()

	for i = 1, 3 do
		if(g_GemItemPos[i] ~= -1) then
			LifeAbility : Lock_Packet_Item(g_GemItemPos[i],0);
		end
	end

	if(g_NeedItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
	end

	for i = 1, 3 do
		g_GemMelting_GemItemCtrList[i]:SetActionItem(-1)
	end

	GemMelting_State:SetText("")
	GemMelting_ProductItem:SetActionItem(-1)

	GemMelting_NeedItem:SetToolTip("")
	GemMelting_NeedItem:SetActionItem(-1)
		
	GemMelting_NeedMoney:SetProperty("MoneyNumber", "")
	GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )   --�����ռ� Vega

	for i = 1, 3 do
		g_GemItemPos[i] = -1
	end

	for i = 1, 3 do
		g_GemItemID[i] = -1
	end

	g_ProductID = -1;

	g_NeedItemPos = -1;
	g_NeedItemID = -1;

	g_NeedMoney = 0;

	g_NotifyBind = 1

	GemMelting_ProductItem:Hide();
	GemMelting_Accept:Disable();

end

--=========================================================
--���½���
--=========================================================
function GemMelting_Update( pos_ui, pos_packet )

	-- pos_ui
	-- 1 = ������1����ʯ�����Ϸű�ʯ....
	-- 2 = ������2����ʯ�����Ϸű�ʯ....
	-- 3 = ������3����ʯ�����Ϸű�ʯ....
	-- 4 = �����������Ʒ�ĸ����Ϸ�������Ʒ....
	-- 0 = ����ڱ������Ҽ������ʯ....��Ҫ�Զ�Ѱ�ҿո񽫸ñ�ʯ�ŵ�������....

	if pos_ui == 0 or pos_ui == 1 or pos_ui == 2 or pos_ui == 3 then
		GemMelting_UpdateGemItem( pos_ui, pos_packet )
	elseif pos_ui == 4 then
		GemMelting_UpdateNeedItem( pos_ui, pos_packet )
	end

end

--=========================================================
--���±�ʯ����
--=========================================================
function GemMelting_UpdateGemItem( pos_ui, pos_packet )

	--�Ƿ����....
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--�����Ǳ�ʯ....
	local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
	if Item_Class ~= 5 then
		PushDebugMessage("#{JKBS_081021_006}")
		return
	end

	--������ͬ���ͱ�ʯ....
	local bErrorType = 0
	local CurGemItemID = PlayerPackage : GetItemTableIndex( pos_packet )
	for i = 1, 3 do
		if g_GemItemPos[i] ~= -1 and CurGemItemID ~= PlayerPackage:GetItemTableIndex( g_GemItemPos[i] ) then
			bErrorType = 1
		end
	end

	if bErrorType == 1 then
		PushDebugMessage("#{JKBS_081022_002}")
		return
	end


	--��ȡ��������Ϣ....
	local CurProductID = -1
	local CurNeedItemID = -1
	local CurNeedMoney = 0
	CurProductID, CurNeedItemID, CurNeedMoney = GemMelting:GetGemMeltingInfo( CurGemItemID )
	if -1 == CurProductID then
		PushDebugMessage("#{JKBS_081021_007}")
		return
	end


	--����Ŀ�����....
	local TargetPos = -1
	if pos_ui == 0 then
		for i = 3, 1, -1 do
			if g_GemItemPos[i] == -1 then
				TargetPos = i
			end
		end	
	else
		TargetPos = pos_ui
	end

	if -1 == TargetPos then
		--PushDebugMessage("�������Ѿ��������㻹�ţ�����")
		return
	end


	--����Ŀ�걦ʯ���Action....
	local theAction = EnumAction(pos_packet, "packageitem");
	if theAction:GetID() == 0 then
		return
	end

	if g_GemItemPos[TargetPos] ~= -1 then
		LifeAbility : Lock_Packet_Item(g_GemItemPos[TargetPos],0)
	end

	g_GemItemPos[TargetPos] = pos_packet
	LifeAbility : Lock_Packet_Item(g_GemItemPos[TargetPos],1);
	g_GemMelting_GemItemCtrList[TargetPos]:SetActionItem(theAction:GetID());


	--����Ƿ��Ѿ�������3����ʯ....
	local bAllSet = 1
	for i = 1, 3 do
		if g_GemItemPos[i] == -1 then
			bAllSet = 0
		end
	end


	--��������˱�ʯ����Ҫ��ʾ����....
	if bAllSet == 1 and g_ProductID ~= CurProductID then

		g_ProductID = CurProductID

		--���ò���Action....
		GemMelting_State : SetText("S�n ph�m sau khi dung luy�n: ")
		GemMelting_ProductItem:Show()
		local ProductAction = GemMelting:UpdateProductAction( g_ProductID )
		if ProductAction and ProductAction:GetID() ~= 0 then
			GemMelting_ProductItem:SetActionItem(ProductAction:GetID());
		else
			GemMelting_ProductItem:SetActionItem(-1);
		end

	end


	--��������˱�ʯ����Ҫ����������Ʒ....
	if bAllSet == 1 then
		g_NeedItemID = CurNeedItemID
		GemMelting_NeedItem:SetToolTip("C�n �t v�o #{_ITEM"..g_NeedItemID.."}")
	end


	--��������˱�ʯ����Ҫ��ʾ����Ǯ��....
	if bAllSet == 1 then
		g_NeedMoney = CurNeedMoney
		GemMelting_NeedMoney : SetProperty("MoneyNumber", tostring(g_NeedMoney))
	end


end


--=========================================================
--��������������
--=========================================================
function GemMelting_UpdateNeedItem( pos_ui, pos_packet )

	--�Ƿ����....
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end


	--����Ƿ��Ѿ�������3����ʯ....
	local bAllSet = 1
	for i = 1, 3 do
		if g_GemItemPos[i] == -1 then
			bAllSet = 0
		end
	end
	if bAllSet ~= 1 then
		PushDebugMessage("#{JKBS_081022_001}")
		return
	end


	--�Ƿ�����Ҫ����Ʒ....
	if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID then
		PushDebugMessage("#{JKBS_081021_010}#{_ITEM"..g_NeedItemID.."}")
		return
	end


	--����������Ʒ���Action....
	local theAction = EnumAction(pos_packet, "packageitem");
	if theAction:GetID() == 0 then
		return
	end

	if g_NeedItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0)
	end

	g_NeedItemPos = pos_packet;
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 1 )
	GemMelting_NeedItem:SetActionItem(theAction:GetID())


	--����������ť....
	GemMelting_Accept:Enable()
	g_NotifyBind = 1


end

--=========================================================
--���ActionButton
--=========================================================
function Resume_Equip_GemMelting( nIndex )

	--������Ƴ���ʯ������ı�ʯ....
	if nIndex == 1 or nIndex == 2 or nIndex == 3 then

		--����ñ�ʯ....
		LifeAbility:Lock_Packet_Item( g_GemItemPos[nIndex], 0 )
		g_GemMelting_GemItemCtrList[nIndex]:SetActionItem(-1)
		g_GemItemPos[nIndex] = -1

		--������б�ʯ�����õ���....��ֱ���������....
		local bAllRemove = 1
		for i = 1, 3 do
			if g_GemItemPos[i] ~= -1 then
				bAllRemove = 0
			end
		end
		if bAllRemove == 1 then
			GemMelting_Clear()
			return
		end

		--����....
		--���ڱ�ʯ���Ѿ�������....

		--ȡ����ʾ����....
		GemMelting_State: SetText("")
		GemMelting_ProductItem:SetActionItem(-1)
		GemMelting_ProductItem:Hide()
		g_ProductID = -1

		--ȡ����ʾ������Ʒ....
		g_NeedItemID = -1
		GemMelting_NeedMoney:SetProperty("MoneyNumber", "")

		--ȡ����ʾ����Ǯ��....
		g_NeedMoney = 0
		GemMelting_NeedMoney : SetProperty("MoneyNumber", "")

	end


	--���������Ʒ....
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 0 )
	GemMelting_NeedItem:SetActionItem(-1)
	g_NeedItemPos = -1;


	--����������ť....
	GemMelting_Accept:Disable()


end

--=========================================================
--ȷ��
--=========================================================
function GemMelting_Buttons_Clicked()

	--Ǯ�Ƿ�....
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --�����ռ� Vega
	if selfMoney < g_NeedMoney then
		PushDebugMessage( "#{JKBS_081021_011}" )
		return
	end

	--�Ƿ���˰�ȫʱ��....
	if( tonumber(DataPool:GetLeftProtectTime()) >0 ) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end


	--����״̬....
	local bHaveBind = 0
	for i = 1, 3 do
		if GetItemBindStatus( g_GemItemPos[i] ) == 1 then
			bHaveBind = 1
		end
	end
	if GetItemBindStatus( g_NeedItemPos ) == 1 then
		bHaveBind = 1
	end


	--����а󶨵�����Ҫ��ʾ....
	if bHaveBind == 1 and g_NotifyBind == 1 then
		ShowSystemInfo("JKBS_081022_003")
		g_NotifyBind = 0
		return
	end


	--����....
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGemMelting")
		Set_XSCRIPT_ScriptID(800118)
		Set_XSCRIPT_Parameter(0,g_GemItemPos[1])
		Set_XSCRIPT_Parameter(1,g_GemItemPos[2])
		Set_XSCRIPT_Parameter(2,g_GemItemPos[3])
		Set_XSCRIPT_Parameter(3,g_NeedItemPos)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()

	--GemMelting_Close()


end

--=========================================================
--�ر�
--=========================================================
function GemMelting_Close()
	this:Hide();
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--=========================================================
--��������
--=========================================================
function GemMelting_OnHide()
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_GemMelting()
	this:CareObject(ObjCaredID, 1, "GemMelting");
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_GemMelting()
	this:CareObject(ObjCaredID, 0, "GemMelting");
end