local Prescr_Ability = -1;
local cur_count = 1;
local Current_Select = -1;
local Material_Icon = {};
local Material_Name = {};
local Material_Frame = {};
local Material_Num  = {};
local Material_Mask  = {};
local SynthesizePucker = {};
local Max_SkillExp = {};
local Synthesize_Special_Item = -1
local Ability_Limit = {}
local TheLastItem = -1;
local ShowBindWin	=	-1

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_Synthesize_Frame_UnifiedXPosition;
local g_Synthesize_Frame_UnifiedYPosition;

function Synthesize_PreLoad()
	this:RegisterEvent("OPEN_COMPOSE_ITEM");
	this:RegisterEvent("OPEN_COMPOSE_GEM");
	this:RegisterEvent("UPDATE_COMPOSE_ITEM");
	this:RegisterEvent("TOGLE_SKILL_BOOK");
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("CLOSE_SKILL_BOOK");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_VIGOR");
	this:RegisterEvent("UNIT_ABILITYEXP");
	this:RegisterEvent("UPDATE_SYNTHESIZE_ITEM");
	this:RegisterEvent("CHANGE_MAKE_COUNT");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Synthesize_OnLoad()

	Material_Icon[1] = Synthesize_MaterialIcon1;
	Material_Icon[2] = Synthesize_MaterialIcon2;
	Material_Icon[3] = Synthesize_MaterialIcon3;
	Material_Icon[4] = Synthesize_MaterialIcon4;
	Material_Icon[5] = Synthesize_MaterialIcon5;

	Material_Name[1] = Synthesize_Material1_Name_Text;
	Material_Name[2] = Synthesize_Material2_Name_Text;
	Material_Name[3] = Synthesize_Material3_Name_Text;
	Material_Name[4] = Synthesize_Material4_Name_Text;
	Material_Name[5] = Synthesize_Material5_Name_Text;

	Material_Frame[1] = Synthesize_MaterialIcon1_Frame;
	Material_Frame[2] = Synthesize_MaterialIcon2_Frame;
	Material_Frame[3] = Synthesize_MaterialIcon3_Frame;
	Material_Frame[4] = Synthesize_MaterialIcon4_Frame;
	Material_Frame[5] = Synthesize_MaterialIcon5_Frame;

	Material_Num[1] =	Synthesize_MaterialIcon1_Amount;
	Material_Num[2] =	Synthesize_MaterialIcon2_Amount;
	Material_Num[3] =	Synthesize_MaterialIcon3_Amount;
	Material_Num[4] =	Synthesize_MaterialIcon4_Amount;
	Material_Num[5] =	Synthesize_MaterialIcon5_Amount;

	Material_Mask[1] =	Synthesize_MaterialIcon1_Mask;
	Material_Mask[2] =	Synthesize_MaterialIcon2_Mask;
	Material_Mask[3] =	Synthesize_MaterialIcon3_Mask;
	Material_Mask[4] =	Synthesize_MaterialIcon4_Mask;


	Max_SkillExp[1] = 10
	Max_SkillExp[2] = 30
	Max_SkillExp[3] = 60
	Max_SkillExp[4] = 100
	Max_SkillExp[5] = 150
	Max_SkillExp[6] = 210
	Max_SkillExp[7] = 280
	Max_SkillExp[8] = 360
	Max_SkillExp[9] = 450
	Max_SkillExp[10] = 5500
	Max_SkillExp[11] = 5500
	Max_SkillExp[12] = 5500

	for i=1,200 do
		SynthesizePucker[i] = 1;
	end;
	Ability_Limit[0] = " Ðúc khuôn "
	Ability_Limit[1] = " May m£c "
	Ability_Limit[2] = " Công ngh® "

	ShowBindWin = 1

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Synthesize_Frame_UnifiedXPosition	= Synthesize_Frame : GetProperty("UnifiedXPosition");
	g_Synthesize_Frame_UnifiedYPosition	= Synthesize_Frame : GetProperty("UnifiedYPosition");

end

