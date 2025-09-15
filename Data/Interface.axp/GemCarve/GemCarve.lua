
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = -1;
local g_GemItemID = -1;
local g_NeedItemPos = -1;
local g_NeedItemID = -1;
local g_NeedMoney = 0;
local g_RightGem = 0;
local EB_BINDED = 1;				-- �Ѿ���

local g_LastGemItemID = -1;
local g_LastNeedItemID = -1;

local ObjCaredIDID = -1;


function GemCarve_PreLoad()

	this:RegisterEvent("UPDATE_GEMCARVE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")		--�����ռ� Vega
end

function GemCarve_OnLoad()
end

function GemCarve_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 112236) then

			local xx = Get_XParam_INT(0);
			ObjCaredID = DataPool : GetNPCIDByServerID(xx);
			if ObjCaredID == -1 then
					PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
					return;
			end
			ObjCaredIDID = xx
			BeginCareObject_GemCarve()
			GemCarve_Clear()
			this:Show();

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemCarve_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if ( g_GemItemPos == tonumber(arg0) ) then
			Resume_Equip_GemCarve(1)
		end

		if ( g_NeedItemPos == tonumber(arg0) ) then
			Resume_Equip_GemCarve(2)
		end

	elseif( event == "UPDATE_GEMCARVE") then

		if arg0 == nil or arg1 == nil then
			return
		end

		GemCarve_Update(tonumber(arg0),tonumber(arg1));

	elseif( event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then

		GemCarve_UserMoneyChanged();

	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		if tonumber(arg0) == 41 then
			Resume_Equip_GemCarve(1)
		elseif tonumber(arg0) == 42 then
			Resume_Equip_GemCarve(2)
		end

	end

end

--=========================================================
--���ý���
--=========================================================
function GemCarve_Clear()

	if(g_GemItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
	end
	if(g_NeedItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
	end

	GemCarve_GemItem : SetActionItem(-1);
	GemCarve_NeedItem : SetActionItem(-1);
	GemCarve_ProductItem:SetActionItem(-1);

	GemCarve_NeedItem : SetToolTip("")
	GemCarve_Money : SetProperty("MoneyNumber", "")
	GemCarve_State: SetText("")
	
	g_GemItemPos = -1;
	g_GemItemID = -1;
	g_NeedItemPos = -1;
	g_NeedItemID = -1;
	g_NeedMoney = 0;
	g_RightGem = 0;
	g_LastGemItemID = -1;
    g_LastNeedItemID = -1;

	GemCarve_ProductItem:Hide();
	GemCarve_Accept:Disable();

end

--=========================================================
--���½���
--=========================================================
function GemCarve_Update( pos_ui, pos_packet )

	local theAction = EnumAction(pos_packet, "packageitem");

	if pos_ui == 1 then

		if theAction:GetID() == 0 then
			return
		end

		--�����Ǳ�ʯ....
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		if Item_Class ~= 5 then
			PushDebugMessage("Ch� c� B�o Th�ch m�i c� th� �i�u tr�c")
			return
		end

		--��¼ˢ��ǰ....��ҷŵ�������Ʒ���е�������Ʒ����Ϣ....
		local lastNeedItemPos = g_NeedItemPos
		local lastNeedItemID = g_NeedItemID

		--���ý���....
		GemCarve_Clear();

		--����ActionButton....
		if g_GemItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
		end
		g_GemItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_GemItemPos,1);
		GemCarve_GemItem:SetActionItem(theAction:GetID());

		--��ȡ��������Ϣ....
		local GemItemID = PlayerPackage : GetItemTableIndex( pos_packet )
		g_GemItemID = GemItemID;
		local ProductID
		ProductID, g_NeedItemID, g_NeedMoney = GemCarve:GetGemCarveInfo( GemItemID )
		if -1 == ProductID then
			g_RightGem = 0
			GemCarve_State : SetText("B�o Th�ch n�y kh�ng th� �i�u tr�c")
			return
		else
			g_RightGem = 1
		end

		--���ò�ƷActionButton....
		GemCarve_State : SetText("S�n ph�m sau khi �i�u tr�c:")
		GemCarve_ProductItem:Show()
		local ProductAction = GemCarve:UpdateProductAction( ProductID )
		if ProductAction and ProductAction:GetID() ~= 0 then
			GemCarve_ProductItem:SetActionItem(ProductAction:GetID());
		else
			GemCarve_ProductItem:SetActionItem(-1);
		end

		--����������ƷTooltips....
		GemCarve_NeedItem : SetToolTip("C�n �t v�o #{_ITEM"..g_NeedItemID.."}")

		--��������Ǯ��....
		GemCarve_Money : SetProperty("MoneyNumber", tostring(g_NeedMoney));
		
		--�����ε�������Ʒ���ϴε���ͬ....��ֱ�Ӱ��ϴε�������Ʒ�ŵ�������Ʒ����....
		if lastNeedItemID ~= -1 and lastNeedItemID == g_NeedItemID then
			GemCarve_Update( 2, lastNeedItemPos )
		end

	elseif pos_ui == 2 then

		if theAction:GetID() == 0 then
			return
		end

		if -1 == g_GemItemPos or g_RightGem == 0 then
			PushDebugMessage("Xin h�y b� B�o Th�ch c�n �i�u tr�c v�o")
			return
		end

		--�����������Ʒ....
		if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID then
			PushDebugMessage("� ��y ch� c� th� �t v�o #{_ITEM"..g_NeedItemID.."}")
			return
		end

		--����ActionButton....
		if g_NeedItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
		end
		g_NeedItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,1);
		GemCarve_NeedItem:SetActionItem(theAction:GetID());

		--�����Ʒ����ȷ�˲���ǮҲ����Enable������ť....
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")  --�����ռ� Vega
		if selfMoney >= g_NeedMoney then
			GemCarve_Accept:Enable();
		end

	end

end

--=========================================================
--���ActionButton
--=========================================================
function Resume_Equip_GemCarve(nIndex)

	if(nIndex == 1) then
		GemCarve_Clear()
	else
		if(g_NeedItemPos ~= -1) then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
			GemCarve_NeedItem : SetActionItem(-1);
			g_NeedItemPos	= -1;
		end
		GemCarve_Accept:Disable();
	end

end

--=========================================================
--ȷ��
--=========================================================
function GemCarve_Buttons_Clicked()

	if g_GemItemPos == -1 or g_RightGem == 0 then
		return
	end

	if g_NeedItemPos == -1 then
		return
	end
	
	if(g_LastGemItemID ~= g_GemItemID or g_LastNeedItemID ~= g_NeedItemID) then
	  g_LastGemItemID = g_GemItemID
	  g_LastNeedItemID = g_NeedItemID
	  --���ݱ�ʯ�Ƿ�󶨺ͱ�ʯ�������Ƿ�󶨣�����ժ����ı�ʯ�Ƿ��
	  if (GetItemBindStatus(g_GemItemPos) == EB_BINDED or GetItemBindStatus(g_NeedItemPos) == EB_BINDED) then
	    ShowSystemInfo("INTERFACE_XML_GemCarve_7");
	    --LifeAbility:Carve_Confirm("OnGemCarve",800117,g_GemItemPos,g_NeedItemPos,2);
	  return
	  end
	end


	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnGemCarve");
		Set_XSCRIPT_ScriptID(800117);
		Set_XSCRIPT_Parameter(0,g_GemItemPos);
		Set_XSCRIPT_Parameter(1,g_NeedItemPos);
		Set_XSCRIPT_Parameter(2,ObjCaredIDID);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	GemCarve_Close()

end

--=========================================================
--�ر�
--=========================================================
function GemCarve_Close()
	this:Hide();
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--��������
--=========================================================
function GemCarve_OnHide()
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_GemCarve()
	this:CareObject(ObjCaredID, 1, "GemCarve");
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_GemCarve()
	this:CareObject(ObjCaredID, 0, "GemCarve");
end

--=========================================================
--��ҽ�Ǯ�仯
--=========================================================
function GemCarve_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --�����ռ� Vega
	if selfMoney < g_NeedMoney then
		GemCarve_Accept:Disable();
	else
		if g_GemItemPos ~= -1 and g_NeedItemPos ~= -1 then
			GemCarve_Accept:Enable();
		end
	end

end