local g_uitype = 1;
local g_serverScriptId = 311111;
local g_serverNpcId = -1;
local g_clientNpcId = -1;
local g_selidx = -1;						-- ��ǰѡ�������
local g_selidx_jns = -1;				-- ��ǰ������ѡ��ļ����飨Ŀǰ������ֻ��һ��
local	g_selidx_ynd = -1;				-- ��ǰ������ѡ������굤��Ŀǰ������ֻ��һ��
local g_stduySkill = false;			-- �Ƿ��Ѿ�ѧϰ����
local MAX_OBJ_DISTANCE = 3.0;
local g_DefaultTxt = "M�i c�c h� �y nh�ng ��o c� c�n d�ng v�o trong khung ��o c� tr߾c m�t.";
local g_tlvcostmoney = {};
local g_tbabaymoney = {};
local g_petSkillStudyMoreMoney = 990000

local PETSKILLSTUDY_ACCBTN = {};
local FUNCTION_ACCNAME = {};

local UITYPE_LIANSHOUDAN = 800107
local UITYPE_ZHUANXINGDAN = 800108
local CurUIType = -1       --800107Ϊ����ϴ�����

function PetSkillStudy_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_PETSKILLSTUDY");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
--	this:RegisterEvent("CONFIRM_PETSKILLSTUDY");				-- ���¼��� MessageBox_Self �����е� PET_SKILL_STUDY_CONFIRM �¼��д���
end

function PetSkillStudy_OnLoad()
	PETSKILLSTUDY_ACCBTN[1] = {PetSkillStudy_Skill1, "", -1, ""}; --{ActionButton�ؼ�,����������,����ֵ,���ܵ�����}
	--PETSKILLSTUDY_ACCBTN[2] = {PetSkillStudy_Skill2, "", -1, ""};
	--PETSKILLSTUDY_ACCBTN[3] = {PetSkillStudy_Skill3, "", -1, ""};
	
	--"S"		������ѧϰ
	--"R"		��ͯ
	--"A"		�����ӳ�
	--"L"   	���޵�
	FUNCTION_ACCNAME = {"S", "R", "A"};
	g_tlvcostmoney = {
		[5]=1000,
		[15]=3000,
		[25]=5000,
		[35]=7000,
		[45]=9000,
		[55]=11000,
		[65]=13000,
		[75]=15000,
		[85]=17000,
		[95]=19000,
		[105]=21000,
	};
	g_tbabaymoney = {
		[5]=5000,
		[15]=6000,
		[20]=7000,
		[25]=7000,
		[35]=10000,
		[45]=15000,
		[55]=25000,
		[65]=40000,
		[75]=55000,
		[85]=70000,
		[95]=85000,
		[105]=100000,
	};
end

function PetSkillStudy_OnEvent(event)
	
	--�����ã���ӡ����ؼ������������¼�
	--AxTrace( 6, 0, event )
	--PushDebugMessage(event);
	
	if ( event == "UI_COMMAND" ) then
		PetSkillStudy_OnUICommand(arg0);
	elseif( event == "UPDATE_PETSKILLSTUDY" and this:IsVisible()) then
		PetSkillStudy_Update(arg0, arg1);
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		PetSkillStudy_Selected(tonumber(arg0));
	elseif ( event == "UPDATE_PET_PAGE" and this:IsVisible() ) then
		PetSkillStudy_Show();
	elseif ( event == "DELETE_PET" and this:IsVisible() ) then
		PetSkillStudy_Hide();
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetSkillStudy_CareEventHandle(arg0,arg1,arg2);
--	ʹ���µ�����ѧϰ���ܽ��棬�˽��治����Ӧѧϰȷ����Ϣ
--	elseif ( event == "CONFIRM_PETSKILLSTUDY") then
--		PetSkillStudy_ConfirmPetSkillStudy()
	end
end

