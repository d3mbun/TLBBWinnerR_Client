local CUSTOM_BUTTONS = {};
local CUSTOM_BUTTONS_NUM = 13;
local g_Action = "";
--ϵͳ��˽�ġ����顢��ᡢͬ��
local g_ipRegionConfig = {4,5,2,7,13};

function isInIpRegionConfig(idx)
	for i = 1,5 do
		if (tonumber(g_ipRegionConfig[i]) == tonumber(idx)) then
			return 1;
		end
	end
	return 0;
end

function ChannelCustomization_PreLoad()
	this:RegisterEvent("CHAT_TAB_CREATE");
	this:RegisterEvent("CHAT_TAB_CONFIG");
	this:RegisterEvent("CHAT_TAB_CHANGED");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end
	
function ChannelCustomization_OnLoad()
	CUSTOM_BUTTONS[3] = ChannelCustomization_WorldInfo;
	CUSTOM_BUTTONS[1] = ChannelCustomization_VicinityInfo;
	CUSTOM_BUTTONS[4] = ChannelCustomization_PersonalInfo;
	CUSTOM_BUTTONS[8] = ChannelCustomization_MenpaiInfo;
	CUSTOM_BUTTONS[7] = ChannelCustomization_CorporateInfo;
	CUSTOM_BUTTONS[2] = ChannelCustomization_TeamInfo;
	CUSTOM_BUTTONS[9] = ChannelCustomization_SelfInfo;
	CUSTOM_BUTTONS[5] = ChannelCustomization_SystemInfo;			--ϵͳƵ��
	CUSTOM_BUTTONS[6] = ChannelCustomization_SelfInfo;				--�Խ�Ƶ��������û�й��ܣ�
	CUSTOM_BUTTONS[10] = ChannelCustomization_HelpInfo;				--����Ƶ��
	CUSTOM_BUTTONS[11] = nil;
	CUSTOM_BUTTONS[12] = ChannelCustomization_City;				--ͬ������
	CUSTOM_BUTTONS[13] = ChannelCustomization_GuildLeagueInfo;				--ͬ������


	--��������Ϣ
	ChannelCustomization_ProvinceCity : ResetList();
	local num = DataPool : GetProvincesNum();
	if (num > 0) then
		for i = 0, num-1 do
			local _id,_name =DataPool : EnumProvinces(i);
			ChannelCustomization_Province:ComboBoxAddItem(_name,_id);
		end
	end
end

function ChannelCustomization_ComboListProvinceChanged(cIdx)
	local szName, nIndex = ChannelCustomization_Province:GetCurrentSelect();
	if(nIndex and nIndex ~= -1 ) then
		ChannelCustomization_ProvinceCity : ResetList();
		local num = DataPool : GetCityNumFromOneProvinceId(nIndex);
		if (num > 0) then
			for i = 0, num-1 do
				local _id,_name = DataPool : NumCityFromOneProvince(nIndex,i)
				ChannelCustomization_ProvinceCity:ComboBoxAddItem(_name,_id);
			end
		end
		if(tonumber(cIdx) and tonumber(cIdx) > 0 and tonumber(cIdx) < num ) then	
			ChannelCustomization_ProvinceCity:SetCurrentSelect(tonumber(cIdx));
		else
			ChannelCustomization_ProvinceCity:SetCurrentSelect(0);
		end
	end
end

function ChannelCustomization_OnEvent( event )
	if (event == "CHAT_TAB_CREATE") then
		ChatTabAction("create", "1111111111001", "", arg0);
	elseif (event == "CHAT_TAB_CONFIG") then
		ChatTabAction("config", arg1, arg0, arg2);
	elseif (event == "CHAT_ADJUST_MOVE_CTL" and this:IsVisible()) then
		Chat_ChannelTab_AdjustMoveCtl();
	elseif (event == "CHAT_TAB_CHANGED" and this:IsVisible()) then
		ChannelCustomization_Close_Clicked();
	end
end


