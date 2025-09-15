local GEM_BUTTONS_FOUR = {};
local GEM_QUALITY_FOUR = {};
local GEM_EFFECT_FOUR = {};
local INVALID_ID =-1;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local LastBaoshi = -1;
local LastZhuangbei = -1;
local LastCharm = -1;            --���һ����Ƕ��
local LastOdds = -1;             --���һ�μ���֮��
local SuccRate = 25;						 --��Ƕ�ĳɹ���


local g_Object = -1;

local Enchase_Four_Cost = {}
local EquipGemTable = {}

x701614_GemEmbed_four_ID = {
														50113004,50213004,50313004,50413004,50513004,50613004,50713004,50813004,50913004,50113006,
														50213006,50313006,50413006,50513006,50613006,50713006,50813006,50913006
													}
																
function Enchase_Four_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_COMPOSE_GEM");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	
	--this:RegisterEvent("DISABLE_ENCHASE_ALL_GEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE");
	this:RegisterEvent("MONEYJZ_CHANGE")		--�����ռ� Vega

end

function Enchase_Four_OnLoad()
	GEM_BUTTONS_FOUR[1] = Enchase_Four_Item;
	GEM_BUTTONS_FOUR[2] = Enchase_Four_Gem1;
	GEM_BUTTONS_FOUR[3] = Enchase_Four_Gem2;
	GEM_BUTTONS_FOUR[4] = Enchase_Four_Gem3;
	GEM_QUALITY_FOUR[1] = -1;
	GEM_QUALITY_FOUR[2] = -1;
	GEM_QUALITY_FOUR[3] = -1;
	GEM_QUALITY_FOUR[4] = -1;
	GEM_EFFECT_FOUR[1] = Enchase_Four_Effect1;
	GEM_EFFECT_FOUR[2] = Enchase_Four_Effect2;
	GEM_EFFECT_FOUR[3] = Enchase_Four_Effect3;
	GEM_EFFECT_FOUR[4] = Enchase_Four_Effect4;
	
	Enchase_Four_Cost[1] = 5000
	Enchase_Four_Cost[2] = 6000
	Enchase_Four_Cost[3] = 7000
	Enchase_Four_Cost[4] = 8000
	Enchase_Four_Cost[5] = 9000
	Enchase_Four_Cost[6] = 10000
	Enchase_Four_Cost[7] = 11000
	Enchase_Four_Cost[8] = 12000
	Enchase_Four_Cost[9] = 13000
	
	EquipGemTable[0] = { 1, 2, 3, 4, 21 }
	EquipGemTable[1] = { 11, 12, 13, 14 }
	EquipGemTable[2] = { 11, 12, 13, 14 }
	EquipGemTable[3] = { 11, 12, 13, 14 }
	EquipGemTable[4] = { 11, 12, 13, 14 }
	EquipGemTable[5] = { 11, 12, 13, 14 }
	EquipGemTable[6] = { 1, 2, 3, 4, 21 }
	EquipGemTable[7] = { 1, 2, 3, 4, 11, 12, 13, 14, 21 }
	EquipGemTable[11] = { 1, 2, 3, 4, 21 }
	EquipGemTable[12] = { 1, 2, 3, 4, 21 }
	EquipGemTable[13] = { 1, 2, 3, 4, 21 }
	EquipGemTable[14] = { 1, 2, 3, 4, 21 }
	EquipGemTable[15] = { 11, 12, 13, 14 }
	EquipGemTable[17] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	EquipGemTable[18] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	EquipGemTable[8] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	EquipGemTable[9] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	EquipGemTable[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	EquipGemTable[16] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
end

function Enchase_Four_Closed()
	LifeAbility : Enchase_CloseMsgBox();
end

function Enchase_Four_OnEvent(event)
	
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			Enchase_Four_Cancel_Clicked()
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 751107 ) then

	
		this:Show();

		Enchase_Four_Effect1:Hide();
		Enchase_Four_Effect2:Hide();
		Enchase_Four_Effect3:Hide();

		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
				return;
		end
		BeginCareObject_Enchase_Four(objCared)
		return

	elseif ( event == "UPDATE_COMPOSE_GEM" and this:IsVisible() ) then
		Enchase_Four_Update(arg0,arg1);
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
    --���κζ����ı䶼Ҫ����
    LastZhuangbei = -1;
	  LastBaoshi = -1;
	  LastCharm = -1;
	  LastOdds = -1;
	
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end
		
		
		if( arg0~= nil ) then
			local cancleMsgBox = 1;
			if (GEM_QUALITY_FOUR[1] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(25)
			elseif ( GEM_QUALITY_FOUR[2] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(26)
			elseif ( GEM_QUALITY_FOUR[3] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(27)
			elseif ( GEM_QUALITY_FOUR[4] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(28)	
			else
				cancleMsgBox = 0;
			end
			if(cancleMsgBox == 1)then
				Enchase_Four_Closed();
			end
		end
	elseif ( event == "CLOSE_SYNTHESIZE_ENCHASE" ) then
		Enchase_Four_Close();
		return;
	--elseif ( event == "DISABLE_ENCHASE_ALL_GEM" ) then
		--DisableAllGem();
		--Enchase_Four_Closed();
		--return;
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			Enchase_Four_Resume_Gem(tonumber(arg0));
			Enchase_Four_Closed();
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Enchase_Four_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));   --�����ռ� Vega
	end

end

function Enchase_Four_OnShown()
	Enchase_Four_Clear();
	Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	Enchase_Four_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
end

function Enchase_Four_Clear()

	for i=1,4 do 
		if GEM_QUALITY_FOUR[i] ~= -1 then
			GEM_BUTTONS_FOUR[i]:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[i],0);
			GEM_QUALITY_FOUR[i] = -1
		end
	end
	
	for i = 1,4 do
		GEM_EFFECT_FOUR[i] : Hide();
	end
	Enchase_Four_DemandMoney : SetProperty("MoneyNumber", 0);
	Enchase_Four_Explain : SetText("")
	Update_Four_Rate()
	
	LastZhuangbei = -1;
	LastBaoshi = -1;
	LastCharm = -1;
	LastOdds = -1;

end

function Enchase_Four_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");

	Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	Enchase_Four_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));       --�����ռ� Vega
	
	if theAction:GetID() ~= 0 then
						
			if u_index == 1 then
			
			
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 then
					if EquipPoint ~= -1 then
						PushDebugMessage("Kh�ng ���c l�p �t thi�t b� n�y v�o. ")
					end
					return
				end
				
				local hole_count = LifeAbility : GetEquip_HoleCount(i_index);
					
				if hole_count < 0 then
					return
				end
					
				if hole_count < 4 then
					PushDebugMessage("#{XQC_20080509_10}")
					return
				end
				
				local gem_count = LifeAbility : GetEquip_GemCount(i_index);

								
				if gem_count > 3 then
					PushDebugMessage("#{XQC_20080509_11}")
					return
				end
					
				if gem_count < 3 then
					PushDebugMessage("#{XQC_20080509_12}")
					return
				end
				
				local hole_count = LifeAbility : GetEquip_HoleCount(i_index);
					
				if hole_count < 0 then
					return
				end
					
				if hole_count < 4 then
					PushDebugMessage("#{XQC_20080509_10}")
					return
				end
					
				if GEM_QUALITY_FOUR[2] ~= -1 then
				
					local gem_count = LifeAbility : GetEquip_GemCount(i_index);
										
					local gem_level = LifeAbility : Get_Gem_Level(GEM_QUALITY_FOUR[2],1);
					local gem_type  = LifeAbility : Get_Gem_Level(GEM_QUALITY_FOUR[2],2);
					if gem_count < 0 then
						return
					end
					if gem_level <= 0 then
						Enchase_Four_Resume_Gem(26)
						return
					end
					if not EquipGemTable[EquipPoint] then
						PushDebugMessage("Thi�t b� l�p �t n�y kh�ng c� c�ch n�o g�n v�o.")
						return
					end
				
					local passFlag = 0
					for i, gt in EquipGemTable[EquipPoint] do
						if gt == gem_type then
							passFlag = 1
							break
						end
					end
					
					if passFlag == 0 then
						PushDebugMessage("Lo�i �� qu� n�y kh�ng ���c g�n v�o thi�t b� lo�i n�y.")
						return
					end
								
					if gem_count == 4 then
						Enchase_Four_DemandMoney : SetProperty("MoneyNumber",0)
					else
						Enchase_Four_DemandMoney : SetProperty("MoneyNumber", Enchase_Four_Cost[gem_level]*(gem_count+1));
					end
								
				end
				
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
						
				
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index
				
				for i=1,4 do
					szIconName = LifeAbility : GetEquip_Gem(GEM_QUALITY_FOUR[1], i-1);
					if szIconName and szIconName ~= "" then
						GEM_EFFECT_FOUR[i] : SetProperty("ShortImage", szIconName);
						GEM_EFFECT_FOUR[i] : Show();
					else
						GEM_EFFECT_FOUR[i] : Hide();
					end
				end
				
			elseif u_index == 2 then
				local gem_level = LifeAbility : Get_Gem_Level(i_index,1);
				if gem_level <= 0 then
					return
				end
				local gem_type  = LifeAbility : Get_Gem_Level(i_index,2);
				local EquipPoint = LifeAbility : Get_Equip_Point(GEM_QUALITY_FOUR[1])
				if(tonumber(EquipPoint)== INVALID_ID) then
					PushDebugMessage("Xin h�y �t trang b� c�n kh�m n�m v�o !")
					Enchase_Four_Resume_Gem(25)
					return;
				end
				if not EquipGemTable[EquipPoint] then
					PushDebugMessage("Thi�t b� l�p �t n�y kh�ng c� c�ch n�o g�n v�o.")
					Enchase_Four_Resume_Gem(25)
					return
				end
				
				local passFlag = 0
				for i, gt in EquipGemTable[EquipPoint] do
					if gt == gem_type then
						passFlag = 1
						break
					end
				end
					
				if passFlag == 0 then
					PushDebugMessage("Lo�i �� qu� n�y kh�ng ���c g�n v�o thi�t b� lo�i n�y.")
					return
				end
			
			 local fourgemid = PlayerPackage : GetItemTableIndex( i_index )
			 local IsRedGem = 0	
			 
			 for i, v in x701614_GemEmbed_four_ID do
		     if fourgemid == v then
			     IsRedGem = 1;
			     break
		     end
	     end
	    
	     if IsRedGem == 1 then
	    	PushDebugMessage("#{XQC_20080509_14}")
				return
	     end
	    
				if GEM_QUALITY_FOUR[1] ~= -1 then
					local gem_count = LifeAbility : GetEquip_GemCount( GEM_QUALITY_FOUR[1]);
					if gem_count < 0 then
						Enchase_Four_Resume_Gem(25)
						return
					end
					if gem_count == 4 then

						Enchase_Four_DemandMoney : SetProperty("MoneyNumber",0)
					else
						Enchase_Four_DemandMoney : SetProperty("MoneyNumber", Enchase_Four_Cost[gem_level]*(gem_count+1));
					end
				end
				
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index
			elseif u_index == 3 then
				if PlayerPackage : GetItemTableIndex( i_index ) == 30900009 then
					Enchase_Four_Explain : SetText("#cFF0000T� l� th�nh c�ng: 50%")
				elseif PlayerPackage : GetItemTableIndex( i_index ) == 30900010 then
					Enchase_Four_Explain : SetText("#cFF0000T� l� th�nh c�ng: 75%")
				else
					PushDebugMessage("� ��y b�t bu�c ph�i cho v�o #{_ITEM30900009} ho�c #{_ITEM30900010}.")
					return
				end
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index
			elseif u_index == 4 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900011 then
					PushDebugMessage("� ��y b�t bu�c ph�i cho v�o #{_ITEM30900011}.")
					return
				end
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index				
				
			end
	else
			if i_index == 1 then
				GEM_EFFECT_FOUR[i] : Hide();
			end
			GEM_BUTTONS_FOUR[u_index]:SetActionItem(-1);			
			LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);		
			GEM_QUALITY_FOUR[u_index] = -1;
	end
	Update_Four_Rate()
	Enchase_Four_Closed();