function PetSkillStudy_OnUICommand(arg0)
	local op = tonumber(arg0);
	CurUIType = -1
	
	--�����ã��жϰ����ĸ�����
	--PushDebugMessage(op);
	
	--���޼���ѧϰ����ͯ���ӳ�������ѱ������ͬһ������
	if( op == 3 ) then
		g_serverNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
		--AxTrace(0,0,"PetSkillStudy_OnUICommand g_clientNpcId:"..tostring(g_clientNpcId));
		this:CareObject(g_clientNpcId, 1, "PetSkillStudy");
		g_uitype = Get_XParam_INT(1);
		g_selidx = -1;
		PetSkillStudy_Hide();							--Ϊ�˱���ʹ�ò�ͬ����ʱ����͵��߻����ڣ��ȹرմ��ڣ������´򿪴���
		PetSkillStudy_Show();		
	
	--����ϴ��	
	elseif( op == UITYPE_LIANSHOUDAN ) then
		g_serverNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
		this:CareObject(g_clientNpcId, 1, "PetSkillStudy");
		CurUIType = op
		g_uitype = -1
		PetSkillStudy_ShowReset()
		
	--elseif( op == UITYPE_ZHUANXINGDAN ) then
	--	g_serverNpcId = Get_XParam_INT(0);
	--	g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
	--	this:CareObject(g_clientNpcId, 1, "PetSkillStudy");
	--	CurUIType = UITYPE_ZHUANXINGDAN
	--	g_uitype = -1
	--	PetSkillStudy_ShowZhuanxingdan()
				
	elseif( op == 4 and 4 == g_uitype) then
		local needMoney = Get_XParam_INT(0);
		--AxTrace(0,0,"needMoney:"..tostring(needMoney));
		PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(needMoney));
		PetSkillStudy_Accept:Enable();
	elseif( op == 4 and 6 == g_uitype) then
		local strRate = Get_XParam_STR(1);
		local sRate = nil;
		--AxTrace(0,0,"PetSkillStudy_OnUICommand "..tostring(strRate));
		if(nil == strRate) then
			strRate = "rat=1.0";
		end
		_,_,sRate = string.find(strRate, "rat=(%d+)");
		PetSkillStudy_ShowPetGrow(tonumber(sRate));
	end
end

function PetSkillStudy_ShowReset()  --��ʾϴ�����
	--�ؼ��������
	
	AxTrace( 1, 0, "PetSkillStudy_ShowReset" )
	
	PetSkillStudy_PetModel:SetFakeObject( "" );
	PetSkillStudy_Unlock();
	for i=1,1 do
			PETSKILLSTUDY_ACCBTN[i][1]: SetPushed(0);
			PETSKILLSTUDY_ACCBTN[i][1]: SetActionItem(-1);

			PETSKILLSTUDY_ACCBTN[i][2] = "";
			PETSKILLSTUDY_ACCBTN[i][3] = -1;
	end
	
	PetSkillStudy_SkillType_Text:SetText("#gFF0FA0T�y �i�m Tr�n th�");
	PetSkillStudy_SkillType_Text:Show();
	PetSkillStudy_Accept:SetText("Duy�t");
	PetSkillStudy_Accept:Enable();

	PetSkillStudy_Money:SetProperty("MoneyNumber", "");
	PetSkillStudy_Money:Hide()
	PetSkillStudy_Static3:SetText("Kh�ng c�n ti�u hao ti�n")
	--PetSkillStudy_Money:Show();
	--PetSkillStudy_Static3:SetText("��Ҫ��Ǯ");
	PetSkillStudy_MultiIMEEditBox:Hide();
	PetSkillStudy_Text1:SetText(g_DefaultTxt);
	PetSkillStudy_Text1:Show();
	
	PetSkillStudy_SetButtonAccName_Reset()
	this:Show();
	Pet:ShowPetList(1);
end
function PetSkillStudy_SetButtonAccName_Reset()  --��ʾϴ�����
	PETSKILLSTUDY_ACCBTN[1][1]:SetProperty("DragAcceptName", "T"..(1).."L" );
end

function PetSkillStudy_ShowZhuanxingdan() --ת�Ե�����
	--�ؼ��������
	PetSkillStudy_PetModel:SetFakeObject( "" );
	PetSkillStudy_Unlock();
	for i=1,1 do
			PETSKILLSTUDY_ACCBTN[i][1]: SetPushed(0);
			PETSKILLSTUDY_ACCBTN[i][1]: SetActionItem(-1);

			PETSKILLSTUDY_ACCBTN[i][2] = "";
			PETSKILLSTUDY_ACCBTN[i][3] = -1;
	end
	
	PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Ho�n �ng �n");
	PetSkillStudy_SkillType_Text:Show();
	PetSkillStudy_Accept:SetText("Duy�t");
	PetSkillStudy_Accept:Enable();

	PetSkillStudy_Money:SetProperty("MoneyNumber", "");
	PetSkillStudy_Money:Hide()
	PetSkillStudy_Static3:SetText("")
	--PetSkillStudy_Money:Show();
	--PetSkillStudy_Static3:SetText("��Ҫ��Ǯ");
	PetSkillStudy_MultiIMEEditBox:Hide();
	PetSkillStudy_Text1:SetText(g_DefaultTxt);
	PetSkillStudy_Text1:Show();
	
	PetSkillStudy_SetButtonAccName_Zhuanxingdan()
	this:Show();
	Pet:ShowPetList(1);
end
function PetSkillStudy_SetButtonAccName_Zhuanxingdan()  
	PETSKILLSTUDY_ACCBTN[1][1]:SetProperty("DragAcceptName", "T"..(1).."Z" );
end



