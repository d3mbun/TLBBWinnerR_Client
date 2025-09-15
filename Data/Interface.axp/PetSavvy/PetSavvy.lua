-- PetSavvy.lua
-- ���޺ϳɽ���

local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

local theNPC = -1													-- ���� NPC
local MAX_OBJ_DISTANCE = 3.0

local currentChoose = -1

local moneyCosts = {													-- ���������޵ĵ�ǰ����ֵ
	[0] = 10000,
	[1] = 11000,
	[2] = 12100,
	[3] = 13310,
	[4] = 14641,
	[5] = 16105,
	[6] = 17716,
	[7] = 19487,
	[8] = 21436,
	[9] = 23579,
}

function PetSavvy_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- ��Ҵ��б�ѡ��һֻ����
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- ������ϵ��������ݷ����仯����������һֻ����
	this : RegisterEvent( "DELETE_PET" )							-- ������ϼ���һֻ����
	this : RegisterEvent( "OBJECT_CARED_EVENT" )					-- ���� NPC �Ĵ��ںͷ�Χ
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--�����ռ� Vega
end

function PetSavvy_OnLoad()
	PetSavvy_Clear()
end

function PetSavvy_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19820424 then	-- �򿪽���
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			return
		end
		Pet : ShowPetList( 0 )
		PetSavvy_Clear()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		BeginCareObject( npcObjId )
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "REPLY_MISSION_PET" and this : IsVisible() then		-- ���ѡ��һֻ����
		PetSavvy_SelectPet( tonumber( arg0 ) )
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_PET_PAGE" and this : IsVisible() then		-- ������ϵ��������ݷ����仯����������һֻ����
		PetSavvy_UpdateSelected()
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "DELETE_PET" and this : IsVisible() then			-- ������ϼ���һֻ����
		PetSavvy_UpdateSelected()
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- ���� NPC �Ĵ��ںͷ�Χ
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSavvy_Cancel_Clicked()
		end
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		PetSavvy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetSavvy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
end

function PetSavvy_Choose_Clicked( type )
	if type == "main" then
		currentChoose = 1
		PetSavvy_Other_PetList1_Select : Disable()
		PetSavvy_Other_PetList2_Select : Enable()
	elseif type == "assis" then
		currentChoose = 2
		PetSavvy_Other_PetList1_Select : Enable()
		PetSavvy_Other_PetList2_Select : Disable()
	else
		return
	end

	-- ��һ���ٿ����������
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

function PetSavvy_OK_Clicked()
	-- �����ж�����Ƿ������Ҫ���������ޣ����û�з���NPC���ᵯ���Ի������أ�
	if mainPet.idx == -1 then
	-- �������Ҫ�������Եȼ������ޡ�
		ShowSystemTipInfo( "M�i c�c h� nh�p y�u c�u c�n n�ng cao nh�n th�c th� qu� c�a b�n." )
		return
	end

	-- �ж�����Ƿ�������ϳɵ����ޣ����û�з���NPC���ᵯ���Ի������أ�
	if assisPet.idx == -1 then
		-- �������Ҫ����ϳɵ����ޡ�
		ShowSystemTipInfo( "M�i cho v�o th� qu� k�t h�p m� c�c h� mu�n tham gia." )
		return
	end

	-- �жϸ������Ƿ��������
	if PetSavvy_Check() == 0 then
		-- ����������򷵻�
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

	-- ���� UI_Command ���кϳ�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetSavvy" )
		Set_XSCRIPT_ScriptID( 800104 )
		Set_XSCRIPT_Parameter( 0, mainPet.guid.high )
		Set_XSCRIPT_Parameter( 1, mainPet.guid.low )
		Set_XSCRIPT_Parameter( 2, assisPet.guid.high )
		Set_XSCRIPT_Parameter( 3, assisPet.guid.low )
		Set_XSCRIPT_ParamCount( 4 )
	Send_XSCRIPT()
end

function PetSavvy_Cancel_Clicked()
	
	this:Hide()
end

function PetSavvy_Close()
	StopCareObject()
	Pet : ShowPetList( 0 )
	PetSavvy_Clear()
end

function PetSavvy_RemoveMainPet()
	if mainPet.idx ~= -1 then
		Pet : SetPetLocation( mainPet.idx, -1 )
	end

	mainPet.idx = -1
	mainPet.guid.high = -1
	mainPet.guid.low = -1
	PetSavvy_Pet1_Text : SetText( "" )
end

function PetSavvy_RemoveAssisPet()
	if assisPet.idx ~= -1 then
		Pet : SetPetLocation( assisPet.idx, -1 )
	end

	assisPet.idx = -1
	assisPet.guid.high = -1
	assisPet.guid.low = -1
	PetSavvy_Pet2_Text : SetText( "" )
end

function PetSavvy_Clear()
	PetSavvy_RemoveMainPet()
	PetSavvy_RemoveAssisPet()

	PetSavvy_Text2 : SetText( "#cFF0000T� l� th�nh c�ng" )
	PetSavvy_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )

	PetSavvy_OK : Disable()

	currentChoose = -1
	PetSavvy_Other_PetList1_Select : Enable()
	PetSavvy_Other_PetList2_Select : Enable()
