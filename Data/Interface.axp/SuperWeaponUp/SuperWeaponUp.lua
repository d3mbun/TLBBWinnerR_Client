
local ObjCaredIDID = -1
local g_ItemPos = -1
local g_NewId = -1
local g_NeedMoney = -1
local MAX_OBJ_DISTANCE = 3.0
local g_Accept_Clicked_Num = 0
local Equip_Level = -1
local g_NeedItem = -1
--=========================================================
--��������
--=========================================================
local MIN_MENPAI_IDX = 0
local MAX_MENPAI_IDX = 8
local TypeUI = 0;

function SuperWeaponUp_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "OBJECT_CARED_EVENT" )
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "UPDATE_SHENQIUP" )
	this : RegisterEvent( "RESUME_ENCHASE_GEM" )
	this : RegisterEvent( "NEW_DEBUGMESSAGE" )
end

function SuperWeaponUp_OnLoad()

end


--=========================================================
--�¼���Ӧ
--=========================================================
function SuperWeaponUp_OnEvent( event )

	if event == "UI_COMMAND" and tonumber(arg0) == 19831114 then
		local targetId = Get_XParam_INT(0)
		TypeUI = Get_XParam_INT(1)
		ObjCaredID = DataPool : GetNPCIDByServerID( targetId )
		if ObjCaredID == -1 then
			--PushDebugMessage("server�����������������⡣")
			return
		end
		
		if TypeUI == 1 then
			SuperWeaponUp_Title:SetText("#{SQSJ_XML_01}")
			SuperWeaponUp_Info:SetText("#cfff263Th�n Kh� Luy�n H�n 5 #GTh�n Binh Ph� #cfff263��ng c�p t߽ng �ng v� m�t �t ti�n, th�n kh� sau khi ���c luy�n h�n s� m�nh h�n r�t nhi�u. #cff0000Ch� �: ��ng c�p s� d�ng c�a Th�n Kh� Luy�n H�n c�p 82, 92 s� bi�n th�nh 86, 96")
			SuperWeaponUp_Info2:SetText("#{SQSJ_XML_03}")
		elseif TypeUI == 2 then
			SuperWeaponUp_Title:SetText("#gFF0FA0T�i Luy�n Th�n Kh�")
			SuperWeaponUp_Info:SetText("#cfff263T�i Luy�n Th�n Kh� c�n 10 vi�n #GN� Oa Th�ch #cfff263v� m�t �t ti�n, th�n kh� sau khi ���c t�i luy�n s� m�nh h�n r�t nhi�u. #cff0000Ch� �: T�i luy�n Th�n Kh� ch� c� th� �p d�ng cho th�n kh� �� Luy�n H�n.")
			SuperWeaponUp_Info2:SetText("H�y ��a v�o Th�n kh� c�n t�i luy�n:")
		elseif TypeUI == 3 then
			SuperWeaponUp_Title:SetText("#gFF0FA0��c Th��ng C� Th�n Kh�")
			SuperWeaponUp_Info:SetText("#cfff263��c Th��ng C� Th�n Kh� c�n 20 vi�n #GN� Oa Th�n Th�ch #cfff263v� m�t �t ti�n, th�n kh� sau khi ���c ��c xong s� m�nh h�n r�t nhi�u. #cff0000Ch� �: ��c Th��ng C� Th�n Kh� ch� c� th� �p d�ng cho th�n kh� �� T�i Luy�n.")
			SuperWeaponUp_Info2:SetText("H�y ��a v�o Th�n kh� c�n ��c th�nh #GTh��ng C� Th�n Kh�")
		elseif TypeUI == 4 then
			SuperWeaponUp_Title:SetText("#gFF0FA0T�y Thu�c T�nh Th�n Kh�")
			SuperWeaponUp_Info:SetText("#cfff263T�y thu�c t�nh s� l�m m�i thu�c t�nh �ang c�. Y�u c�u m�t l��ng l�n Huy�n Binh Th�ch.#r#cff0000Th�n Kh� Luy�n H�n: #cfff2635 c�i #GHuy�n Binh Th�ch#r#cff0000Th�n Kh� T�i Luy�n: #cfff26310 c�i #GHuy�n Binh Th�ch#r#cff0000Th�n Kh� Th��ng C�: #cfff26320 c�i #GHuy�n Binh Th�ch")
			SuperWeaponUp_Info2:SetText("H�y ��a v�o Th�n kh� c�n T�y Thu�c T�nh")
		end
		
		ObjCaredIDID = targetId
		BeginCareObject_SuperWeaponUp()
		SuperWeaponUp_Clear()
		this : Show()

	elseif event == "UNIT_MONEY" then
		SuperWeaponUp_SelfMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )

	elseif event == "MONEYJZ_CHANGE" then
		SuperWeaponUp_DemandJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )

	elseif event == "OBJECT_CARED_EVENT" then
		if( tonumber(arg0) ~= ObjCaredID ) then
			return
		end
		if( arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1=="destroy" ) then
			SuperWeaponUp_Close()
		end

	elseif event == "RESUME_ENCHASE_GEM" then
		SuperWeaponUp_Resume_Equip_Gem()

	elseif event == "PACKAGE_ITEM_CHANGED" then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if tonumber(arg0) == g_ItemPos then
			SuperWeaponUp_Resume_Equip_Gem()
		end

	--elseif event == "UPDATE_SHENQIUP" then
	end
	if IsWindowShow("SuperWeaponUp") then
		if ((event == "UI_COMMAND") and (tonumber(arg0) == 10102017)) then
			if arg1 ~= nil then
				SuperWeaponUp_Update( arg1 )
			end
		end
	end
