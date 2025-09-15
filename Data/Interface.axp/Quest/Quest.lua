local QUEST_STATE_EVENTLIST 				= 1;
local QUEST_STATE_MISSON_INFO 			= 2;
local QUEST_STATE_CONTINUE_DONE 		= 3;
local QUEST_STATE_CONTINUE_NOTDONE 	= 4;
local QUEST_STATE_AFTER_CONTINUE		= 5;
g_nQuestState = 0;
g_nRewardItemID = 0;

local bBeingRadio = 0;
local bRadioSelect = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

local Icon_Preference = {}
function Quest_PreLoad()
	this:RegisterEvent("QUEST_EVENTLIST");
	this:RegisterEvent("QUEST_INFO");
	this:RegisterEvent("QUEST_CONTINUE_DONE");
	this:RegisterEvent("QUEST_CONTINUE_NOTDONE");
	this:RegisterEvent("QUEST_AFTER_CONTINUE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("TOGLE_SKILLSTUDY");
	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("OPEN_ACCOUNT_SAFE");
end

function Quest_OnLoad()

	Icon_Preference[1] = 1
	Icon_Preference[2] = 2
	Icon_Preference[3] = 3
	Icon_Preference[4] = 4
	Icon_Preference[5] = 5
	Icon_Preference[6] = 6
	Icon_Preference[7] = 7
	Icon_Preference[8] = 12
	Icon_Preference[9] = 10
	Icon_Preference[10] = 9
	Icon_Preference[11] = 11
	Icon_Preference[12] = 8
	
end

--=========================================================
-- �¼�����
--=========================================================
function Quest_OnEvent(event)
	local objCared = tonumber(arg0);
	AxTrace(0, 0, "event = ".. event);
	--��һ�κ�npc�Ի����õ�npc���ܼ���Ĳ���
	if(event == "QUEST_EVENTLIST") then
		--����NPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_EventListUpdate();


	--�ڽ�����ʱ��������������Ϣ
	elseif(event == "QUEST_INFO") then
		--����NPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_QuestInfoUpdate()


	--����������ٴκ�npc�Ի������õ�������������Ϣ��(�������)
	elseif(event == "QUEST_CONTINUE_DONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(1);

	--����������ٴκ�npc�Ի������õ�������������Ϣ��(����δ���)
	elseif(event == "QUEST_CONTINUE_NOTDONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(0);

		--����NPC
		BeginCareObject_Quest(objCared)

	--���������֮�󡱣���Ʒѡ�����
	elseif(event == "QUEST_AFTER_CONTINUE") then
		--����NPC
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionRewardUpdate();

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Quest_Close();

			--ȡ������
			StopCareObject_Quest(objCared);
		end

	elseif (event == "TOGLE_SKILLSTUDY") then
		AxTrace(0,0,"M� gi�i di�n h�c t�p, ��ng v� khung �i tho�i c�a NPC");
		Quest_Close();

		--ȡ������
		StopCareObject_Quest(objCared);

	elseif (event == "TOGLE_BANK") then
		AxTrace(0,0,"M� gi�i di�n ng�n h�ng, ��ng v� khung �i tho�i c�a NPC");
		Quest_Close();

		--ȡ������
		StopCareObject_Quest(objCared);
	elseif ( event == "REPLY_MISSION" ) then
		Quest_Close();

	-- ������Ч
	elseif ( event == "UI_COMMAND" ) then
		AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0))
		if tonumber(arg0) == 123 then
			PlaySoundEffect();
		elseif tonumber(arg0) == 124 then
			PlayBackSound()
		elseif tonumber(arg0) == 1000 then
			Quest_Close();
		elseif tonumber(arg0) == 0147005 then
			Quest_Close();
		elseif tonumber(arg0) == 0147006 then
			Quest_Close();
		end

	-- �л�����
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		Quest_Close();
		if objCared then
			StopCareObject_Quest(objCared);
		end
	elseif( event == "OPEN_ACCOUNT_SAFE") then
		Quest_Close();
	end

end

--=========================================================
-- �ر���Ӧ
--=========================================================
function Quest_Close()
	--ȡ������
	StopCareObject_Quest(objCared);
end

--=========================================================
-- ��ʾ�����б�
--=========================================================
function Quest_EventListUpdate()
	local nEventListNum = DataPool:GetNPCEventList_Num();
	local i;
	local j =1;
	local k =1;
	local yy = 1;

	local canacceptArr ={}
	local cansubmitArr = {}
	local Sequence_OnefoldGenre = {}
	local Constitutes = {}
	local nTitleType = 0;
	for i=1, nEventListNum do
		local strType,strState,strScriptId,strExtra,strTemp = DataPool:GetNPCEventList_Item(i-1);
		AxTrace(0,0,"return single " .. strType);
		AxTrace(0,0,"return single " .. strState);
		AxTrace(0,0,"return single " .. strScriptId);
		AxTrace(0,0,"return single " .. strExtra);
		AxTrace(0,0,"return single " .. strTemp);
		
		AxTrace(0,0,"return ,,," .. strType..strState..strScriptId..strExtra..strTemp);
		if(strType == "text") then
			QuestGreeting_Desc:AddTextElement(strTemp);
		elseif(strType == "id") then
			if strState <= 0 or strState > 12 then
				strState = 8
			end
			if( tonumber( strScriptId ) == 808007 ) then
				if( strTemp == "Ta mu�n m� kh�a ngay" ) then
					nTitleType = 1
				elseif( strTemp == "Ta mu�n m� kh�a �n l�" ) then
					nTitleType = 1
				elseif( strTemp == "Kh�a to�n b�" ) then
					nTitleType = 2
				elseif( strTemp == "Kh�a �n l�" ) then
					nTitleType = 2
				elseif( strTemp == "Duy�t" ) then
					nTitleType = 2
				end
			end
				
			
			strTemp = strTemp .. "&"
			strTemp = strTemp .. strScriptId
			strTemp = strTemp .. ","
			strTemp = strTemp .. strExtra
			strTemp = strTemp .. "$"
			strTemp = strTemp .. strState
			Constitutes = {strTemp,Icon_Preference[strState]}
			if table.getn(Sequence_OnefoldGenre) > 0 then
				local Inserted = 0
				for yy,eachConstitute in Sequence_OnefoldGenre do
					AxTrace(5,5,"yy="..yy)
					if not CompareTable_Quest(eachConstitute,Constitutes) then
						table.insert(Sequence_OnefoldGenre,yy,Constitutes)
						Inserted = 1
						break
					end
				end
				if Inserted == 0 then
					table.insert(Sequence_OnefoldGenre,Constitutes)
				end
			else
				table.insert(Sequence_OnefoldGenre,Constitutes)
			end

		end
	end
	

	for i,PerOption in ipairs(Sequence_OnefoldGenre) do 
		QuestGreeting_Desc:AddOptionElement(PerOption[1]);
	end
	Sequence_OnefoldGenre = {};


	g_nQuestState = QUEST_STATE_EVENTLIST;
	Quest_Frame_Debug:SetText("#gFF0FA0"..Target:GetDialogNpcName());--get npc��name
	if( nTitleType == 1 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0M� kh�a" );
	elseif( nTitleType == 2 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0Kho�" );
	end
	AxTrace( 8,0,"title="..Target:GetDialogNpcName() );
	Quest_Button_Continue:SetText("Ti�p");--����
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("T�m bi�t");--�ټ�
end

--=========================================================
-- ��ʾ������Ϣ
--=========================================================
function Quest_QuestInfoUpdate()
	local nTextNum, nBonusNum = DataPool:GetMissionInfo_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionInfo_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

--	QuestGreeting_Desc:AddTextElement("#Y������#W");
	local nRadio = 1;
	local nRadio_Necessary = 1;
	local nItemID;
	local ActionID;

	for i=1, nBonusNum do
		--    ���������ͣ�������ƷID���������ٸ�
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#YKhen th߷ng c� �nh: #W")
				nRadio_Necessary = 0;
			end
			
			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#YKhen th߷ng c� �nh: #W")
				nRadio_Necessary = 0;
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end	
		elseif(strType == "itemrand") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#YKhen th߷ng c� �nh: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			if (nRadio == 1) then
				nRadio = 0;
				QuestGreeting_Desc:AddTextElement("#YSau khi ho�n th�nh nhi�m v� c� th� ch�n 1 v�t l�m qu� th߷ng: #W");
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		end
	end

	g_nQuestState = QUEST_STATE_MISSON_INFO
--	Quest_Frame_Debug:SetText("QUEST_STATE_MISSON_INFO");--get npc��name
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc��name
	end

	Quest_Button_Continue:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "1" );
	Quest_Button_Accept:Enable();
	Quest_Button_Continue:SetText("Ti�p");--����
	Quest_Button_Refuse:SetText("Hu�");--ȡ��
end

--=========================================================
--Continue����ĶԻ���
--=========================================================
function Quest_MissionContinueUpdate(bDone)
	local nTextNum, nBonusNum = DataPool:GetMissionDemand_Num();
	local ActionID;
	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionDemand_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

	if( nBonusNum>1 ) then
		QuestGreeting_Desc:AddTextElement("#YC�n v�t ph�m:#W");
	end

	for i=1, nBonusNum do
		--    ��Ҫ�����ͣ���Ҫ��ƷID����Ҫ���ٸ�
		local nItemID, nNum = DataPool:GetMissionDemand_Item(i-1);
--		QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Demand(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end

	end

	if (bDone == 1) then
		g_nQuestState = QUEST_STATE_CONTINUE_DONE;
--		Quest_Frame_Debug:SetText("CONTINUE_DONE");--get npc name
		Quest_Button_Continue:Enable();
	else
		g_nQuestState = QUEST_STATE_CONTINUE_NOTDONE;
--		Quest_Frame_Debug:SetText("CONTINUE_NOTDONE");--get npc name
		Quest_Button_Continue:Disable();
	end

	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc��name
	end

	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("Hu�");--ȡ��
	Quest_Button_Continue:SetText("Ti�p");--����

end

--=========================================================
--��ȡ������Ʒ�ĶԻ���
--=========================================================
function Quest_MissionRewardUpdate()
	g_nQuestState = QUEST_STATE_AFTER_CONTINUE;
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc��name
	end
--	Quest_Frame_Debug:SetText("AFTER_CONTINUE");--get npc name

	Quest_Button_Continue:Enable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("Hu�");--ȡ��
	Quest_Button_Continue:SetText("Tr�");--���

	local nTextNum, nBonusNum = DataPool:GetMissionContinue_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionContinue_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

	local nRadio = 1;
	local nRadio_Necessary = 1;
	local nItemID;
	local ActionID;
	
	bBeingRadio = 0;
	bRadioSelect = 0;
	for i=1, nBonusNum do
		--    ���������ͣ�������ƷID���������ٸ�
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#YKhen th߷ng c� �nh: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#YKhen th߷ng c� �nh: #W")
				nRadio_Necessary = 0;
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);		
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		elseif(strType == "itemrand") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#YKhen th߷ng c� �nh: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			bBeingRadio = 1;
			if (nRadio == 1) then
				nRadio = 0;
				if nRadio_Necessary == 1 then
					QuestGreeting_Desc:AddTextElement("#YC�c h� c� th� ch�n 1 m�n t� qu� th߷ng d߾i ��y: #W");
				else
					QuestGreeting_Desc:AddTextElement("#YH�y ch�n 1 trong nh�ng th� qu� th߷ng d߾i ��y: #W");
				end
				
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 1);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 1);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		end
	end