function Synthesize_OnEvent(event)
	
	--PushDebugMessage(event)
	
	if ( event == "OPEN_COMPOSE_ITEM" ) then
		if(Prescr_Ability ~= tonumber(arg0)) then
			Current_Select = -1;
		end
		Prescr_Ability = tonumber(arg0);
		ShowBindWin = 1
		
		if Prescr_Ability == 46 then
			PushEvent("UI_COMMAND",1017011)
			return
		elseif Prescr_Ability == 47 then
			PushEvent("UI_COMMAND",1017012)
			return
		elseif Prescr_Ability == 48 then
			PushEvent("UI_COMMAND",1017013)
			return
		end
		
		local popup = Player:GetAbilityInfo(Prescr_Ability,"popup");
		if(popup ~= 1) then
			this:Hide();
			return;
		end;
		cur_count=1;
		this:TogleShow();
		return;
	elseif (event == "UPDATE_COMPOSE_ITEM" and this:IsVisible()) then
		if(Prescr_Ability ~= tonumber(arg0)) then
			Current_Select = -1;
		end
		Prescr_Ability = tonumber(arg0);
		local popup = Player:GetAbilityInfo(Prescr_Ability,"popup");
		if(popup ~= 1) then
			this:Hide();
			return;
		end;
		Synthesize_Update();
		return;
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		Synthesize_UpdateItem();
		return;
	elseif ( event == "UPDATE_SYNTHESIZE_ITEM" and this:IsVisible() ) then
		if tonumber(arg0)==nil then
			return
		end
		if(Synthesize_SpecialMaterialIcon_Frame:IsVisible())then
			Update_Synthesize_Item(tonumber(arg0));
		end
			return
	elseif ( event == "OPEN_COMPOSE_GEM" ) then
		this:Hide();
		return;

	elseif ( event == "CLOSE_SYNTHESIZE_ENCHASE" ) then
		this:Hide();
		return;
	elseif ( event == "UNIT_VIGOR" and tostring(arg0) == "player" and this:IsVisible()) then
		strName = Player : GetData("VIGOR");
		Synthesize_CurrentlyEnergy1 : SetText("HoÕt lñc hi®n tÕi: "..strName)
		return;
	elseif ( event == "UNIT_ENERGY" and tostring(arg0) == "player" and this:IsVisible()) then
		strName = Player : GetData("ENERGY");
		Synthesize_CurrentlyEnergy2 : SetText("Tinh lñc: "..strName)
		return;
	elseif ( event == "UNIT_ABILITYEXP" and this:IsVisible()) then
		strName = Player : GetAbilityInfo(Prescr_Ability,"skillexp");
		local level= Player:GetAbilityInfo(Prescr_Ability,"level");
		local max_exp
		if level > 12 or level < 1 then
			max_exp = "~"
		else
			max_exp = LifeAbility : GetLifeAbility_LimitExp(Prescr_Ability,level);
		end

		strName = Player : GetAbilityInfo(Prescr_Ability,"skillexp");
		Synthesize_SkilledGrade:SetText("Thành thÕo: "..strName.."/"..max_exp);
		return;
	elseif ( event == "CHANGE_MAKE_COUNT" ) then
		Synthesize_MadeAmount : SetText( tonumber(arg0) );
		cur_count = tonumber(arg0)
		return;

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		Synthesize_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		Synthesize_Frame_On_ResetPos()
	end

end

function Synthesize_OnShown()
	Synthesize_Update();
end

function Synthesize_UpdateItem()

	local nItemCount = Synthesize_Item_List:GetItemNumber();
	local nPrescrNum = DataPool:GetPrescrList_Num();

	local i;

	for i=1, nItemCount do
		local szItemText, nItemID = Synthesize_Item_List:GetItem(i);

		if nItemID >= 10000 then
			continue;
		end

		local szPrescrName = DataPool:GetPrescrList_Item(nItemID);
		local nLevel =  DataPool:GetPrescrList_Item_LifeAbilityLevel(nItemID);
		local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nItemID);

		if(nMaxAmount > 0) then
			if(nLevel >0) then
				szPrescrName = szPrescrName .. " (ÐÆng c¤p "..nLevel..") [" .. nMaxAmount .. "]";
			else
				szPrescrName = szPrescrName .. "    [" .. nMaxAmount .. "]";
			end
		elseif(nMaxAmount < 0) then
			if(nLevel >0) then
				szPrescrName = szPrescrName .. " (ÐÆng c¤p "..nLevel..") [N/A]";
			else
				szPrescrName = szPrescrName .. "    [N/A]";
			end
		else
			if(nLevel >0) then
				szPrescrName = szPrescrName .. " (ÐÆng c¤p "..nLevel..")";
			else
				szPrescrName = szPrescrName ;
			end
		end;

		Synthesize_Item_List:SetListItemText(i-1, " "..szPrescrName);
		if(Current_Select == -1 ) then
			Current_Select = i-1
		end

	end
	Synthesize_ListBox_Selected();