function ChatTabAction( act , strCfg , strName , pos)
	if(g_Action == act) then
		if(this:IsVisible() or this:ClickHide()) then
			ChannelCustomization_Close_Clicked();
			return;
		end
	end
	CC_BUTTON_Enable(12);
	g_Action = act;
	--AxTrace(0, 0, "ChannelCustomization " .. act .. " " .. strCfg .. " " .. strName);	
	-- ���ô�������
	if ( g_Action == "create" ) then
		ChannelCustomization_PageHeader_Text:SetText("#gFF0FA0T� �nh ngh�a");
		ChannelCustomization_Text1:SetText("K�nh ri�ng");
		ChannelCustomization_Cancel:SetText("T�o");
		ChannelCustomization_Destory:SetText("Hu�");
		ChannelCustomization_EditName:Show();
		ChannelCustomization_EditName:CaptureInput();
		ChannelCustomization_Accept:Hide();
		ChannelCustomization_TxtName:Hide();
		ChannelCustomization_EditName:SetText(strName);
	elseif ( g_Action == "config" ) then
		ChannelCustomization_PageHeader_Text:SetText("#gFF0FA0B�y tr� k�nh");
		ChannelCustomization_Text1:SetText("T�n g�i k�nh");
		ChannelCustomization_Accept:SetText("Duy�t");
		ChannelCustomization_Cancel:SetText("Hu�");
		ChannelCustomization_Destory:SetText("X�a b�");
		ChannelCustomization_EditName:Hide();
		ChannelCustomization_TxtName:Show();
		ChannelCustomization_Accept:Show();
		ChannelCustomization_TxtName:SetText(strName);
		
		if(strName == "B�n th�n") then
			ChannelCustomization_Destory:Hide();
		else
			ChannelCustomization_Destory:Show();
		end
	end
	Chat_ChannelTab_ChangePosition(pos);
	
	local ipRegion = Player:GetData("IPREGION");
	local pIdx = -1;
	local cIdx =  -1;
	local yes = 0 ;
	if(ipRegion and ipRegion > 0) then
		pIdx,cIdx = DataPool:getUINumbersFromIpRegion(ipRegion);
		local count =  DataPool : GetProvincesNum();
		count = tonumber(count);
		if(pIdx < count and count) then
			local num = DataPool : GetCityNumFromOneProvinceId(pIdx);
			num = tonumber(num);
			if(cIdx < num and num) then
				--�����ȷ������Ч��ipRegion
				yes = 1;
			end
		end
	end
	
	--ͬ��Ƶ�������⴦��,���ͬ��Ƶ��ѡ��
	if(string.byte(strCfg,12) == 49 ) then
		for i=1, 13 do
			if i==12 then
				continue
			end
			
			if(isInIpRegionConfig(i) == 0) then
				CC_BUTTON_SetCheck(i,0);
				CC_BUTTON_Disable(i);
			else
				if(string.byte(strCfg, i) == 49) then
					CC_BUTTON_SetCheck(i,1);
				else
					CC_BUTTON_SetCheck(i,0);
				end
				CC_BUTTON_Enable(i);
			end
		end
		CC_BUTTON_SetCheck(12,1);
		ChannelCustomization_ProvinceCity : Enable();
		ChannelCustomization_Province	  : Enable();
		if(tonumber(yes) == 1)then
			ChannelCustomization_Province	  : SetCurrentSelect(pIdx);
			ChannelCustomization_ComboListProvinceChanged(cIdx);
		else
			ChannelCustomization_Province : SetCurrentSelect(0);
			ChannelCustomization_ComboListProvinceChanged(-1);
		end
	else
		for i=1, 13 do
			if i==12 then
				continue
			end
			
			if(string.byte(strCfg, i) == 48) then -- 0
				CC_BUTTON_SetCheck(i,0);
			elseif(string.byte(strCfg, i) == 49) then -- 1
				CC_BUTTON_SetCheck(i,1);
			end
			CC_BUTTON_Enable(i);
		end
		CC_BUTTON_SetCheck(12,0);
		if(tonumber(yes) == 1)then
			ChannelCustomization_Province	  : SetCurrentSelect(pIdx);
			ChannelCustomization_ComboListProvinceChanged(cIdx);
		else
			ChannelCustomization_Province : SetCurrentSelect(0);
			ChannelCustomization_ComboListProvinceChanged(-1);
		end
		ChannelCustomization_ProvinceCity : Disable();
		ChannelCustomization_Province	  : Disable();

	end
	local curTab = Talk : GetCurTab();
	if(g_Action == "config" and curTab == 3) then
		CC_BUTTON_Disable(12);
	end
	-- ����checkbox
--	local i;
--	for i=1, CUSTOM_BUTTONS_NUM do
--		if(string.byte(strCfg, i) == 48) then -- 0
--			CC_BUTTON_SetCheck(i,0);
--		elseif(string.byte(strCfg, i) == 49) then -- 1
--			CC_BUTTON_SetCheck(i,1);
--		end
--	end
	
--	if("False" == CC_BUTTON_GetSelected(12))then
--		ChannelCustomization_ProvinceCity : Disable();
--		ChannelCustomization_Province	  : Disable();
--	else
--		ChannelCustomization_ProvinceCity : Enable();
--		ChannelCustomization_Province	  : Enable();
--	end
	-- ��ʾ����
	this:Show();
end

function CC_BUTTON_SetCheck(idx,val)
	if not idx then return; end
	if not val then return; end
	
	if CUSTOM_BUTTONS[idx] then
		CUSTOM_BUTTONS[idx]:SetCheck(val);
	end
end

function CC_BUTTON_GetSelected(idx)
	if not idx then return "False"; end
	if CUSTOM_BUTTONS[idx] then
		return CUSTOM_BUTTONS[idx]:GetProperty("Selected");
	end
	return "False";
