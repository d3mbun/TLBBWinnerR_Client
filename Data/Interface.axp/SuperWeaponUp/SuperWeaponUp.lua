
local ObjCaredIDID = -1
local g_ItemPos = -1
local g_NewId = -1
local g_NeedMoney = -1
local MAX_OBJ_DISTANCE = 3.0
local g_Accept_Clicked_Num = 0
local Equip_Level = -1
local g_NeedItem = -1
--=========================================================
--³£Á¿¶¨Òå
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
--ÊÂ¼þÏìÓ¦
--=========================================================
function SuperWeaponUp_OnEvent( event )

	if event == "UI_COMMAND" and tonumber(arg0) == 19831114 then
		local targetId = Get_XParam_INT(0)
		TypeUI = Get_XParam_INT(1)
		ObjCaredID = DataPool : GetNPCIDByServerID( targetId )
		if ObjCaredID == -1 then
			--PushDebugMessage("server´«¹ýÀ´µÄÊý¾ÝÓÐÎÊÌâ¡£")
			return
		end
		
		if TypeUI == 1 then
			SuperWeaponUp_Title:SetText("#{SQSJ_XML_01}")
			SuperWeaponUp_Info:SetText("#cfff263Th¥n Khí Luy®n H°n 5 #GTh¥n Binh Phù #cfff263ðÆng c¤p tß½ng Ñng và mµt ít ti«n, th¥n khí sau khi ðßþc luy®n h°n s¨ mÕnh h½n r¤t nhi«u. #cff0000Chú ý: ÐÆng c¤p sØ døng cüa Th¥n Khí Luy®n H°n c¤p 82, 92 s¨ biªn thành 86, 96")
			SuperWeaponUp_Info2:SetText("#{SQSJ_XML_03}")
		elseif TypeUI == 2 then
			SuperWeaponUp_Title:SetText("#gFF0FA0Tôi Luy®n Th¥n Khí")
			SuperWeaponUp_Info:SetText("#cfff263Tôi Luy®n Th¥n Khí c¥n 10 viên #GNæ Oa ThÕch #cfff263và mµt ít ti«n, th¥n khí sau khi ðßþc tôi luy®n s¨ mÕnh h½n r¤t nhi«u. #cff0000Chú ý: Tôi luy®n Th¥n Khí chï có th¬ áp døng cho th¥n khí ðã Luy®n H°n.")
			SuperWeaponUp_Info2:SetText("Hãy ðßa vào Th¥n khí c¥n tôi luy®n:")
		elseif TypeUI == 3 then
			SuperWeaponUp_Title:SetText("#gFF0FA0Ðúc Thßþng C± Th¥n Khí")
			SuperWeaponUp_Info:SetText("#cfff263Ðúc Thßþng C± Th¥n Khí c¥n 20 viên #GNæ Oa Th¥n ThÕch #cfff263và mµt ít ti«n, th¥n khí sau khi ðßþc ðúc xong s¨ mÕnh h½n r¤t nhi«u. #cff0000Chú ý: Ðúc Thßþng C± Th¥n Khí chï có th¬ áp døng cho th¥n khí ðã Tôi Luy®n.")
			SuperWeaponUp_Info2:SetText("Hãy ðßa vào Th¥n khí c¥n ðúc thành #GThßþng C± Th¥n Khí")
		elseif TypeUI == 4 then
			SuperWeaponUp_Title:SetText("#gFF0FA0T¦y Thuµc Tính Th¥n Khí")
			SuperWeaponUp_Info:SetText("#cfff263T¦y thuµc tính s¨ làm m¾i thuµc tính ðang có. Yêu c¥u mµt lßþng l¾n Huy«n Binh ThÕch.#r#cff0000Th¥n Khí Luy®n H°n: #cfff2635 cái #GHuy«n Binh ThÕch#r#cff0000Th¥n Khí Tôi Luy®n: #cfff26310 cái #GHuy«n Binh ThÕch#r#cff0000Th¥n Khí Thßþng C±: #cfff26320 cái #GHuy«n Binh ThÕch")
			SuperWeaponUp_Info2:SetText("Hãy ðßa vào Th¥n khí c¥n T¦y Thuµc Tính")
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
--È·¶¨°´Å¥
--=========================================================
function SuperWeaponUp_Buttons_Clicked()
	if g_ItemPos ~= -1 and PlayerPackage : GetItemTableIndex( g_ItemPos ) > 0 then

		if PlayerPackage : IsLock( g_ItemPos ) == 1 then
			PushDebugMessage( "V§t ph¦m không t°n tÕi ho£c ðã khóa!" )
			return
		end

		--Ç®ÊÇ·ñ¹»....
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --½»×ÓÆÕ¼° Vega
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
		PushDebugMessage( "Hãy ð£t th¥n khí c¥n tái tÕo!" )
	end
end




--=========================================================
--¸üÐÂ½çÃæ
--=========================================================
function SuperWeaponUp_Update( pos_packet )
	local BagIndex = tonumber( pos_packet )
	local theAction = EnumAction( BagIndex, "packageitem" )

	if theAction : GetID() == 0 then
		return
	end

	--±ØÐëÊÇ¿É¶Ò»»µÄÉñÆ÷....
	--local MenpaiID = Player : GetData( "MEMPAI" )
	local ItemID = PlayerPackage : GetItemTableIndex( BagIndex )
	local LastINT = ItemID - 10300000;
	if (LastINT < 4 or LastINT > 100000) then
		PushDebugMessage("V§t ph¦m này không phäi là th¥n khí có th¬ ð±i!")
		return
	end

	--g_NewId, g_NeedMoney = ShenqiUpgrade : GetShenqiUpgradeInfo( ItemID, MenpaiID )
	Equip_Level = LifeAbility : Get_Equip_Level(BagIndex);
	if (Equip_Level < 82) then
		PushDebugMessage("Hãy ð£t th¥n khí có th¬ ð±i!")
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
	-- 	PushDebugMessage("Hãy ð£t th¥n khí có th¬ ð±i!")
	-- 	return
	-- end

	--¸ü»»ActionButton....
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
--ÖØÖÃ½çÃæ
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
--¹Ø±Õ
--=========================================================
function SuperWeaponUp_Close()
	this : Hide()
	StopCareObject_SuperWeaponUp()
	SuperWeaponUp_Clear()
end

--=========================================================
--½çÃæÒþ²Ø
--=========================================================
function SuperWeaponUp_OnHiden()
	StopCareObject_SuperWeaponUp()
	SuperWeaponUp_Clear()
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨Õâ¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_SuperWeaponUp()
	this : CareObject( ObjCaredID, 1, "SuperWeaponUp" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_SuperWeaponUp()
	this : CareObject( ObjCaredID, 0, "SuperWeaponUp" )
end

--=========================================================
--ÓÒ¼üµã»÷ActionButton
--=========================================================
function SuperWeaponUp_Resume_Equip_Gem()

	if( this:IsVisible() ) then

		SuperWeaponUp_Clear()

	end
end