end

function Synthesize_Update()

	local strName;

	strName = Player : GetAbilityInfo(Prescr_Ability,"name");
	Synthesize_PageHeader_Name:SetText("#gFF0FA0"..strName);

	strName = Player : GetAbilityInfo(Prescr_Ability,"level");
	local level = tonumber(strName);
	Synthesize_Level:SetText("C¤p: "..strName);

	local max_exp;
	if level > 11 or level < 1 then
		max_exp = "~"
	else
		max_exp = LifeAbility : GetLifeAbility_LimitExp(Prescr_Ability,level);
	end

	strName = Player : GetAbilityInfo(Prescr_Ability,"skillexp");
	Synthesize_SkilledGrade:SetText("Thành thÕo: "..strName.."/"..max_exp);

	strName = Player : GetData("VIGOR");
	Synthesize_CurrentlyEnergy1 : SetText("HoÕt lñc hi®n tÕi: "..strName)

	strName = Player : GetData("ENERGY");
	Synthesize_CurrentlyEnergy2 : SetText("Tinh lñc: "..strName)

	Synthesize_MadeAmount : SetText( tonumber(cur_count));

	local nPrescrNum = DataPool:GetPrescrList_Num();
	local i,k;

	Synthesize_Item_List:ClearListBox();
	for i=1, 4 do
		Material_Num[i]	 : SetText("");
		Material_Num[i]  : Hide();
		Material_Icon[i] : Hide();
		Material_Name[i] : SetText("");
	end
	Synthesize_Item_Frame : Hide();
	Synthesize_Amount : SetText("");
	Synthesize_Item_Name_Text : SetText("");

	for j=1, 200 do
		local bHave = 0;
		for	i=1, nPrescrNum do
			local nPrescr	= LifeAbility : GetPrescrList_Item_FromNum(i-1);
			local Prescr,Group = DataPool:GetPrescrList_Item_LifeAbility(nPrescr);
			if Prescr == Prescr_Ability and Group == j then

				if ( SynthesizePucker[j] > 0 ) then
					if(bHave == 0) then
						local str= "- #gFE7E82" .. LifeAbility :GetPrescription_Kind(j);
						Synthesize_Item_List:AddItem(str,10000+j);
						bHave = 1;
					end

					local szPrescrName = DataPool:GetPrescrList_Item(nPrescr);
					local nLevel =  DataPool:GetPrescrList_Item_LifeAbilityLevel(nPrescr);
					local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nPrescr);

					if(nMaxAmount > 0) then
						if(nLevel >0) then
							szPrescrName = szPrescrName .. " (ÐÆng c¤p "..nLevel..") [" .. nMaxAmount .. "]";
						else
							szPrescrName = szPrescrName .. "    [" .. nMaxAmount .. "]";
						end
					elseif(nMaxAmount < 0) then
						if(nLevel >0) then
							szPrescrName = szPrescrName .. " (ÐÆng c¤p "..nLevel..") [N/A]";
						else
							szPrescrName = szPrescrName .. "    [N/A]";
						end
					else
						if(nLevel >0) then
							szPrescrName = szPrescrName .. " (ÐÆng c¤p "..nLevel..")";
						else
							szPrescrName = szPrescrName ;--¡Þ
						end
					end;

					Synthesize_Item_List:AddItem(" "..szPrescrName, nPrescr);
					if(Current_Select == -1 ) then
						Current_Select = nPrescr
					end
					if(Current_Select == nPrescr) then
						Synthesize_Item_List : SetItemSelectByItemID(Current_Select);
					end

				else
					if(bHave == 0) then
						local str= "+ #gFE7E82" .. LifeAbility :GetPrescription_Kind(j);
						Synthesize_Item_List:AddItem(str,10000+j);
						bHave = 1;
					end
			end
		end
	end
	end

	Synthesize_AllMake:Show();
	Synthesize_SpecialMaterial_Text : Show();
	Synthesize_SpecialMaterialIcon_Frame : Show()

	Synthesize_AllMake : Disable();
	Synthesize_Make : Disable();

	Synthesize_Explain:SetText("");
	Synthesize_Explain:Show();

	Synthesize_Resume()
	Synthesize_ListBox_Selected();
end

function Synthesize_Add_Clicked()
	if(cur_count < 20) then
		cur_count = cur_count + 1;
		Synthesize_MadeAmount : SetText( tonumber(cur_count));
	end
