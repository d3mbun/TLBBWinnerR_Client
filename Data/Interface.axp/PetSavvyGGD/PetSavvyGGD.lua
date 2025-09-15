-- PetSavvyGGD.lua
-- ���޺ϳɽ���

local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

local theNPC = -1													-- ���� NPC
local MAX_OBJ_DISTANCE = 3.0

local currentChoose = -1

local moneyCosts = {													-- ���������޵ĵ�ǰ����ֵ
	[0] = 100,
	[1] = 110,
	[2] = 121,
	[3] = 133,
	[4] = 146,
	[5] = 161,
	[6] = 177,
	[7] = 194,
	[8] = 214,
	[9] = 235,
}

function PetSavvyGGD_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- ��Ҵ��б�ѡ��һֻ����
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- ������ϵ��������ݷ����仯����������һֻ����
	this : RegisterEvent( "DELETE_PET" )							-- ������ϼ���һֻ����
	this : RegisterEvent( "OBJECT_CARED_EVENT" )					-- ���� NPC �Ĵ��ںͷ�Χ
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--�����ռ� Vega
end

function PetSavvyGGD_OnLoad()
	PetSavvyGGD_Clear()
end


function PetSavvyGGD_OK_Clicked()
	-- �����ж�����Ƿ������Ҫ���������ޣ����û�з���NPC���ᵯ���Ի������أ�
	if mainPet.idx == -1 then
	-- �������Ҫ�������Եȼ������ޡ�
		ShowSystemTipInfo( "M�i c�c h� nh�p y�u c�u c�n n�ng cao nh�n th�c th� qu� c�a b�n." )
		return
	end

	-- �ж���ҵĽ�Ǯ�Ƿ��㹻������������ᵯ���Ի���
	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end	

	-- ���Ľ�Ǯ���㣬��ȷ��
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--�����ռ� Vega
	if selfMoney < cost then
		ShowSystemTipInfo( "Ng�n l��ng c�a c�c h� kh�ng ��, m�i x�c nh�n." )
		return
	end
	
	--��� ���� ��
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local msgTemp;
	
	AxTrace(0,0,"nSavvyNeed:"..nSavvyNeed);
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "Th�p";
		nItemIdGenGuDan = 30502000;
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "Trung"
		nItemIdGenGuDan = 30502001;
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "Cao"
		nItemIdGenGuDan = 30502002;
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	local bExist1 = IsItemExist( 30504038 );
	
	if bExist + bExist1 <= 0 then
		local msg = "N�ng ng� t�nh �n "..nSavvyNeed.." C�n "..msgTemp.." c�p c�n c�t �an. ";
		PetSavvyGGD_GGD : SetText( msg );
		SetNotifyTip( msg );
		return;
	end
	
	-- ���� UI_Command ���кϳ�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetSavvy" )
		Set_XSCRIPT_ScriptID( 800106 )
		Set_XSCRIPT_Parameter( 0, mainPet.guid.high )
		Set_XSCRIPT_Parameter( 1, mainPet.guid.low )		
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
		
	
end

function PetSavvyGGD_Cancel_Clicked()
	this : Hide()
end

function PetSavvyGGD_SelectPet( petIdx )
	if -1 == petIdx then
		return
	end
	
	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	-- �ж� petIdex ������Ǳ������ĳ軹�Ǹ�����
	-- ����Ǳ������ĳ�

		-- ���ԭ���Ѿ�ѡ����һ���������ĳ�
		-- �����ԭ��������
		PetSavvyGGD_RemoveMainPet()

		-- XX ���ԭ�����и����貢�Ҹ����費�����µ�����
		-- XX ����ո����������
		-- ��¼�ó��λ�úš�GUID
		mainPet.idx = petIdx
		mainPet.guid.high = guidH
		mainPet.guid.low = guidL
		
		local savvy = Pet : GetSavvy( mainPet.idx )
		
		if savvy <=9 then
			-- ������������ı�����
			PetSavvyGGD_Pet : SetText( petName )
			-- ����������
			Pet : SetPetLocation( petIdx, 3 )
		else
			--���Դ���9�Ͳ�����������....
			PetSavvyGGD_Pet : SetText( "" )
			PetSavvyGGD_GGD : SetText( "" )
			PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", 0 )
			PetSavvyGGD_Text2 : SetText( "Kh�ng c� c�ch n�o th�ng c�p" )
			PetSavvyGGD_OK:Disable();
			return
		end

	-- ���½�Ǯ�ͼ�����ʾ
	PetSavvyGGD_CalcSuccOdds()
	PetSavvyGGD_CalcCost()
	
	local savvy = Pet : GetSavvy( mainPet.idx )
	--��� ���� ��
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local msgTemp;
	
	AxTrace(0,0,"nSavvyNeed:"..nSavvyNeed);
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "Th�p";		
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "Trung"		
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "Cao"		
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	
	if bExist <= 0 then
		local msg = "N�ng ng� t�nh �n "..nSavvyNeed.."C�n "..msgTemp.." c�p c�n c�t �an. ";
		PetSavvyGGD_GGD : SetText( msg );		
		return;
	end
	
end

