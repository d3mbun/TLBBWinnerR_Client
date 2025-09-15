local m_Equip_Idx = -1

local g_ObjCared = -1
local g_UI_Command = 201405041
local g_NeedGcp_RlGradeUp = {200,300,400,500,"T痠 餫"}	--令牌升阶需要的帮贡
local g_EquipLingPai_ShengJie_Frame_UnifiedPosition
local m_StaticText_NeedContri
local m_StaticText_HaveContri


function EquipLingPai_ShengJie_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RL_GRADEUP_PUTIN")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("ON_SCENE_TRANSING")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED") 
	this:RegisterEvent("UPDATE_SELFGUILDCONTRI")
end

function EquipLingPai_ShengJie_OnLoad()
	g_EquipLingPai_ShengJie_Frame_UnifiedPosition = EquipLingPai_ShengJie_Frame:GetProperty( "UnifiedPosition" )
	
	m_StaticText_NeedContri = EquipLingPai_ShengJie_TextShuZhi
	m_StaticText_HaveContri = EquipLingPai_ShengJie_Text1ShuZhi
	
end

function EquipLingPai_ShengJie_OnEvent(event)
	    
	if ( event == "UI_COMMAND" ) and tonumber( arg0 ) == g_UI_Command then
		EquipLingPai_ShengJie_Reset()
		this:Show()
		g_ObjCared = -1
		local xx = Get_XParam_INT( 0 )
		g_ObjCared = DataPool : GetNPCIDByServerID( xx )
		if g_ObjCared == -1 then
			return
		end
		this:CareObject( g_ObjCared, 1)
		return

	end
	
		if (event == "UI_COMMAND" and tonumber(arg0) == 10102017 and this:IsVisible()) then
		if arg1 ~= nil then
			EquipLingPai_ShengJie_Update( tonumber(arg1) )
		end
		end
	if (event == "RL_GRADEUP_PUTIN"  and this:IsVisible()) then
		if arg0 ~= nil then
			EquipLingPai_ShengJie_Update( tonumber(arg0) )
		end
		return
	end
	
	if (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			EquipLingPai_ShengJie_Update(m_Equip_Idx)
		end 
		return
	end

	if event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
            EquipLingPai_ShengJie_Reset()
			this:Hide()
		end
	elseif event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
            EquipLingPai_ShengJie_Reset()
			this:Hide()
		end
	elseif event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
            EquipLingPai_ShengJie_Reset()
			this:Hide()
		end
	elseif (event == "ADJEST_UI_POS" ) then
		EquipLingPai_ShengJie_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipLingPai_ShengJie_On_ResetPos()
	end
	
	if event == "UPDATE_SELFGUILDCONTRI" then
		local nGuildContri = Guild:GetGuildContri();
		m_StaticText_HaveContri:SetText(tostring(nGuildContri))
	end
	
end

function EquipLingPai_ShengJie_Reset()
	
	LifeAbility : Lock_Packet_Item(m_Equip_Idx,0)
	m_Equip_Idx = -1
	g_ObjCared = -1
	EquipLingPai_ShengJie_OK:Disable()
	EquipLingPai_ShengJie_Object:SetActionItem(-1)
	
	m_StaticText_NeedContri:SetText("")
	local nGuildContri = Guild:GetGuildContri();
	m_StaticText_HaveContri:SetText(tostring(nGuildContri))

end

function EquipLingPai_ShengJie_OnClosed()
	
	EquipLingPai_ShengJie_Reset()
	this:Hide()

end

function EquipLingPai_ShengJie_OnHiden()
	
	EquipLingPai_ShengJie_Reset()
	
end

function EquipLingPai_ShengJie_OnOK()
	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end
	
	if m_Equip_Idx == -1 then
		
		PushDebugMessage("#{BHZB_140521_44}")
		return

	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name( "ActionPingPai" );
		Set_XSCRIPT_ScriptID( 880001 );
		Set_XSCRIPT_Parameter( 0, 1    );  
		Set_XSCRIPT_Parameter( 1, m_Equip_Idx     );         --- 物品背包索引
		Set_XSCRIPT_ParamCount( 2 );
	Send_XSCRIPT();	
	EquipLingPai_ShengJie_OnHiden();
end

function EquipLingPai_ShengJie_Update(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem")
	if theAction:GetID() ~= 0 then
		
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		
		if itemID <10155201 or itemID >10155249 then
		PushDebugMessage("H銀 穑t 1 L畁h B鄆 v鄌")
		return
		end	
		
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0)
		end
		
		EquipLingPai_ShengJie_Object:SetActionItem(theAction:GetID())
		LifeAbility : Lock_Packet_Item(itemIdx,1)
		m_Equip_Idx = itemIdx
	Need =0
	if itemID>=10155201 and itemID<= 10155209 then
	Need =1
	elseif itemID>=10155211 and itemID<= 10155219 then
	Need =2
	elseif itemID>=10155221 and itemID<= 10155229 then
	Need =3
	elseif itemID>=10155231 and itemID<= 10155239 then
	Need =4
	elseif itemID>=10155241 and itemID<= 10155249 then
	Need =5
	end
		EquipLingPai_ShengJie_TextShuZhi:SetText(tostring(g_NeedGcp_RlGradeUp[Need]))
			EquipLingPai_ShengJie_OK:Enable()
			
		local nGuildContri = Guild:GetGuildContri();
	m_StaticText_HaveContri:SetText(tostring(nGuildContri))		
	else
		EquipLingPai_ShengJie_Object:SetActionItem(-1)			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0)
		m_Equip_Idx = -1
		EquipLingPai_ShengJie_OK:Disable()
		m_StaticText_NeedContri:SetText("")
	end
end

function EquipLingPai_ShengJie_Resume_Equip()
	EquipLingPai_ShengJie_Update(-1)
end

function EquipLingPai_ShengJie_On_ResetPos()
    EquipLingPai_ShengJie_Frame:SetProperty( "UnifiedPosition", g_EquipLingPai_ShengJie_Frame_UnifiedPosition )
end
