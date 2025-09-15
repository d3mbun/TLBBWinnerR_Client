-------------------------------------------------------
--"�Զ�����ְλ����"����ű�
--create by xindefeng
-------------------------------------------------------

local g_NameCtls = nil	--��Ҫ�õ��Ŀؼ���

--��׼���ְλ����
local g_StdPositionName = {
	"Bang ch� ",			--9
	"Ph� bang ch� ",		--8
	"N�i v� s� ",		--7
	"C�ng v� s� ",		--6
	"Ho�ng h�a s� ",		--5
	"Th߽ng nh�n ",			--4
	"Tinh anh ",			--3
	"Bang ch�ng "			--2
}

--Reset��ť�Ƿ�ʹ�ù���־
local g_ResetBtnFlag = {0,0,0,0,0,0,0,0}

local g_SaveForReset = nil --����򿪽���ʱ"�Զ���ְλ����"����Reset
local g_ConfraternityCustomPosition_Frame_UnifiedPosition;

--�¼�ע��
function ConfraternityCustomPosition_PreLoad()
	this:RegisterEvent("GUILD_SHOW_CUSTOMPOSITION")
	this:RegisterEvent("GUILD_FORCE_CLOSE")
		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityCustomPosition_OnLoad()	
		g_ConfraternityCustomPosition_Frame_UnifiedPosition=ConfraternityCustomPosition_Frame:GetProperty("UnifiedPosition");
end

--�¼���Ӧ
function ConfraternityCustomPosition_OnEvent(event)	
	if( event == "GUILD_SHOW_CUSTOMPOSITION" ) then
		ConfraternityCustomPosition_SetCtls()	--���ÿؼ�
		g_ResetBtnFlag = {0,0,0,0,0,0,0,0}
		
		ConfraternityCustomPosition_Clear()
		ConfraternityCustomPosition_Update()
		ConfraternityCustomPosition_Show()
	elseif( event == "GUILD_FORCE_CLOSE" ) then	
		ConfraternityCustomPosition_Close()
	end
	
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityCustomPosition_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityCustomPosition_Frame_On_ResetPos()
	end
end

--���ÿؼ���
function ConfraternityCustomPosition_SetCtls()
	g_NameCtls = nil;
	
	g_NameCtls = {
									oldNames = {
										          	CurCustomPosition1,
										          	CurCustomPosition2,
										          	CurCustomPosition3,
										          	CurCustomPosition4,
										          	CurCustomPosition5,
										          	CurCustomPosition6,
										          	CurCustomPosition7,
										          	CurCustomPosition8,
										         },
									newNames = {
										          	Edit_CustomPosition1,
										          	Edit_CustomPosition2,
										          	Edit_CustomPosition3,
										          	Edit_CustomPosition4,
										          	Edit_CustomPosition5,
										          	Edit_CustomPosition6,
										          	Edit_CustomPosition7,
										          	Edit_CustomPosition8
										         },
									ResetBtn = {
																ConfraternityCustomPosition_Reset_Button1,
																ConfraternityCustomPosition_Reset_Button2,
																ConfraternityCustomPosition_Reset_Button3,
																ConfraternityCustomPosition_Reset_Button4,
																ConfraternityCustomPosition_Reset_Button5,
																ConfraternityCustomPosition_Reset_Button6,
																ConfraternityCustomPosition_Reset_Button7,
																ConfraternityCustomPosition_Reset_Button8
														}
								}
end

--��ս�������
function ConfraternityCustomPosition_Clear()	
end

--ˢ�½�����ʾ������
function ConfraternityCustomPosition_Update()
	local szMsg = nil
	
	ConfraternityCustomPosition_Title:SetText("#gFF0FA0T� l�p ch�c v� ")
	
	--��ʾ��ǰ"�Զ���ְλ����"
	for i=1,8 do
		g_NameCtls.ResetBtn[i]:SetText("Kh�i ph�c")		--�޸İ�ť����
		
		szMsg = Guild:GetCurCustomPositionName(10-i)		
		g_SaveForReset[i] = szMsg	--����һ��,���ڱȽ��ж��Ƿ�Ĺ�		
		if((szMsg == "") or (szMsg == g_StdPositionName[i]))then
			szMsg = g_StdPositionName[i]
			g_NameCtls.ResetBtn[i]:Disable()	--����û�иĹ�,��ť����ʹ��,�ҵ�
		else
			szMsg = szMsg.."("..g_StdPositionName[i]..")"
			g_NameCtls.ResetBtn[i]:Enable()						--�Ĺ�,��ť����ʹ��			
		end
		
		--���õ�ǰ�Զ���ְλ����
		g_NameCtls.oldNames[i]:SetText(szMsg)
		
	end
	
	--���༭�����
	for i=1,8 do
		g_NameCtls.newNames[i]:SetText("")
	end	
	
