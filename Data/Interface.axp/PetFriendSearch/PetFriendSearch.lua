
local cooldownTime =15*1000;		--��ʶ��ȴʱ��
local pageCoolDownTime = 5*1000;	--��ҳ��ȴʱ�䣬��ҳ���Ľϴ�
local PET_AITYPE = {};
local FlashTextHeader = "#ecc33cc#cffcccc";		--�������������������ɫ����˸
local showPrevPage = true;
local showNextPage = true;

function PetFriendSearch_PreLoad()
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("OPEN_WINDOW");
end

function PetFriendSearch_OnLoad()
	PET_AITYPE[0] = "Nh�t gan";
	PET_AITYPE[1] = "C�n th�n";
	PET_AITYPE[2] = "Trung th�c";
	PET_AITYPE[3] = "Nhanh nh�n";
	PET_AITYPE[4] = "D�ng m�nh";
end

function PetFriendSearch_OnEvent(event)

	if(event == "UPDATE_PETINVITEFRIEND") then
		if("searchlist" == arg0) then
			showPrevPage = true;
			showNextPage = true;
			PetFriendSearch_ShowWindow();
		elseif("searchlistbegin" == arg0) then
			showPrevPage = false;
			PetFriendSearch_ShowWindow();
		elseif("searchnonextpage" == arg0) then
			PetFriendSearch_PageDown:Disable();
			showNextPage = false;
		elseif("searchnoprevpage" == arg0) then
			PetFriendSearch_PageUp:Disable();
			showPrevPage = false;
		end
	elseif ( event == "OPEN_WINDOW") then
		if( arg0 == "Show_Pet_Search") then
			this:Show();
		end
	end
end

function PetFriendSearch_ShowWindow()
	local num = PetInviteFriend:GetInviteNum("search")
	if( num <= 0 ) then
		PushDebugMessage("Kh�ng t�m th�y d� li�u Tr�n Th� th�ch h�p");
		return;
	end
	PetFriendSearch_Clear_All();
	if( num == 1 ) then
		PetFriendSearch_DisableButton(1);
		PetFriendSearch_HideWindow(1);
		showNextPage = false;
	else
		showNextPage = true;
	end
	for i=1, num do
		PetFriendSearch_Update(i);
	end
	this:Show();
end

