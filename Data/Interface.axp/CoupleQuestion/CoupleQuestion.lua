local Current = -1;									--ѡ��Ĵ𰸺�
local Question_Max = 0;							--���������
local Question_Sequence = 0;				--�ڼ���
local CoupleQuestion_Buttons = {}		--ÿ���𰸰�ť�ؼ�����
local Button_Answer = {}						--ÿ���𰸰�ť��Ӧ�Ĵ𰸱��
local IsEnableOK = 0;
					

local objCared = -1;								--����NPC��Obj�ı�ţ�Server��������

function CoupleQuestion_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
end

function CoupleQuestion_OnLoad()
	CoupleQuestion_Buttons[1] = CoupleQuestion_Button_1;
	CoupleQuestion_Buttons[2] = CoupleQuestion_Button_2;
	CoupleQuestion_Buttons[3] = CoupleQuestion_Button_3;
end

function CoupleQuestion_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 888901) then
			CoupleQuestion_OnShown();
	end
end

function CoupleQuestion_OnShown()
	local UI_ID = Get_XParam_STR(0);
	
	if UI_ID == "start" then
		Question_Max = Get_XParam_INT(1)
		CoupleQuestion_ShowQuestion()
		this:Show();
	elseif UI_ID == "timeout" or UI_ID == "oknext" or UI_ID == "failnext" then
		IsEnableOK = 0;
		CoupleQuestion_ShowQuestion()
		this:Show();
	elseif UI_ID == "cancel" then
		CoupleQuestion_Cancel_Clicked();
		AxTrace( 0, 0, "UI_ID(1) "..tostring(UI_ID))
		return;
	else
		AxTrace( 0, 0, "UI_ID(2) "..tostring(UI_ID))
		return;
	end
	
	Current = -1;

	CoupleQuestion_Total_StopWatch:SetProperty("Timer", "60");
	CoupleQuestion_ok:Disable();
	CoupleQuestion_StopWatch_Text:SetText("Xin l�a ch�n")
	
end



function CoupleQuestion_ShowQuestion()
	Question_Sequence = Get_XParam_INT(2)
	
	CoupleQuestion_Pageheader : SetText("#gFF0FA0Phu th� v�n ��p");
	CoupleQuestion_NPCName_Text: SetText("T�ng s� c�u h�i:"..tostring(Question_Max))
	CoupleQuestion_Type_Text : SetText("S� c�u h�i tr߾c:"..tostring(Question_Sequence))
	CoupleQuestion_Number_Text:SetText("Ch� s�:"..tostring(Get_XParam_INT(3)))
	CoupleQuestion_Text2:SetText("K�t qu�:"..tostring(Get_XParam_STR(5)))

	CoupleQuestion_Text : SetText(Get_XParam_STR(1));

	for j=1,3 do
		CoupleQuestion_Buttons[j]:SetText("");
		CoupleQuestion_Buttons[j]:Enable();
		CoupleQuestion_Buttons[j]:SetProperty("Selected", "False");
	end
										
	for i=2,4 do
		local str_temp = Get_XParam_STR(i);
		local answer_position = Get_XParam_INT(3+i)
		if  str_temp~= "#" and str_temp~="" then
			CoupleQuestion_Buttons[answer_position] : SetText(str_temp)
			Button_Answer[answer_position] = i-1;
		end
	end
end

function CoupleQuestion_Button_Clicked(nAnswerNumber)
	if nAnswerNumber<=0 or nAnswerNumber > 3 then return; end
	
	--for i=1,3 do
	--	if i == nAnswerNumber then
	--		CoupleQuestion_Buttons[i]:SetProperty("Selected", "True");
	--		Current = Button_Answer[i];
	--	else
	--		CoupleQuestion_Buttons[i]:SetProperty("Selected", "False");
	--	end
	--end
	Current = Button_Answer[nAnswerNumber];
	if Current > 0 then
		CoupleQuestion_ok:Enable();
	else
		CoupleQuestion_ok:Disable();
	end
end

function CoupleQuestion_Quit_Clicked()
	Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("CoupleQuestion_ClientAction");
			Set_XSCRIPT_ScriptID(888901);
			Set_XSCRIPT_Parameter(0,3);
			Set_XSCRIPT_Parameter(1,-1);
			Set_XSCRIPT_Parameter(2,Question_Sequence);	--modi:lby ������ż�����鵱ǰ�����Ƿ������ڴ����
			
			Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	--CoupleQuestion_Cancel_Clicked();
end

function CoupleQuestion_Cancel_Clicked()
	--StopCareObject_CoupleQuestion(objCared)
	this:Hide();
	LifeAbility:CloseStrengthMsgBox();	--modi:lby ���ٵ�ǰ��msg
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_CoupleQuestion(objCaredId)
	this:CareObject(objCaredId, 1, "CoupleQuestion");
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_CoupleQuestion(objCaredId)
	this:CareObject(objCaredId, 0, "CoupleQuestion");
	objCared = -1;
end

function CoupleQuestion_OK_Clicked()
	if Current<0 then return; end
	Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("CoupleQuestion_ClientAction");
			Set_XSCRIPT_ScriptID(888901);
			Set_XSCRIPT_Parameter(0,1);
			Set_XSCRIPT_Parameter(1,Current);
			Set_XSCRIPT_Parameter(2,Question_Sequence);	--modi:lby ������ż�����鵱ǰ�����Ƿ������ڴ����
			Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	CoupleQuestion_ok:Disable();
	IsEnableOK = 1;
	CoupleQuestion_Time_Event:SetProperty("Timer", "5");	--modi:lby ����ȷ����ť��ʱ��
	for j=1,3 do
		CoupleQuestion_Buttons[j]:Disable();
	end
	CoupleQuestion_StopWatch_Text:SetText("�ang ��i �i ph߽ng l�a ch�n")
end

--modi:lby ����ȷ����ť��ʱ��
--��ť��ʱ����Ӧ����
function CoupleQuestion_TimeReach()
	if IsEnableOK ==1 then
	CoupleQuestion_ok:Enable();
	end
end