end

function Synthesize_Minus_Clicked()
	if(cur_count > 1) then
		cur_count = cur_count - 1;
		Synthesize_MadeAmount : SetText( tonumber(cur_count));
	end
end

-- add by cuiyinjie 2008-10-25 ÔÚÎ´Ñ¡ÖÐÅä·½Ê±Çå³ýÅä·½ËùÐè²ÄÁÏ
function Synthesize_HideCtrlOnNoSelect()
	local i = 1;
	for i=1, 4 do
		Material_Num[i]	 : SetText("");
		Material_Num[i]  : Hide();
		Material_Icon[i] : Hide();
		Material_Name[i] : SetText("");
	end

	Synthesize_Item : SetProperty("ShortImage","");   --ÉèÖÃÎªÎÞÍ¼±ê
	Synthesize_Item_Name_Text : SetText("");
	Synthesize_Amount : SetText("");
end

function Synthesize_ListBox_Selected()
	local nSelIndex = Synthesize_Item_List:GetFirstSelectItem();
	local nPrescrNum = DataPool:GetPrescrList_Num();

	if nSelIndex > 10000 then
		if SynthesizePucker[nSelIndex-10000] == 1 then
			SynthesizePucker[nSelIndex-10000] = 0;
		else
			SynthesizePucker[nSelIndex-10000] = 1;
		end
		Synthesize_Update();
		return
	end

	if nSelIndex == -1 then
		if Current_Select == -1 then
			--Begin Modify By Ma Liang TT 69445
			Synthesize_MadeAmount_Bk : Show()
			Synthesize_Decrease : Show()
			Synthesize_More : Show()
			--End
			return;
		else
			nSelIndex = Current_Select;
		end
	elseif nSelIndex ~= Current_Select then
		cur_count = 1
		Synthesize_MadeAmount : SetText( tonumber(cur_count));
	end

	Current_Select = nSelIndex;

	for i=1, 4 do
		Material_Num[i]	 : SetText("");
		Material_Num[i]  : Hide();
		Material_Icon[i] : Hide();
		Material_Name[i] : SetText("");
	end

	Synthesize_Item_Frame : Hide();
	Synthesize_Item : Hide();
	Synthesize_Item_Name_Text : SetText("");
	Synthesize_Amount : SetText("");

	if( nSelIndex < 0 ) then
		return;
	end

	local resultid,resultnum = DataPool : GetPrescrList_Item_Result(nSelIndex);

	if(resultid == -1) then
		Synthesize_Explain:SetText(LifeAbility:GetPrescr_Explain(nSelIndex));
		Synthesize_Explain:Show();
		Synthesize_AllMake : Enable();
		Synthesize_Make : Enable();
		--Begin Modify By MaLiang TT 69445
		Synthesize_AllMake : Show()
		Synthesize_MadeAmount_Bk : Show()
		Synthesize_Decrease : Show()
		Synthesize_More : Show()
		--End

		return;
	else
		Synthesize_Explain:Hide();
	end

	local name,icon = LifeAbility : GetPrescr_Material(resultid);
	Synthesize_Item_Frame : Show();
	Synthesize_Item : SetProperty("ShortImage",icon);
	Synthesize_Item : Show();

	if resultnum == -1 then
		Synthesize_Amount : Hide();
	else
		Synthesize_Amount : SetText("#e010101" .. resultnum);
		Synthesize_Amount : Show();
	end

	--4,5,6
	--ÖýÔì²Ã·ì¹¤ÒÕ
	--¾«Ìú£¬ÃÞ²¼£¬ÃØÒø
	--¾«Á¶ - ÖýÔì - 46
	--¾«ÖÆ - ·ìÈÒ - 47
	--¾«¹¤ - ¹¤ÒÕ - 48

	Synthesize_SpecialMaterialIcon_Frame : Show();
	Synthesize_SpecialMaterial_Text : Show();
	if  Prescr_Ability == 46 then
		Synthesize_SpecialMaterial_WarningText : SetText("#cE6BA00M¶i ðßa vào phía bên phäi v§t li®u chª tÕo #cFFFF00Tinh Thiªt#cE6BA00. LoÕi v§t li®u ð£c bi®t này có th¬ tång thêm ph¦m ch¤t cüa thiªt b¸ ")
		Synthesize_SpecialMaterial : SetToolTip("Tinh Thiªt")
		Synthesize_SpecialMaterial:SetProperty( "DragAcceptName", "N1" );  --´ËÊ±´ò¿ª¾«Á¶½çÃæÁË
	elseif Prescr_Ability == 47 then
		Synthesize_SpecialMaterial_WarningText : SetText("#cE6BA00 m¶i ðßa vào phía bên phäi v§t li®u chª tÕo #cFFFF00väi bông #cE6BA00. LoÕi v§t li®u ð£c bi®t này có th¬ tång thêm ph¦m ch¤t cüa thiªt b¸ ")
		Synthesize_SpecialMaterial : SetToolTip("Miên B¯")
		Synthesize_SpecialMaterial:SetProperty( "DragAcceptName", "N2" ); --´ËÊ±´ò¿ª¾«ÖÆ½çÃæÁË
	elseif Prescr_Ability == 48 then
		Synthesize_SpecialMaterial_WarningText : SetText("#cE6BA00Xin hãy ð£t nguyên li®u chª tÕo vào bên phäi#cFFFF00Bí Ngân#cE6BA00, loÕi nguyên li®u ð£c thù này có th¬ nâng cao ph¦m ch¤t trang b¸")
		Synthesize_SpecialMaterial : SetToolTip("Bí Ngân")
		Synthesize_SpecialMaterial:SetProperty( "DragAcceptName", "N3" ); --´ËÊ±´ò¿ª¾«¹¤½çÃæÁË
	else
		Synthesize_SpecialMaterial_Text : Hide();
		Synthesize_SpecialMaterialIcon_Frame : Hide()
		Synthesize_SpecialMaterial:SetProperty( "DragAcceptName", "N" );
		if(Synthesize_Special_Item ~= -1)then
			LifeAbility : Lock_Packet_Item(Synthesize_Special_Item,0);
			Synthesize_SpecialMaterial : SetActionItem(-1);
			Synthesize_Special_Item	= -1;
		end
	end

	Synthesize_Item_Name_Text : SetText(name);
	Synthesize_Item_Name_Text : Show();

	local tip_name,tip_type,tip_level = LifeAbility : GetPrescr_Material_Tooltip(resultid);
	local Consume_Vigor,Consume_Energy = LifeAbility : GetPrescr_Consume_Vigor_Energy(nSelIndex);
	local Consume_Attr = LifeAbility : GetPrescr_Consume_ContriAttr(nSelIndex);
	local strName = ""
	if Consume_Vigor >= 0 then
		strName = strName .. "#rTiêu hao hoÕt lñc c½ bän".. tostring(Consume_Vigor);
	end

	if Consume_Energy >= 0 then
		strName = strName .. "#rTiêu hao sÑc lñc".. tostring(Consume_Energy);
	end

	if Consume_Attr >= 0 then
		strName = strName .. "#rÐi¬m c¯ng hiªn môn phái hao phí:".. tostring(Consume_Attr);
	end

	if resultnum == -1 or resultid == -1 then
		Synthesize_Item : SetToolTip(tip_name.."#rLoÕi hình"..tip_type..strName);
		Synthesize_Amount:SetToolTip(tip_name.."#rLoÕi hình"..tip_type..strName);
	end

	local Material_number = LifeAbility : GetPrescr_Material_Number(nSelIndex);
	if(Material_number < 1) then
		--Begin Modify By Ma Liang TT 69445
		Synthesize_MadeAmount_Bk : Show()
		Synthesize_Decrease : Show()
		Synthesize_More : Show()
		--End
		Synthesize_AllMake : Enable();
		Synthesize_Make : Enable();
		return;
	end

	for	i=1, 4 do
	  local stuffid,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,i);

		if(stuffid == -1) then
			Material_Num[i]	 : SetText("");
			Material_Icon[i] : Hide();
		else
			name,icon = LifeAbility : GetPrescr_Material(stuffid);
			local holdnum = LifeAbility : GetPrescr_Material_Hold_Count(nSelIndex,i);
			Material_Icon[i] : SetProperty("ShortImage",icon);
			Material_Icon[i] : Show();
			Material_Name[i] : SetText(name);
			if holdnum > 99 then
				Material_Num[i]  : SetText("#e010101 ~/" .. stuffnum);
			else
				Material_Num[i]  : SetText("#e010101" .. holdnum .. "/" .."#e010101" .. stuffnum);
			end
			if( holdnum < stuffnum ) then
				Material_Mask[ i ]:Show();
			else
				Material_Mask[ i ]:Hide();
			end
			Material_Num[i]  : Show();
			Material_Frame[i]: Show();
			tip_name,tip_type,tip_level = LifeAbility : GetPrescr_Material_Tooltip(stuffid);
		end
	end

	local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nSelIndex);
	if(nMaxAmount == 0) then
		Synthesize_AllMake : Disable();
		Synthesize_Make : Disable();
	else
		Synthesize_AllMake : Enable();
		Synthesize_Make : Enable();
	end

	if Prescr_Ability == 46 or Prescr_Ability == 47 or Prescr_Ability == 48 then
	--µ±¾«Á¶¾«ÖÆ¾«¹¤Ê±£¬Òþ²Ø¡°È«²¿ÖÆ×÷¡±°´Å¥
		Synthesize_AllMake : Hide()
		Synthesize_MadeAmount_Bk : Hide()
		Synthesize_Decrease : Hide()
		Synthesize_More : Hide()
	else
		Synthesize_AllMake : Show()
		Synthesize_MadeAmount_Bk : Show()
		Synthesize_Decrease : Show()
		Synthesize_More : Show()
	end

	-- ¡°ÌØÊâ²ÄÁÏ¡±µÄ´¦Àí
	-- ÓÉÓÚÏÖÔÚconfig.txt±íÖÐµÄÊý¾ÝÒÑ¾­±äµÄ²»¿ÉÐÅÈÎ£¨ºÜ¶à¶«Î÷¶¼ÊÇÒòÎªÔÚÒÑ¾­¶¨ºÃµÄ¹æÔòÉÏ£¬²ß»®Ìí´í±í£©£¬ÕâÀïÐ´ËÀÌØÀý
	-- Ö»ÓÐ¡°¾«Á¶¡±¡¢¡°¾«ÖÆ¡±¡¢¡°¾«¹¤¡±Ê±ºò£¬²Å´Ó±íÀïÅÐ¶ÏÊÇ·ñÐèÒªÌØÊâ²ÄÁÏ£¬²»ÔÙµ¥´¿ÒÀ¿¿±íÀ´ÅÐ¶Ï
	if Prescr_Ability == 46 or Prescr_Ability == 47 or Prescr_Ability == 48 then
		local NeedSpecial = LifeAbility : GetPrescr_Item_IsNeedSpecial( nSelIndex ) --È¡µÃÊÇ·ñÐèÒªÌØÊâ²ÄÁÏ
		-- 0£º¾«Ìú
		-- 1£ºÃÞ²¼
		-- 2£ºÃØÒø
		if NeedSpecial >= 0 then
			local SItem = Synthesize_SpecialMaterial:GetActionItem() --¼ì²â¿òÀïÓÐÃ»ÓÐ·ÅÈëÌØÊâ²ÄÁÏ
			if SItem > 0 and nMaxAmount > 0 then
				Synthesize_Make : Enable();
			else
				Synthesize_Make : Disable();
			end
		else
			Synthesize_SpecialMaterial_Text : Hide();
			Synthesize_SpecialMaterialIcon_Frame : Hide()
			if(Synthesize_Special_Item ~= -1)then
				LifeAbility : Lock_Packet_Item(Synthesize_Special_Item,0);
				Synthesize_SpecialMaterial : SetActionItem(-1);
				Synthesize_Special_Item	= -1;
			end
		end
	end

	-- ++++begin  add by cuiyinjie 2008-10-25 ÔÚÎ´Ñ¡ÖÐÅä·½Ê±Çå³ýÅä·½ËùÐè²ÄÁÏ
	if ( Synthesize_Item_List:GetFirstSelectItem() < 0 ) then
		Synthesize_HideCtrlOnNoSelect();
	end
	-- +++++end

