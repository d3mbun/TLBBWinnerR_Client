local Current = -1;
local Question = 0;
local Question_Sequence = 0;
local Examination_Buttons = {}
local Button_Answer = {}
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;
local HaveClicked = 0
function Examination_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function Examination_OnLoad()
	Examination_Buttons[1] = Examination_Button_1;
	Examination_Buttons[2] = Examination_Button_2;
	Examination_Buttons[3] = Examination_Button_3;
	Examination_Buttons[4] = Examination_Button_4;
	Examination_Buttons[5] = Examination_Button_5;

end

function Examination_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 28) then
			Examination_OnShown();
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		
		if(tonumber(arg0) ~= objCared) then
			return
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			Examination_Cancel_Clicked()
		end
	end
end

function Examination_OnShown()
	--Examination_StopWatch : Hide()
	local UI_ID = Get_XParam_INT(0);
	local need_money = Get_XParam_INT(2);

	if UI_ID == 1 then

			Examination_Text : SetText("#r Sao? Mu�n tham gia Khoa C� Kh�o Th�? Trong th�i bu�i tr�ng v� n�y, v�n nh�n ch�ng ta th�t kh� s�ng? Th�i, kh�ng n�i n�a, c�c h� mu�n tham gia khoa c� c�n ti�u hao #{_EXCHG"..need_money.."} ph� b�o danh");
			Examination_Button_1 : Show();
			Examination_Button_1 : SetText("T�t r�i, ��y l� ph� b�o danh")
			Examination_Button_2 : Show();
			Examination_Button_2 : SetText("T�i ngh� l�i...")
			Examination_Button_3 : Hide();
			Examination_Button_4 : Hide();
			Examination_Button_5 : Hide();
			
			--Examination_StopWatch : Hide()
			Examination_NPCName_Text : Hide()
			Examination_Type_Text : Hide()
			Examination_Number_Text : Hide()
			Examination_Fault_Text : Hide()
			
			Examination_Pageheader : SetText("#gFF0FA0Thi c�"..Get_XParam_STR(0));
			
			local xx = Get_XParam_INT(1);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if objCared == -1 then
					PushDebugMessage("Server v�n � s� li�u");
					return;
			end
			BeginCareObject_Examination(objCared)
			
			Current = UI_ID;
			this:Show();
	elseif UI_ID == 2 then

			Question = Get_XParam_INT(2)
			Question_Sequence = Get_XParam_INT(1)

			local NPCName =	Target:GetDialogNpcName();
			Examination_NPCName_Text: SetText(NPCName.."(T�ng c�ng 10 c�u)")
			Examination_NPCName_Text:Show()
			Examination_Pageheader : SetText("#gFF0FA0Thi c�");
			Examination_Pageheader : Show()
			Examination_Text : SetText(Get_XParam_STR(0) .. "#rT�t c� ��p �n tr�n ch� c� m�t c�u l� ch�nh x�c, h�y suy ngh� k� tr߾c khi ch�n");
			Examination_Text : Show();
			Examination_Type_Text : SetText("Lo�i h�nh: "..Get_XParam_STR(7))
			Examination_Type_Text : Show();
			Examination_Number_Text : SetText("Th� "..Question_Sequence.."C�u ")
			Examination_Number_Text : Show();
			--Examination_StopWatch : SetProperty("Timer","30");
			--Examination_StopWatch : Show();
			Examination_Fault_Text : SetText("S� l�n tr� l�i sai c�n l�i     "..Get_XParam_INT(10))
			Examination_Fault_Text : Show()
											
			for i=1,3 do
				local str_temp = Get_XParam_STR(i);
				local answer_position = Get_XParam_INT(2+i)
				if  str_temp~= "#" and str_temp~="" then
					Examination_Buttons[answer_position+1] : Show();
					Examination_Buttons[answer_position+1] : SetText(str_temp)
					Button_Answer[answer_position+1] = i;
				end
			end

			if Get_XParam_INT(11) == 0 then			
				Examination_Buttons[4] : Show();
				Examination_Buttons[4] : SetText("#cFFCC99H�i l� gi�m quan")
			else
				Examination_Buttons[4] : Hide();
			end

			if Get_XParam_INT(12) == 0 then	
				Examination_Buttons[5] : Show();
				Examination_Buttons[5] : SetText("#cFFCC99D�ng v� � n�i chuy�n")
			else
				Examination_Buttons[5] : Hide();
			end
			HaveClicked = 0
			
			local xx = Get_XParam_INT(13);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if objCared == -1 then
					return;
			end
			BeginCareObject_Examination(objCared)
			Current = UI_ID;
			this:Show();
	elseif UI_ID == 3 then

			Examination_Pageheader : SetText("#gFF0FA0Thi c�");
			Examination_Text : SetText("Th�t ��ng ti�c, c�u tr� l�i c�a c�c h� �� sai. Th�i ��ng n�n l�ng, c� g�ng l�n sau nh�");
			Question_Sequence = 0;
			Examination_Button_1 : Show();
			Examination_Button_1 : SetText("B�t �u ki�m tra");
			Examination_Button_2 : Hide();
			Examination_Button_3 : Hide();
			Examination_Button_4 : Hide();
			Examination_Button_5 : Hide();
			
			--Examination_StopWatch : Hide()
			Examination_NPCName_Text : Hide()
			Examination_Type_Text : Hide()
			Examination_Number_Text : Hide()
			Examination_Fault_Text : Hide()
			
			Current = UI_ID;
			this:Show();
		elseif UI_ID == 4 then

			Examination_Pageheader : SetText("#gFF0FA0Thi c�");
			Examination_Text : SetText("Ch�c m�ng c�c h� tr� l�i ��ng t�t c� c�c c�u h�i!#rL�n sau ��ng qu�n nh� ti�p t�c tham gia ^_^");
			Examination_Button_2 : SetText("T�m bi�t")
			Examination_Button_2 : Show();
			Examination_Button_1 : Hide();
			Examination_Button_3 : Hide();
			Examination_Button_4 : Hide();
			Examination_Button_5 : Hide();
			
			--Examination_StopWatch : Hide()
			Examination_NPCName_Text : Hide()
			Examination_Type_Text : Hide()
			Examination_Number_Text : Hide()
			Examination_Fault_Text : Hide()
			
			Current = UI_ID;
			this:Show();
	end
	Examination_Time_Text : Show();			
	Examination_Time_Text : SetProperty("Timer","1");
	Examination_Button_1:Disable()
	Examination_Button_2:Disable()
	Examination_Button_3:Disable()
