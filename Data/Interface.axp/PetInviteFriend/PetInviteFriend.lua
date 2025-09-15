local g_Invite = {};
local g_serverNpcId = -1;
local g_clientNpcId = -1;
local g_serverScriptId = 311111;
local MAX_OBJ_DISTANCE = 3.0;

--���ÿؼ����ں���lua��ʹ��
function PetInviteFriend_SetInviteCtl()
	g_Invite[1] = {
									model = PetInviteFriend_PetModel1, 
									id = PetInviteFriend_Pet1_ID,
									name = PetInviteFriend_Pet1_Name,
									menpai = PetInviteFriend_Pet1_ManPai,
									level = PetInviteFriend_Pet1_Level,
									guild = PetInviteFriend_Pet1_Confraternity,
									msg = PetInviteFriend_Pet1_MessageBoard,
									view = PetInviteFriend_Pet1_Investigate,
									mail = PetInviteFriend_Pet1_Acquaintance,
									left = PetInviteFriend_PetModel1_TurnLeft,
									right = PetInviteFriend_PetModel1_TurnRight,
								};
								
	g_Invite[2] = {
									model = PetInviteFriend_PetModel2,
									id = PetInviteFriend_Pet2_ID,
									name = PetInviteFriend_Pet2_Name,
									menpai = PetInviteFriend_Pet2_ManPai,
									level = PetInviteFriend_Pet2_Level,
									guild = PetInviteFriend_Pet2_Confraternity,
									msg = PetInviteFriend_Pet2_MessageBoard,
									view = PetInviteFriend_Pet2_Investigate,
									mail = PetInviteFriend_Pet2_Acquaintance,
									left = PetInviteFriend_PetModel2_TurnLeft,
									right = PetInviteFriend_PetModel2_TurnRight,
								};
	g_Invite.prevbtn = PetInviteFriend_PageUp;
	g_Invite.nextbtn = PetInviteFriend_PageDown;
end

function PetInviteFriend_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
end

function PetInviteFriend_OnLoad()
end

function PetInviteFriend_OnEvent(event)
	PetInviteFriend_SetInviteCtl();
	if(event == "UI_COMMAND") then
		local op = tonumber(arg0);
		if(op == 5) then
			g_serverNpcId = Get_XParam_INT(0);
			g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
			PetInviteFriend_Clear_All();
			this:Show();
			this:CareObject(g_clientNpcId, 1, "PetInviteFriend");
			PetInviteFriend_PageBtnDisable();
		end
	elseif(event == "UPDATE_PETINVITEFRIEND") then
		if("invite" == arg0) then
			PetInviteFriend_Clear_All();
			local num = PetInviteFriend:GetInviteNum();
			for i=1,num do
				PetInviteFriend_Update(i);
			end
			PetInviteFriend_PageBtnEnable();
		end
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetInviteFriend_CareEventHandle(arg0,arg1,arg2);
	end
end

function PetInviteFriend_Clear_All()
	for i=1,2 do
		PetInviteFriend_Clear(i);
	end
end

function PetInviteFriend_Clear( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end

	--���ģ��
	g_Invite[idx].model:SetFakeObject( "" );

	--�������
	g_Invite[idx].id:SetText("");
	g_Invite[idx].name:SetText("");
	g_Invite[idx].menpai:SetText("");
	g_Invite[idx].level:SetText("");
	g_Invite[idx].guild:SetText("");
	g_Invite[idx].msg:SetText("");
	
	--��ť����
	g_Invite[idx].view:Disable();
	g_Invite[idx].mail:Disable();
	g_Invite[idx].left:Disable();
	g_Invite[idx].right:Disable();
end

function PetInviteFriend_PageBtnEnable()
	g_Invite.prevbtn:Enable();
	g_Invite.nextbtn:Enable();
end

function PetInviteFriend_PageBtnDisable()
	g_Invite.prevbtn:Disable();
	g_Invite.nextbtn:Disable();
end

function PetInviteFriend_Hide()
	this:CareObject(g_clientNpcId, 0, "PetInviteFriend");
	PetInviteFriend_Clear_All();
	this:Hide();
end

function PetInviteFriend_Update( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end
	--��������������Ϣ
	local strTxt = PetInviteFriend:GetHumanINFO(idx, "GUID");
	g_Invite[idx].id:SetText(strTxt);
	
	strTxt = PetInviteFriend:GetHumanINFO(idx, "NAME");
	g_Invite[idx].name:SetText(strTxt);
	
	strTxt = tostring(PetInviteFriend:GetHumanINFO(idx, "LEVEL"));
	g_Invite[idx].level:SetText(strTxt);
	
	strTxt = PetInviteFriend:GetHumanINFO(idx, "GUILD");
	if( "" == strTxt or nil == strTxt) then
		--strTxt = "???"
		strTxt = "";
	end
	g_Invite[idx].guild:SetText(strTxt);
	
	strTxt = PetInviteFriend_ConvertNumToMenPai(PetInviteFriend:GetHumanINFO(idx, "MENPAI"));
	g_Invite[idx].menpai:SetText(strTxt);
	
	--�������޵�������Ϣ
	strTxt = PetInviteFriend:GetInviteMsg(idx);
	g_Invite[idx].msg:SetText(strTxt);
	
	--��������ģ��
	PetInviteFriend:SetPetModel(idx);
	strTxt = "My_PetInviteFriend0" .. tostring(idx);
	g_Invite[idx].model:SetFakeObject(strTxt);
	
	--���ð�ť
	g_Invite[idx].view:Enable();
	g_Invite[idx].mail:Enable();
	g_Invite[idx].left:Enable();
	g_Invite[idx].right:Enable();	
end

function PetInviteFriend_ConvertNumToMenPai( MenPaiId )
	local strMenPai = "Kh�ng c�";
	-- �õ���������.
	if(0 == MenPaiId) then
		strMenPai = "Thi�u L�m";

	elseif(1 == MenPaiId) then
		strMenPai = "Minh Gi�o";

	elseif(2 == MenPaiId) then
		strMenPai = "C�i Bang";

	elseif(3 == MenPaiId) then
		strMenPai = "V� �ang";

	elseif(4 == MenPaiId) then
		strMenPai = "Nga My";

	elseif(5 == MenPaiId) then
		strMenPai = "Tinh T�c";

	elseif(6 == MenPaiId) then
		strMenPai = "Thi�n Long";

	elseif(7 == MenPaiId) then
		strMenPai = "Thi�n S�n";

	elseif(8 == MenPaiId) then
		strMenPai = "Ti�u Dao";

	elseif(10 == MenPaiId) then
		strMenPai = "M� Dung";
	end
	
	return strMenPai;
end
----------------------------------------------------------------------------------
--
-- ��ת����ģ�ͣ�����)
--
function PetInviteFriend_Modle_TurnLeft(modelIdx, start)
	
	if(modelIdx <= 2 and modelIdx > 0) then
		--������ת��ʼ
		if(start == 1) then
			g_Invite[modelIdx]["model"]:RotateBegin(-0.3);
		--������ת����
		else
			g_Invite[modelIdx]["model"]:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ģ�ͣ�����)