end

--ÏÔÊ¾µÀ¾ßµÄToolTips
function Synthesize_OnShowToolTip(who)
	local nSelIndex = Synthesize_Item_List:GetFirstSelectItem();
	local left, right, top, bottom;
	local itemID = 0;
	local stuffnum = 0;

	-- begin +++++++++++ add by cuiyinjie 2008-10-25 for bug TT40225, Ã»Ñ¡ÖÐÅä·½Ê±ÏÔÊ¾tip¿Í»§¶Ë±¨´í
	if ( nSelIndex < 0 ) then
	   return;
	end
	-- end +++++++++++

	if who == 0 then
		itemID,stuffnum = DataPool : GetPrescrList_Item_Result(nSelIndex);
		left, right, top, bottom = Synthesize_Item :GetPixelRect();
	elseif who == 1 then
		itemID,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,1);
		left, right, top, bottom = Synthesize_MaterialIcon1_Mask :GetPixelRect();
	elseif who == 2 then
		itemID,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,2);
		left, right, top, bottom = Synthesize_MaterialIcon2_Mask :GetPixelRect();
	elseif who == 3 then
		itemID,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,3);
		left, right, top, bottom = Synthesize_MaterialIcon3_Mask :GetPixelRect();
	elseif who == 4 then
		itemID,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,4);
		left, right, top, bottom = Synthesize_MaterialIcon4_Mask :GetPixelRect();
	end

	LifeAbility:ShowSuperToolTip(itemID, true,left,top,right,bottom);
