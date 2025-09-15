local Enchange_Item1 = -1;
local Enchange_Item2 = -1;
local g_Object = -1;
local QianghualuId = 30900045
function EquipStrengthen_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PUT_STENGTHEN_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("TAKE_STENGTHEN_ITEM")
	this:RegisterEvent("MONEYJZ_CHANGE"); --zchw
end

function EquipStrengthen_OnLoad()

end

function EquipStrengthen_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 1002 then
			EquipStrengthen_Clear();
			Init_EquipStrengthen_Frame();
			objCared = -1
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
				PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
				return;
			end
			this:Show();
			BeginCareObject_EquipStrengthen(objCared);
		end
	elseif  ( event == "PUT_STENGTHEN_ITEM" ) then
		if arg0~= nil then
			EquipStrengthen_Update(arg0);
		end
		local playerMoney = Player:GetData("MONEY");
		EquipStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		EquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif	( event == "UNIT_MONEY" and this:IsVisible()) then
		EquipStrengthen_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif	( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if(tonumber(arg0) and PlayerPackage:GetItemTableIndex(tonumber(arg0)) == Enchange_Item2) then
				if(PlayerPackage:IsLock(tonumber(arg0)) == 1) then
					--push�¼��ɵ�msgbox
					LifeAbility:CloseStrengthMsgBox();
					return;
				end
		end
		if (Enchange_Item1 == tonumber(arg0)) then
			--if(PlayerPackage:IsLock(tonumber(Enchange_Item1)) == 1) then
				--EquipStrengthen_Clear();
				--Init_EquipStrengthen_Frame();
				--return
			--end
			EquipStrengthen_Update(arg0);
		end
	elseif (event == "TAKE_STENGTHEN_ITEM") then
		EquipStrengthen_Clear();
		Init_EquipStrengthen_Frame();
	end
end

function Init_EquipStrengthen_Frame()
	local playerMoney = Player:GetData("MONEY");
	EquipStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
	EquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	EquipStrengthen_Info2:Hide();
	EquipStrengthen_Info6:Hide();
	EquipStrengthen_Info5:Hide();
	EquipStrengthen_Info8:Hide();
	EquipStrengthen_Info7:Hide();
	EquipStrengthen_Info9:Hide();
end

function BeginCareObject_EquipStrengthen(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "EquipStrengthen");
end

function EquipStrengthen_Update(Item_index)
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	local NeedMoney
	local Property
	
	--PushDebugMessage(tostring(Item_index));
	
	if theAction:GetID() ~= 0 then
			local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
			if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
				if EquipPoint ~= -1 then
					PushDebugMessage("Kh�ng ���c l�p �t thi�t b� n�y v�o. ")
				end
				return
			end
			NeedMoney,Property = LifeAbility : Get_Equip_StrengthLevel(i_index);
			
			--BUG30523,alan,2007-12-29
			--��װ���ϵ�ǿ��������ÿ��ǿ������������ô˺�����9��װ���ǲ�����ŵ�ǿ�����ڵģ�����ǿ����9��ʱ
			--��Ҫ��ʾ9��װ��ǿ���Ľ����������ǿ�����ڵ���Ʒ���Ƿ�����Ʒ��ʶ�����������Ρ�
			--��һ�����½���OK��ť
			
			if(NeedMoney<=0 or tonumber(Property)==nil or tonumber(Property)<0) then
				if Enchange_Item1 ~= -1 then
					NeedMoney = 0
					EquipStrengthen_OK:Disable()
				else
					PushDebugMessage("Trang b� n�y kh�ng th� c߶ng h�a.")
					return
				end
			else				
					EquipStrengthen_OK:Enable()
			end

			if Enchange_Item1 ~= -1 then
				LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
			end
			--push�¼��ɵ�msgbox
			LifeAbility:CloseStrengthMsgBox();
			EquipStrengthen_Info5:Show();
			EquipStrengthen_Info5:SetText(""..tonumber(Property).."%");
			local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
			EquipStrengthen_Object1:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enchange_Item1 = i_index
			EquipStrengthen_Money : SetProperty("MoneyNumber", tostring(NeedMoney));
			
			local StrongLevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index);
			
			--PushDebugMessage("EquipPoint:"..tostring(EquipPoint)..",StrongLevel:"..tostring(StrongLevel))
			
			if(tonumber(StrongLevel)~=nil and tonumber(StrongLevel)>=0)then
				EquipStrengthen_Info2:Show();
				EquipStrengthen_Info6:Show();
				if(tonumber(StrongLevel) == 0)then
					EquipStrengthen_Info6:SetText("Kh�ng");
				else
					EquipStrengthen_Info6:SetText(""..tonumber(StrongLevel));
				end
			end

			local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
			--PushDebugMessage(tostring(Equip_Level));
			
			EquipStrengthen_Info8:Show();
			EquipStrengthen_Info7:Show();
			if Equip_Level < 40 then
				Enchange_Item2 = 30900005;
				EquipStrengthen_Info7 : SetText("#G#{_ITEM30900005}")
			else
				Enchange_Item2 = 30900006;
				EquipStrengthen_Info7 : SetText("#G#{_ITEM30900006}#W ho�c #G#{_ITEM30900045}")
			end
			
			EquipStrengthen_Info9:Show();
			
	else			
			return;
	end	