end

function Examination_Button_Clicked(nAnswerNumber)

	if nAnswerNumber == 1 and Current == 1 then
		Question_Sequence = 0
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AskQuestion");
				Set_XSCRIPT_ScriptID(801016);
				Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
		return
	end
	
	if nAnswerNumber == 2 and Current == 1 then
		this : Hide()
		return
	end

	if nAnswerNumber == 1 and Current == 3 then
		Question_Sequence = 0
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AskQuestion");
				Set_XSCRIPT_ScriptID(801016);
				Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
		return
	end

	if nAnswerNumber == 2 and Current == 4 then
		Examination_Cancel_Clicked();
		return;
	end
	
	if Question > 0 then
		if nAnswerNumber > 0 and nAnswerNumber < 4 then
			if HaveClicked == 1 then
				return
			end
			HaveClicked = 1
			Examination_Button_1 : Hide();
			Examination_Button_2 : Hide();
			Examination_Button_3 : Hide();
			Examination_Button_4 : Hide();
			Examination_Button_5 : Hide();
			
			--Examination_StopWatch : Hide()
			Examination_NPCName_Text : Hide()
			Examination_Type_Text : Hide()
			Examination_Number_Text : Hide()
			Examination_Fault_Text : Hide()
			
			Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("AnswerQuestion");
					Set_XSCRIPT_ScriptID(801016);
					Set_XSCRIPT_Parameter(0,Question);
					Set_XSCRIPT_Parameter(1,Button_Answer[nAnswerNumber]);
					Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
			return
		elseif nAnswerNumber == 4 then
			Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("OnBribe");
					Set_XSCRIPT_ScriptID(801016);
					Set_XSCRIPT_Parameter(0,Question);
					Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
			return
		elseif nAnswerNumber == 5 then
			Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("OnDefaultEvent");
					Set_XSCRIPT_ScriptID(801018);
					Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();
			StopCareObject_Examination(objCared)
			this:Hide();
			return
		end
	end

end

function Examination_Cancel_Clicked()

	if Current == 4 and Question > 0 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnOverTime");
			Set_XSCRIPT_ScriptID(801016);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	end
	
	StopCareObject_Examination(objCared)
	this:Hide();
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Examination(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Examination");
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Examination(objCaredId)
	this:CareObject(objCaredId, 0, "Examination");
	g_Object = -1;

end

--��ʱ��0��
function Examination_OverTime()
--	Clear_XSCRIPT();
--			Set_XSCRIPT_Function_Name("OnOverTime");
--			Set_XSCRIPT_ScriptID(801016);
--			Set_XSCRIPT_ParamCount(0);
--	Send_XSCRIPT();
end

--��ʱ��0��
function Examination_TimeOut()
		Examination_Button_1:Enable()
		Examination_Button_2:Enable()
		Examination_Button_3:Enable()
		--this:Hide();
end
