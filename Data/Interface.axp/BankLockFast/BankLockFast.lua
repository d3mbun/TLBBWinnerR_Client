local g_BankLockFast_Frame_UnifiedPosition;
--�����ʾ��Ч������
function BankLockFast_PreLoad()
	this:RegisterEvent("BANK_LOCKFAST_UPDATE");
		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function BankLockFast_OnLoad()
  g_BankLockFast_Frame_UnifiedPosition=BankLockFast_Frame:GetProperty("UnifiedPosition");
end

function BankLockFast_OnEvent(event)
	if ( event == "BANK_LOCKFAST_UPDATE" ) then
		local careobjid = Target:GetServerId2ClientId(tonumber(arg0));
		this:CareObject(careobjid, 1, "BankLockFast");
		BankLockFast_update();
		this:Show();
	end
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		BankLockFast_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		BankLockFast_Frame_On_ResetPos()
	end	
end

function BankLockFast_tiqu_Clicked()
	SafeBox("getmoney");
end

function BankLockFast_cunru_Clicked()
	SafeBox("savemoney");
end

function BankLockFast_kaiqi_Clicked()
	SafeBox("unlock");
end

function BankLockFast_suoding_Clicked()
	SafeBox("lock");
end

function BankLockFast_update()
	local boxstatus = SafeBox("getstatus");
	local statusmsg;
	local finalmsg;
	if(boxstatus == "locked") then
		BankLockFast_Save:Enable();
		BankLockFast_Lock:Disable();
		BankLockFast_Get:Disable();
		BankLockFast_Unlock:Enable();
		statusmsg = "Tr�ng th�i b�o hi�m s߽ng: #GKh�a иnh#W#r"
		finalmsg = statusmsg.."#{YHBXX_20071220_14}";
	elseif(boxstatus == "freezed") then
		BankLockFast_Save:Enable();
		BankLockFast_Lock:Enable();
		BankLockFast_Get:Disable();
		BankLockFast_Unlock:Disable();
		local leftday  = SafeBox("getleftday");
		local lefthour = SafeBox("getlefthour");
        statusmsg = string.format("Tr�ng th�i b�o hi�m s߽ng: #GTrong th�i gian Gi�i kh�a#W (c�n #G%d#W ng�y #G%d#W gi�) #r",leftday,lefthour);
		finalmsg = statusmsg.."#{YHBXX_20071220_15}";
	elseif(boxstatus == "unfreezed") then
		BankLockFast_Save:Enable();
		BankLockFast_Lock:Enable();
		BankLockFast_Get:Enable();
		BankLockFast_Unlock:Disable();
		statusmsg = "Tr�ng th�i b�o hi�m s߽ng: #GGi�i Kh�a#W#r"
		finalmsg = statusmsg.."#{YHBXX_20071220_16}";
	end
	BankLockFast_WarningText:SetText(finalmsg);
	
	local safeboxmoney = SafeBox("getsafeboxmoney");
	BankLockFast_Money:SetProperty("MoneyNumber", safeboxmoney);	

end

function BankLockFast_Close()
	SafeBox("onclose");
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function BankLockFast_Frame_On_ResetPos()
  BankLockFast_Frame:SetProperty("UnifiedPosition", g_BankLockFast_Frame_UnifiedPosition);
end