local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local MATERIAL_BUTTONS;
local MATERIAL_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

function Stiletto_PreLoad()

	this:RegisterEvent("UPDATE_STILETTO");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	

end

function Stiletto_OnLoad()
	EQUIP_BUTTONS = Stiletto_Item
	MATERIAL_BUTTONS = Stiletto_Material
end

function Stiletto_OnEvent(event)

		--PushDebugMessage(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 25) then
			this:Show();
			-- �����Ʒ�� zchw
			Stiletto_Clear();
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
					return;
			end
			BeginCareObject_Stiletto(objCared)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			Stiletto_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		
		if (EQUIP_QUALITY == tonumber(arg0) ) then
			Stiletto_Clear()
			Stiletto_Update(1,tonumber(arg0))
		end
			
		if (MATERIAL_QUALITY == tonumber(arg0) ) then
			Stiletto_Clear()
			Stiletto_Update(2,tonumber(arg0))
		end
	
		
	elseif ( event == "RESUME_STILETTO_EQUIP" ) then
		Resume_Equip(1);
	elseif( event == "UPDATE_STILETTO") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 == nil or arg1 == nil then
			return
		end

		Stiletto_Update(tonumber(arg0),tonumber(arg1));		

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 3) then
			Resume_Equip_Stiletto(1);
		elseif(arg0~=nil and tonumber(arg0) == 35) then
			Resume_Equip_Stiletto(2);
		end
		
	end
end

function Stiletto_OnShown()
	Stiletto_Clear()
end

function Stiletto_Clear()
	if(EQUIP_QUALITY ~= -1) then
		EQUIP_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
	end
	
--	Stiletto_Material_Bak : SetProperty("Image", "set:CommonItem image:ActionBK"); 
--	Stiletto_Material_Bak	: SetToolTip("")
	if(MATERIAL_QUALITY ~= -1) then
		MATERIAL_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
		MATERIAL_QUALITY = -1;
	end
	Stiletto_Money : SetProperty("MoneyNumber", "");
	Stiletto_State: SetText("")
end

function Stiletto_Update(pos1,pos0)
	local pos_packet,pos_ui;
	pos_packet = tonumber(pos0);
	pos_ui		 = tonumber(pos1)

	local theAction = EnumAction(pos_packet, "packageitem");
	if pos_ui == 1 then
		if theAction:GetID() ~= 0 then
			
			local Bore_Count1 = 0;
		  local Need_Item1 = -1;
		  local Need_Money1 = 0;
		  local Need_Item_Count1 =0;
			
			--Need_Item,Need_Money,Need_Item_Count,Bore_Count=LifeAbility : Stiletto_Preparation(pos_packet);
			Need_Item1,Need_Money1,Need_Item_Count1,Bore_Count1=LifeAbility : Stiletto_Preparation(pos_packet, 1); --1��ʾȡ��һ������ֵ
			
					
			if Bore_Count1 > 2 then --add:lby 20080521 
				PushDebugMessage("� ��y ch� c� th� ��c ���c 3 l�")
				return
			end
			
			-- if Need_Item1 < -1 then
				-- PushDebugMessage("V�t ph�m n�y kh�ng c� c�ch n�o t�ng th�m m�ng l�m")
				-- return
			-- end
			
			
			Need_Item = Need_Item1
			Need_Money = Need_Money1 
			Need_Item_Count = Need_Item_Count1
			Bore_Count = Bore_Count1
			
			
			--��֮ǰ�Ķ�������
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				Stiletto_Money : SetProperty("MoneyNumber", "");
				Stiletto_State: SetText("")
			end

			EQUIP_BUTTONS:SetActionItem(theAction:GetID());
			EQUIP_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
		else
			EQUIP_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_QUALITY = -1;
			Stiletto_Money : SetProperty("MoneyNumber", "");
			Stiletto_State: SetText("")
			return;
		end
		Stiletto_Money : SetProperty("MoneyNumber", tostring(Need_Money));
		Stiletto_State : SetText("S� m�ng l�m hi�n t�i: "..Bore_Count.."; c� th� t�ng th�m s� m�ng l�m: "..tostring(3-Bore_Count))
	elseif pos_ui == 2 then
		
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		local Item_Quality = PlayerPackage : GetItemSubTableIndex(pos_packet,1)
		local Item_Type = PlayerPackage : GetItemSubTableIndex(pos_packet,2)
		
		local itemindex = PlayerPackage : GetItemTableIndex(pos_packet)
		
		
		
	  if itemindex == 20109101 or itemindex == 20310111 then  --add:lby 20080521���֮�䲻�ܷ��룬���񾫴ⲻ�ܷ���
	 		PushDebugMessage("V�t ph�m n�y kh�ng th� s� d�ng � ��y")
	 		return
	  end

		if Item_Class ~= 2 or Item_Quality ~= 1 or Item_Type ~= 9 then
			return
		end
		
		if theAction:GetID() ~= 0 then
			MATERIAL_BUTTONS:SetActionItem(theAction:GetID());
			if MATERIAL_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			end
			--��֮ǰ�Ķ�������
			MATERIAL_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,1);
		else
			MATERIAL_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			MATERIAL_QUALITY = -1;
			return;
		end
		
	end
	

--add here

end

function Stiletto_Buttons_Clicked()
	if MATERIAL_QUALITY == -1 then
		PushDebugMessage("M�i th�m v�o v�t li�u ��c l�")
		return
	end
	if EQUIP_QUALITY ~= -1 then
		-- if Need_Item == -2 then
			-- PushDebugMessage("V�t ph�m n�y kh�ng c� c�ch n�o t�ng th�m m�ng l�m")
		-- elseif Need_Item == -3 then
		if Need_Item == -3 then
			PushDebugMessage("M�ng l�m �� ��t �n s� l��ng to nh�t")
--		elseif DataPool:GetPlayerMission_ItemCountNow(Need_Item) < Need_Item_Count then
--			PushDebugMessage("ȱ�ٲ���")
		elseif Player:GetData("MONEY") + Player:GetData("MONEY_JZ") < Need_Money then
			PushDebugMessage("Ng�n l��ng kh�ng ��")
		else
			
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnStiletto");
				Set_XSCRIPT_ScriptID(311200);
				Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
				Set_XSCRIPT_Parameter(1,MATERIAL_QUALITY);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		end
	else
		PushDebugMessage("M�i cho v�o 1 thi�t b� l�p �t.")
	end
	
end

function Stiletto_Close()
	--�����ã��ñ������λ�ñ���
	this:Hide();
	Stiletto_Clear();
	StopCareObject_Stiletto(objCared)
end

function Stiletto_Cancel_Clicked()
	Stiletto_Close();
	return;
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Stiletto(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Stiletto");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Stiletto(objCaredId)
	this:CareObject(objCaredId, 0, "Stiletto");
	g_Object = -1;

end

function Resume_Equip_Stiletto(nIndex)

	if( this:IsVisible() ) then
	
		if(nIndex == 1) then
			if(EQUIP_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EQUIP_BUTTONS : SetActionItem(-1);
				EQUIP_QUALITY	= -1;
				Stiletto_Money : SetProperty("MoneyNumber", "");
				Stiletto_State: SetText("")
			end
		else
			if(MATERIAL_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
				MATERIAL_BUTTONS : SetActionItem(-1);
				MATERIAL_QUALITY	= -1;
			end	
		end
		
	end
	
end