function PetSkillStudy_Show()
	--local nPetCount = Pet : GetPet_Count();
	--local szPetName;
	
	--AxTrace( 1, 0, "PetSkillStudy_Show" )
	--PushDebugMessage ("PetSkillStudy_Show")
	
	--�ؼ��������
	--PetSkillStudy_PetList : ClearListBox();
	--������Ǹ�ѧ�꼼�ܣ���������е����޼������Ϣ(���޼���ѧϰ�����)
	if (g_stduySkill == false) then
		PetSkillStudy_PetModel:SetFakeObject( "" );
		PetSkillStudy_Unlock();
		for i=1,1 do
			PETSKILLSTUDY_ACCBTN[i][1]: SetPushed(0);
			PETSKILLSTUDY_ACCBTN[i][1]: SetActionItem(-1);

			PETSKILLSTUDY_ACCBTN[i][2] = "";
			PETSKILLSTUDY_ACCBTN[i][3] = -1;
		end

		Pet:ClosePetSkillStudyMsgBox()
	end
	
	--���ȫ�������б�
	--for	i=1, nPetCount do
	--	szPetName = Pet : GetPetList_Appoint(i-1);
	--	PetSkillStudy_PetList : AddItem(szPetName, i-1);
	--end
	
	--Ĭ�ϰ����ѡ���һֻ����
	--if(0 ~= nPetCount) then
	--	Pet:SetSkillStudyModel(0);
	--	PetSkillStudy_PetList:SetItemSelectByItemID(0);
	--	PetSkillStudy_PetModel:SetFakeObject( "My_PetStudySkill" );
	--end
	
	Variable:SetVariable("PetStudyType", tostring(g_uitype), 1)
	
--	if(1 == g_uitype) then --��ͨ����ѧϰ
--		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0��ͨ����ѧϰ");
--		PetSkillStudy_SkillType_Text:Show();
--		PetSkillStudy_Accept:SetText("ѧϰ");
--		PetSkillStudy_Accept:Enable();
--		
--		PetSkillStudy_Money:SetProperty("MoneyNumber", "");
--		PetSkillStudy_Money:Show();
--		PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
--		PetSkillStudy_MultiIMEEditBox:Hide();
--		PetSkillStudy_Text1:SetText(g_DefaultTxt);
--		PetSkillStudy_Text1:Show();
--		PetSkillStudy_SetButtonAccName();
		
	if(2 == g_uitype) then	--��ͯ
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Ho�n �ng �n");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Duy�t");
		PetSkillStudy_Accept:Enable();

		PetSkillStudy_Money:SetProperty("MoneyNumber", "");
		PetSkillStudy_Money:Show();
		PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:SetText(g_DefaultTxt);
		PetSkillStudy_Text1:Show();
		PetSkillStudy_SetButtonAccName();
		
	elseif(3 == g_uitype) then --�ӳ�����
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0K�o d�i tu�i th�");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Duy�t");
		PetSkillStudy_Accept:Enable();
		
		PetSkillStudy_Money:Hide();
		PetSkillStudy_Static3:SetText("Kh�ng c�n ph�i ti�u hao ng�n l��ng");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:SetText(g_DefaultTxt);
		PetSkillStudy_Text1:Show();
		PetSkillStudy_SetButtonAccName();
		
	elseif(4 == g_uitype) then --����ѱ��
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Ph� hu�n luy�n");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Ch�i");
		PetSkillStudy_Accept:Disable();
		PetSkillStudy_Money:SetProperty("MoneyNumber", "");
		PetSkillStudy_Money:Show();
		PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:Hide();
--		if( 0 ~= nPetCount ) then
--			PetSkillStudy_AskMoney(0);
--		end

	elseif(5 == g_uitype) then --��������
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0C�c h� chi�n �u");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Duy�t");
		PetSkillStudy_Accept:Enable();
		PetSkillStudy_Money:Hide();
		PetSkillStudy_Static3:SetText("Kh�ng c�n ph�i ti�u hao ng�n l��ng");
		PetSkillStudy_MultiIMEEditBox:SetText("");
		PetSkillStudy_MultiIMEEditBox:Show();
		PetSkillStudy_Text1:Hide();
		
	elseif(6 == g_uitype) then --���������ʲ�ѯ
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Ki�m tra t�ng tr߷ng");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Ki�m");
		PetSkillStudy_Accept:Disable();
		
		PetSkillStudy_Money:SetProperty("MoneyNumber", "100");
		PetSkillStudy_Money:Show();
		PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:SetText("Ki�m tra t� l� tr߷ng th�nh c�a Tr�n Th�"); -- zchw
		PetSkillStudy_Text1:Show();
		
	elseif(7 == g_uitype) then --���޳ƺ���ȡ
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0 L�nh nh�n danh hi�u tr�n th�");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Duy�t");
		PetSkillStudy_Accept:Enable();
		PetSkillStudy_Money:Hide();
		PetSkillStudy_Static3:SetText("Kh�ng c�n ph�i ti�u hao ng�n l��ng");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:SetText("Xin l�a ch�n danh hi�u tr�n th� c�n");
		PetSkillStudy_Text1:Show();
	end
	
	if CurUIType == UITYPE_LIANSHOUDAN then
		PetSkillStudy_ShowReset()
	end
	
	--���޼���ѧϰѧϰ���ɾ���������еļ�����
--	if (1 == g_uitype) then
--		g_selidx_jns = -1;				--�ָ�Ϊδѡ�е������еļ����飨ֻ������޼���ѧϰ��
		--PushDebugMessage ("��������ɾ����")
--	end
	
	--�����ӳ�������ɾ���������е����굤
	if (3 == g_uitype) then
		g_selidx_ynd = -1;				--�ָ�Ϊδѡ�е������е����굤��ֻ��������ӳ�������
		--PushDebugMessage ("���굤��ɾ����")
	end	
		
	this:Show();
	Pet:ShowPetList(1);		-- �������б�
end

function PetSkillStudy_SetButtonAccName()
	if(nil == FUNCTION_ACCNAME[g_uitype]) then
		for i=1,1 do
				PETSKILLSTUDY_ACCBTN[i][1]:SetProperty("DragAcceptName", "T"..i);
		end
	else
		for i=1,1 do
				PETSKILLSTUDY_ACCBTN[i][1]:SetProperty("DragAcceptName", "T"..i..FUNCTION_ACCNAME[g_uitype]);
		end
	end
end

function PetSkillStudy_Test()
	g_uitype = g_uitype + 1;
	if( g_uitype > 6 ) then
		g_uitype = 1;
	end
	PetSkillStudy_Show();
end

--ѡ��ͬ����ʱ�����ò�ͬ������ģ��
function PetSkillStudy_Selected(selidx)
	--local selidx = PetSkillStudy_PetList:GetFirstSelectItem();
	
	--PushDebugMessage (selidx);
	
	if( -1 == selidx ) then
		return;
	end

	if 2 == g_uitype or CurUIType == UITYPE_ZHUANXINGDAN or CurUIType == UITYPE_LIANSHOUDAN then	--��ͯ��ת�ԣ�ϴ��
		if PlayerPackage:IsPetLock(selidx) == 1 then
			PushDebugMessage("�� th�m kh�a v�i Tr�n Th�")
			return
		end
	end

	PetSkillStudy_PetModel:SetFakeObject("");
	Pet:SetSkillStudyModel(selidx);
	Pet:SetPetLocation(selidx,2);
	PetSkillStudy_PetModel:SetFakeObject( "My_PetStudySkill" );

	--���޴�����....
	--�����ǰ��ͳ趼ѡ����....������Ƿ��ǿ��µ��ֶ����ܸ�....����������Ǯ....
--	if( 1 == g_uitype and g_sleidx ~= selidx) then
--		if Pet:CheckPetSkillStudyMoreMoneyMode( selidx, PETSKILLSTUDY_ACCBTN[1][3] ) == 1 then
--			PetSkillStudy_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
--		else
--			local ptlv = Pet:GetTakeLevel(selidx);
--			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
--			PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
--		end
--	end
	
	if( 2 == g_uitype and g_sleidx ~= selidx) then
		local ptlv = Pet:GetTakeLevel(selidx);
		
		local saidx = -1;
		for i=1,1 do
			if(PETSKILLSTUDY_ACCBTN[i][1]:GetProperty("Checked") == "True") then
				saidx = i;
				break;
			end
		end
		
		local itemId = -1;
		if saidx ~= -1 then
			local bagIndex = PETSKILLSTUDY_ACCBTN[saidx][3];
			itemId = PlayerPackage:GetItemTableIndex(bagIndex);
		end
		
		local ptM = PetSkillStudy_GetTakeBabyCostMoney(ptlv, itemId);
		PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
	end	
	
	if( 4 == g_uitype ) then
		PetSkillStudy_AskMoney(selidx);
		PetSkillStudy_Accept:Disable();
	end
	
	if( 6 == g_uitype and g_selidx ~= selidx) then
		PetSkillStudy_Text1:SetText("Ki�m tra t� l� tr߷ng th�nh c�a Tr�n Th� !");
		PetSkillStudy_Accept:Enable();
	end
	
	g_selidx = selidx;	--�Ѿ�ѡ��������

	Pet:ClosePetSkillStudyMsgBox()

end

function PetSkillStudy_AskMoney( selidx )

	if( -1 == selidx ) then
		return;
	end
	
	local hid,lid = Pet:GetGUID(selidx);

	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("PetSkillStudy_Ask_Money");
	Set_XSCRIPT_ScriptID(g_serverScriptId);
	Set_XSCRIPT_Parameter(0,hid);
	Set_XSCRIPT_Parameter(1,lid);
	Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

--����ѡ������ޣ���ʾ��Ӧ����ϸ��Ϣ
--function PetSkillStudy_ShowTargetPet(selidx)
	--local selidx = PetSkillStudy_PetList:GetFirstSelectItem();
