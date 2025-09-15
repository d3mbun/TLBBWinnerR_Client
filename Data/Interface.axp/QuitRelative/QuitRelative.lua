
-- 1-�����˳���Ϸ...
-- 2-�ͷ����������ӱ��Ͽ����Ƿ�����������? 
-- 3-�����������ӷ�����...
-- 4-���ӳɹ����������½��볡��...
-- 5-����ʧ��
local QuitRelative_Status = 0;


--===============================================
-- OnLoad()
--===============================================
function QuitRelative_PreLoad()
	this:RegisterEvent("QUIT_RELATIVE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function QuitRelative_OnLoad()

end


--===============================================
-- OnEvent()
--===============================================
function QuitRelative_OnEvent(event)
	if(event == "QUIT_RELATIVE") then
		if(arg0 == "QuitGaming...") then
			
			this:Show();
			QuitRelative_OK_Button:Hide();
			QuitRelative_Cancel_Button:Hide();
			QuitRelative_Text:SetText("�ang tho�t kh�i tr� ch�i...");
			QuitRelativeSelectUpdateRect();
			QuitRelative_Status=1;
		elseif(arg0 == "AskReconnect") then
			this:Show();
			QuitRelative_OK_Button:Show();
			QuitRelative_OK_Button:Enable();
			QuitRelative_Cancel_Button:Show();
			QuitRelative_Cancel_Button:Enable();
			QuitRelative_Text:SetText("M�t k�t n�i v�i server, c� k�t n�i l�i b�nh th߶ng kh�ng?");
			QuitRelativeSelectUpdateRect();
			QuitRelative_Status=2;
		elseif(arg0 == "EnterScene") then
			if(this:IsVisible()) then
				QuitRelative_Text:SetText("K�t n�i th�nh c�ng, b�t �u v�o tr� ch�i...");
				QuitRelative_Status=4;
			end
		elseif(arg0 == "ConnFailed") then
			this:Show();
			QuitRelative_OK_Button:Disable();
			QuitRelative_Cancel_Button:Enable();
			QuitRelative_Text:SetText("K�t n�i th�t b�i, nguy�n do sai s�t: #r" .. arg1);
			QuitRelative_Status=5;
		end
		
	elseif(event == "PLAYER_ENTERING_WORLD") then
		this:Hide();
	end
end

function QuitRelative_OK_Clicked()
	if(QuitRelative_Status == 2) then
		--�����������
		QuitRelative_OK_Button:Hide();
		QuitRelative_Cancel_Button:Enable();
		QuitRelative_Text:SetText("�ang k�t n�i m�y ch�...");
		QuitRelativeSelectUpdateRect();
		QuitRelative_Status=3;
		EnterReconnect(true);
	end
end

function QuitRelative_Cancel_Clicked()
	--����ѯ���Ƿ�����������������
	if(QuitRelative_Status == 2 or QuitRelative_Status == 3) then
		--����������ֱ���˳�
		EnterReconnect(false);
	elseif(QuitRelative_Status == 5) then
		QuitApplication("quit");
	end
end


function QuitRelativeSelectUpdateRect()
	local nWidth, nHeight = QuitRelative_Text:GetWindowSize();
	local nTitleHeight = 0;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	QuitRelative_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end