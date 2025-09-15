
-- hongyu
-- ������ר�ý��棬�벻Ҫ�����������ܣ�
-- 

local g_SERVER_CONTROL_1 = 1008
local g_SERVER_CONTROL_2 = 1009
local g_SERVER_CONTROL_3 = 112235	--������ʹ�ý���

local Server_Script_Function = "";
local Server_Script_ID = 0;
local Server_Return_1 = 0;
local Server_Return_2 = 0;
local Server_Return_3 = 0;
local Server_Str = ""

local Client_ItemIndex = 0;

local g_Type	-- "use"ʹ��������
							-- "call"����ʹ��������
							-- "useTLZ"ʹ��������

local g_Item_TuDunZhu_Frame_UnifiedPosition;

--===============================================
-- PreLoad()
--===============================================
function Item_TuDunZhu_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--===============================================
-- OnLoad()
--===============================================
function Item_TuDunZhu_OnLoad()
g_Item_TuDunZhu_Frame_UnifiedPosition=Item_TuDunZhu_Frame:GetProperty("UnifiedPosition");
end

--===============================================
-- OnEvent()
--===============================================
function Item_TuDunZhu_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == g_SERVER_CONTROL_1 then
			Item_TuDunZhu_Show("use")
			g_Type = "use"
		elseif tonumber(arg0) == g_SERVER_CONTROL_2 then
			-- ������������ڿ��ţ��Ͳ�����
			if( this:IsVisible() ) then
				return
			else
				Item_TuDunZhu_Show("call")
				g_Type = "call"
			end
		elseif tonumber(arg0) == g_SERVER_CONTROL_3 then	--������
			Item_TuDunZhu_Show("useTLZ")
			g_Type = "useTLZ"
		else
			return
		end
	elseif event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event == "ADJEST_UI_POS" ) then
		Item_TuDunZhu_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Item_TuDunZhu_Frame_On_ResetPos()
	end
end

--===============================================
-- Show()
--===============================================
function Item_TuDunZhu_Show(event)
	if event == "use"  then
		
		Client_ItemIndex = tonumber(arg1)
		
--		Server_Script_Function = Get_XParam_STR(0)
--		Server_Script_ID = Get_XParam_INT(0);
--		Server_Return_1 = Get_XParam_INT(1);
--		
		Item_TuDunZhu_OK_Button:SetText("#{INTERFACE_XML_975}")	--��λ
		Item_TuDunZhu_Cancel_Button:SetText("#{INTERFACE_XML_976}")	--����
		Item_TuDunZhu_DragTitle:SetText("#{INTERFACE_XML_977}")	--������
		Item_TuDunZhu_Text:SetText("#{Item_TuDunZhu_Show_001}")	--���������
		this:Show()

		-- �رյ���ʱ����
		--Item_TuDunZhu_StopWatch : SetProperty("Timer",tostring(2000000));
		Item_TuDunZhu_StopWatch:Hide()

	elseif event == "call"  then
		Server_Script_Function = Get_XParam_STR(0)
		Server_Script_ID = Get_XParam_INT(0);
		Server_Return_1 = Get_XParam_INT(1);
		Server_Return_2 = Get_XParam_INT(2);
		Server_Str = Get_XParam_STR(1)

		Item_TuDunZhu_OK_Button:SetText("#{INTERFACE_XML_976}")	--����
		Item_TuDunZhu_Cancel_Button:SetText("#{INTERFACE_XML_539}")	--ȡ��
		Item_TuDunZhu_DragTitle:SetText("#{INTERFACE_XML_977}")	--������
		Item_TuDunZhu_Text:SetText(Server_Str)
		
		-- ��ӵ���ʱ
		Item_TuDunZhu_StopWatch : SetProperty("Timer",tostring(20));
		Item_TuDunZhu_StopWatch:Show()
		this:Show()
		
	elseif event == "useTLZ"  then
	
		local Level = 0;  --TT67793
		Level = Player:GetData("LEVEL");
		if Player ~= nil and Player:GetData("LEVEL") < 10 then
			PushDebugMessage("#{GMTripperObj_Resource_Info_Level_Not_Enough}");
			return
		end

		Client_ItemIndex = tonumber(arg1)
		Item_TuDunZhu_OK_Button:SetText("#{INTERFACE_XML_975}")	--��λ
		Item_TuDunZhu_Cancel_Button:SetText("#{INTERFACE_XML_976}")	--����
		Item_TuDunZhu_DragTitle:SetText("#{INTERFACE_XML_978}")	--������
		Item_TuDunZhu_Text:SetText("#{INTERFACE_XML_979}")	--���������
		this:Show()

		-- �رյ���ʱ����
		--Item_TuDunZhu_StopWatch : SetProperty("Timer",tostring(2000000));
		Item_TuDunZhu_StopWatch:Hide()
		
	else
		return
	end

end

function Item_TuDunZhu_TimeOut()
	this:Hide()
end

--===============================================
-- OK
--===============================================
function Item_TuDunZhu_OK_Clicked()

	if g_Type == "use"  then
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("UseItem");
			Set_XSCRIPT_ScriptID(300056);
			Set_XSCRIPT_Parameter(0, 0);
			Set_XSCRIPT_Parameter(1, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		
	elseif g_Type == "call"  then
	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name(Server_Script_Function);
			Set_XSCRIPT_ScriptID(Server_Script_ID);
			Set_XSCRIPT_Parameter(0, 1);
			Set_XSCRIPT_Parameter(1, Server_Return_1);
			Set_XSCRIPT_Parameter(2, Server_Return_2);
			Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();

	elseif g_Type == "useTLZ"  then
	
		PlayerPackage:UseTulingzhuSetpos(Client_ItemIndex);
	
			--ֱ�ӵ���������ű���ĺ�������������Ķ�λ....
		--Clear_XSCRIPT();
		--	Set_XSCRIPT_Function_Name("SetPosition");
		--	Set_XSCRIPT_ScriptID(330001);
		--	Set_XSCRIPT_Parameter(0, Client_ItemIndex);
		--	Set_XSCRIPT_ParamCount(1);
		--Send_XSCRIPT();
	

				
	end
	
	this:Hide()
	
end

--===============================================
-- Cancel
--===============================================
function Item_TuDunZhu_Cancel_Clicked()

	if g_Type == "use"  then

		PlayerPackage:UseItem(Client_ItemIndex)

	elseif g_Type == "call"  then
		-- 
	elseif g_Type == "useTLZ"  then
	
		PlayerPackage:UseItem(Client_ItemIndex)	--�������Ĭ��ʹ���߼�Ϊ����....
		
	end

	this:Hide()
	
end

--===============================================
-- ��λ/ȡ��
--===============================================
function Item_TuDunZhu_Help()
	
end

function Item_TuDunZhu_Frame_On_ResetPos()
  Item_TuDunZhu_Frame:SetProperty("UnifiedPosition", g_Item_TuDunZhu_Frame_UnifiedPosition);
end