--	if( -1 == selidx ) then
--		return;
--	end
	
--	Pet:ShowTargetPet(selidx);
--end

----------------------------------------------------------------------------------
--
-- ��ת����ģ�ͣ�����)
--
function PetSkillStudy_Modle_TurnLeft(start)
	--������ת��ʼ
	if(start == 1) then
		PetSkillStudy_PetModel:RotateBegin(-0.3);
	--������ת����
	else
		PetSkillStudy_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--��ת����ģ�ͣ�����)
--
function PetSkillStudy_Modle_TurnRight(start)
	--������ת��ʼ
	if(start == 1) then
		PetSkillStudy_PetModel:RotateBegin(0.3);
	--������ת����
	else
		PetSkillStudy_PetModel:RotateEnd();
	end
end

-- ��������ѧϰ�����ActionButton
-- aidx  ActionButton������
-- pidx	 ����(Packge)�ڵ���Ʒ����
function PetSkillStudy_Update(aidxs, pidxs)

	--PushDebugMessage ("PetSkillStudy_Update")
	
	local aidx = tonumber(aidxs);
	local pidx = tonumber(pidxs);
	
	if(aidx < 1 or aidx > 1) then
		return;
	end
	
	--���ԭ������������Ʒ
	if("package" == tostring(PETSKILLSTUDY_ACCBTN[aidx][2])) then
		Pet:SkillStudyUnlock(PETSKILLSTUDY_ACCBTN[aidx][3]);
	end
	
	--�����µ���Ʒ
	local action = EnumAction(pidx, "packageitem");
	if(action:GetID() ~= 0) then
		PETSKILLSTUDY_ACCBTN[aidx][1]:SetActionItem(action:GetID());
		PETSKILLSTUDY_ACCBTN[aidx][2] = "package";
		PETSKILLSTUDY_ACCBTN[aidx][3] = pidx;
	end
	
	if 2 == g_uitype and action:GetID() ~= 0 then
		local slidx = g_selidx;
		local ptlv = Pet:GetTakeLevel(slidx);
		local itemId = action:GetDefineID();
		local ptM = PetSkillStudy_GetTakeBabyCostMoney(ptlv, itemId);
		PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
	end
	
	if(1 == g_uitype or 3 == g_uitype or 2 == g_uitype or -1 == g_uitype ) then
		PETSKILLSTUDY_ACCBTN[1][1]:SetPushed(1);
	end

	--���޴�����....
	--�����ǰ��ͳ趼ѡ����....������Ƿ��ǿ��µ��ֶ����ܸ�....����������Ǯ....
--	if 1 == g_uitype and g_selidx ~= -1 and action:GetID() ~= 0 then
--		if Pet:CheckPetSkillStudyMoreMoneyMode( g_selidx, pidx ) == 1 then
--			PetSkillStudy_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
--		else
--			local ptlv = Pet:GetTakeLevel(g_selidx);
--			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
--			PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
--		end
--	end

	--���޼���ѧϰ
--	if (1 == g_uitype) then
--		g_selidx_jns = 1			--��ѧϰ�������Ͻ���������ѡ�е���������ǰ������ֻ��1����ֻ�������ѧϰ���ܣ�
		--PushDebugMessage ("�ѷ��뼼����")
--	end
	
	--�����ӳ�����
	if (3 == g_uitype) then
		g_selidx_ynd = 1			--�����굤�Ͻ���������ѡ�е���������ǰ������ֻ��1����ֻ��������ӳ�������
		--PushDebugMessage ("�ѷ����������굤")
	end	
		
	Pet:ClosePetSkillStudyMsgBox()

end

--����ActionButton�ĵ��
function PetSkillStudy_Btn_Click(aidx)
	if(aidx < 1 or aidx > 1) then
		return;
	end
	
	for i=1,1 do
		if( i == aidx ) then
			PETSKILLSTUDY_ACCBTN[i][1]:SetPushed(1);
		else
			PETSKILLSTUDY_ACCBTN[i][1]:SetPushed(0);
		end
	end
	
end

function PetSkillStudy_PetReset( PetIndex, ItemPos ) --����ϴ��
	
	if (-1 == PetIndex ) then
		PushDebugMessage("Ch�n Th�");
		return;
	end
	if(-1 == ItemPos ) then
		PushDebugMessage("C�n Luy�n Th� �an");
		return;
	end
		
	local hid, lid = Pet:GetGUID(PetIndex);
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("ResetPetAttrPt");
	Set_XSCRIPT_ScriptID( 800107 );
	
	Set_XSCRIPT_Parameter(0,hid);
	Set_XSCRIPT_Parameter(1,lid);
	Set_XSCRIPT_Parameter(2,ItemPos);
	Set_XSCRIPT_ParamCount(3)
	
	Send_XSCRIPT();
	
end

