--UI Command 150
local g_MembersCtl = {};
local g_SynPet = {};
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

function PetSynthesize_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("PET_SYNC_OPEN");
end

function PetSynthesize_OnLoad()
	g_SynPet[0] = nil;
	g_SynPet[1] = nil;
end

function PetSynthesize_OnEvent(event)
	PetSynthesize_SetCtl();
	if(event == "UI_COMMAND") then
		PetSynthesize_OnUICommand(arg0);
	elseif(event == "PET_SYNC_OPEN" and arg0 == "close") then
		PetSynthesize_Hide();
	elseif(event == "REPLY_MISSION_PET" and this:IsVisible()) then
		PetSynthesize_SetPet(tonumber(arg0));
	elseif(event == "DELETE_PET" and this:IsVisible()) then
		PetSynthesize_Hide();
	elseif(event == "UPDATE_PET_PAGE" and this:IsVisible()) then
		PetSynthesize_UpdatePet();
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetSynthesize_CareEventHandle(arg0,arg1,arg2);
	end
end

function PetSynthesize_SetCtl()
	g_MembersCtl[0] =	{
											--�ؼ�
											name 	= PetSynthesize_Other_Pet,
											model	=	PetSynthesize_Other_PetModel,
											left	= PetSynthesize_OtherModel_TurnLeft,
											right	=	PetSynthesize_OtherModel_TurnRight,
											cancel = PetSynthesize_ViewDesc_Other,
											--��Ӧlist�е�����
											idx = g_SynPet[0],
											--Fakeϵͳ�е�����
											strFake = "My_PetSynLeft",
										};

	g_MembersCtl[1] =	{
											--�ؼ�
											name 	= PetSynthesize_Self_Pet,
											model	=	PetSynthesize_Self_PetModel,
											left	= PetSynthesize_SelfModel_TurnLeft,
											right	=	PetSynthesize_SelfModel_TurnRight,
											cancel = PetSynthesize_ViewDesc_Self,
											--��Ӧlist�е�����
											idx = g_SynPet[1];
											--Fakeϵͳ�е�����
											strFake = "My_PetSynRight",
										};

	g_MembersCtl.confirm = PetSynthesize_Accept;
end

function PetSynthesize_OnUICommand(arg0)
	local op = tonumber(arg0);
	if(op == 150) then
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		this:CareObject(g_clientNpcId, 1, "PetSynthesize");
		
		PetSynthesize_ClearAll();
		Pet:ShowPetList(1);
		this:Show();
	end
end

function PetSynthesize_ClearPos(id)
	local pos = tonumber(id);
	if(pos == 0 or pos == 1) then
		g_MembersCtl[pos].name:SetText("");
		g_MembersCtl[pos].model:SetFakeObject("");
		g_MembersCtl[pos].left:Disable();
		g_MembersCtl[pos].right:Disable();
		g_MembersCtl[pos].cancel:Disable();
		g_MembersCtl[pos].idx = nil;
		g_SynPet[pos] = nil;
		
		g_MembersCtl.confirm:Disable();
	end
end

function PetSynthesize_ClearAll()
	PetSynthesize_ClearPos(0);
	PetSynthesize_ClearPos(1);
end

function PetSynthesize_UpdatePet()
	for pos = 0, 1 do
		if(g_MembersCtl[pos].idx) then
			--����ɵ���Ϣ
			g_MembersCtl[pos].name:SetText("");
			g_MembersCtl[pos].model:SetFakeObject("");
			--�����µ���Ϣ
			g_MembersCtl[pos].name:SetText(Pet:GetName(g_MembersCtl[pos].idx));
			Pet:SetSynModel(g_MembersCtl[pos].idx, pos);
			g_MembersCtl[pos].model:SetFakeObject(g_MembersCtl[pos].strFake);
		end
	end
end

function PetSynthesize_SetPet(idx)
	local nIdx = tonumber(idx);  --�Լ��ĵڼ�ֻ����
	if( -1 == nIdx or nil == nIdx) then
		return;
	end
	--����Ƿ��ظ�
	for i = 0, 1 do
		--AxTrace(0,0,"PetSynthesize_SetPet nIdx:"..tostring(nIdx).." g_MembersCtl["..tostring(i).."].idx:"..
		--						tostring(g_MembersCtl[i].idx));
		if(g_MembersCtl[i].idx and g_MembersCtl[i].idx == nIdx) then return; end
	end
	--���ҿռ�
	local nEmptyIdx = 0;	--���ռ���˴ӵ�һ����
	for i = 0, 1 do
		if(nil == g_MembersCtl[i].idx) then 
			nEmptyIdx = i;
			break;
		end
	end
	--���ö�Ӧλ�õĶ�Ӧ����
	--AxTrace(0,0,"PetSynthesize_SetPos nEmptyIdx:"..tostring(nEmptyIdx).." nIdx:"..tostring(nIdx));
	PetSynthesize_SetPos(nEmptyIdx, nIdx);
end

function PetSynthesize_SetPos(id, petIdx)
	local pos = tonumber(id);
	local nPetIdx = tonumber(petIdx);
	if( -1 == nPetIdx or nil == nPetIdx) then
		return;
	end

	if(pos == 0 or pos == 1) then
		--���������
		PetSynthesize_ClearPos(pos);
		--����������
		g_MembersCtl[pos].name:SetText(Pet:GetName(nPetIdx));
		Pet:SetSynModel(nPetIdx, pos);
		g_MembersCtl[pos].model:SetFakeObject(g_MembersCtl[pos].strFake);
		g_MembersCtl[pos].left:Enable();
		g_MembersCtl[pos].right:Enable();
		g_MembersCtl[pos].cancel:Enable();
		g_MembersCtl[pos].idx = nPetIdx;
		g_SynPet[pos] = nPetIdx;
		--AxTrace(0,0,"PetSynthesize_SetPos g_MembersCtl["..tostring(pos).."].idx:"..tostring(g_MembersCtl[pos].idx).." nPetIdx:"..tostring(nPetIdx));
		--����ȷ�ϰ�ť״̬
		PetSynthesize_SetConfirm();
	end
end

function PetSynthesize_SetConfirm()
	local bConfirm = 1;
	for i = 0, 1 do
		if(nil == g_MembersCtl[i].idx) then
			bConfirm = nil;
			break;
		end
	end
	
	if(bConfirm) then g_MembersCtl.confirm:Enable(); end
end

function PetSynthesize_Clicked()
	for i = 0, 1 do
		if(nil == g_MembersCtl[i].idx) then return; end
	end
	
	Pet:Syn_Confirm(g_MembersCtl[0].idx, g_MembersCtl[1].idx);
	--PetSynthesize_Hide();
end

function PetSynthesize_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetSynthesize_Hide();
		end
end

function PetSynthesize_Hide()
	this:Hide();
	Pet:ShowPetList(-1);
end

function PetSynthesize_Modle_TurnLeft(id,start)
	local pos = tonumber(id);
	if(pos == 0 or pos == 1) then
		--������ת��ʼ
		if(start == 1) then
			g_MembersCtl[pos].model:RotateBegin(-0.3);
		--������ת����
		else
			g_MembersCtl[pos].model:RotateEnd();
		end
	end
end

function PetSynthesize_Modle_TurnRight(id,start)
	local pos = tonumber(id);
	if(pos == 0 or pos == 1) then
		--������ת��ʼ
		if(start == 1) then
			g_MembersCtl[pos].model:RotateBegin(0.3);
		--������ת����
		else
			g_MembersCtl[pos].model:RotateEnd();
		end
	end
end