end

--=========================================================
--ȷ����ť
--=========================================================
function SuperWeaponUp_Buttons_Clicked()
	if g_ItemPos ~= -1 and PlayerPackage : GetItemTableIndex( g_ItemPos ) > 0 then

		if PlayerPackage : IsLock( g_ItemPos ) == 1 then
			PushDebugMessage( "V�t ph�m kh�ng t�n t�i ho�c �� kh�a!" )
			return
		end

		--Ǯ�Ƿ�....
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --�����ռ� Vega
		if selfMoney < g_NeedMoney then
			PushDebugMessage( "#{JKBS_081021_011}" )
			return
		end

		-- if (g_ItemPos ~= -1) then
			-- local ItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
			--local MatID,MatNum = g_NeedItem,5;--ShenqiUpgrade : GetShenqiUpMaterial( ItemID, 0 )
			-- local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(g_NeedItem))--Player : IsHaveItem( MatID, MatNum)
			--PushDebugMessage( n.."::"..nHaveNum.."::"..MatID )
			-- if (index == -1) then
				-- PushDebugMessage( "#{SQSJ_0708_04}" )
				-- return
			-- end
		-- end

		if (g_Accept_Clicked_Num == 0) then
			ShowSystemInfo("SQSJ_0708_09")
			g_Accept_Clicked_Num = 1
		else
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "XSCRIPT" )
				Set_XSCRIPT_ScriptID( 045001 )
				Set_XSCRIPT_Parameter( 0, 1 )
				Set_XSCRIPT_Parameter( 1, g_ItemPos )
				Set_XSCRIPT_Parameter( 2, TypeUI )
				Set_XSCRIPT_ParamCount( 3 )
			Send_XSCRIPT()
			SuperWeaponUp_Clear()
		end

	else
		PushDebugMessage( "H�y �t th�n kh� c�n t�i t�o!" )
	end
end




--=========================================================
--���½���
--=========================================================
function SuperWeaponUp_Update( pos_packet )
	local BagIndex = tonumber( pos_packet )
	local theAction = EnumAction( BagIndex, "packageitem" )

	if theAction : GetID() == 0 then
		return
	end

	--�����ǿɶһ�������....
	--local MenpaiID = Player : GetData( "MEMPAI" )
	local ItemID = PlayerPackage : GetItemTableIndex( BagIndex )
	local LastINT = ItemID - 10300000;
	if (LastINT < 4 or LastINT > 100000) then
		PushDebugMessage("V�t ph�m n�y kh�ng ph�i l� th�n kh� c� th� �i!")
		return
	end

	--g_NewId, g_NeedMoney = ShenqiUpgrade : GetShenqiUpgradeInfo( ItemID, MenpaiID )
	Equip_Level = LifeAbility : Get_Equip_Level(BagIndex);
	if (Equip_Level < 82) then
		PushDebugMessage("H�y �t th�n kh� c� th� �i!")
		return
	end

	if (Equip_Level >= 82 and Equip_Level < 92) then
		g_NeedItem = 30505816;
	elseif (Equip_Level >= 92 and Equip_Level < 102) then
		g_NeedItem = 30505817;
	elseif (Equip_Level >= 102) then
		g_NeedItem = 30505908;
	end

	g_NeedMoney = 50000
	-- g_NewId = 1;
	-- if g_NewId == -1 then
	-- 	PushDebugMessage("H�y �t th�n kh� c� th� �i!")
	-- 	return
	-- end

	--����ActionButton....
	if g_ItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
	end
	LifeAbility : Lock_Packet_Item( BagIndex, 1 )
	SuperWeaponUp_Object : SetActionItem( theAction : GetID() )
	g_ItemPos = BagIndex
	SuperWeaponUp_DemandMoney : SetProperty( "MoneyNumber", tostring( g_NeedMoney ) )
	g_Accept_Clicked_Num = 0
end



--=========================================================
--���ý���
--=========================================================
function SuperWeaponUp_Clear()
	if g_ItemPos ~= -1 then
		SuperWeaponUp_Object : SetActionItem( -1 )
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
		g_ItemPos = -1
		g_NewId = -1
		g_NeedMoney = -1
		SuperWeaponUp_DemandMoney : SetProperty( "MoneyNumber", 0 )
		g_Accept_Clicked_Num = 0
	end
end


--=========================================================
--�ر�
--=========================================================
function SuperWeaponUp_Close()
	this : Hide()
	StopCareObject_SuperWeaponUp()
	SuperWeaponUp_Clear()
end

--=========================================================
--��������
--=========================================================
function SuperWeaponUp_OnHiden()
	StopCareObject_SuperWeaponUp()
	SuperWeaponUp_Clear()
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_SuperWeaponUp()
	this : CareObject( ObjCaredID, 1, "SuperWeaponUp" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_SuperWeaponUp()
	this : CareObject( ObjCaredID, 0, "SuperWeaponUp" )
end

--=========================================================
--�Ҽ����ActionButton
--=========================================================
function SuperWeaponUp_Resume_Equip_Gem()

	if( this:IsVisible() ) then

		SuperWeaponUp_Clear()

	end
end