end

--=========================================================
-- ѡ��һ������
--=========================================================
function QuestOption_Clicked()

--	AxTrace(0,0,"click " .. arg0);
	--���ֵĸ�ʽ��
	--QuestGreeting_option_03#211207,0
	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");

	local strOptionID = -1;
	local strOptionExtra1 = string.sub(arg0, pos2+1,pos3-1 );
	local strOptionExtra2 = string.sub(arg0, pos4+1);

--	AxTrace(0,0,"strOptionExtra1" .. strOptionExtra1);
--	AxTrace(0,0,"strOptionExtra2" .. strOptionExtra2);

--	AxTrace(0,0,"ѡ��ID" .. tonumber(strOptionID));
--	AxTrace(0,0,"ѡ��1Str" .. tonumber(strOptionExtra1));
--	AxTrace(0,0,"ѡ��2Str" .. tonumber(strOptionExtra2));

	QuestFrameOptionClicked(tonumber(strOptionID),tonumber(strOptionExtra1),tonumber(strOptionExtra2));


end

--=========================================================
-- ѡ��һ����ѡһ�Ľ�����Ʒ
--=========================================================
function RewardItem_Clicked()
	--AxTrace(0, 1, "------------" .. arg0);
	local strRewardItemID = string.sub(arg0, -2, -1);
	g_nRewardItemID = tonumber(strRewardItemID);
	bRadioSelect = 1;
