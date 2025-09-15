local MISSION_BUTTONS_NUM =3;
local Pet_Index = -1;
local objCared = -1;
local MISSION_ITEM_BUTTONS = {};
local MISSION_ITEM_TEXT ={};
local MAX_OBJ_DISTANCE = 3.0;
local	Accept_Clicked_Num = 0;				-- �Ƿ��Ѱ���һ�Ρ�ȷ����											add by WTT	20090112
local	scriptId = -1;								-- ��Ѫԡ���������ʱ�����øý���Ľű�ID			add by WTT	20090112							

--�����ύ����

--===============================================
-- OnLoad
--===============================================
function MissionReply_PreLoad()

	this:RegisterEvent("REPLY_MISSION");						-- �ύ�������
	this:RegisterEvent("QUEST_AFTER_CONTINUE");			-- �����������֮�󣬽�Ʒѡ�����
	this:RegisterEvent("REPLY_MISSION_PET");				-- ����ˢ��
	this:RegisterEvent("UPDATE_REPLY_MISSION");			-- ˢ���ύ�������
	this:RegisterEvent("OBJECT_CARED_EVENT");				-- ĳ�߼������ĳЩ�����ı�
	
end

function MissionReply_OnLoad()
	MISSION_ITEM_BUTTONS[1] = MissionReply_NeedItem1;
	MISSION_ITEM_BUTTONS[2] = MissionReply_NeedItem2;
	MISSION_ITEM_BUTTONS[3] = MissionReply_NeedItem3;
	
	MISSION_ITEM_TEXT[1] = MissionReply_NeedItem1_Info;
	MISSION_ITEM_TEXT[2] = MissionReply_NeedItem2_Info;
	MISSION_ITEM_TEXT[3] = MissionReply_NeedItem3_Info;
	
end

--===============================================
-- OnEvent
--===============================================
function MissionReply_OnEvent(event)
	
	-- �ύ�������
	if ( event == "REPLY_MISSION" ) then		
		if (arg0~=nil) then
			objCared = tonumber(arg0);
			BeginCareObject_MissionReply(tonumber(arg0));
		end
		
		-- ��Ѫԡ���������ʱ���õ����øý���� scriptId
		-- add by WTT	20090112
		if (arg1~=nil) then
			scriptId = tonumber(arg1);			
		end
		
		MissionReplyFrameUpdate();
		this:Show();
	
	-- ˢ���ύ�������
	elseif( event == "UPDATE_REPLY_MISSION" )  then
		MissionReplyFrameUpdate();
	
	-- �����������֮�󣬽�Ʒѡ�����
	elseif ( event == "QUEST_AFTER_CONTINUE" and this:IsVisible() ) then
		StopCareObject_MissionReply(objCared)
		this:Hide();
	
	-- ����ˢ��
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		Pet_Index = tonumber(arg0);
		MissionReply_NeedPet_Info : SetText(Pet:GetName(Pet_Index));	

	-- ĳ�߼������ĳЩ�����ı�
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			
			--ȡ������
			StopCareObject_MissionReply(objCared);
		end
		
	end

end

--===============================================
-- ������ʾ��������
--===============================================
function MissionReplyFrameUpdate()
	
	--������Ϣ�������󡢽�����������
	--����ǰ�����ԭ����Ϣ
	MissionReply_Desc:ClearAllElement();
	MissionReply_NeedPet_Info: SetText("");
	if Pet_Index ~= -1 then
		MissionReply_NeedPet_Info : SetText(Pet:GetName(Pet_Index));	
	end
	
	
	--��ʾNPC����
	if( Target:IsPresent()) then
		MissionReply_PageHeader_Name:SetText("#gFF0FA0"..Target:GetDialogNpcName());--get npc��name
	end
	local nTextNum, nBonusNum = DataPool:GetMissionDemand_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionDemand_Text(i-1);
		MissionReply_Desc:AddTextElement(strInfo);
	end
	
	if( nBonusNum>1 ) then
		MissionReply_Desc:AddTextElement("C�n v�t ph�m");
	end
	
	for i=1, nBonusNum do
		--    ��Ҫ�����ͣ���Ҫ��ƷID����Ҫ���ٸ�
		local nItemID, nNum = DataPool:GetMissionDemand_Item(i-1);
		MissionReply_Desc:AddItemElement(nItemID, nNum, 0);
	end
	
	
	--������Ҫ����Ʒ��������Լ��Ϸţ�
	local i=1;
	while i<=MISSION_BUTTONS_NUM do
		local theAction = MissionReply:EnumItem(i-1);

		if theAction:GetID() ~= 0 then
			MISSION_ITEM_BUTTONS[i]:SetActionItem(theAction:GetID());
			MISSION_ITEM_TEXT[i] : SetText(theAction:GetName());
		else
			MISSION_ITEM_BUTTONS[i]:SetActionItem(-1);
			MISSION_ITEM_TEXT[i] : SetText("");
		end

		i = i+1;
	end

	
	--������Ҫ�ĳ�����������Լ��Ϸţ�
	
end

--===============================================
-- ���� (��ʱ�������)
--===============================================
function MissionReply_Pet_Clicked()
	MissionReply:OpenPetFrame();
end

--===============================================
-- ȷ��
--===============================================
function MissionReply_Accept_Clicked()
		
	-- ����ǡ�Ѫԡ������еġ��������족������������������õĸý���
	if ( scriptId == 500503 ) or ( scriptId == 500504 ) then

		if (Accept_Clicked_Num == 0) then
			MissionReply:OpenSecondConfirmFrame(scriptId);		-- ���ݵ��øý����scriptId���򿪶�Ӧ�Ķ���ȷ��ҳ��
			Accept_Clicked_Num = 1;

		else 	 
			MissionReply:OnContinue(Pet_Index);
			StopCareObject_MissionReply(objCared)
			Pet_Index = -1;
			Accept_Clicked_Num = 0; 													-- ��2�ε����ȷ�����󣬻ָ� Accept_Clicked_Num Ϊδ������ȷ������ť��
			this:Hide();
		end
		
	else
		MissionReply:OnContinue(Pet_Index);
		StopCareObject_MissionReply(objCared)
		Pet_Index = -1;
		this:Hide();	
	end
	
end

--===============================================
-- ȡ��
--===============================================
function MissionReply_Cancel_Clicked()

	-- ����ǡ�Ѫԡ������еġ��������족������������������õĸý���
	if ( scriptId == 500503 ) or ( scriptId == 500504 ) then
		Accept_Clicked_Num = 0; 														-- �����ȡ�����󣬻ָ� Accept_Clicked_Num Ϊδ������ȷ������ť��
	end
	
	StopCareObject_MissionReply(objCared)
	Pet_Index = -1;
	this:Hide();
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_MissionReply(objCaredId)

	AxTrace(0,0,"objCaredId =" .. objCaredId )
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "MissionReply");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_MissionReply(objCaredId)
	this:CareObject(objCaredId, 0, "MissionReply");
	g_Object = -1;

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function MissionReply_OnClose()
	DataPool:CloseMissionFrame();
	Pet : ShowPetList(0);
	MissionReply_Cancel_Clicked();

end

function MissionReply_ToggleShowPetList()
	DataPool : ToggleShowPetList();
end

--=========================================================
-- ���ͼ��
--=========================================================
function MissionReply_NeedItem_Click(nIndex)
	MissionReply:DoAction(nIndex);
end

