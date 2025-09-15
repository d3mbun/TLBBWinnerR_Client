--��̯��Ϣ

--��̯���������������ǻظ�����
local NEW_MESSAGE   = 0;
local REPLY_MESSAGE = 1;
local g_NewOrReply  = NEW_MESSAGE;

--̯��������ҵı�־	=1��ʾ̯��  =0��ʾ���
local SALESMAN = 1;
local BUYER  = 0;
local g_nSalesman = -1;

-- �޸Ĺ���ﰴť������״̬���������������ġ�
local AD_ISSUE		=0  
local AD_REJIGGER =1  
local g_AdState		= AD_REJIGGER;

--�ظ���ť��Ӧ����ϢID
local g_nMessageId = -1;

--===============================================
-- OnLoad()
--===============================================
function StallMessage_PreLoad()

	this:RegisterEvent("OPEN_STALL_MESSAGE");
	this:RegisterEvent("CLOSE_STALL_MESSAGE");
	
end

function StallMessage_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function StallMessage_OnEvent(event)

	if(event == "OPEN_STALL_MESSAGE") then
		
		--̯���򿪵�BBS
		if(arg0 == "sale") then
			g_nSalesman = SALESMAN;
			
			StallMessage_Checkbox_Locked:Disable();
			StallMessage_Checkbox_Locked:SetCheck(0);
			
			if(g_AdState == AD_ISSUE) then
				StallMessage_Ad:SetText("C�ng b�");
				StallMessage_EditText:Show();
				StallMessage_StaticText:Hide();
			else
				StallMessage_Ad:SetText("бi");
				StallMessage_EditText:Hide();
				StallMessage_StaticText:Show();
				StallMessage_StaticText:SetText("#c9CCF00".. StallSale:GetAdvertise());
				
				--AxTrace(0, 0, "#B"..StallSale:GetAdvertise());
			
			end
			
			--ֻҪ��̯���򿪣�ʼ����Ҫ��ʾ�����ť			
			StallMessage_Ad:Show();
			StallMessage_ClearMessage:Show()

		elseif(arg0 == "buy") then
			g_nSalesman = BUYER;
			StallMessage_Ad:Hide();
			StallMessage_ClearMessage:Hide()
		end
		
		this:Show();
		g_nMessageId = -1;
		StallMessage_UpdateFrame();
		
	elseif(event == "CLOSE_STALL_MESSAGE") then
		this:Hide();
	end

end

--===============================================
-- OnEvent()
--===============================================
--��AddChatBoardElement�����Ӹ�����������index��ʾ�ǵڼ�����Ϣ��
--�Լ��İ�̯��indexΪ -2 �� -21 �� ���˵İ�̯��indexΪ -22 �� -41
--���������Ҽ�ʱ��ͨ�����ID�õ��������ݣ����ھٱ���
--by wangdw 2008.05.22
function StallMessage_UpdateFrame(event)

	StallMessage_Desc:ClearAllElement();
		
	local nMsgId;
	local szAuthorName;
	local szTime;
	local szMessage;
	local bReply;
	local szReplyMsg;
	
	--����̯��
	if(g_nSalesman == SALESMAN) then
	
		StallMessage_EditText:Hide();
		StallMessage_StaticText:Show();
		
		g_AdState = AD_REJIGGER;
		StallMessage_Ad:SetText("бi");

		local nMessageNum = StallBbs:GetMessageNum("sale");
		for i=1, nMessageNum do
			
			nMsgId,szAuthorName,szTime,szMessage,bReply,szReplyMsg = StallBbs:EnumMessage(i-1,"sale");
			
			--1���Ա����ֺ�ID��ϣ�������Լ���
			if(szAuthorName == "#{_INFOUSR"..Player:GetName().."}("..StallSale:GetGuid()..")" )then
				StallMessage_Desc:AddChatBoardElement(szAuthorName);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				
			elseif(szAuthorName == "_SYSTEM")  then
				StallMessage_Desc:AddChatBoardElement("Ghi ch�p mua s�m: "..szTime);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement("#R"..szMessage,i-1);
			
			--2����������Լ�
			else
				StallMessage_Desc:AddChatBoardElement(szAuthorName,i-1);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				--����Ѿ��лظ���Ϣ
				if(bReply == true) then
					StallMessage_Desc:AddChatBoardElement("   tr� l�i ch� qu�n: "..szReplyMsg);
				else
					--�ظ���ť
					--StallMessage_Desc:AddOptionElement("�ظ�" .. tostring(nMsgId));
					StallMessage_Desc:AddOptionElement("Tr� l�i&".. nMsgId ..",0$-1");
				end
			
			end
		end
	
	--�������
	elseif(g_nSalesman == BUYER) then
		StallMessage_StaticText:SetText("#c9CCF00"..StallBuy:GetAdvertise());

		nMessageNum = StallBbs:GetMessageNum("buy");
		
		--���ܻظ�
		StallMessage_Checkbox_Locked:SetCheck(0);
		StallMessage_Checkbox_Locked:Disable();

		
		for i=1, nMessageNum do
			
			nMsgId,szAuthorName,szTime,szMessage,bReply,szReplyMsg = StallBbs:EnumMessage(i-1,"buy");
			
			if(szAuthorName == "_SYSTEM")  then
				
				StallMessage_Desc:AddChatBoardElement("Ghi ch�p mua s�m: "..szTime);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement("#R"..szMessage,i-1+20);

			else
				StallMessage_Desc:AddChatBoardElement(szAuthorName,i-1+20);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				if(bReply == true) then
					StallMessage_Desc:AddChatBoardElement("   tr� l�i ch� qu�n: "..szReplyMsg);
				end
			
			end
			
		end
	end
	StallMessage_Desc:PageEnd();