end

function Enchase_Four_Buttons_Clicked()
--local LastBaoshi = -1;
--local LastZhuangbei = -1;
	local Notify = 0;

	if(LastZhuangbei ~= GEM_QUALITY_FOUR[1] or LastBaoshi ~=	GEM_QUALITY_FOUR[2]
	    or LastCharm ~= GEM_QUALITY_FOUR[3] or LastOdds ~= GEM_QUALITY_FOUR[4]) then
	--װ�� ��ʯ ��Ƕ�� ����֮�� ����
	  LastZhuangbei = GEM_QUALITY_FOUR[1];
	  LastBaoshi = GEM_QUALITY_FOUR[2];
	  LastCharm = GEM_QUALITY_FOUR[3];
	  LastOdds = GEM_QUALITY_FOUR[4];		
		Notify = 1;		
	end
	
	if(Notify == 1) then
	  local ZhuangbeiBind = 0
	  local BaoshiBind = 0
	  local CharmBind = 0
	  local OddsBind = 0
	  
	  if(GEM_QUALITY_FOUR[1] ~= -1) then
	    ZhuangbeiBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[1])
	  end
	  if(GEM_QUALITY_FOUR[2] ~= -1) then
	    BaoshiBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[2])
	  end
	  if(GEM_QUALITY_FOUR[3] ~= -1) then
	    CharmBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[3])
	  end
	  if(GEM_QUALITY_FOUR[4] ~= -1) then
	    OddsBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[4])
	  end
	  
		local equipTableIndex = PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[1] )
		-- ����΢��2008.7.1����¥�䡢��¥��Ļ����޸ģ�1�����Դ�ף�2��������Ƕ��ʯ����ֻ����Ƕ���󶨵ı�ʯ
