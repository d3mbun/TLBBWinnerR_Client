local g_InitiativeClose = 0;

--�����رմ��ڵ�һ����־
local g_CloseSign;		-- 

--button�ĸ���
local BUTTON_NUMBER = 5;
--�Լ���
local SELF_BUTTON = {};
local SELF_TEXT = {};
--�Է���
local OTHER_BUTTON = {};
local OTHER_TEXT = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 6.0;

--�����ܷ�������ĳ�������
local MAX_PET_NUM  = 5;
local g_nSelfPetID = {};				--����ID��
local g_nOtherPetID = {};				--����ID��

local g_LastLockTime = 0;
local LOCK_TIME_DIFF = 10000           --10��

--===============================================
-- OnLoad()
--===============================================
function Exchange_PreLoad()

	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("UPDATE_EXCHANGE");
	this:RegisterEvent("CANCEL_EXCHANGE");
	this:RegisterEvent("SUCCEED_EXCHANGE_CLOSE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("EXCHANGE_ENABLE_ACCBTN");	
end

function Exchange_OnLoad()
	
	SELF_BUTTON[1] = Self_Exchange_Item1;
	SELF_BUTTON[2] = Self_Exchange_Item2;
	SELF_BUTTON[3] = Self_Exchange_Item3;
	SELF_BUTTON[4] = Self_Exchange_Item4;
	SELF_BUTTON[5] = Self_Exchange_Item5;
	SELF_BUTTON[6] = Self_Exchange_Item6;
	
	SELF_TEXT[1] = Self_Exchange_Item_Text1;
	SELF_TEXT[2] = Self_Exchange_Item_Text2;
	SELF_TEXT[3] = Self_Exchange_Item_Text3;
	SELF_TEXT[4] = Self_Exchange_Item_Text4;
	SELF_TEXT[5] = Self_Exchange_Item_Text5;
	SELF_TEXT[6] = Self_Exchange_Item_Text6;
	
	OTHER_BUTTON[1] = Other_Exchange_Item1;
	OTHER_BUTTON[2] = Other_Exchange_Item2;
	OTHER_BUTTON[3] = Other_Exchange_Item3;
	OTHER_BUTTON[4] = Other_Exchange_Item4;
	OTHER_BUTTON[5] = Other_Exchange_Item5;
	OTHER_BUTTON[6] = Other_Exchange_Item6;

	OTHER_TEXT[1] = Other_Exchange_Item_Text1;
	OTHER_TEXT[2] = Other_Exchange_Item_Text2;
	OTHER_TEXT[3] = Other_Exchange_Item_Text3;
	OTHER_TEXT[4] = Other_Exchange_Item_Text4;
	OTHER_TEXT[5] = Other_Exchange_Item_Text5;
	OTHER_TEXT[6] = Other_Exchange_Item_Text6;
	
	for i=0, MAX_PET_NUM    do
		g_nSelfPetID[i] = -1;
		g_nOtherPetID[i] = -1
	end
end

--===============================================
-- OnEvent()
--===============================================
function Exchange_OnEvent(event)

	if(event == "OPEN_EXCHANGE_FRAME") then
		--����NPC
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "Exchange");
		ExchangeValidate_StopWatch1:SetProperty("Timer", "300");
		g_InitiativeClose = 0;
		--Update	
		Exchange_UpdateFrame();
		Exchange_Checkbox_other_Locked:Disable();
		Exchange_Frame:SetProperty("UnifiedXPosition","{0.0,0}");
		Exchange_Frame:SetProperty("UnifiedYPosition","{0.12,0}");
		this:Show();
		
	elseif(event == "UPDATE_EXCHANGE") then
		Exchange_UpdateFrame();
		
	elseif(evnet == "CANCEL_EXCHANGE") then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--ȡ������
		this:CareObject(objCared, 0, "Exchange");
		
	elseif(event == "SUCCEED_EXCHANGE_CLOSE") then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--ȡ������
		this:CareObject(objCared, 0, "Exchange");
	
	--������ʱ����Ҫȡ������
	elseif(event == "RELIVE_SHOW" and this:IsVisible()) then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--ȡ������
		this:CareObject(objCared, 0, "Exchange");
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();
			Exchange:CloseExchangeInfo();
			
			--ȡ������
			this:CareObject(objCared, 0, "Exchange");
		end
	
	elseif( event == "ACCELERATE_KEYSEND" and this:IsVisible()) then
		this:Hide();
		Exchange:CloseExchangeInfo();
		--ȡ������
		this:CareObject(objCared, 0, "Exchange");
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide();
		Exchange:CloseExchangeInfo();
		--ȡ������
		this:CareObject(objCared, 0, "Exchange");
	end

	if event == "EXCHANGE_ENABLE_ACCBTN" then	--����˷�����֤�Ƿ�ͨ��....

		if not this:IsVisible() then
			return;
		end
		Exchange_UpdateFrame();
	end