function PetSavvyGGD_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19820425 then	-- �򿪽���
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			return
		end

		this : Show()
		PetSavvyGGD_Pet : SetText( "" )
		PetSavvyGGD_Text2 : SetText( "" )
		PetSavvyGGD_NeedMoney:SetProperty("MoneyNumber", tostring(0));
		local npcObjId = Get_XParam_INT( 0 )
		BeginCareObject( npcObjId )
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		PetSavvyGGD_OK:Disable();
		return
	end
	
	if event == "REPLY_MISSION_PET" then		-- ���ѡ��һֻ����
		PetSavvyGGD_GGD : SetText( "" );
		PetSavvyGGD_SelectPet( tonumber( arg0 ) )
	
		PetSavvyGGD_SelfMoney_Text:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_PET_PAGE" and this : IsVisible() then		-- ������ϵ��������ݷ����仯����������һֻ����
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "DELETE_PET" and this : IsVisible() then			-- ������ϼ���һֻ����
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- ���� NPC �Ĵ��ںͷ�Χ
		Pet : ShowPetList( 0 )
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			
			PetSavvyGGD_Cancel_Clicked()
		end
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
	
end

function PetSavvyGGD_Choose_Clicked( type )

	-- ��һ���ٿ����������
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end


function PetSavvyGGD_Close()
	Pet : ShowPetList( 0 )
	StopCareObject()
	PetSavvyGGD_Clear()
end

function PetSavvyGGD_RemoveMainPet()
	if mainPet.idx ~= -1 then
		Pet : SetPetLocation( mainPet.idx, -1 )
	end

	mainPet.idx = -1
	mainPet.guid.high = -1
	mainPet.guid.low = -1
end

function PetSavvyGGD_Clear()
	PetSavvyGGD_RemoveMainPet()
	
	PetSavvyGGD_GGD : SetText( "" );
	PetSavvyGGD_Pet : SetText( "" );
	PetSavvyGGD_Text2 : SetText( "#cFF0000T� l� th�nh c�ng" )
	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )

	PetSavvyGGD_OK : Disable()

	currentChoose = -1
end

function PetSavvyGGD_Check()
	if mainPet.idx == -1 or assisPet.idx == -1 then
		return 0
	end

	if mainPet.idx == assisPet.idx then
		ShowSystemTipInfo( "M�i cho v�o 2 con tr�n th� kh�c nhau." )
		return 0
	end

	-- �ж��������޵�Я���ȼ��Ƿ���ڵ�����Ҫ���������޵�Я���ȼ���������ǣ��򵯳��Ի������أ�
	local mainCarryLevel = Pet : GetTakeLevel( mainPet.idx )
	local assisCarryLevel = Pet : GetTakeLevel( assisPet.idx )
	if assisCarryLevel < mainCarryLevel then
		-- ���Ĳ���ϳɵ�����Я���ȼ�Ϊa������Ҫ��Я���ȼ����ڵ���b�Ĳ��ܲ���ϳɡ���aΪ����ϳ����޵�Я���ȼ���bΪ��Ҫ���������޵�Я���ȼ���
		ShowSystemTipInfo( "C�p mang theo c�a th� qu� c�a c�c h� khi tham gia li�n k�t l�" .. assisCarryLevel .. ", c�n t�m ��ng c�p mang theo l�n h�n ho�c b�ng" .. mainCarryLevel .. "m�i c� th� tham gia h�p th�nh" )
		return 0
	end

	-- �ж�����ϳɵ����޵ĸ����Ƿ���ڵ�����Ҫ���������޵����Եȼ�������ж��������򵯳��Ի������أ�
	local savvy = Pet : GetSavvy( mainPet.idx )
	local con = Pet : GetBasic( assisPet.idx )
	if con < savvy then
		-- ����ϳɵ����޵ĸ��Ǳ�����ڵ���a��aΪ��Ҫ���������޵����Եȼ���
		ShowSystemTipInfo( "C�n c�t c�a th� qu� k�t h�p tham gia b�t bu�c ph�i b�ng ho�c nhi�u h�n " .. savvy .. "." )
		return 0
	end

	return 1
end

-- ����ɹ���
function PetSavvyGGD_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetSavvyGGD_Text2 : SetText( "#cFF0000T� l� th�nh c�ng" )
		PetSavvyGGD_OK : Disable()
		return
	end

	succOdds = {													-- ���������޵ĵ�ǰ����ֵ
		[0] = 1000,
		[1] = 850,
		[2] = 750,
		[3] = 600,
		[4] = 200,
		[5] = 310,
		[6] = 310,
		[7] = 30,
		[8] = 70,
		[9] = 100,
	}

	local savvy = Pet : GetSavvy( mainPet.idx )
	local str = "#cFF0000"
	local odds = succOdds[savvy]
	if not odds then
		str = "Kh�ng c� c�ch n�o th�ng c�p"
		PetSavvyGGD_OK : Disable()
	else
		str = str .. math.floor( odds / 10 ) .. "%"
		PetSavvyGGD_OK : Enable()
	end

	PetSavvyGGD_Text2 : SetText( str )
end

-- �����Ǯ����
function PetSavvyGGD_CalcCost()
	if mainPet.idx == -1 then
		PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end

	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( cost ) )
end


function PetSavvyGGD_UpdateSelected()
	-- �жϱ�ѡ�е������Ƿ��ڱ�����
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( mainPet.guid.high, mainPet.guid.low )
		-- AxTrace( 0, 1, "newIdx=".. newIdx )

		-- ���������ɾ��
		if newIdx == -1 then
			mainPet.idx = -1
			mainPet.guid.high = -1
			mainPet.guid.low = -1
			PetSavvyGGD_Pet : SetText( "" )
		-- �����ж����޵�λ���Ƿ����仯
		elseif newIdx ~= mainPet.idx then
			-- ��������仯���λ�ý��и���
			mainPet.idx = newIdx
		end
	end

	PetSavvyGGD_SelectPet( mainPet.idx );
	
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	if theNPC == -1 then
		PushDebugMessage("Ch�a ph�t hi�n NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "PetSavvyGGD" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject()
	this : CareObject( theNPC, 0, "PetSavvyGGD" )
	Pet : ShowPetList( 0 )
	theNPC = -1
end
