local MAX_CHARACTER_INPUTNAME = 12; --��������
local MAX_COUNTRY_INPUTNAME   = 12; --��������
local g_PortId = -1;
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Type = 0;
local g_ConfraternityApplyManor_Frame_UnifiedXPosition;
local g_ConfraternityApplyManor_Frame_UnifiedYPosition;

function ConfraternityApplyManor_PreLoad()
	this:RegisterEvent("CITY_SHOW_INPUT_NAME");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UI_COMMAND");
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function ConfraternityApplyManor_OnLoad()
		-- ���汳�������Ĭ�����λ��
	g_ConfraternityApplyManor_Frame_UnifiedXPosition	= ConfraternityApplyManor_Frame:GetProperty("UnifiedXPosition");
	g_ConfraternityApplyManor_Frame_UnifiedYPosition	= ConfraternityApplyManor_Frame:GetProperty("UnifiedYPosition");
end

function ConfraternityApplyManor_OnEvent(event)
	if(event == "CITY_SHOW_INPUT_NAME" and arg0 == "open") then
		g_PortId = -1;
		g_PortId = tonumber(arg1);
		g_Type =0;
		ConfraternityApplyManor_Update(0, tonumber(arg2))
		this:Show();
	elseif(event == "CITY_SHOW_INPUT_NAME" and arg0 == "close") then
		this:Hide();
	elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		City_InputName_CareEventHandle(arg0,arg1,arg2);
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 5423  or tonumber(arg0) == 5424 or tonumber(arg0) == 5425) then
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
			PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
			return;
		end
		if(tonumber(arg0) == 5423)then
			g_Type =1;
		elseif (tonumber(arg0) == 5424)then
			g_Type =2;
		else
			g_Type = 3;
		end
		
		ConfraternityApplyManor_Update(g_Type,objCared);
		this:Show();
	
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ConfraternityApplyManor_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityApplyManor_Frame_On_ResetPos()
	end
end

function ConfraternityApplyManor_Update(type,clientNpcId)
		ConfraternityApplyManor_FeudalName:SetProperty("DefaultEditBox", "True");
		ConfraternityApplyManor_FeudalName:SetText("");
		g_clientNpcId = clientNpcId;
		this:CareObject(g_clientNpcId, 1, "CityInputName");
		if(type == 0)then
			--�½�����
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength","12");
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_56}");	--#gFF0FA0����������
			ConfraternityApplyManor_Text1:SetText("#{INTERFACE_XML_627}"); --����һ�������Ҫ����1000���ƽ��ʹ�ý�������
			ConfraternityApplyManor_Text1:Show();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_525}"); --�����������
		elseif(type == 1)then
			--�������
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_CHARACTER_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_GAIMING_0}");	--#gFF0FA0��ɫ����  ע���Ϸ�
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_GAIMING_1}"); --�������µĽ�ɫ���ƣ�
		elseif(type == 2)then
			--���ɸ���
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_COUNTRY_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_GAIMING_2}");	--#gFF0FA0���ɸ���
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_GAIMING_3}"); --�������µİ������ƣ�
		elseif(type == 3)then
			--��ɫ���� guochenshu 2010-08-09
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_CHARACTER_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{GMT_20100811_3}");	--#gFF0FA0��ɫ����
			ConfraternityApplyManor_Text1:SetText("#{GMT_20100811_27}"); --#cfff263��ɫ��������Ҫ����#G1��������#cfff263��
			ConfraternityApplyManor_Text1:Show();
			ConfraternityApplyManor_Text2:SetText("#{GMT_20100811_18}"); --�������µĽ�ɫ���ƣ�
		end
end

function City_InputName_Clear()
	g_PortId = -1;
	ConfraternityApplyManor_FeudalName:SetText("");
end

function City_InputName_Confirm()
	if(g_PortId >= 0) then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		City:DoConfirm(1, g_PortId, txt);
	end
end

function City_InputName_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end

function ConfraternityApplyManor_Release_Button_Clicked()
	if g_Type == 0 then
		City_InputName_Confirm();
	elseif g_Type == 1 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Target:CharRnameCheck(txt);
		if(ret>0)then
			Target:CharRnameConfirm(txt);
			this:Hide();
		else
			City_InputName_Clear();
		end
	elseif g_Type == 2 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Guild:CityRnameCheck(txt);
		if(ret>0)then
			Guild:CityRnameConfirm(txt);
			this:Hide();
		else
			City_InputName_Clear();
		end
	elseif g_Type == 3 then
		-- ��ɫ����
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Target:CharRnameCheck(txt);
		if(ret>0)then
			Target:ChangeNameConfirm(txt,g_clientNpcId);
			this:Hide();
		else
			City_InputName_Clear();
	end
	end
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityApplyManor_Frame_On_ResetPos()
  ConfraternityApplyManor_Frame:SetProperty("UnifiedXPosition", g_ConfraternityApplyManor_Frame_UnifiedXPosition);
	ConfraternityApplyManor_Frame:SetProperty("UnifiedYPosition", g_ConfraternityApplyManor_Frame_UnifiedYPosition);
end