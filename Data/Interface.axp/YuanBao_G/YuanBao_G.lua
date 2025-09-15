local g_Shouxu = 1;
local g_limit = 50;
local g_YuanBao_G_Frame_UnifiedPosition;
local g_YuanBao_Limit = {
							[0] = {min = 25, max = 50},
							[1] = {min = 100, max = 200},
							[2] = {min = 250, max = 500},
						}

function YuanBao_G_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");

		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end
	
function YuanBao_G_OnLoad()
	 g_YuanBao_G_Frame_UnifiedPosition=YuanBao_G_Frame:GetProperty("UnifiedPosition");
end

-- OnEvent
function YuanBao_G_OnEvent(event)
	if ( event == "UI_COMMAND" ) then

		if(tonumber(arg0) == 19850424 and 3 == Get_XParam_INT(1)) then
		--����Ԫ��
			local yuanbao = tonumber(Player:GetData("YUANBAO"));
			if(g_limit + g_Shouxu > yuanbao) then
				PushDebugMessage("Nguy�n b�o tr�n ng߶i c�a c�c h� nh� h�n 51, ch� khi c� s� l��ng nguy�n b�o l�n h�n ho�c b�ng 51 m�i c� th� g�i b�n.")
				this:Hide();
				return;
			end
			 xx =  Get_XParam_INT(0)
			objCared = DataPool : GetNPCIDByServerID(xx);
			YuanBao_G_Shown();
			this:Show();
			this:CareObject(objCared, 1, "CommisionStall");
		end
	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--ȡ������
			StopCareObject_Carriage(objCared);
		end
	elseif (event == "OBJECT_CARED_EVENT") then
		this:Hide();
	elseif(event == "OPEN_EXCHANGE_FRAME") then
		this:Hide();
	end
			-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		YuanBao_G_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YuanBao_G_Frame_On_ResetPos()
	end
end

function YuanBao_G_Shown()
	YuanBao_G_Type1:SetCheck(1);
	YuanBao_G_Type2:SetCheck(-1);
	YuanBao_G_Type3:SetCheck(-1);
	YuanBao_G_InputMoney_Gold:SetProperty("DefaultEditBox", "True");
	YuanBao_G_InputMoney_Gold:SetText("0");
	YuanBao_G_InputMoney_Silver:SetText("0");
	YuanBao_G_InputMoney_CopperCoin:SetText("0");
	YuanBao_G_InputMoney_Gold:SetSelected( 0, -1 );
end

function YuanBao_G_OK_Click()
	local nYuanbao =0; 
	local g_grad =0;
	if(tonumber(YuanBao_G_Type1 : GetCheck()) == 1) then
		g_grad =0;
		nYuanbao = 50;
	elseif(tonumber(YuanBao_G_Type2 : GetCheck()) == 1)then
		g_grad =1;
		nYuanbao = 200;
	elseif(tonumber(YuanBao_G_Type3 : GetCheck()) == 1) then
		g_grad =2;
		nYuanbao = 500;
	end
	local nGlod = tonumber(YuanBao_G_InputMoney_Gold:GetText());
	local nSilver = tonumber(YuanBao_G_InputMoney_Silver:GetText());
	local nCopperCoin = tonumber(YuanBao_G_InputMoney_CopperCoin:GetText());
	local nHaveYuanbao = tonumber(Player:GetData("YUANBAO"));
	if(nYuanbao == 0) then
		PushDebugMessage("Xin ch�n lo�i h�nh nguy�n b�o g�i b�n!")
		return;
	end
	if(nGlod==nil or nSilver == nil or nCopperCoin == nil) then
		PushDebugMessage("� nh�p ti�n kh�ng cho ph�p � tr�ng!")
		return
	end
	local bAvailability,nMoney = Bank:GetInputMoney(nGlod,nSilver,nCopperCoin);
	if(bAvailability~=true or nMoney <=0)then
		PushDebugMessage("Ti�n kh�ng th� l� 0!")
		return;
	end
	if tonumber(nMoney) < g_YuanBao_Limit[g_grad].min * 10000 then
		local errMsg = string.format( "%d Nguy�n B�o g�i b�n gi� c� kh�ng th� th�p d߾i %d v�ng", tonumber(nYuanbao), g_YuanBao_Limit[g_grad].min)
		PushDebugMessage(errMsg)
		return
	end 
	if tonumber(nMoney) > g_YuanBao_Limit[g_grad].max * 10000 then
		local errMsg = string.format( "%d Nguy�n B�o g�i b�n gi� c� kh�ng th� cao h�n %d v�ng", tonumber(nYuanbao), g_YuanBao_Limit[g_grad].max)
		PushDebugMessage(errMsg)
		return
	end 
	
	if( tonumber(nHaveYuanbao) < tonumber(nYuanbao) +  tonumber(nYuanbao)*2/100) then
		local tmpnum = tonumber(nYuanbao) +  tonumber(nYuanbao)*2/100;
		PushDebugMessage("S� nguy�n b�o tr�n ng߶i c�c h� kh�ng �� "..tmpnum..", xin ch�n l�i t� �u.")
		return
	end
	--�ж�ok ��������ȥҲ
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Sell");
		Set_XSCRIPT_ScriptID(800116);
		Set_XSCRIPT_Parameter(0,tonumber(xx));
		Set_XSCRIPT_Parameter(1,tonumber(g_grad));
		Set_XSCRIPT_Parameter(2,tonumber(nMoney));
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	this:Hide();
end

function YuanBao_G_CheckIfOK(idx)
	local nNum = nil;
	local szErr = nil ;
	local Ctl = nil;
	if(idx == 1)then
		nNum = tonumber(YuanBao_G_InputMoney_Gold : GetText());
		Ctl = YuanBao_G_InputMoney_Gold;
		szErr = "";
	elseif(idx == 2) then
		nNum = tonumber(YuanBao_G_InputMoney_Silver : GetText());
		Ctl = YuanBao_G_InputMoney_Silver;
		szErr = "Ch� cho ph�p nh�p v�o gi� tr� nh� h�n 100!";
	elseif(idx == 3) then
		nNum = tonumber(YuanBao_G_InputMoney_CopperCoin : GetText());
		Ctl = YuanBao_G_InputMoney_CopperCoin;
		szErr = "Ch� cho ph�p nh�p v�o gi� tr� nh� h�n 100!";
	end
	if(szErr ==nil or Ctl == nil)then
		return
	end
	if(nNum == nil)then
		nNum = 0;
	end
	nNum = tostring(nNum);
	if(nNum ~= Ctl : GetText())then
		Ctl:SetText(nNum);
	end
end

function YuanBao_G_ResetSelect(idx)
	if(idx==1) then
		YuanBao_G_InputMoney_Gold:SetSelected( 0, -1 );
	elseif(idx==2) then
		YuanBao_G_InputMoney_Silver:SetSelected( 0, -1 );
	else
		YuanBao_G_InputMoney_CopperCoin:SetSelected( 0, -1 );
	end
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function YuanBao_G_Frame_On_ResetPos()
  YuanBao_G_Frame:SetProperty("UnifiedPosition", g_YuanBao_G_Frame_UnifiedPosition);
end