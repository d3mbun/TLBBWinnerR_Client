--UI COMMAND ID 19822

local g_clientNpcId = -1;
local g_ConfraternityJuanxian_Frame_UnifiedPosition;

function ConfraternityJuanxian_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_MONEY");

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	
end

function ConfraternityJuanxian_OnLoad()
		g_ConfraternityJuanxian_Frame_UnifiedPosition=ConfraternityJuanxian_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityJuanxian_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 19822) then
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			return
		end
		ConfraternityJuanxian_Clear()
		ConfraternityJuanxian_Moral_Value:SetText("1")
		ConfraternityJuanxian_Moral_Value:SetProperty("DefaultEditBox", "True");
		ConfraternityJuanxian_Moral_Value:SetSelected( 0, -1 )
		ConfraternityJuanxian_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		ConfraternityJuanxian_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		this : Show()

		local npcObjId = Get_XParam_INT(0)
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("Ch�a ph�t hi�n NPC")
			ConfraternityJuanxian_Close()
			return
		end
		
		this : CareObject( g_clientNpcId, 1, "ConfraternityJuanxian" )
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			ConfraternityJuanxian_Close()
		end
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		ConfraternityJuanxian_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		ConfraternityJuanxian_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityJuanxian_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityJuanxian_Frame_On_ResetPos()
	end
end

function ConfraternityJuanxian_Cancel_Clicked()
	ConfraternityJuanxian_Close()
end

function ConfraternityJuanxian_Clear()
end

function ConfraternityJuanxian_Close()
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "ConfraternityJuanxian")
	g_clientNpcId = -1
	ConfraternityJuanxian_Clear()
end

function ConfraternityJuanxian_Count_Change()
	local str = ConfraternityJuanxian_Moral_Value:GetText()
	local strNumber = 0;
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	
	str = tostring( strNumber );
	ConfraternityJuanxian_Moral_Value:SetTextOriginal( str );
	
end

function ConfraternityJuanxian_OK_Clicked()	
	local str = ConfraternityJuanxian_Moral_Value:GetText()
	local strNumber = 0
	
	if str == nil or str == "" then
		return
	end
	
	strNumber = tonumber(str)
	strNumber = strNumber*10000 --���뵥λ�ǽ����ԡ�10000
	
	--PushDebugMessage("���룺"..strNumber.." ӵ�У�"..Player:GetData("MONEY"))
	if strNumber > Player:GetData("MONEY")+ Player:GetData("MONEY_JZ") then
		PushDebugMessage("#{BPZJ_0801014_007}")
		return
	end
	
--	Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name("PutGuildMoney");
--		Set_XSCRIPT_ScriptID(805012);
--		Set_XSCRIPT_Parameter(0,strNumber);
--		Set_XSCRIPT_ParamCount(1);
--	Send_XSCRIPT();
	
	Guild:PutGuildMoney(strNumber,g_clientNpcId)
	
	ConfraternityJuanxian_Close()
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityJuanxian_Frame_On_ResetPos()
  ConfraternityJuanxian_Frame:SetProperty("UnifiedPosition", g_ConfraternityJuanxian_Frame_UnifiedPosition);
end