end

--Òþ²ØµÀ¾ßµÄToolTips
function Synthesize_OnHideToolTip()
	LifeAbility:ShowSuperToolTip(1, false);
end

function Synthesize_Do_Clicked()

	local Notify = 0;

	if Synthesize_Special_Item ~= -1 then
		local Item_Medindex = PlayerPackage : GetItemSubTableIndex(Synthesize_Special_Item,3)
		if Item_Medindex == 0 then
			local Item_ID = PlayerPackage : GetItemTableIndex(Synthesize_Special_Item);
			PushDebugMessage("#{_ITEM".. Item_ID .."} ko th¬ dùng ð¬ hþp thành.")
			return;
		end
	end

	local nSelIndex = Synthesize_Item_List:GetFirstSelectItem();
	local nPrescrNum = DataPool:GetPrescrList_Num();
	local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(Current_Select);
	local nMake_Count = tonumber(Synthesize_MadeAmount:GetText());
	if( nMaxAmount == -1 ) then
		nMaxAmount = 99;
	end

	--ÅÐ¶Ï°ó¶¨
	if Prescr_Ability == 46 or Prescr_Ability == 47 or Prescr_Ability == 48 then
		local NeedSpecial = LifeAbility : GetPrescr_Item_IsNeedSpecial( nSelIndex ) --È¡µÃÊÇ·ñÐèÒªÌØÊâ²ÄÁÏ
		if NeedSpecial >= 0 then
			local SItem = Synthesize_SpecialMaterial:GetActionItem() --¼ì²â¿òÀïÓÐÃ»ÓÐ·ÅÈëÌØÊâ²ÄÁÏ
			if SItem > 0 and nMaxAmount > 0 then
				--ÅÐ¶ÏÊÇ·ñ°ó¶¨£¬ÆäËûµÄ¼ì²âÒÑ¾­×öÍê
				if(TheLastItem ~= Synthesize_Special_Item) then
					TheLastItem = Synthesize_Special_Item;
					Notify = 1;
				end
				if(Notify == 1) then
					if(Synthesize_IsBind(Synthesize_Special_Item) == 1) then
						ShowSystemInfo("BSHE_20070924_002");
						return;
		end
				end
			end
		end

	elseif Prescr_Ability == 5 or Prescr_Ability == 6 then
		if ShowBindWin == 1 then
			for	i=1, 4 do
	  		local stuffid,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,i);
				if(stuffid ~= -1) then
					local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(stuffid));
					if(BindState == 1)then
						ShowSystemInfo("BSHE_20070924_002");
						ShowBindWin = 0
						return;
			end
		end
	end
		end
	end

	if(Current_Select <= 0 ) then
		return;
	end

	if nMake_Count > nMaxAmount then
		PushDebugMessage("Nguyên li®u không ðü")
		return;
	end
	ComposeItem_Begin(Current_Select,nMake_Count,Synthesize_Special_Item);