function PetFriendSearch_Update( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end
	idx = idx + 4;

	--��ȡ����������Ϣ
	local humanName = PetInviteFriend:GetHumanINFO(idx, "NAME");
	local humanMenPai = PetInviteFriend:GetHumanINFO(idx, "MENPAI");
	local humanLevel = PetInviteFriend:GetHumanINFO(idx, "LEVEL");
	local humanSex  = PetInviteFriend:GetHumanINFO(idx, "SEX");
	humanMenPai = PetFriendSearch_ConvertNumToMenPai(humanMenPai);
	if( humanSex == 0 ) then
		humanSex = "N�";
	else
		humanSex = "Nam";
	end

	--��ȡ������Ϣ
	local petName = PetInviteFriend:GetPetINFO(idx, "NAME");
	local petGrow = PetInviteFriend:GetPetINFO(idx, "GROW");
	local petLevel = PetInviteFriend:GetPetINFO(idx, "LEVEL");
	local petSex  = PetInviteFriend:GetPetINFO(idx, "SEX");
	local petAI   = PetInviteFriend:GetPetINFO(idx, "AITYPE");
	local petTypeName = PetInviteFriend:GetPetINFO(idx, "TYPENAME");
	petTypeName = FlashTextHeader .. petTypeName .. "B�o B�o";
	if( petSex == 0 ) then
		petSex = "C�i";
	else
		petSex = "��c";
	end
	local strTbl = {"S� c�p","Xu�t s�c","Ki�t xu�t","Tr�c vi�t","To�n m�"};

	if(petGrow >= 0) then
		petGrow = petGrow + 1;	--c���Ǵ�0��ʼ��ö��
		if(strTbl[petGrow]) then
			petGrow = strTbl[petGrow];
		else
			petGrow = "Ch�a bi�t";
		end
	else
		petGrow = "Ch�a bi�t";
	end

	if(petAI>4 or petAI <0) then
		petAI = "Sai s�t ";
	else
		petAI =	PET_AITYPE[petAI];
	end


	if( idx == 5 ) then
	  --����������Ϣ
		PetFriendSearch_Master1Pet_NameInfo:SetText(petName);
		PetFriendSearch_Master1Pet_GenderInfo:SetText(petSex);
		PetFriendSearch_Master1Pet_ChenZhangInfo:SetText(petGrow);
		PetFriendSearch_Master1Pet_LevelInfo:SetText(petLevel);
		PetFriendSearch_Type1:SetText(petAI);
		PetFriendSearch_Flash_Name1:SetText(petTypeName);

		--����������Ϣ
		PetFriendSearch_Master1_NameInfo:SetText(humanName);
		PetFriendSearch_Master1_LevelInfo:SetText(humanLevel);
		PetFriendSearch_Master1_ManPaiInfo:SetText(humanMenPai);
		PetFriendSearch_Master1_GenderInfo:SetText(humanSex);

		--����ģ����Ϣ
		PetInviteFriend:SetPetModel(idx);
		PetFriendSearch_PetModel1:SetFakeObject("My_PetSearchFriend01");

		PetFriendSearch_Pet1_Investigate:Enable();
		PetFriendSearch_Pet1_Investigate:Enable();
		PetFriendSearch_PetModel1_TurnRight:Enable();
		PetFriendSearch_PetModel1_TurnLeft:Enable();
		if showPrevPage then
			PetFriendSearch_PageUp:Enable();
		else
			PetFriendSearch_PageUp:Disable();
		end


	elseif( idx == 6 ) then
	  --����������Ϣ
		PetFriendSearch_Master2Pet_NameInfo:SetText(petName);
		PetFriendSearch_Master2Pet_GenderInfo:SetText(petSex);
		PetFriendSearch_Master2Pet_ChenZhangInfo:SetText(petGrow);
		PetFriendSearch_Master2Pet_LevelInfo:SetText(petLevel);
		PetFriendSearch_Flash_Name2:SetText(petTypeName);
		PetFriendSearch_Type2:SetText(petAI);

		--����������Ϣ
		PetFriendSearch_Master2_NameInfo:SetText(humanName);
		PetFriendSearch_Master2_LevelInfo:SetText(humanLevel);
		PetFriendSearch_Master2_ManPaiInfo:SetText(humanMenPai);
		PetFriendSearch_Master2_GenderInfo:SetText(humanSex);

		--����ģ����Ϣ
		PetInviteFriend:SetPetModel(idx);
		PetFriendSearch_PetModel2:SetFakeObject("My_PetSearchFriend02");

		--���ť
		PetFriendSearch_Pet2_Investigate:Enable();
		PetFriendSearch_Pet2_Acquaintance:Enable();
		PetFriendSearch_PetModel2_TurnRight:Enable();
		PetFriendSearch_PetModel2_TurnLeft:Enable();
		if showNextPage then
			PetFriendSearch_PageDown:Enable()
		end

		--��ʾ�ı�
		PetFriendSearch_Master2Pet_Name:Show();
		PetFriendSearch_Master2Pet_Gender:Show();
		PetFriendSearch_Master2Pet_ChenZhang:Show();
		PetFriendSearch_Master2Pet_Level:Show();
		PetFriendSearch_Master2_Name:Show();
		PetFriendSearch_Master2_Level:Show();
		PetFriendSearch_Master2_ManPai:Show();
		PetFriendSearch_Master2_Gender:Show();
		PetFriendSearch_Master2Pet_NameInfo:Show();
		PetFriendSearch_Master2Pet_GenderInfo:Show();
		PetFriendSearch_Master2Pet_ChenZhangInfo:Show();
		PetFriendSearch_Master2Pet_LevelInfo:Show();
		PetFriendSearch_Master2_NameInfo:Show();
		PetFriendSearch_Master2_LevelInfo:Show();
		PetFriendSearch_Master2_ManPaiInfo:Show();
		PetFriendSearch_Master2_GenderInfo:Show();
		PetFriendSearch_Type2:Show();
		PetFriendSearch_Flash_Name2:Show();
	end

end

--����һЩ ����
function PetFriendSearch_HideWindow(idx)
	if( idx == 0 ) then
		PetFriendSearch_Master1Pet_Name:Hide();
		PetFriendSearch_Master1Pet_Gender:Hide();
		PetFriendSearch_Master1Pet_ChenZhang:Hide();
		PetFriendSearch_Master1Pet_Level:Hide();
		PetFriendSearch_Master1_Name:Hide();
		PetFriendSearch_Master1_Level:Hide();
		PetFriendSearch_Master1_ManPai:Hide();
		PetFriendSearch_Master1_Gender:Hide();
	else
		PetFriendSearch_Master2Pet_Name:Hide();
		PetFriendSearch_Master2Pet_Gender:Hide();
		PetFriendSearch_Master2Pet_ChenZhang:Hide();
		PetFriendSearch_Master2Pet_Level:Hide();
		PetFriendSearch_Master2_Name:Hide();
		PetFriendSearch_Master2_Level:Hide();
		PetFriendSearch_Master2_ManPai:Hide();
		PetFriendSearch_Master2_Gender:Hide();
		PetFriendSearch_Master2Pet_NameInfo:Hide();
		PetFriendSearch_Master2Pet_GenderInfo:Hide();
		PetFriendSearch_Master2Pet_ChenZhangInfo:Hide();
		PetFriendSearch_Master2Pet_LevelInfo:Hide();
		PetFriendSearch_Master2_NameInfo:Hide();
		PetFriendSearch_Master2_LevelInfo:Hide();
		PetFriendSearch_Master2_ManPaiInfo:Hide();
		PetFriendSearch_Master2_GenderInfo:Hide();
		PetFriendSearch_Type2:Hide();
		PetFriendSearch_Flash_Name2:Hide();
	end
end

--����һЩ��ť
function PetFriendSearch_DisableButton(idx)
	if( idx == 0 ) then
		PetFriendSearch_Pet1_Investigate:Disable();
		PetFriendSearch_Pet1_Acquaintance:Disable();
		PetFriendSearch_PetModel1_TurnRight:Disable();
		PetFriendSearch_PetModel1_TurnLeft:Disable();
	else
		PetFriendSearch_Pet2_Investigate:Disable();
		PetFriendSearch_Pet2_Acquaintance:Disable();
		PetFriendSearch_PetModel2_TurnRight:Disable();
		PetFriendSearch_PetModel2_TurnLeft:Disable();
		--û����һҳ����Ϣ��
		PetFriendSearch_PageDown:Disable();
	end
end


function PetFriendSearch_Clear_All()
	--for i=0, 2 do
		PetFriendSearch_DisableButton(1);
		PetFriendSearch_HideWindow(1);
		PetFriendSearch_PetModel1:SetFakeObject("");
		PetFriendSearch_PetModel2:SetFakeObject("");

	--end
end


function PetFriendSearch_ShowTargetFrame(who)
	PetInviteFriend:ShowTargetPet(who);
end

function PetFriendSearch_Hide()
	this:Hide();
end


function PetFriendSearch_ConvertNumToMenPai( MenPaiId )
	local strMenPai = "???";
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

	elseif(9 == MenPaiId) then
		strMenPai = "Kh�ng c�";

	elseif(10== MenPaiId) then
		strMenPai = "M� Dung";

	end

	return strMenPai;
end
----------------------------------------------------------------------------------
--
-- ��ת����ģ�ͣ�����)
--
function PetFriendSearch_Modle_TurnLeft(modelIdx,start)

		if( modelIdx == 5 ) then
		--������ת��ʼ
			if(start == 1) then
				PetFriendSearch_PetModel1:RotateBegin(-0.3);
			--������ת����
			else
				PetFriendSearch_PetModel1 :RotateEnd();
			end
		end
		if( modelIdx == 6 ) then
			if(start == 1) then
				PetFriendSearch_PetModel2:RotateBegin(-0.3);
			--������ת����
			else
				PetFriendSearch_PetModel2 :RotateEnd();
			end
	 end