end

--===============================================
-- ���½���
--===============================================
function Exchange_UpdateFrame()

	--����˫��������
	--�Լ���
	Exchange_SelfName:SetText(Player:GetName());
	
	--�Է���
	Exchange_OtherName:SetText("#b#c0000FF#effffff"..Exchange:GetOthersName());

	--�Է���������ť����һֱ�����ã�
	Exchange_Other_Locked_Button:Disable();
	--�Լ��Ľ��װ�ť����˫����������ã�
	Trade_Accept_Button:Disable();
	
	--======================
	--�����Ǯ
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	--�Է��Ľ�Ǯ����
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Exchange:GetMoney("other");
	Exchange_Other_Money:SetProperty("MoneyNumber", tostring(nMoney));

	--�Լ��Ľ�Ǯ����
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Exchange:GetMoney("self");
	Exchange_Slfe_Money:SetProperty("MoneyNumber", tostring(nMoney));

	--=======================
	--������Ʒ
	--�Լ���
	local nSelfTotalNum = GetActionNum("ex_self");
	--AxTrace(0, 0, "Exchange:nSelfTotalNum =  " .. nSelfTotalNum);
	
	for i=0, BUTTON_NUMBER-1  do

		local theAction = EnumAction(i, "ex_self");

		--AxTrace(0, 0, "Exchange:nActIndex =  " .. i);

		if theAction:GetID() ~= 0 then
			SELF_BUTTON[i+1]:SetActionItem(theAction:GetID());
			SELF_TEXT[i+1]:SetText(theAction:GetName());
		else
			SELF_BUTTON[i+1]:SetActionItem(-1);
			SELF_TEXT[i+1]:SetText("");
		end
	
	end

	--�Է���
	local nOtherTotalNum = GetActionNum("ex_other");
	--AxTrace(0, 0, "Exchange:nOtherTotalNum =  " .. nOtherTotalNum);

	for i=0, BUTTON_NUMBER-1  do

		local theAction = EnumAction(i, "ex_other");

		--AxTrace(0, 0, "Bank:nActIndex =  " .. i);

		if theAction:GetID() ~= 0 then
			OTHER_BUTTON[i+1]:SetActionItem(theAction:GetID());
			OTHER_TEXT[i+1]:SetText(theAction:GetName());
		else
			OTHER_BUTTON[i+1]:SetActionItem(-1);
			OTHER_TEXT[i+1]:SetText("");
		end

	end
	
	--=======================
	--��������״̬,�����ݳػ�����ݣ�Ȼ��֪ͨ������ֳ���
	local bIsSelfLocked = Exchange:IsLocked("self");
	local bIsOtherLocked = Exchange:IsLocked("other");

	--�Լ��Ľ��װ�ť����˫����������ã�
	if( bIsSelfLocked == true ) then
		if( bIsOtherLocked == true ) then
			Trade_Accept_Button:Enable();
		end
	end
	
	--�Լ���
	local bIsSelfLocked = Exchange:IsLocked("self");
	if( bIsSelfLocked == true ) then
		Exchange_Checkbox_Locked:SetCheck(1);
		Exchange_Locked_Button:SetText("Hu� b� giao d�ch");
	elseif ( bIsSelfLocked == false) then
		Exchange_Checkbox_Locked:SetCheck(0);
		Exchange_Locked_Button:SetText("аng � giao d�ch");
	end
	
	--�Է���
	if( bIsOtherLocked == true ) then
		Exchange_Checkbox_other_Locked:SetCheck(1);
		Exchange_Other_Locked_Button:SetText("�� kh�a �nh");
	elseif ( bIsOtherLocked == false) then
		Exchange_Checkbox_other_Locked:SetCheck(0);
		Exchange_Other_Locked_Button:SetText("Ch�a kh�a �nh");
	end
	
	--=======================
	--�������
	--�Լ���
	Exchange_Self_PetList:ClearListBox();
	
	--local nNum = Exchange:GetPetNum("self");
	local nIndex = 0;
	for i=1, MAX_PET_NUM     do
		local szPetName = Exchange:EnumPet("self", i-1);
		if( szPetName ~= "" )then
			Exchange_Self_PetList:AddItem(szPetName, nIndex);
			g_nSelfPetID[nIndex] = i-1;
			nIndex = nIndex + 1;
		end
	end
	
	--�Է���
	Exchange_Other_PetList:ClearListBox();
	nIndex = 0;
	--local nNum = Exchange:GetPetNum("other");
	for i=1, MAX_PET_NUM      do
		local szPetName = Exchange:EnumPet("other", i-1);
		if( szPetName ~= "" )  then
			Exchange_Other_PetList:AddItem(szPetName, nIndex);
			g_nOtherPetID[nIndex] = i-1;
			nIndex = nIndex+1;
		end
	end