end

function Synthesize_Do_All_Clicked()

	if Synthesize_Special_Item ~= -1 then
		local Item_Medindex = PlayerPackage : GetItemSubTableIndex(Synthesize_Special_Item,3)
		if Item_Medindex == 0 then
			local Item_ID = PlayerPackage : GetItemTableIndex(Synthesize_Special_Item);
			PushDebugMessage("#{_ITEM".. Item_ID .."} ko th¬ dùng ð¬ hþp thành.")
			return
		end
	end

	local nSelIndex = Synthesize_Item_List:GetFirstSelectItem();
	local nPrescrNum = DataPool:GetPrescrList_Num();
	local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(Current_Select);

	if(Current_Select <= 0 ) then
		return;
	end

	if( nMaxAmount == -1 ) then
		nMaxAmount = 99;
	end

	if Prescr_Ability == 5 or Prescr_Ability == 6 then
		if ShowBindWin == 1 then
			for	i=1, 4 do
	  		local stuffid,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,i);
				if(stuffid ~= -1) then
					local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(stuffid));
					if(BindState == 1)then
						ShowSystemInfo("BSHE_20070924_002");
						ShowBindWin = 0
						return;
			end
		end
	end
		end
	end

	ComposeItem_Begin(Current_Select,nMaxAmount,Synthesize_Special_Item);