end

function PetSavvy_Check()
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
function PetSavvy_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetSavvy_Text2 : SetText( "#cFF0000T� l� th�nh c�ng" )
		PetSavvy_OK : Disable()
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
		[9] = 60,
	}

	local savvy = Pet : GetSavvy( mainPet.idx )
	local str = "#cFF0000 t� l� th�nh c�ng: "
	local odds = succOdds[savvy]
	if not odds then
		str = "Kh�ng c� c�ch n�o th�ng c�p"
		PetSavvy_OK : Disable()
	else
		str = str .. math.floor( odds / 10 ) .. "%"
		PetSavvy_OK : Enable()
	end

	PetSavvy_Text2 : SetText( str )
end

-- �����Ǯ����
function PetSavvy_CalcCost()
	if mainPet.idx == -1 then
		PetSavvy_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end

	PetSavvy_NeedMoney : SetProperty( "MoneyNumber", tostring( cost ) )
end

function PetSavvy_SelectPet( petIdx )
	if -1 == petIdx then
		return
	end

	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	-- �ж� petIdex ������Ǳ������ĳ軹�Ǹ�����
	-- ����Ǳ������ĳ�
	if currentChoose == 1 then
		-- ���ԭ���Ѿ�ѡ����һ���������ĳ�
		-- �����ԭ��������
		PetSavvy_RemoveMainPet()

		-- XX ���ԭ�����и����貢�Ҹ����費�����µ�����
		-- XX ����ո����������
		-- ��¼�ó��λ�úš�GUID
		mainPet.idx = petIdx
		mainPet.guid.high = guidH
		mainPet.guid.low = guidL

		-- ������������ı�����
		PetSavvy_Pet1_Text : SetText( petName )

		-- ����������
		Pet : SetPetLocation( petIdx, 3 )
	-- ����Ǹ�����
	elseif currentChoose == 2 then
		if PlayerPackage:IsPetLock(petIdx) == 1 then
			PushDebugMessage("�� th�m kh�a v�i Tr�n Th�")
			return
		end
		-- XX ���û�б������ĳ����
		-- XX ����ʾ��Ҫ�ȷ��뱻�����ĳ貢����
		-- XX �жϸ������Ƿ��������
		-- XX ����������򷵻�
		-- ���ԭ�����и�����
		-- �����ԭ��������
		PetSavvy_RemoveAssisPet()

		-- ��¼�ó��λ�úš�GUID
		assisPet.idx = petIdx
		assisPet.guid.high = guidH
		assisPet.guid.low = guidL

		-- ������������ı�����
		PetSavvy_Pet2_Text : SetText( petName )

		-- ����������
		Pet : SetPetLocation( petIdx, 3 )
	end

	-- ���½�Ǯ�ͼ�����ʾ
	PetSavvy_CalcSuccOdds()
	PetSavvy_CalcCost()
end

function PetSavvy_UpdateSelected()
	-- AxTrace( 0, 1, "mainPet.guid.high=".. mainPet.guid.high .. "mainPet.guid.low=" .. mainPet.guid.low )
	-- AxTrace( 0, 1, "assisPet.guid.high=".. assisPet.guid.high .. "assisPet.guid.low=" .. assisPet.guid.low )
	-- AxTrace( 0, 1, "mainPet.idx=" .. mainPet.idx .. "assisPet.idx=" .. assisPet.idx )
	-- �жϱ�ѡ�е������Ƿ��ڱ�����
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( mainPet.guid.high, mainPet.guid.low )
		-- AxTrace( 0, 1, "newIdx=".. newIdx )

		-- ���������ɾ��
		if newIdx == -1 then
			mainPet.idx = -1
			mainPet.guid.high = -1
			mainPet.guid.low = -1
			PetSavvy_Pet1_Text : SetText( "" )
		-- �����ж����޵�λ���Ƿ����仯
		elseif newIdx ~= mainPet.idx then
			-- ��������仯���λ�ý��и���
			mainPet.idx = newIdx
		end
	end

	-- �жϱ�ѡ�е������Ƿ��ڱ�����
	if assisPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( assisPet.guid.high, assisPet.guid.low )
		-- AxTrace( 0, 1, "newIdx=".. newIdx )

		-- ���������ɾ��
		if newIdx == -1 then
			assisPet.idx = -1
			assisPet.guid.high = -1
			assisPet.guid.low = -1
			PetSavvy_Pet2_Text : SetText( "" )
		-- �����ж����޵�λ���Ƿ����仯
		elseif newIdx ~= assisPet.idx then
			-- ��������仯���λ�ý��и���
			assisPet.idx = newIdx
		end
	end
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

	this : CareObject( theNPC, 1, "PetSavvy" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject()
	this : CareObject( theNPC, 0, "PetSavvy" )
	theNPC = -1
end