function PetSkillStudy_Zhuanxingdan( PetIndex, ItemPos ) --����ϴ��
	
	if (-1 == PetIndex ) then
		PushDebugMessage("Ch�n Th�");
		return;
	end
	if(-1 == ItemPos ) then
		PushDebugMessage("C�n Chuy�n T�nh �an");
		return;
	end
		
	local hid, lid = Pet:GetGUID(PetIndex);
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("ZhuanXingdian");
	Set_XSCRIPT_ScriptID( UITYPE_ZHUANXINGDAN );
	
	Set_XSCRIPT_Parameter(0,hid);
	Set_XSCRIPT_Parameter(1,lid);
	Set_XSCRIPT_Parameter(2,ItemPos);
	Set_XSCRIPT_ParamCount(3)
	
	Send_XSCRIPT();
	
end


--�������ȷ��Ҫ�������飬����g_uitype
function PetSkillStudy_Do()
	local saidx = -1;	--ActionButtonѡ�е�����
	local slidx = g_selidx;	--ListBoxѡ�е�����
	
	--ף�� 2007-8-17
	--Ŀǰֻ����1��ActionButton�Ͳ�Ҫ��ѭ�����ҵ�ǰ���׼�������ĸ���....
	--��Ҫ��ôŪ�Ļ�....��ʧȥ�����ʱ�����ŵ�����ƷҲ��˵û����Ʒ��....
	--for i=1,1 do
	--	if(PETSKILLSTUDY_ACCBTN[i][1]:GetProperty("Checked") == "True") then
	--		saidx = i;
	--		break;
	--	end
	--end
	--ֱ��˵������ǵ�1��ActionButton������....
	saidx = 1;
	--ף�� 2007-8-17

	--PushDebugMessage ("PetSkillStudy_Do " .. g_uitype);
	
	if CurUIType == UITYPE_LIANSHOUDAN then
		if (-1 == slidx) then
			PushDebugMessage("Ch�n Th�");
			return;
		end
		if(-1 == saidx) then
			PushDebugMessage("C�n Luy�n Th� �an");
			return;
		end
		PetSkillStudy_PetReset( slidx, PETSKILLSTUDY_ACCBTN[saidx][3] )
		PetSkillStudy_Hide()
		return
	end

	if CurUIType == UITYPE_ZHUANXINGDAN then
		if (-1 == slidx) then
			PushDebugMessage("Ch�n Th�");
			return;
		end
		if(-1 == saidx) then
			PushDebugMessage("C�n Chuy�n T�nh �an");
			return;
		end
		PetSkillStudy_Zhuanxingdan( slidx, PETSKILLSTUDY_ACCBTN[saidx][3] )
		PetSkillStudy_Hide()
		return
	end
	
	--slidx = PetSkillStudy_PetList:GetFirstSelectItem();
	--AxTrace(0,0,"saidx: "..saidx.." slidx: "..slidx.." g_uitype: "..g_uitype);
--	if(1 == g_uitype) then
--		--��ͨ����ѧϰ
--		if (-1 == slidx) then
--			PushDebugMessage("��ѡ�����ޡ�");
--			return;
--		end
--		if(-1 == g_selidx_jns) then								-- ��Ϊ����ѡ���ʹ��saidx��Ϊ�˲�Ӱ������ѡ�����ʹ��ֻ������޼���ѧϰ��g_selidx_jns
--			PushDebugMessage("��Ҫ�����顣");
--			return;
--		end
	if(2 == g_uitype) then
		--��ͯ
		if (-1 == slidx) then
			PushDebugMessage("Ch�n Th�");
			return;
		end
		if(-1 == saidx) then
			PushDebugMessage("C�n c� x߽ng s�ng ho�n �ng.");
			return;
		end
	elseif(3 == g_uitype) then
		--�ӳ�����
		if (-1 == slidx) then
			PushDebugMessage("Ch�n Th�");
			return;
		end
		if(-1 == g_selidx_ynd) then								-- ��Ϊ����ѡ���ʹ��saidx��Ϊ�˲�Ӱ������ѡ�����ʹ��ֻ��������ӳ�������g_selidx_ynd
			PushDebugMessage("#{ZSSM_090113_01}");	-- "������������굤��"
			return;
		end
	elseif(4 == g_uitype) then
		--ѱ��
		if (-1 == slidx) then
			PushDebugMessage("Ch�n Th�");
			return;
		end
	elseif(5 == g_uitype) then
		--����������Ϣ
		if (-1 == slidx) then
			PushDebugMessage("Ch�n Th�");
			return;
		end
	else
		--����ɶ
		--PetSkillStudy_Hide();
		--return;
	end
	
	--����g_uitype������
	--�ӳ�����
	if(3 == g_uitype) then
		Pet:SkillStudy_Do(g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3]);
	--���޼���ѧϰ