end

function Synthesize_Cancel_Clicked()
	if( Synthesize_Special_Item ~= -1 ) then
		LifeAbility : Lock_Packet_Item(Synthesize_Special_Item,0);
		Synthesize_SpecialMaterial : SetActionItem(-1);
		Synthesize_Special_Item	= -1;
	end
	this:Hide();
	return;
end

function Synthesize_Carculate_Clicked()
	local obj_id,obj_count;
	local tip_name,tip_type,tip_level
	local sum_price;
	local Ability_Level;
	local Consume_Vigor,Consume_Energy;

	for i=0,398 do
		sum_price = 0;
		Consume_Vigor,Consume_Energy = LifeAbility : GetPrescr_Consume_Vigor_Energy(i);

		if Consume_Vigor > 0 then
			sum_price = sum_price + Consume_Vigor;
		end

		if Consume_Energy > 0 then
			sum_price = sum_price + Consume_Energy;
		end

		for k=1,4 do
			obj_id,obj_count = LifeAbility:Get_Test_Prescr_Item(i,k);

			if(obj_id ~= -1) then
				tip_name,tip_type,tip_level = LifeAbility : GetPrescr_Material_Tooltip(obj_id);
				Ability_Level = LifeAbility : GetPrescr_Material_Consume(obj_id);
				if tonumber(Ability_Level) > 0 then
					sum_price = sum_price + (Ability_Level * 2 + 1) * obj_count;
		end
	end
		end

	end

end

function Update_Synthesize_Item(Item_index)

	local index = tonumber(Item_index)
	local theAction = EnumAction(index, "packageitem");

	if theAction:GetID() ~= 0 then

			local Item_Quality = PlayerPackage : GetItemSubTableIndex(index,1)
			local Item_Class = PlayerPackage : GetItemSubTableIndex(index,0)

			if Item_Class ~= 2 or Item_Quality ~= 5 then
				return
			end

			local Item_Type = PlayerPackage : GetItemSubTableIndex(index,2)
			if (Item_Type == 0  and Prescr_Ability ~= 46 ) or
					(Item_Type == 1 and Prescr_Ability ~= 47 ) or
					(Item_Type == 2 and Prescr_Ability ~= 48 ) then

					local Item_ID = PlayerPackage : GetItemTableIndex(index)
					local szName = LifeAbility:GetPrescr_Material(Item_ID)

					PushDebugMessage("#B"..szName.."#W chï có th¬ dùng v¾i #B"..Ability_Limit[Item_Type].."#W.")
					return
			end

			if Synthesize_Special_Item ~= -1 then
				LifeAbility : Lock_Packet_Item(Synthesize_Special_Item,0);
			end

			Synthesize_SpecialMaterial:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(index,1);
			Synthesize_Special_Item = index

	else
			Synthesize_SpecialMaterial:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Synthesize_Special_Item,0);
			Synthesize_Special_Item = -1;
	end

end

function Synthesize_Resume()
	if(Synthesize_Special_Item ~= -1) then
		LifeAbility : Lock_Packet_Item(Synthesize_Special_Item,0);
		Synthesize_SpecialMaterial : SetActionItem(-1);
		Synthesize_Special_Item	= -1;
	end
end

function Synthesize_OnHidden()
	TheLastItem = -1;
	ShowBindWin = 1
	Synthesize_Cancel_Clicked()
end

function Synthesize_IsBind( ItemID )
	if(GetItemBindStatus(ItemID) == 1) then
		return 1;
	else
		return 0;
	end
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Synthesize_Frame_On_ResetPos()

	Synthesize_Frame : SetProperty("UnifiedXPosition", g_Synthesize_Frame_UnifiedXPosition);
	Synthesize_Frame : SetProperty("UnifiedYPosition", g_Synthesize_Frame_UnifiedYPosition);

end