end

----------------------------------------------------------------------------------
--
--��ת����ģ�ͣ�����)
--
function PetFriendSearch_Modle_TurnRight(modelIdx, start)
	if( modelIdx == 5 ) then
		--������ת��ʼ
			if(start == 1) then
				PetFriendSearch_PetModel1:RotateBegin(0.3);
			--������ת����
			else
				PetFriendSearch_PetModel1 :RotateEnd();
			end
	elseif( modelIdx == 6 ) then
			if(start == 1) then
				PetFriendSearch_PetModel2:RotateBegin(0.3);
			--������ת����
			else
				PetFriendSearch_PetModel2 :RotateEnd();
			end
	end
end

--��ѯ��һƪ������������Ϣ
function PetFriendSearch_PrevPage()
	PetInviteFriend:ShowSearchPage(-1);
	PetFriendSearch_PageUp:Disable();
	SetTimer("PetFriendSearch","PetFriendSearch_CoolPageUp();",pageCoolDownTime);
end

function PetFriendSearch_CoolPageUp()
	if showPrevPage then
		PetFriendSearch_PageUp:Enable();
	end
	KillTimer("PetFriendSearch_CoolPageUp();");
end

--��ѯ��һƪ������������Ϣ
function PetFriendSearch_NextPage()
	PetInviteFriend:ShowSearchPage(1);
	PetFriendSearch_PageDown:Disable();
	SetTimer("PetFriendSearch","PetFriendSearch_CoolPageDown();",pageCoolDownTime);
end
function PetFriendSearch_CoolPageDown()
	if showNextPage then
		PetFriendSearch_PageDown:Enable();
	end
	KillTimer("PetFriendSearch_CoolPageDown();");
end

--���������˷��ʼ���˵��������
function PetFriendSearch_SendMail( idx )
	if( idx == 5 or idx == 6 ) then
		local owner = PetInviteFriend:GetHumanINFO(idx, "NAME");
		local player = Player:GetName();
		if(owner == player) then
			PushDebugMessage("Kh�ng th� t� k�t th�n Tr�n Th�");
			return;
		end
			--�����������˷����ʼ����������������������������޽�ʶ
		DataPool:OpenMail( owner,"Ta mu�n k�t th�n v�i B�o B�o c�a b�n" );
	end

	if( idx == 5 ) then
		SetTimer("PetFriendSearch","PetFriendSearch_CoolDown3();" ,cooldownTime);
		PetFriendSearch_Pet1_Acquaintance:Disable();
	elseif(idx == 6 ) then
		SetTimer("PetFriendSearch","PetFriendSearch_CoolDown4();" ,cooldownTime);
		PetFriendSearch_Pet2_Acquaintance:Disable();
	end
end

function PetFriendSearch_CoolDown3()
		PetFriendSearch_Pet1_Acquaintance:Enable();
		KillTimer("PetFriendSearch_CoolDown3();");
end
function PetFriendSearch_CoolDown4()
		PetFriendSearch_Pet2_Acquaintance:Enable();
		KillTimer("PetFriendSearch_CoolDown4();");
end
