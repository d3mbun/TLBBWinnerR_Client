--UI COMMAND ID 19821

local g_clientNpcId = -1;

local g_ExchangeMaxBangGong = 200; --���Զһ��İﹱ����
local g_ExchangeMinBangGong = 10;	--���Զһ��İﹱ����

function BanggongExchange_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	--this:RegisterEvent("UNIT_GUILDPOINT"); --�ﹱ����û��ʵʱˢ�»��ƣ��������Ժͻ�Ա������涼û��
	
end

function BanggongExchange_OnLoad()
end

function BanggongExchange_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 19821) then
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			return
		end
		BanggongExchange_Clear()
		BanggongExchange_Moral_Value:SetText("1")
		BanggongExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
		BanggongExchange_Moral_Value:SetSelected( 0, -1 )
		BanggongExchange_Text1:SetText("#{BGCH_8901_23}"..tostring(Guild:GetGuildContri()))
		
		this : Show()

		local npcObjId = Get_XParam_INT(0)
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("Ch�a ph�t hi�n NPC")
			BanggongExchange_Close()
			return
		end
		
		this : CareObject( g_clientNpcId, 1, "BanggongExchange" )
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			BanggongExchange_Close()
		end
	
--	elseif (event == "UNIT_GUILDPOINT" and this:IsVisible()) then
--		
--		BanggongExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
--		BanggongExchange_Moral_Value:SetSelected( 0, -1 )
--		BanggongExchange_Text1:SetText("#{BGCH_8901_23}"..tostring(Player:GetData("GUILDPOINT")))
		
	end
	
end

function BanggongExchange_Cancel_Clicked()
	BanggongExchange_Close()
end

function BanggongExchange_Clear()
end

function BanggongExchange_Close()
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "BanggongExchange")
	g_clientNpcId = -1
	BanggongExchange_Clear()
end

function BanggongExchange_Count_Change()
	local str = BanggongExchange_Moral_Value:GetText()
	local strNumber = 0;
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	
	str = tostring( strNumber );
	BanggongExchange_Moral_Value:SetTextOriginal( str );
	
end

function BanggongExchange_OK_Clicked()	
	local str = BanggongExchange_Moral_Value:GetText()
	local strNumber = 0
	
	if str == nil or str == "" then
		return
	end
	
	strNumber = tonumber(str)
	
	if strNumber > Guild:GetGuildContri() then
		PushDebugMessage("#{BGCH_8829_03}")
		return
	end
	
	--�ﹱ�Ƶ�����Ȳ��ܳ���200��
	if strNumber > g_ExchangeMaxBangGong then
		PushDebugMessage("#{BGCH_8922_25}")
		return
	end
	
	--�ﹱ�Ƶ���С��Ȳ��ܵ���10��
	if strNumber < g_ExchangeMinBangGong then
		PushDebugMessage("#{BGCH_8922_26}")
		return
	end
	
--	Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name("BanggongExchange");
--		Set_XSCRIPT_ScriptID(805009);
--		Set_XSCRIPT_Parameter(0,strNumber);
--		Set_XSCRIPT_ParamCount(1);
--	Send_XSCRIPT();

	Guild:ExchangeBangGong(strNumber,g_clientNpcId)
	
	BanggongExchange_Close()
end

