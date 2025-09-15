local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Current = 0;

local g_Object = -1;
local Prompt_Text = {}

function Service_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_SERVICE");
	this:RegisterEvent("RESUME_ENCHASE_GEM");

end

function Service_OnLoad()
	EQUIP_BUTTONS = Service_Item
	Prompt_Text[1] = "  C�c h� c� th� ��c s�a ch�a v� kh� b�n h� th�p. V� kh� mu�n s�a ch�a c�n ph�i c� ��ng c�p �t nh�t l� >= c�p 40. V� kh� c�p 40 tr� xu�ng m�i t�m th߽ng nh�n b�n h�ng � s�a ch�a.#rV� kh� s�a ch�a c�n ��ng c�p k� n�ng ��c c�a c�c h� *12 kh�ng nh� h�n ��ng c�p y�u c�u c�a v� kh�.#rS�a ch�a c� th� th�t b�i, t�ng c�ng 3 l�n th�t b�i v� kh� b�o b� �i. ��ng c�p k� n�ng ��c c�a c�c h� c�ng cao, kh� n�ng th�t b�i c�ng nh�.#rM�i ��a v� kh� s�a ch�a �n l�n v�t ph�m d߾i ��y, �n n�t\"S�a ch�a\".#rM�i l�n s�a ch�a ti�u hao s�c s�ng = ��ng c�p v� kh� +4.#r��ng c�p v� kh� = y�u c�u ��ng c�p v� kh� /10+1 nh�n v� sau."
	Prompt_Text[2] = "  C�c h� c� th� may s�a ch�a v�t ph�ng b�n h� th�p. V�t ph�ng mu�n s�a ch�a c�n ph�i c� ��ng c�p �t nh�t l� >= c�p 40. V�t ph�ng c�p 40 tr� xu�ng m�i t�m th߽ng nh�n b�n h�ng � s�a ch�a.#rV�t ph�ng s�a ch�a c�n ��ng c�p k� n�ng may c�a c�c h� *12 kh�ng nh� h�n ��ng c�p y�u c�u c�a v�t ph�ng.#rS�a ch�a c� th� th�t b�i, t�ng c�ng 3 l�n th�t b�i v�t ph�ng s� b�o b� �i. ��ng c�p k� n�ng may c�a c�c h� c�ng cao, kh� n�ng th�t b�i c�ng nh�.#rM�i ��a v�t ph�ng s�a ch�a �n l�n v�t ph�m d߾i ��y, �n n�t\"S�a ch�a\".#rM�i l�n s�a ch�a ti�u hao s�c s�ng = ��ng c�p v�t ph�ng +4.#r��ng c�p v�t ph�ng= y�u c�u ��ng c�p v�t ph�ng /10+1 nh�n v� sau."
	Prompt_Text[3] = "  C�c h� c� th� c�ng ngh� s�a ch�a � trang s�c b�n h� th�p. а trang s�c mu�n s�a ch�a c�n ph�i c� ��ng c�p �t nh�t l� >= c�p 40. а trang s�c c�p 40 tr� xu�ng m�i t�m th߽ng nh�n b�n h�ng � s�a ch�a.#rа trang s�c s�a ch�a c�n ��ng c�p k� n�ng c�ng ngh� c�a c�c h� *12 kh�ng nh� h�n ��ng c�p y�u c�u c�a � trang s�c.#rS�a ch�a c� th� th�t b�i, t�ng c�ng 3 l�n th�t b�i � trang s�c b�o b� �i. ��ng c�p k� n�ng c�ng ngh� c�a c�c h� c�ng cao, kh� n�ng th�t b�i c�ng nh�.#rM�i ��a � trang s�c s�a ch�a �n l�n v�t ph�m d߾i ��y, �n n�t\"S�a ch�a\".#rM�i l�n s�a ch�a ti�u hao s�c s�ng = ��ng c�p � trang s�c +4.#r��ng c�p � trang s�c= y�u c�u ��ng c�p � trang s�c /10+1 nh�n v� sau."
end

function Service_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 41) then
			this:Show();

			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
					return;
			end
			BeginCareObject_Service(objCared)
			Current = Get_XParam_INT(1);
			Service_Text:SetText(Prompt_Text[Current]);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			Service_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (EQUIP_QUALITY == tonumber(arg0) ) then
				Service_Clear()
				Service_Update(tonumber(arg0))
			end
		end
	elseif( event == "UPDATE_SERVICE") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 ~= nil then
			Service_Clear()
			Service_Update(tonumber(arg0));
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 5) then
			Service_Clear()
		end
		
	end
	
end

function Service_OnShown()
	Service_Clear()
end

function Service_Clear()

	EQUIP_BUTTONS : SetActionItem(-1);
	Service_Item_Explain:SetText("")
	LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
	EQUIP_QUALITY = -1;

end

function Service_Update(pos0)
	local pos_packet;
	pos_packet = tonumber(pos0);

	local theAction = EnumAction(pos_packet, "packageitem");
	
	if theAction:GetID() ~= 0 then
		EQUIP_BUTTONS:SetActionItem(theAction:GetID());
		Service_Item_Explain:SetText(theAction:GetName());
		if EQUIP_QUALITY ~= -1 then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
		--��֮ǰ�Ķ�������
		EQUIP_QUALITY = pos_packet;
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
	else
		EQUIP_BUTTONS:SetActionItem(-1);
		Service_Item_Explain:SetText("")
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
		return;
	end

--add here
end

function Service_Buttons_Clicked()

	if EQUIP_QUALITY ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnService");
			Set_XSCRIPT_ScriptID(801015);
			Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
			Set_XSCRIPT_Parameter(1,Current);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	else
		PushDebugMessage("M�i k�o thi�t b� s�a ch�a v�o trong khoang v�t ph�m.")
	end
	
end

function Service_Close()
	--�����ã��ñ������λ�ñ���
	if( this:IsVisible() ) then
		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
	end
	this:Hide();
	Service_Clear();
	StopCareObject_Service(objCared)
end

function Service_Cancel_Clicked()
	Service_Close();
	return;
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Service(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Service");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Service(objCaredId)
	this:CareObject(objCaredId, 0, "Service");
	g_Object = -1;

end

function Resume_Equip()

	if( this:IsVisible() ) then

		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_BUTTONS : SetActionItem(-1);
			Service_Item_Explain:SetText("")
			EQUIP_QUALITY	= -1;
		end	
	end
	
end