--		if(BaoshiBind == 1) then
--	  	if(equipTableIndex == 10422016 or equipTableIndex == 10423024) then
--	  		PushDebugMessage("M�n trang b� n�y kh�ng th� t߽ng kh�m B�o Th�ch �� ���c c� �nh.");
--				return
--	  	end
--		end

		if(BaoshiBind == 1 or CharmBind == 1 or OddsBind ==1) then
		--��� ��ʯ ��Ƕ�� ����֮�� ����һ���ǰ󶨵�
			
			if(ZhuangbeiBind == 1) then
			--���װ���ǰ󶨵�
			
				ShowSystemInfo("GEM_ENCHASE_001");
					return;
			elseif(ZhuangbeiBind == 0) then
			--���װ���ǲ��󶨵�
			 		ShowSystemInfo("GEM_ENCHASE_002");
					return;
			end
			
		end
		
	end
		
	if GEM_QUALITY_FOUR[1] == -1 then
		PushDebugMessage("M�i cho thi�t b� l�p �t g�n v�o �� qu�.")
		return
	end
	
	if GEM_QUALITY_FOUR[2] == -1 then
		PushDebugMessage("M�i cho �� qu� ���c g�n v�o")
		return
	end
	
	local Item_3=-1
	local Item_4=-1
	if GEM_QUALITY_FOUR[3] ~= -1 then 
		Item_3 = PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[3] )
	else
		PushDebugMessage("H�p th�nh ph�:")
		return
	end
	
	if GEM_QUALITY_FOUR[4] ~= -1 then 
	 Item_4 = PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[4] )
	end
	
	if (Item_3 ~= 30900009 and Item_3 ~= 30900010 ) or 
			(Item_4 ~= 30900011) then
			if SuccRate ~= 100 then
				LifeAbility:Enchase_Four_Confirm(GEM_QUALITY_FOUR[1],GEM_QUALITY_FOUR[2],GEM_QUALITY_FOUR[3],GEM_QUALITY_FOUR[4]);
				return
			end
	end
	LifeAbility : Do_Enchase_Four(GEM_QUALITY_FOUR[1],GEM_QUALITY_FOUR[2],GEM_QUALITY_FOUR[3],GEM_QUALITY_FOUR[4]);
	Enchase_Four_Close()