end

--===============================================
-- ���ڹر�ִ�е�   Hidden
--===============================================
function Exchange_Cancel()

	Exchange:ExchangeCancel();
	--ȡ������
	this:CareObject(objCared, 0, "Exchange");

end

--===============================================
-- �������
--===============================================
function Exchange_Lock_Button_Clicked()

	local nNowTickCount = Exchange:GetTickCount();
	local bSelfIsLock = Exchange:IsLocked("self");
	
	if (bSelfIsLock == true) then	    --ԭ����������׼��ȡ������
		g_LastLockTime = nNowTickCount;		
	else                               --ԭ��δ������׼������
		if(g_LastLockTime >0 and (nNowTickCount - g_LastLockTime) < LOCK_TIME_DIFF) then
			PushDebugMessage("#{JYTX_090303_1}");
			return;
		end
	end
	
	Exchange:LockExchange();
end


--===============================================
-- ������ף�ͬ�⽻�ף�
--===============================================
function Trade_Accept_Button_Clicked()

	Trade_Accept_Button:Disable();
	Exchange:AcceptExchange();

end


--===============================================
-- �򿪽�Ǯ�Ի���
--===============================================
function Exchange_Open_InputMoney_Clicked()

	Exchange:OpenPetFrame();

end

--===============================================
-- ɾ��ѡ�еĳ���
--===============================================
function Trade_DeletePet_Button_Clicked()
	
	local nIndex = Exchange_Self_PetList:GetFirstSelectItem();
	if(nIndex == -1)    then
		return ;
	end
	Exchange:DelSelectPet(g_nSelfPetID[nIndex]);
	
end 

--===============================================
-- �Ҽ����
--===============================================
function Exchange_Other_PetList_RClick()
	local nIndex = Exchange_Other_PetList:GetFirstSelectItem();
	
	if(nIndex == -1) then
		return ;
	end
	
	Exchange:ViewPetDesc("other",g_nOtherPetID[nIndex]);
end

--===============================================
-- �Ҽ����
--===============================================
function Exchange_Self_PetList_RClick()
	local nIndex = Exchange_Self_PetList:GetFirstSelectItem();

	if(nIndex == -1) then
		return ;
	end

	Exchange:ViewPetDesc("self",g_nSelfPetID[nIndex]);	
end

function ExchangeValidate_TimeReach1()
    PushDebugMessage("Giao d�ch qu� h�n, xin ti�p t�c th� giao d�ch l�i.");
    Exchange_Cancel();
    ExchangeValidate_StopWatch1:SetProperty("Timer", "-1");
end