--	elseif(1 == g_uitype) then
--		local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--�����ռ� Vega
--		local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"));
--		if( pM < nM) then
--			PushDebugMessage("��Ǯ�������޷�ѧϰ����");
--			return;
--		end
--		
--		-- �����ѧϰ������ͬ����ֶ�����
--		if Pet:CheckPetSkillStudyMoreMoneyMode( slidx, PETSKILLSTUDY_ACCBTN[saidx][3] ) == 1 then
--			Pet:OpenPetSkillStudyMsgBox()				-- ֪ͨ�ͻ��˵��� MessageBox_Self ����
--			--PushDebugMessage ("ת�� MessageBox_Self ����")
--			return
--		else			
--			Pet:SkillStudy_Do(g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3]);			
--			g_stduySkill = true;	--�Ѿ�ѧ������			
--			--PushDebugMessage("������Ϣ��������ѧ��	");	
--		end
	--��ͯ
	elseif(2 == g_uitype) then
		local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") ;          --�����ռ� Vega
		local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"));
		--AxTrace(0,0,"Money pM:" .. tostring(pM) .. " nM:" .. tostring(nM));
		if( pM >= nM) then
		        Pet:SkillStudy_Do(g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3]);
		else
			PushDebugMessage("Kh�ng �� ng�n l��ng,kh�ng th� ho�n �ng");
			return;
		end
	--ѱ��
	elseif(4 == g_uitype) then
		local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--�����ռ� Vega
		local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"));
		--AxTrace(0,0,"Money pM:" .. tostring(pM) .. " nM:" .. tostring(nM));
		if(100 == tonumber(Pet:GetHappy(slidx)) ) then	--and tonumber(Pet:GetHP(slidx)) == tonumber(Pet:GetMaxHP(slidx))
			PushDebugMessage("Kh�ng c�n thu�n d��ng");
			return;
		end
		
		if( pM >= nM) then
			local hid,lid = Pet:GetGUID(slidx);
			Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PetSkillStudy_Domestication");
			Set_XSCRIPT_ScriptID(g_serverScriptId);
			Set_XSCRIPT_Parameter(0,hid);
			Set_XSCRIPT_Parameter(1,lid);
			Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		else
			PushDebugMessage("Kh�ng �� ng�n l��ng,kh�ng th� hu�n luy�n");
			return;
		end
	elseif(5 == g_uitype) then
		local txt = PetSkillStudy_MultiIMEEditBox:GetText();
		local ret = Pet:SkillStudy_Do(g_uitype, slidx, txt, g_serverNpcId);
		--AxTrace(0,0, "txt{" .. txt .. "} ret{" .. tostring(ret) .. "}");
		if(0 == ret) then
			PushDebugMessage("M�i ��ng nh�p t� qu�ng c�o c�a chi�n h�u");
			return;
		end
	elseif(6 == g_uitype and -1 ~= slidx) then
		local hid,lid = Pet:GetGUID(slidx);
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnInquiryForGrowRate");
		Set_XSCRIPT_ScriptID(1050);
		Set_XSCRIPT_Parameter(0,hid);
		Set_XSCRIPT_Parameter(1,lid);
		Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		return;
	elseif(7 == g_uitype and -1 ~= slidx) then
		local hid,lid = Pet:GetGUID(slidx);
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnAcceptPetTitle");
		Set_XSCRIPT_ScriptID(1031);
		Set_XSCRIPT_Parameter(0,g_serverNpcId);
		Set_XSCRIPT_Parameter(1,hid);
		Set_XSCRIPT_Parameter(2,lid);
		Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();
		--��Ҫ�رս���
		--return;
	end
	
	--��ͯ������ѧϰ���ܺ󴰿ڲ��ر�
	if (2 ~= g_uitype) and (1 ~= g_uitype) then
		PetSkillStudy_Hide();
	end
	
	--���������ѧϰ����
	--if (1 == g_uitype) then		
	--	Pet:ShowPetList(1)		--�ٴδ������б�
	--end	
	
end

--��������ǰ�Ƚ������б���������Ʒ����
function PetSkillStudy_Unlock()
	for i=1,1 do
		if("package" == tostring(PETSKILLSTUDY_ACCBTN[i][2])) then
			Pet:SkillStudyUnlock(PETSKILLSTUDY_ACCBTN[i][3]);
		end
	end
	
	Pet:SkillStudy_MenPaiSkill_Clear();
end

--�������غ���
function PetSkillStudy_Hide()

	Pet:ClosePetSkillStudyMsgBox()

	this:CareObject(g_clientNpcId, 0, "PetSkillStudy");
	
	PetSkillStudy_Unlock();
	this:Hide();
	Pet:ShowPetList(-1);
	g_selidx = -1;
	g_stduySkill = false;
	
end