end

function Enchase_Four_Close()
	this:Hide()
end

function Enchase_Four_Cancel_Clicked()
	Enchase_Four_Close();
	return;
end

function Enchase_Four_OnHidden()
	StopCareObject_Enchase_Four(objCared)
	Enchase_Four_Clear()
	Enchase_Four_Closed()
	return
end
--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Enchase_Four(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Enchase_Four");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Enchase_Four(objCaredId)
	this:CareObject(objCaredId, 0, "Enchase_Four");
	g_Object = -1;

end

function Enchase_Four_Resume_Gem(nIndex)
	if nIndex < 25 or nIndex > 28 then
		return
	end

	nIndex = nIndex - 24
	if( this:IsVisible() ) then
		if GEM_QUALITY_FOUR[nIndex]~=nil and GEM_QUALITY_FOUR[nIndex] ~= -1 then
			GEM_BUTTONS_FOUR[nIndex]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[nIndex],0);
			GEM_QUALITY_FOUR[nIndex] = -1
			if nIndex == 1 then
				for i = 1,4 do
					GEM_EFFECT_FOUR[i] : Hide();
				end
				Enchase_Four_DemandMoney : SetProperty("MoneyNumber", 0);
			elseif nIndex == 2 then
				Enchase_Four_DemandMoney : SetProperty("MoneyNumber", 0);
			end
		end
	end
	Update_Four_Rate()
end

function Update_Four_Rate()
	Enchase_Four_Explain : SetText("#cFF0000T� l� th�nh c�ng: 25%")
	SuccRate = 25;
	if GEM_QUALITY_FOUR[3] ~= -1 then
		if PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[3] ) == 30900009 then
			Enchase_Four_Explain : SetText("#cFF0000T� l� th�nh c�ng: 50%")
			SuccRate = 50;
		elseif PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[3] ) == 30900010 then
			Enchase_Four_Explain : SetText("#cFF0000T� l� th�nh c�ng: 100%")
			SuccRate = 100;
		end
	end
	Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
end

function Enchase_Four_IsBind( ItemID )

	if(GetItemBindStatus(ItemID) == 1) then
		
		return 1;
		
	else
	
		return 0;
		
	end
	
end