end

function CC_BUTTON_Disable(idx)
	if not idx then return "False"; end
	if CUSTOM_BUTTONS[idx] then
		CUSTOM_BUTTONS[idx]:Disable();
	end
end

function CC_BUTTON_Enable(idx)
	if not idx then return "False"; end
	if CUSTOM_BUTTONS[idx] then
		CUSTOM_BUTTONS[idx]:Enable();
	end
end

function ChannelCustomization_Accept_Clicked()
	local strName = "";
	local strConfig = "";

	-- config
	local i;
	for i=1, CUSTOM_BUTTONS_NUM do
		if("False" == CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "0";
		elseif("True" == CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "1";
		end
	end
	
	--AxTrace(0, 0, "ChannelCustomization Config: " .. strConfig .. " " .. g_Action);
	-- call Talk Interface
	if(g_Action == "config") then
		strName = ChannelCustomization_TxtName:GetText();
		if("True" == CC_BUTTON_GetSelected(12)) then
			local _name,_id = ChannelCustomization_ProvinceCity:GetCurrentSelect();
			if(_id == nil or tonumber(_id) == nil)then
				_id = -1;
			end
			if(_id < 0)then
				PushDebugMessage("Xin c�c h� l�a ch�n 1 c�i th�nh th� r�i x�c nh�n s� d�ng аng th�nh t�n ��o!")
				this : Hide()
				return;
			end
			Player:SetIPRegion(tonumber(_id));
		end
		Talk:ConfigTabFinish(strName, strConfig, "sucess");
	end
	
	--AxTrace(0, 0, "ChannelCustomization Name: " .. strName .. " " .. g_Action);
	this:Hide();
end

function ChannelCustomization_Cancel_Clicked()
	local strName = "";
	local strConfig = "";
	
	-- config
	local i;
	for i=1, CUSTOM_BUTTONS_NUM do
		if("False" == CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "0";
		elseif("True" == CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "1";
		end
	end
	
	if(g_Action == "create") then
		strName = ChannelCustomization_EditName:GetText();
		if("True" == CC_BUTTON_GetSelected(12)) then
			local _name,_id = ChannelCustomization_ProvinceCity:GetCurrentSelect();
			if(_id == nil or tonumber(_id) == nil)then
				_id = -1;
			end
			if(_id < 0)then
				PushDebugMessage("Xin c�c h� l�a ch�n 1 c�i th�nh th� r�i x�c nh�n s� d�ng аng th�nh t�n ��o!")
				this : Hide()
				return;
			end
			Player:SetIPRegion(tonumber(_id));
		end
		Talk:CreateTabFinish(strName, strConfig, "sucess");

	elseif(g_Action == "config") then
		strName = ChannelCustomization_TxtName:GetText();
		Talk:ConfigTabFinish(strName, strConfig, "cancel");
	end
	
	this:Hide();
end

function ChannelCustomization_Destory_Clicked()
	local strName = "";
	local strConfig = "";
	
	if(g_Action == "create") then
		strName = ChannelCustomization_EditName:GetText();
		Talk:CreateTabFinish(strName, strConfig, "cancel");
		this:Hide();
	elseif(g_Action == "config") then
		Talk:ConfigTabFinish(strName,strConfig,"delete");
		this:Hide();
	end
end

function Chat_ChannelTab_Frame_OnHiden()
	ChannelCustomization_EditName:SetProperty("DefaultEditBox", "False");
end

function Chat_ChannelTab_AdjustMoveCtl()
	ChannelCustomization_Close_Clicked();
end

function Chat_ChannelTab_ChangePosition(pos)
	ChannelCustomization_Frame:SetProperty("UnifiedXPosition", "{0.0,"..pos.."}");
end

function ChannelCustomization_Close_Clicked()
	if(g_Action == "create") then
		ChannelCustomization_Destory_Clicked();
	elseif(g_Action == "config") then
		ChannelCustomization_Cancel_Clicked();
	end
end

function ChannelCustomization_ComboListProvinceCityChanged()
end

function ChannelCustomization_City_Click()
	if("False" == ChannelCustomization_City:GetProperty("Selected"))then
		ChannelCustomization_Province : Disable()
		ChannelCustomization_ProvinceCity : Disable();
		--
		for i=1, 13 do
			if i==12 then
				continue
			end
			CC_BUTTON_Enable(i);
		end

	else

		ChannelCustomization_Province : Enable()
		ChannelCustomization_ProvinceCity : Enable();
		--
		for i=1, 13 do
			if i==12 then
				continue
			end
			
			if(isInIpRegionConfig(i) == 0) then
				CC_BUTTON_SetCheck(i,0);
				CC_BUTTON_Disable(i);
			else
				CC_BUTTON_Enable(i);
			end
		end

		--Ĭ��ѡ�С����ǡ�
		--ChannelCustomization_Province : SetCurrentSelect(0);
	end
end
