--/* modified by cuiyinjie ����4�������ϳɹ��� */
local STUFF_SLOTS = {}										-- ��Ʒ��
local ITEM_IN_SLOTS = {}									-- ��Ʒ���е���Ʒ����λ��
local Current = 0											-- ����ĵ�ǰ״̬ 1����ʯ�ϳ� 2�����Ϻϳ� 3: ����ϳ�
local Type = -1												-- ��ǰ�ϳɵĲ�������
local Grade = -1											-- ��ǰ�ϳɵĲ��ϵ���
local theNPC = -1											-- ���� NPC
local MATERIAL_COUNT = 5									-- �źϳɲ��ϵĲ۵�����
local SLOT_COUNT = 6										-- �����ܷŶ����Ĳ۵�����
local SPECIAL_MATERIAL_SLOT = 6								-- ��������ϵĸ��Ӻ�
local MAX_OBJ_DISTANCE = 3.0

local LaskPack = {}

local curSuccRate = 0;
local RuleTable = {
	{
		msgDiffTypeErr = "B�t bu�c c�ng lo�i �� qu� m�i ti�n h�nh h�p th�nh.",
		msgDiffGradeErr = "C�n �� qu� h�p th�nh b�t bu�c ��ng c�p ngang nhau m�i h�p th�nh.",
		msgLackMoney = "Kh�ng �� #{_EXCHG%d} v�ng. ",
		msgLackStuff = "M�i l�n c�t v�t ph�m h�p th�nh ph�i nhi�u h�n 2 chi�c.",
		msgSlotEmpty = "H�y �t B�o Th�ch c�n h�p th�nh v�o.",         -- add  by zchw
		maxGrade = 7,
		msgGradeLimited = "B�o th�ch h�p th�nh c�p cao nh�t l� c�p 7, b�o th�ch c�a b�ng h�u kh�ng th� ti�p t�c h�p th�nh n�a.",
		[1] = { SpecialStuff = 30900015, MoneyCost = 5000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[2] = { SpecialStuff = 30900015, MoneyCost = 6000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[3] = { SpecialStuff = 30900015, MoneyCost = 7000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[4] = { SpecialStuff = 30900016, MoneyCost = 8000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[5] = { SpecialStuff = 30900016, MoneyCost = 9000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[6] = { SpecialStuff = 30900016, MoneyCost = 10000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[7] = { SpecialStuff = 30900016, MoneyCost = 11000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[8] = { SpecialStuff = 30900016, MoneyCost = 12000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	},
	{
		msgDiffTypeErr = "B�t bu�c ph�i s� d�ng c�ng m�t lo�i t�i li�u m�i h�p th�nh.",
		msgDiffGradeErr = "B�t bu�c t�i li�u ��ng c�p ngang nhau m�i h�p th�nh.",
		msgLackMoney = "Kh�ng �� #{_EXCHG%d} v�ng. ",
		msgLackStuff = "M�i l�n c�t v�t ph�m h�p th�nh ph�i nhi�u h�n 2 chi�c.",
		msgSlotEmpty = "H�y ��a nguy�n li�u c�n h�p th�nh v�o.",				-- add by zchw
		maxGrade = 5,	-- ��Ʒ����ĵȼ���3������Ϊ4�������Ա߽�Ϊ5�� mark by cuiyinjie maxGrade add 1
		msgGradeLimited = "Cao nh�t c� th� � v�o nguy�n li�u c�p 3, nguy�n li�u c�a c�c h� kh�ng th� ti�p t�c h�p th�nh.", --�ȼ���1��
		[1] = { SpecialStuff = -1, MoneyCost = 500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[2] = { SpecialStuff = -1, MoneyCost = 1000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[3] = { SpecialStuff = -1, MoneyCost = 1500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[4] = { SpecialStuff = -1, MoneyCost = 5000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, }, -- modify by cuiyinjie cost 20yin -> cost 50yin
--		[5] = { SpecialStuff = -1, MoneyCost = 2500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[6] = { SpecialStuff = -1, MoneyCost = 3000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[7] = { SpecialStuff = -1, MoneyCost = 3500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[8] = { SpecialStuff = -1, MoneyCost = 4000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
	},
	{
		msgDiffTypeErr = "C�n ph�i s� d�ng Huy�n Thi�n H�n Ng�c � h�p th�nh.",
		msgDiffGradeErr = "C�n ph�i s� d�ng c�ng m�t lo�i Huy�n Thi�n H�n Ng�c � h�p th�nh.",
		msgLackMoney = "Kh�ng �� #{_EXCHG%d} v�ng. ",
		msgLackStuff = "M�i l�n c�t v�t ph�m h�p th�nh ph�i nhi�u h�n 2 chi�c.",
		msgSlotEmpty = "H�y ��a Huy�n Thi�n H�n Ng�c c�n h�p th�nh v�o.",
		maxGrade = 2,
		msgGradeLimited = "C�n ph�i nh�p v�o c�ng m�t lo�i Huy�n Thi�n H�n Ng�c, Huy�n Thi�n H�n Ng�c c�a b�ng h�u kh�ng th� ti�p t�c h�p th�nh.",
		[1] = { SpecialStuff = -1, MoneyCost = 10000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[2] = { SpecialStuff = -1, MoneyCost = 1000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[3] = { SpecialStuff = -1, MoneyCost = 1500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[4] = { SpecialStuff = -1, MoneyCost = 2000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[5] = { SpecialStuff = -1, MoneyCost = 2500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[6] = { SpecialStuff = -1, MoneyCost = 3000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[7] = { SpecialStuff = -1, MoneyCost = 3500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[8] = { SpecialStuff = -1, MoneyCost = 4000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
	},
}

local g_MaterialCompound_Frame_UnifiedPosition;

-- ע���¼�
function MaterialCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")						-- ��������¼�

	this:RegisterEvent("UPDATE_COMPOSE_GEM")				-- ˢ�±�ʯ�ϳɽ���
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")				-- ��������Ʒ�ı���Ҫ�жϡ���
	this:RegisterEvent("OBJECT_CARED_EVENT")				-- ��עʵʩ�ϳɵ� NPC
	this:RegisterEvent("RESUME_ENCHASE_GEM")				-- �ϳ����
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE")			-- �رձ�����
	-- this:RegisterEvent("TOGLE_SKILL_BOOK")				-- �����ɼ��ܽ����Ƿ���Ҫ�رմ˽���
	-- this:RegisterEvent("TOGLE_COMMONSKILL_PAGE")			-- ����ͨ���ܽ����Ƿ���Ҫ�رգ�
	-- this:RegisterEvent("CLOSE_SKILL_BOOK")				-- �ر����ɼ��ܽ���
	-- this:RegisterEvent("DISABLE_ENCHASE_ALL_GEM")		-- ���кϳ���ص���Ʒ��Ҫ����
	-- this:RegisterEvent("UPDATE_COMPOSE_ITEM")			-- ��Ʒ�ϳɽ���򿪣��˽����Ƿ���Ҫ�رգ�
	-- this:RegisterEvent("OPEN_COMPOSE_ITEM")				-- ��Ʒ�ϳɽ���򿪣��˽����Ƿ���Ҫ�رգ�
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--�����ռ� Vega
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

-- ��������
function MaterialCompound_OnLoad()
	STUFF_SLOTS[1] = Materalcompose_Space1
	STUFF_SLOTS[2] = Materalcompose_Space2
	STUFF_SLOTS[3] = Materalcompose_Space3
	STUFF_SLOTS[4] = Materalcompose_Space4
	STUFF_SLOTS[5] = Materalcompose_Space5
	STUFF_SLOTS[6] = Materalcompose_Special_Button

	ITEM_IN_SLOTS[1] = -1
	ITEM_IN_SLOTS[2] = -1
	ITEM_IN_SLOTS[3] = -1
	ITEM_IN_SLOTS[4] = -1
	ITEM_IN_SLOTS[5] = -1
	ITEM_IN_SLOTS[6] = -1

	LaskPack[1] = -1
	LaskPack[2] = -1
	LaskPack[3] = -1
	LaskPack[4] = -1
	LaskPack[5] = -1
	LaskPack[6] = -1
	
	 g_MaterialCompound_Frame_UnifiedPosition=Materalcompose_Frame:GetProperty("UnifiedPosition");
	 
end

-- ��ظ����¼�
function MaterialCompound_OnEvent( event )
	if event == "UI_COMMAND" and tonumber( arg0 ) == 23 then	-- ��ʯ�ϳ�
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 1 then				-- ������濪�ţ���ص�
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000T� l� th�nh c�ng");
		Current = 1
		Materalcompose_DragTitle : SetText("#gFF0FA0B�o th�ch h�p th�nh.")
		MaterialCompose_Info : SetText("H�p th�nh b�o th�ch c� th� l�m cho nh�ng b�o th�ch s� c�p h�p th�nh sang b�o th�ch cao c�p #G (B�o th�ch h�p th�nh c�n thi�t ph�i 2 vi�n tr� l�n) #W")
		Materalcompose_Static1 : Show()
		Materalcompose_Special : Show()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UI_COMMAND" and tonumber( arg0 ) == 19810424 then	-- ���Ϻϳ�
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 2 then				-- ������濪�ţ���ص�
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000T� l� th�nh c�ng");
		Current = 2
		Materalcompose_DragTitle : SetText("#gFF0FA0T�i li�u h�p th�nh")
		MaterialCompose_Info : SetText("H�p th�nh nguy�n li�u c� th� d�ng Mi�n B�, B� Ng�n, Tinh Thi�t � ti�n h�nh th�ng c�p h�p th�nh. (#GNguy�n li�u h�p th�nh c�n 5 #Y)")
		Materalcompose_Static1 : Hide()
		Materalcompose_Special : Hide()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UI_COMMAND" and tonumber( arg0 ) == 86021935 then	-- ����ϳ�
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 3 then				-- ������濪�ţ���ص�
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000T� l� th�nh c�ng");
		Current = 3
		Materalcompose_DragTitle : SetText("#gFF0FA0H�p th�nh H�n Ng�c")
		MaterialCompose_Info : SetText("C� th� d�ng 5 vi�n Huy�n Thi�n H�n Ng�c h�p th�nh 1 H�n Ng�c Tinh Tu� (#GC�n 5 c�i � h�p th�nh nguy�n li�u Huy�n Thi�n H�n Ng�c#Y)")
		Materalcompose_Static1 : Hide()
		Materalcompose_Special : Hide()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			MaterialCompound_Cancel_Clicked()
		end
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_COMPOSE_GEM" and this : IsVisible() then
		MaterialCompound_Update( arg0, arg1 )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "PACKAGE_ITEM_CHANGED" and this : IsVisible() then
		if not arg0 or tonumber( arg0 ) == -1 then
			return
		end

		for i = 1, SLOT_COUNT do
			if ITEM_IN_SLOTS[i] == tonumber( arg0 ) then
				MaterialCompound_Remove( i )
				break
			end
		end
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "RESUME_ENCHASE_GEM" and this : IsVisible() then
		if arg0 then
			MaterialCompound_Remove( tonumber( arg0 ) - 6 )
		end

		return
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end

	if event == "CLOSE_SYNTHESIZE_ENCHASE" and this : IsVisible() then
		MaterialCompound_Cancel_Clicked()
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
	
	if (event == "ADJEST_UI_POS" ) then
		MaterialCompound_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		MaterialCompound_Frame_On_ResetPos()
		end
		
end

-- ����ϳɰ�ť
function MaterialCompound_OK_Clicked()
	-- ���ݵ�ǰ�����Ľ�����м��
	local Notify = 0;
	local CurrentRule = RuleTable[Current]
	if not CurrentRule then
		return
	end

	--����״̬
	--������һ���ǲ��ϰ���ʾ������д����bug��ȫ��ע���������µ��߼�
--		for i = 1, MATERIAL_COUNT do

--			if(LaskPack[i] ~= ITEM_IN_SLOTS[i]) then

--				LaskPack[i] = ITEM_IN_SLOTS[i];
--				Notify = 1;

--			end

--		end

--		if(Notify == 1) then

--			for i = 1, MATERIAL_COUNT do

--				if(ITEM_IN_SLOTS[i] == -1) then

--					continue

--				end

--				if(MaterialCompound_IsBind(ITEM_IN_SLOTS[i]) == 1) then
				--�����û�а󶨵���Ʒ
--					ShowSystemInfo("BSHE_20070924_001");
--					return;

--				end

--			end

--		end

	local materialCount = 0

	-- add by zchw
	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] ~= -1 then
			Grade = MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] );
			break;
		end
	end
	if Grade == -1 then
		PushDebugMessage( CurrentRule.msgSlotEmpty )
		return
	end
	-- end of zchw

	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] == -1 then
			continue
		end
		materialCount = materialCount + 1

		-- ����Ƿ���ͬ�ֲ���
		if MaterialCompound_ItemInterface( ITEM_IN_SLOTS[i] ) ~= Current then
			PushDebugMessage( CurrentRule.msgDiffTypeErr )
			return
		end

		if Type ~= MaterialCompound_GetItemType( ITEM_IN_SLOTS[i] ) then
			PushDebugMessage( CurrentRule.msgDiffTypeErr )
			return
		end

		-- �������Ƿ�ȼ���ͬ
		if not CurrentRule[Grade] or Grade ~= MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) then
			PushDebugMessage( CurrentRule.msgDiffGradeErr )
			return
		end

		-- �������Ƿ�����ߵȼ�
		if MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) >= RuleTable[Current].maxGrade then
			PushDebugMessage( CurrentRule.msgGradeLimited )
			return
		end
		--�ϳ�8��9����ʯ���ܹر�
		if Current == 1 then
			if MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) > 6 then
				PushDebugMessage( "#{BSHC_090313_1}" )
				return
			end
		end
	end

	-- ������ϵĽ�Ǯ�Ƿ��㹻
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < CurrentRule[Grade].MoneyCost then
		PushDebugMessage( string.format( CurrentRule.msgLackMoney, CurrentRule[Grade].MoneyCost ) )
		return
	end

	-- �����������Ƿ��㹻
	if not CurrentRule[Grade].CountTable[materialCount] then
		PushDebugMessage( CurrentRule.msgLackStuff )
		return
	end

	-- ����Ǳ�ʯ�ϳɽ��棬�����û�з���������Ͻ�����������ʾ
	if Current == 1 then
		if ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] and ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] == -1 then
--			local dialogStr = "�����ʹ��#{_ITEM" .. CurrentRule[Grade].SpecialStuff ..
--				"}���кϳɵĻ����ϳɵĳɹ������ֻ��75�������Ƿ�ȷ�������ϳɣ�"
--			LifeAbility : Do_Combine( ITEM_IN_SLOTS[1], ITEM_IN_SLOTS[2],
--				ITEM_IN_SLOTS[3], ITEM_IN_SLOTS[4],
--				ITEM_IN_SLOTS[5], ITEM_IN_SLOTS[6], 0, dialogStr )
			PushDebugMessage( "H�p th�nh b�o th�ch c�n �t b�o th�ch h�p th�nh ph�." )
			return
		end
	end

	LifeAbility : Do_Combine( ITEM_IN_SLOTS[1], ITEM_IN_SLOTS[2],
		ITEM_IN_SLOTS[3], ITEM_IN_SLOTS[4],
		ITEM_IN_SLOTS[5], ITEM_IN_SLOTS[6],(curSuccRate.."%") )
end

-- ���ȡ�����߹رհ�ť
function MaterialCompound_Cancel_Clicked()
	MaterialCompound_Close()
	MaterialCompound_StopCareObject()
end

-- �رս���
function MaterialCompound_Close()
	this : Hide()
	MaterialCompound_Clear()
end

-- ��ս���Ԫ��
function MaterialCompound_Clear()
	Current = 0
	Type = -1
	Grade = -1
	Materalcompose_SuccessValue : SetText("#cFF0000T� l� th�nh c�ng")
	Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
	Materalcompose_OK : Disable()

	for i = 1, SLOT_COUNT do
		STUFF_SLOTS[i] : SetActionItem(-1)

		if ITEM_IN_SLOTS[i] ~= -1 then
			LifeAbility : Lock_Packet_Item( ITEM_IN_SLOTS[i], 0 )
		end

		STUFF_SLOTS[i] : Enable()
		ITEM_IN_SLOTS[i] = -1
	end
	LifeAbility:ClearComposeItems();
	LaskPack[1] = -1
	LaskPack[2] = -1
	LaskPack[3] = -1
	LaskPack[4] = -1
	LaskPack[5] = -1
	LaskPack[6] = -1
end

-- �ж�ĳ�����������е���Ʒ�Ƿ�ʯ
function MaterialCompound_IsGem( bagPos )
	if PlayerPackage : IsGem( bagPos ) == 1 then
		return 1
	else
		return 0
	end
end

-- �ж�ĳ�����������е���Ʒ�Ƿ����
function MaterialCompound_IsMaterial( bagPos )
	--local MatIdentifier = PlayerPackage : GetItemSubTableIndex( bagPos, 0 ) * 10000000 + PlayerPackage : GetItemSubTableIndex( bagPos, 1 )*100000 + PlayerPackage : GetItemSubTableIndex( bagPos, 2 )*1000 + PlayerPackage : GetItemSubTableIndex( bagPos, 3 )
	local itemId = PlayerPackage:GetItemTableIndex(bagPos)
	if itemId >= 20500000 and itemId <= 20500008 then
		return 1
	end

	if itemId >= 20501000 and itemId <= 20501008 then
		return 1
	end

	if itemId >= 20502000 and itemId <= 20502008 then
		return 1
	end

	return 0

end

-- �õ�ĳ�����������е���Ʒ������
function MaterialCompound_GetItemType( bagPos )
	if MaterialCompound_IsGem( bagPos ) == 1 then
		return ( PlayerPackage : GetItemSubTableIndex( bagPos, 2 ) * 1000 + PlayerPackage : GetItemSubTableIndex( bagPos, 3 ) )
	elseif MaterialCompound_IsMaterial( bagPos ) == 1 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 2 )
	elseif PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 2 )
	end

	return -1
end

-- �õ�ĳ�����������е���Ʒ�ĵȼ�
function MaterialCompound_GetItemGrade( bagPos )
	if MaterialCompound_IsGem( bagPos ) == 1 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 1 )
	elseif MaterialCompound_IsMaterial( bagPos ) == 1 then
		return PlayerPackage : GetItemGrade( bagPos )
	elseif PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		return PlayerPackage : GetItemGrade( bagPos )
	end

	return PlayerPackage : GetItemGrade( bagPos )
end

-- �õ���ǰ����Ӧ��ƥ���������Ϻ�
-- ������Ǳ�ʯ�����򷵻� -1
-- ����Ǳ�ʯ���浫�ǻ�û�з��κα�ʯ�򷵻� -1
function MaterialCompound_GetSpecialMaterial()
	local CurrentRule = RuleTable[Current]
	if CurrentRule then
		if CurrentRule[Grade] then
			return CurrentRule[Grade].SpecialStuff
		end
	end

	return -1
end

-- �ж�ĳ�����������е���Ʒ�����Ǹ����棬ƥ�� Current��û��ƥ����� 0
-- ����ĵ�ǰ״̬ 1����ʯ�ϳ� 2�����Ϻϳ�
function MaterialCompound_ItemInterface( bagPos )
	if Current == 1 then
		if MaterialCompound_IsGem( bagPos ) == 1 then
			return Current
		end

		if PlayerPackage : GetItemTableIndex( bagPos ) == MaterialCompound_GetSpecialMaterial() then
			return Current
		end
	elseif Current == 2 then
		if MaterialCompound_IsMaterial( bagPos ) == 1 then
			return Current
		end
	elseif Current == 3 then
		if(PlayerPackage:GetItemTableIndex(bagPos)==20310110)then
			return Current
		end
	end

	return 0
end

-- ˢ�ºϳɽ����ϵ���Ʒ
function MaterialCompound_Update( pos0, pos1 )
	local slot = tonumber( pos0 )
	local bagPos = tonumber( pos1 )

	-- AxTrace( 0, 1, "Current=".. Current )
	-- AxTrace( 0, 1, "slot=".. slot )
	-- AxTrace( 0, 1, "bagPos=".. bagPos )
	local CurrentRule = RuleTable[Current]
	if not CurrentRule then
		return
	end

	if not this : IsVisible() then					-- ����δ��
		return
	end

	-- ��֤��Ʒ��Ч��
	local bagItem = EnumAction( bagPos, "packageitem" )
	if bagItem : GetID() == 0 then
		return
	end

	-- AxTrace( 0, 1, "MaterialCompound_ItemInterface( bagPos )=".. MaterialCompound_ItemInterface( bagPos ) )
	-- �ҵ� bagPos ����Ʒ���ͣ����ж��Ƿ���ϵ�ǰ���棬����û���κ���ʾ
		-- PushDebugMessage(MaterialCompound_ItemInterface( bagPos ))
		-- PushDebugMessage(Current)
	if MaterialCompound_ItemInterface( bagPos ) ~= Current then

		PushDebugMessage( "Lo�i h�nh t�i li�u kh�ng ph� h�p" )
		return
	end

	-- ��� bagPos �ǵ�ǰ������Ҫ����Ʒ���ҵ�����ƷӦ�ô��ڵĸ��ӷ�Χ
	-- ����Ǳ�ʯ���߲���
	if MaterialCompound_IsGem( bagPos ) == 1 or MaterialCompound_IsMaterial( bagPos ) == 1 or PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		-- AxTrace( 0, 1, "it's a main material." )
		-- �ж�һ���Ƿ�������ͬ������ͬ������ʾ
		if Type ~= -1 then
			if Type ~= MaterialCompound_GetItemType( bagPos ) then
				PushDebugMessage( CurrentRule.msgDiffTypeErr )
				return
			end
		end

		-- �ж�һ���Ƿ񵵴���ͬ���������ͬ������ʾ
		if Grade ~= -1 then
			if Grade ~= MaterialCompound_GetItemGrade( bagPos ) then
				PushDebugMessage( CurrentRule.msgDiffGradeErr )
				return
			end
		elseif MaterialCompound_GetItemGrade( bagPos ) >= RuleTable[Current].maxGrade then
			PushDebugMessage( CurrentRule.msgGradeLimited )
			return
		end

		if slot == 0 then						-- �Զ�Ѱ�ҿո�
			-- �� 1 ~ MATERIAL_COUNT ֮����һ�����ŵĸ��ӣ����û�пո����ˣ��򷵻�
			for i = 1, MATERIAL_COUNT do
				if ITEM_IN_SLOTS[i] == -1 then
					slot = i
					break
				end
			end

			-- AxTrace( 0, 1, "slot=".. slot )

			if slot == 0 then
				return
			end
		else
			-- �ж� bagPos �Ƿ�Ӧ�ô���������ӣ����Ӳ�����ֱ�ӷ���
			if slot < 1 or slot > MATERIAL_COUNT then
				return
			end
		end
	-- ������������
	elseif PlayerPackage : GetItemTableIndex( bagPos ) == MaterialCompound_GetSpecialMaterial() then
		-- AxTrace( 0, 1, "it's a special material." )
		if slot == 0 then						-- �Զ�Ѱ�ҿո�
			-- ������ SPECIAL_MATERIAL_SLOT �������Ƿ���ŵĸ��ӣ�������ǣ��򷵻�
			if ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] and ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] == -1 then
				slot = SPECIAL_MATERIAL_SLOT
			else
				return
			end
		else
			-- �ж� bagPos �Ƿ�Ӧ�ô���������ӣ����Ӳ�����ֱ�ӷ���
			if slot ~= SPECIAL_MATERIAL_SLOT then
				PushDebugMessage( "M�i �t v�o b�ng v�t li�u �c th�." )
				return
			end
		end
	end

	-- AxTrace( 0, 1, "ITEM_IN_SLOTS[slot]=".. ITEM_IN_SLOTS[slot] )
	-- ����Ʒ�ŵ�������
	-- ���ԭ���ĸ�������Ʒ�����Ƴ�ԭ������Ʒ
	if ITEM_IN_SLOTS[slot] ~= -1 then
		MaterialCompound_Remove( slot )
	end

	-- ������Ʒ�ŵ���Ʒ�񣬲��������ڵı�����
	STUFF_SLOTS[slot] : SetActionItem( bagItem : GetID() )
	ITEM_IN_SLOTS[slot] = bagPos
	LifeAbility : Lock_Packet_Item( bagPos, 1 )

	if Type == -1 then
		Type = MaterialCompound_GetItemType( bagPos )
	end

	if Grade == -1 then
		Grade = MaterialCompound_GetItemGrade( bagPos )
	end

	-- ���½���ĳɹ�����ʾ
	MaterialCompound_RecalcSuccOdds()

	-- �����Ʒ����������ϣ����ҵ�ǰ�����ͺ͵��ζ��� -1������ݸ���Ʒ������Ӧ���ã����ݴ���ʾ��Ǯ����
	if PlayerPackage : GetItemTableIndex( bagPos ) ~= MaterialCompound_GetSpecialMaterial() then
		MaterialCompound_RecalcCost()
	end
end

-- �Ƴ�һ������
function MaterialCompound_Remove( slot )
	if not this : IsVisible() then
		return
	end

	if slot < 1 or slot > SLOT_COUNT then
		return
	end

	if ITEM_IN_SLOTS[slot] == -1 then
		return
	end

	STUFF_SLOTS[slot] : SetActionItem( -1 )
	LifeAbility : Lock_Packet_Item( ITEM_IN_SLOTS[slot], 0 )
	ITEM_IN_SLOTS[slot] = -1

	if slot >= 1 and slot <= MATERIAL_COUNT then
		local materialCount = 0

		for i = 1, MATERIAL_COUNT do
			if ITEM_IN_SLOTS[i] ~= -1 then
				materialCount = materialCount + 1
			end
		end

		if materialCount == 0 then					-- û�в��������Ƴ��������
			Type = -1
			Grade = -1
			MaterialCompound_Remove( SPECIAL_MATERIAL_SLOT )
		end

		MaterialCompound_RecalcSuccOdds()
		MaterialCompound_RecalcCost()
	elseif slot == SPECIAL_MATERIAL_SLOT then
		MaterialCompound_RecalcSuccOdds()
	end
end

-- ���¼���ɹ���
function MaterialCompound_RecalcSuccOdds()
	if not RuleTable[Current] or not RuleTable[Current][Grade] then
		Materalcompose_SuccessValue : SetText("#cFF0000T� l� th�nh c�ng")
		Materalcompose_OK : Disable()
		return
	end

	local currentRule = RuleTable[Current][Grade]
	local materialCount = 0

	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] ~= -1 then
			materialCount = materialCount + 1
		end
	end

	-- AxTrace( 0, 1, "materialCount=".. materialCount )
	local str = "#cFF0000T� l� th�nh c�ng: "

	if not currentRule.CountTable[materialCount] then
		curSuccRate = 0;
		str = str .. "Kh�ng c� c�ch n�o h�p th�nh"
		Materalcompose_OK : Disable()
	elseif ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] ~= -1
	 and currentRule.SpecialStuff == PlayerPackage : GetItemTableIndex( ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] )
	then
		-- AxTrace( 0, 1, "SuccOddsWithSpecStuff=".. currentRule.CountTable[materialCount].SuccOddsWithSpecStuff )
		str = str .. currentRule.CountTable[materialCount].SuccOddsWithSpecStuff .. "%"
		curSuccRate = currentRule.CountTable[materialCount].SuccOddsWithSpecStuff;
		Materalcompose_OK : Enable()
	else
		-- AxTrace( 0, 1, "SuccOdds=".. currentRule.CountTable[materialCount].SuccOdds )
		str = str .. currentRule.CountTable[materialCount].SuccOdds .. "%"
		curSuccRate = currentRule.CountTable[materialCount].SuccOdds;
		Materalcompose_OK : Enable()
	end

	Materalcompose_SuccessValue : SetText( str )
end

-- ���¼����Ǯ����
function MaterialCompound_RecalcCost()
	if not RuleTable[Current] or not RuleTable[Current][Grade] then
		Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( RuleTable[Current][Grade].MoneyCost ) )
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function MaterialCompound_BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		PushDebugMessage("Ch�a ph�t hi�n NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "MaterialCompound" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function MaterialCompound_StopCareObject()
	this : CareObject( theNPC, 0, "MaterialCompound" )
	theNPC = -1
end

function MaterialCompound_IsBind( ItemID )

	if(GetItemBindStatus(ItemID, 0) == 1) then

		return 1;

	else

		return 0;

	end

end

function Materalcompose_Help_Clicked()
	Helper:GotoHelper("*MaterialCompound")
end

function MaterialCompound_Frame_On_ResetPos()
  Materalcompose_Frame:SetProperty("UnifiedPosition", g_MaterialCompound_Frame_UnifiedPosition);
end