end

local EB_FREE_BIND = 0;				-- �ް�����
local EB_BINDED = 1;				-- �Ѿ���
local	EB_GETUP_BIND =2			-- ʰȡ��
local	EB_EQUIP_BIND =3			-- װ����
function EquipStrengthen_Buttons_Clicked()
	if Enchange_Item1 == -1 then
		PushDebugMessage("M�i cho v�o 1 thi�t b� l�p �t.")
		return
	end
	local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Enchange_Item2));

	--PushDebugMessage("�����һ��װ��1��")
 --����ǿ������
	if index == -1 and Enchange_Item2 == 30900006 then
		local index1,BindState1 = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(QianghualuId));
		--PushDebugMessage("�����һ��װ��21��")
		if(index1 == -1)then
			local str = "C�n ph�i #{_ITEM"..Enchange_Item2.."} ho�c #{_ITEM"..QianghualuId.."}";
		--PushDebugMessage("�����һ��װ��321��")
			PushDebugMessage(str);
			return
		end
		
		index = index1;
		BindState =BindState1;
		Enchange_Item2 = QianghualuId;
	end
	
	if(index == -1)then
		local str =  "Thi�u #{_Item"..Enchange_Item2.."}, ho�c #{_Item"..Enchange_Item2.."} �� kh�a.";
		PushDebugMessage(str);
		return
	end
	
	if(BindState == EB_BINDED)then
		--����Ѱ�
		local tmp = PlayerPackage:GetItemBindStatusByIndex(Enchange_Item1);
		if(tmp == EB_BINDED)then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishEnhance");
				Set_XSCRIPT_ScriptID(809262);
				Set_XSCRIPT_Parameter(0,Enchange_Item1);
				Set_XSCRIPT_Parameter(1,index);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		else
			PlayerPackage:OpenStengMsgBox(tonumber(Enchange_Item1),tonumber(index));
		end
	else	
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishEnhance");
				Set_XSCRIPT_ScriptID(809262);
				Set_XSCRIPT_Parameter(0,Enchange_Item1);
				Set_XSCRIPT_Parameter(1,index);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		
	end
end

function EquipStrengthen_Clear()
	if Enchange_Item1 ~= -1 then
		EquipStrengthen_Object1:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
		Enchange_Item1 = -1
		--push�¼��ɵ�msgbox
		LifeAbility:CloseStrengthMsgBox();
	end
	Enchange_Item2 = -1
	EquipStrengthen_Money : SetProperty("MoneyNumber", 0)
end

function EquipStrengthen_OnHiden()
	EquipStrengthen_Clear();
end