end

--=========================================================
-- Continue & Complete
--=========================================================
function MissionContinue_Clicked()
	if ( g_nQuestState == QUEST_STATE_CONTINUE_DONE ) then
		QuestFrameMissionContinue();
--		Quest_Close();
		--ȡ������
--		StopCareObject_Quest(objCared);

	elseif( g_nQuestState == QUEST_STATE_AFTER_CONTINUE )then
		--AxTrace(0, 0, "MissionContinue_Clicked(" .. tostring(g_nRewardItemID) .. ")");
		if(bBeingRadio == 1) then
			if(bRadioSelect == 1)then
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--ȡ������
				StopCareObject_Quest(objCared);
			else
				PushDebugMessage("M�i l�a ch�n v�t ph�m khen th߷ng!");
			end
		else
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--ȡ������
				StopCareObject_Quest(objCared);
		end
	end
end

--=========================================================
-- ��������
--=========================================================
function QuestAccept_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameAcceptClicked()
	end

	Quest_Close();
	--ȡ������
	StopCareObject_Quest(objCared);
end

--=========================================================
--�ܾ�����
--=========================================================
function QuestRefuse_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameRefuseClicked()
	end

	Quest_Close();
	--ȡ������
	StopCareObject_Quest(objCared);

	NpcShop:Close();

end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Quest(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Quest");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Quest(objCaredId)
	this:CareObject(objCaredId, 0, "Quest");
	g_Object = -1;

end

--=========================================================
--������Ч
--=========================================================
function PlaySoundEffect()
	Sound:PlaySound( Get_XParam_INT(0), false );
end

--=========================================================
--���ű�������
--=========================================================
function PlayBackSound()
	Sound:PlaySound( Get_XParam_INT(0),false );
end


function CompareTable_Quest(table_a,table_b)
	if table_a[2] <= table_b[2] then
		return true
	else
		return false
	end
end

function Quest_Open()
	this:Show();
end
function Quest_Close()
	this:Hide();
end