end

--===============================================
-- OnEvent()
--===============================================
function StallMessage_FrameUpdate()
	
end

--===============================================
-- ���� & �ظ���������״̬��ֻ����̯����������Ч��
--     ״̬1����������
--     ״̬2�����ظ���
--===============================================
function StallMessage_SendMessage_Clicked()

	--����̯��
	if(g_nSalesman == SALESMAN) then
		--AxTrace(0, 0, "sale");
		if(g_NewOrReply == NEW_MESSAGE) then
			--������Ϣ
			--AxTrace(0, 0, "AddMsg");
			StallBbs:AddMessage(StallMessage_EditInfoText:GetText(),"sale");
			
		else
			--�ظ�
			StallBbs:ReplyMessage(g_nMessageId+0,StallMessage_EditInfoText:GetText());
			
			g_NewOrReply = NEW_MESSAGE;
			StallMessage_Checkbox_Text:SetText("");
					
		end
		
	-- �������	��û�лظ�״̬��
	elseif(g_nSalesman == BUYER)  then
			StallBbs:AddMessage(StallMessage_EditInfoText:GetText(),"buy");
		
	end
	
	
	StallMessage_EditInfoText:SetText("");

end


--===============================================
-- �������
--===============================================
function StallMessage_ClearMessage_Clicked()

	local nMessageNum = StallBbs:GetMessageNum("sale");
	if(nMessageNum <= 0) then
	   return
	end
	
	StallMessage_Desc:ClearAllElement();
	StallBbs:DeleteMessageByID(-1)
	StallMessage_Desc:PageEnd();

end

--===============================================
-- ���ȷ����ť��������״̬��ֻ����̯����������Ч��
--     ״̬1����������
--     ״̬2�������ġ�
--===============================================
function StallMessage_Ad_Clicked()

	if(g_AdState == AD_ISSUE) then
	
		if( 0 == StallSale:ApplyAd(StallMessage_EditText:GetText()) )  then
			--����ʧ��
			return;
		end
				
		StallMessage_StaticText:SetText("#B"..StallMessage_EditText:GetText());
		StallMessage_EditText:Hide();
		StallMessage_StaticText:Show();
		
		g_AdState = AD_REJIGGER;
		StallMessage_Ad:SetText("бi");
		
		
		StallMessage_EditText:SetProperty("DefaultEditBox", "False");
	
	else
	
		StallMessage_EditText:SetText("");
		StallMessage_EditText:Show();
		StallMessage_StaticText:Hide();
		g_AdState = AD_ISSUE;
		StallMessage_Ad:SetText("C�ng b�");
		StallMessage_EditText:SetProperty("DefaultEditBox", "True");
	
	end

end

--===============================================
-- ���һ���ظ���ť�Ĳ��� 
--===============================================
function StallMessageOption_Clicked()

	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");
	
	AxTrace(0,0, pos1 .. pos2 .. pos3 .. pos4 );
	
	-- ��¼�������Ϣ��ID	
	g_nMessageId = string.sub(arg0, pos2+1,pos3-1 );
	
	-- ��Ӧ�Ľ���䶯
	StallMessage_Checkbox_Locked:SetCheck(1);
	StallMessage_Checkbox_Locked:Enable();
	
	StallMessage_Checkbox_Text:SetText("Tr� l�i tin nh�n");
	
	StallMessage_EditInfoText:SetProperty("DefaultEditBox", "True");
	
	g_NewOrReply = REPLY_MESSAGE;

end

--===============================================
-- �����CheckBox��ȡ���ظ�״̬ 
--===============================================
function StallMessage_ReplyCheck_Clicked()

	-- ��Ӧ�Ľ���䶯
	StallMessage_Checkbox_Locked:SetCheck(0);
	StallMessage_Checkbox_Locked:Disable();
	StallMessage_Checkbox_Text:SetText("");
	
	g_NewOrReply = NEW_MESSAGE;

end

function StallMessage_Frame_OnHiden()
	StallMessage_EditInfoText:SetProperty("DefaultEditBox", "False");
	StallMessage_EditText:SetProperty("DefaultEditBox", "False");
end