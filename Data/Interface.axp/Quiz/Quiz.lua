local Current = -1;
local Question = 0;
local Question_Sequence = 0;
local Quiz_Buttons = {}
local Button_Answer = {}
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

--��ǰ�������ĸ�����....
-- 1 = Ǯ����������������....
-- 2 = 2007ʥ��Ԫ��--���ֳ齱�������....
-- 3 = 2007ʥ��Ԫ��--����ʱ����....
-- 4 = 2007Ԫ����--���մ������....
local g_UIType = 0

local g_UIServerScript = { 311100, 050021, 050029, 050042, 808093, 250042 }

local g_Quiz_Frame_UnifiedPosition;

function Quiz_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Quiz_OnLoad()
	Quiz_Buttons[1] = Quiz_Button_1;
	Quiz_Buttons[2] = Quiz_Button_2;
	Quiz_Buttons[3] = Quiz_Button_3;
	
	g_Quiz_Frame_UnifiedPosition=Quiz_Frame:GetProperty("UnifiedPosition");
end

function Quiz_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 2 then
			g_UIType = 1
		elseif tonumber(arg0) == 20071224 then
			g_UIType = 2
		elseif tonumber(arg0) == 271261215 then
			g_UIType = 3
		elseif tonumber(arg0) == 20080221 then
			g_UIType = 4
		elseif tonumber(arg0) == 20080419 then
			g_UIType = 5
		elseif tonumber(arg0) == 20090627 then
			g_UIType = 6
		else
			return
		end
		Quiz_OnShown();

	elseif (event == "OBJECT_CARED_EVENT") then

		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Quiz_Cancel_Clicked()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		Quiz_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Quiz_Frame_On_ResetPos()

	end
end

function Quiz_OnShown()

	Quiz_StopWatch : Hide()
	local UI_ID = Get_XParam_INT(0);

	if UI_ID == 1 then

			Quiz_Text : SetText( Get_XParam_STR(1) );
			Quiz_Button_1 : Show();
			Quiz_Button_1 : SetText("B�t �u tr� l�i")
			Quiz_Button_2 : Hide();
			Quiz_Button_3 : Hide();
			Quiz_Pageheader : SetText( Get_XParam_STR(0) );
			
			local xx = Get_XParam_INT(1);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if objCared == -1 then
					PushDebugMessage("V�n � s� li�u m�y ch�, ai s�a k�ch b�n m�y ch� a!");
					return;
			end
			BeginCareObject_Quiz(objCared)

			Current = UI_ID;
			this:Show();

	elseif UI_ID == 2 then

			Question = Get_XParam_INT(2)
			Question_Sequence = Get_XParam_INT(1)
			if Question_Sequence == 1 then
				str = "";
			else
				str = "Ch�c m�ng c�c h� �� tr� l�i ch�nh x�c!#rM�i ti�p t�c tr� l�i...#r";
			end
			if(Variable:GetVariable("System_CodePage") == "1258") then
				Quiz_Text : SetText(str .. "C�u " .. "Th� " .. Question_Sequence .. Get_XParam_STR(0) .. "#rT�t c� ��p �n tr�n ch� c� m�t c�u l� ch�nh x�c, h�y suy ngh� k� tr߾c khi ch�n");
			else
				Quiz_Text : SetText(str .. "Th� " .. Question_Sequence .."Ы: #r" .. Get_XParam_STR(0) .. "#rT�t c� ��p �n tr�n ch� c� m�t c�u l� ch�nh x�c, h�y suy ngh� k� tr߾c khi ch�n");
			end
		
			Quiz_StopWatch : SetProperty("Timer","30");
			Quiz_StopWatch : Show();
		
			for i=1,3 do
				local str_temp = Get_XParam_STR(i);
				local answer_position = Get_XParam_INT(2+i)
				if  str_temp~= "#" and str_temp~="" then
					Quiz_Buttons[answer_position+1] : Show();
					Quiz_Buttons[answer_position+1] : SetText(str_temp)
					Button_Answer[answer_position+1] = i;
				else
					Quiz_Buttons[answer_position+1] : Hide();
				end
			end
			Current = UI_ID;
			this:Show();

	elseif UI_ID == 3 then

			Quiz_Text : SetText( Get_XParam_STR(0) );
			Question_Sequence = 0;
			Quiz_Button_1 : Show();
			Quiz_Button_1 : SetText("B�t �u ki�m tra");
			Quiz_Button_2 : Hide();
			Quiz_Button_3 : Hide();
			Current = UI_ID;
			this:Show();

	elseif UI_ID == 4 then

			Quiz_Text : SetText( Get_XParam_STR(0) );
			Quiz_Button_2 : SetText("T�m bi�t")
			Quiz_Button_2 : Show();
			Quiz_Button_1 : Hide();
			Quiz_Button_3 : Hide();
			Current = UI_ID;
			this:Show();

	end

end

function Quiz_Button_Clicked(nAnswerNumber)

	if nAnswerNumber == 1 and Current == 1 then
		Question_Sequence = 0
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AskQuestion");
				Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
				Set_XSCRIPT_Parameter(0,Question_Sequence+1);
				Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		return
	end

	if nAnswerNumber == 1 and Current == 3 then
		Question_Sequence = 0
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AskQuestion");
				Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
				Set_XSCRIPT_Parameter(0,Question_Sequence+1);
				Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		return
	end

	if nAnswerNumber == 2 and Current == 4 then
		Quiz_Cancel_Clicked();
		return;
	end

	if nAnswerNumber > 0 and nAnswerNumber < 4 and Question > 0 then
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AnswerQuestion");
				Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
				Set_XSCRIPT_Parameter(0,Question);
				Set_XSCRIPT_Parameter(1,Button_Answer[nAnswerNumber]);
				Set_XSCRIPT_Parameter(2,Question_Sequence);
				Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();
		return
	end
	
end

function Quiz_Cancel_Clicked()
	StopCareObject_Quiz(objCared)
	this:Hide();
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Quiz(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Quiz");
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Quiz(objCaredId)
	this:CareObject(objCaredId, 0, "Quiz");
	g_Object = -1;

end

--��ʱ��0��
function Quiz_OverTime()
	Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnOverTime");
			Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
			Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end

function Quiz_Frame_On_ResetPos()
  Quiz_Frame:SetProperty("UnifiedPosition", g_Quiz_Frame_UnifiedPosition);
end