--�����������ɼ�����ص�action������ui�ϵ�button������
function PetSkillStudy_GenMenPaiSkill()
	--if(2 == g_uitype) then
	--	--����action
	--	for i=2,4 do
	--		PETSKILLSTUDY_ACCBTN[i-1][2] = "menpai";
	--		PETSKILLSTUDY_ACCBTN[i-1][3] = Get_XParam_INT(i);
	--	end
	--	
	--	Pet:SkillStudy_MenPaiSkill_Created(PETSKILLSTUDY_ACCBTN[1][3],PETSKILLSTUDY_ACCBTN[2][3],PETSKILLSTUDY_ACCBTN[3][3]);
	--	
	--	--����action
	--	for k=1,3 do
	--		local action = Pet:EnumPetSkill(-4444, k-1, "petskill");
	--		if(action:GetID() ~= 0) then
	--			PETSKILLSTUDY_ACCBTN[k][1]:SetActionItem(action:GetID());
	--		end		
	--	end
	--	
	--end
end

function PetSkillStudy_Frame_OnHiden()

	Pet:ClosePetSkillStudyMsgBox()
	PetSkillStudy_MultiIMEEditBox:SetProperty("DefaultEditBox", "False");
	this:CareObject(g_clientNpcId, 0, "PetSkillStudy");
	PetSkillStudy_Unlock();
	this:Hide();
	Pet:ShowPetList(-1);
	g_selidx = -1;
	g_stduySkill = false;
	
end

function PetSkillStudy_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetSkillStudy_Hide();
		end
end

function PetSkillStudy_ShowPetGrow(nGrowLevel)
	local strTbl = {"S� c�p","Xu�t s�c","Ki�t xu�t","Tr�c vi�t","To�n m�"};
	if(nGrowLevel >= 1 and nGrowLevel <= table.getn(strTbl)) then
		if(strTbl[nGrowLevel]) then
			PetSkillStudy_PetModel:SetFakeObject("");
			Pet:SetSkillStudyModel(g_selidx);
			Pet:SetPetLocation(g_selidx,2);
			PetSkillStudy_PetModel:SetFakeObject( "My_PetStudySkill" );
			
			PetSkillStudy_Text1:SetText("S� tr߷ng th�nh c�a tr�n th� n�y #R"..strTbl[nGrowLevel]..".");
			PetSkillStudy_Accept:Disable();
		end
	end
end

function PetSkillStudy_GetTakeLevelCostMoney(ptlv)
	if(nil == ptlv) then return 0; end
	if(nil == g_tlvcostmoney[ptlv]) then return 0; end
	
	return g_tlvcostmoney[ptlv];
end

function PetSkillStudy_GetTakeBabyCostMoney(ptlv, itemId)
	if(nil == ptlv) then return 0; end
	if(nil == g_tbabaymoney[ptlv]) then return 0; end
	
	local costMoney = g_tbabaymoney[ptlv];
	
	--AxTrace(0, 0, "costMoney="..costMoney.."��");
	
	--�ռ���ͯ�����շѽ���90%
	if itemId and itemId ~= -1 then
		--AxTrace(0, 0, "itemId="..itemId.."��");
		if itemId == 30503011 or itemId == 30503012 then
			--���޻�ͯ����/�߼����޻�ͯ����
		elseif itemId == 30503016 or itemId == 30503017 or itemId == 30503018 or itemId == 30503019 or itemId == 30503020 then
			--�ռ����޻�ͯ����
			costMoney = (costMoney * 90) / 100;
			if costMoney <= 0 then
				costMoney = 1;
			end
		else
			--���� ��ͯ��������
			costMoney = costMoney / 100;
			if costMoney <= 0 then
				costMoney = 1;
			end
		end
	end
	--AxTrace(0, 0, "ret costMoney="..costMoney.."��");
	
	return costMoney;
end

--���޼���ѧϰ��������ͬ���ֶ�����ȷ�ϡ�ѧϰ�������¼��� MessageBox_Self �����е� PET_SKILL_STUDY_CONFIRM �¼��д�����
function PetSkillStudy_ConfirmPetSkillStudy()

	--PushDebugMessage ("PetSkillStudy_ConfirmPetSkillStudy")

	local saidx = g_selidx_jns
	local slidx = g_selidx

	--��ǰ�Ƿ������޼���ѧϰ����....
	if 1 ~= g_uitype then
		return
	end

	if (-1 == slidx) then
		PushDebugMessage("Ch�n Th�")
		return
	end

	if(-1 == saidx) then
		PushDebugMessage("C�n s�ch k� n�ng.")
		return
	end

	local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")   --�����ռ� Vega
	local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"))
	if pM < nM then
		PushDebugMessage("Kh�ng �� ng�n l��ng,kh�ng th� h�c ch�c n�ng")
		return
	end

	Pet:SkillStudy_Do( g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3] )

	g_stduySkill = true;	--�Ѿ�ѧ������
	--PushDebugMessage("������Ϣ���ֶ�������ѧ�ᡣ");

end