end

--�򿪽���
function ConfraternityCustomPosition_Show()	
	this:Show()
end

--�رմ���
function ConfraternityCustomPosition_Close()
	this:Hide()
end

--��λ��ť
function ConfraternityCustomPosition_Reset(BtnId)
	g_NameCtls.oldNames[BtnId]:SetText(g_StdPositionName[BtnId])
	g_NameCtls.newNames[BtnId]:SetText("")
		
	g_ResetBtnFlag[BtnId] = 1	--����ʹ�ñ�־	
	
	g_NameCtls.ResetBtn[BtnId]:SetText("#{INTERFACE_XML_1154}")
	g_NameCtls.ResetBtn[BtnId]:Disable()	--�ָ�һ�ξͲ��������ˣ��ҵ�
end

--ȷ��
function ConfraternityCustomPosition_Ok()
	local szOld = nil
	local szNew = nil
	local bIsChanged = 0	--��¼�Ƿ��иı�
	local bLegal = 1			--�Ƿ�Ϸ�
	local result = 0			--�޸Ľ��
	local bTipFlag = 0		--�Ƿ���Ҫ��ʾ"�������뵱����ת���ַ�"
	
	--�ڼ�¼"���޸ĵİ���Զ���ְλ����"֮ǰ,�����һ�����ݽṹ
	Guild:ClearCustomPositionName()
	
	for i=1,8 do		
		--��ȡ����
		szNew = g_NameCtls.newNames[i]:GetText()
		
		--����Ƿ���Υ���ַ���������ͨ����洢����
		result = 0	--ÿ�ζ�Ҫ����
		if(g_ResetBtnFlag[i] == 1)then	--ʹ������Ӧ��Reset��ť,�ָ���׼ְλ����
			bIsChanged = bIsChanged + 1	--�����ı�
			result = Guild:AskModifyCustomPositionName(10-i, tostring(g_StdPositionName[i]), 1)	--���洢
		elseif((szNew ~= "") and (szNew ~= g_SaveForReset[i]))then	--�����Զ�����ְλ����
			bIsChanged = bIsChanged + 1	--�����ı�
			result = Guild:AskModifyCustomPositionName(10-i, tostring(szNew), 0)			--���洢
		end
		
		--����Υ����ʾ
		if (result == -1) then
			PushDebugMessage("B�ng h�u nh�p v�o \""..szNew.." Phi ph�p, mong b�ng h�u ch� � ng�n t� !")	
			bLegal = 0	--��ʶ��Υ���ַ�
			
			bIsChanged = bIsChanged - 1	--�ı�������1
		elseif (result == -2) then			
			bTipFlag = 1		--��Ҫ��ʾ"�������뵱����ת���ַ���"
			bLegal = 0	--��ʶ��Υ���ַ�
			
			bIsChanged = bIsChanged - 1	--�ı�������1
		end		
	end
	
	--�в��Ϸ��ַ���ֱ�ӷ���
	if(bLegal == 0) then
		if(bTipFlag == 1)then	--��Ҫ��ʾ
			PushDebugMessage("B�ng h�u nh�p v�o k� t� phi ph�p !")	--��ʾ��"�������뵱����ת���ַ���"
		end
		return
	end
	
	--����
	if(bIsChanged > 0) then	--�иı�
		Guild:AskModifyCustomPositionName(0)
	end
	
	--�رմ���
	this:Hide()	
end

--ȡ��
function ConfraternityCustomPosition_Cancel()
	this:Hide()
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityCustomPosition_Frame_On_ResetPos()
  ConfraternityCustomPosition_Frame:SetProperty("UnifiedPosition", g_ConfraternityCustomPosition_Frame_UnifiedPosition);
end