--
function PetInviteFriend_Modle_TurnRight(modelIdx, start)
	if(modelIdx <= 2 and modelIdx > 0) then
		--������ת��ʼ
		if(start == 1) then
			g_Invite[modelIdx]["model"]:RotateBegin(0.3);
		--������ת����
		else
			g_Invite[modelIdx]["model"]:RotateEnd();
		end
	end
end

--��ѯ���޵���ϸ��Ϣ
function PetInviteFriend_ShowTargetFrame( idx )
	if(idx < 0 and idx > 2) then
		return;
	end
	
	PetInviteFriend:ShowTargetPet(idx);
end

--��ѯ��һƪ������������Ϣ
function PetInviteFriend_PrevPage()
	--��õ�ǰҳ��Ϣ
	local num = PetInviteFriend:GetInviteNum();
	local guid1=0;
	local guid2=0;
	local tmp;

	if(num == 1) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
	elseif(num == 2) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
		tmp,guid2 = PetInviteFriend:GetHumanINFO(2, "GUID");
	end
	
	--֪ͨ�����������µ���Ϣ����
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("PetInviteFriend_Ask_NewPage");
	Set_XSCRIPT_ScriptID(g_serverScriptId);
	Set_XSCRIPT_Parameter(0,g_serverNpcId);
	Set_XSCRIPT_Parameter(1,guid1);
	Set_XSCRIPT_Parameter(2,guid2);
	Set_XSCRIPT_Parameter(3,0);
	Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();	
end

--��ѯ��һƪ������������Ϣ
function PetInviteFriend_NextPage()
	--��õ�ǰҳ��Ϣ
	local num = PetInviteFriend:GetInviteNum();
	local guid1=0;
	local guid2=0;
	local tmp;

	if(num == 1) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
	elseif(num == 2) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
		tmp,guid2 = PetInviteFriend:GetHumanINFO(2, "GUID");
	end
	
	--֪ͨ�����������µ���Ϣ����
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("PetInviteFriend_Ask_NewPage");
	Set_XSCRIPT_ScriptID(g_serverScriptId);
	Set_XSCRIPT_Parameter(0,g_serverNpcId);
	Set_XSCRIPT_Parameter(1,guid2);
	Set_XSCRIPT_Parameter(2,guid1);
	Set_XSCRIPT_Parameter(3,1);
	Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();	
end

--���������˷��ʼ���˵��������
function PetInviteFriend_SendMail( idx )
	if(idx < 0 and idx > 2) then
		return;
	end
	local strOHuman = PetInviteFriend:GetHumanINFO(idx, "NAME");
	local strOPet		= PetInviteFriend:GetPetINFO(idx, "NAME");
	local strUser = Player:GetName();

	if(strUser == strOHuman) then
		--���ܽ�ʶ�Լ�������
		PushDebugMessage("Kh�ng th� giao l�u ���c v�i th� qu� c�a ch�nh b�n th�n.");
	else
		--֪ͨ�Լ�
		PushDebugMessage("�� ph�t t�n hi�u th�nh c�u k�t b�n.");
		--�����ʼ�
		DataPool:SendMail(strOHuman, strUser .. "Mu�n nh�n th�c c�a b�n"  .. strOPet .. "]!!!" );
		--���ͽ�ʶͳ����Ϣ
		PetInviteFriend : SendAuditMsg(g_serverNpcId);
	end
end

function PetInviteFriend_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetInviteFriend_Hide();
		end
end