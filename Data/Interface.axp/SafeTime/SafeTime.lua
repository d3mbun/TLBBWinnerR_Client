local g_SafeTime_Frame_UnifiedXPosition;
local g_SafeTime_Frame_UnifiedYPosition;
function SafeTime_PreLoad()
	this:RegisterEvent("OPENDLG_FOR_SETPROTECTTIME");

	this:RegisterEvent("LEFTPROTECTTIME_CHANGE");

	this:RegisterEvent("DBLEFTPROTECTTIME_CHANGE");
	this:RegisterEvent("ADJEST_UI_POS")
		
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SafeTime_OnLoad()
	-- ����Ĭ�����λ��
	g_SafeTime_Frame_UnifiedXPosition	= SafeTime_Frame:GetProperty("UnifiedXPosition");
	g_SafeTime_Frame_UnifiedYPosition	= SafeTime_Frame:GetProperty("UnifiedYPosition");
end

function SafeTime_OnEvent( event )
	if ( event == "OPENDLG_FOR_SETPROTECTTIME" ) then
		if( this:IsVisible() ) then
			SafeTime_Close();
		else
			SafeTime_Open();
		end
	elseif(event == "LEFTPROTECTTIME_CHANGE")then
		if( this:IsVisible() ) then
			SafeTime_UpdateLeftSafeTime(tonumber(arg0));
		end
	elseif(event == "DBLEFTPROTECTTIME_CHANGE")then
		if( this:IsVisible() ) then
			SafeTime_DBUpdateLeftSafeTime(tonumber(arg0));
		end
	elseif (event == "ADJEST_UI_POS" ) then
		SafeTime_Frame_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SafeTime_Frame_ResetPos()
	end
end

function SafeTime_DBUpdateLeftSafeTime(time)
	    if (tonumber(time) <= 0) then
		SafeTime_CurrentTime:SetText("#{FDH_090227_4}");
		return
	    end
	    local iTime = math.floor( time / 1000 )
	    local iHor = math.floor( iTime / 3600 )
	    iTime = math.mod( iTime ,3600 )
	    local iMin = math.floor( iTime / 60 )
	    local strTime="";
	    if(iHor>0)then
		strTime = strTime..iHor.." gi�";
	    end
	    if(iMin>0)then
		strTime = strTime..iMin.." ph�t";
	    end

	    SafeTime_CurrentTime:SetText("#{FDH_090112_06}#cFFFF00"..strTime);
end

function SafeTime_UpdateLeftSafeTime(time)
	    local iTime = math.floor( time / 1000 )
	    local iHor = math.floor( iTime / 3600 )
	    iTime = math.mod( iTime, 3600 )
	    local iSec = math.mod( iTime, 60 )
	    local iMin = math.floor( iTime / 60 )
	    local strHor ,strMin,strSec;
	    if(iHor<10)then
		strHor="0"..iHor;
	    else
		strHor=""..iHor;
	    end
	    if(iMin<10)then
		strMin="0"..iMin;
	    else
		strMin=""..iMin;
	    end
	    if(iSec<10)then
		strSec ="0"..iSec;
	    else
		strSec = ""..iSec;
	    end
	    SafeTime_StopWatch_Text:SetText("#{FDH_090112_07}#c00FF00"..strHor..":"..strMin..":"..strSec);
end

function SafeTime_Close()
	Variable:SetVariable("SafeTimePos", SafeTime_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function SafeTime_Open()
	CloseWindow("ErjimimaShezhi", true)
	CloseWindow("ErjimimaXiugai", true)
	CloseWindow("ErjimimaJiesuo", true)
	CloseWindow("Fangdao", true)
	CloseWindow("DianhuaMibao", true)
	SafeTime_InitDlg();
	this:Show();
end

function SafeTime_InitDlg()
	--SafeTime_SetHour:SetText(0);
	SafeTime_SetMin:SetText(10);
	SafeTime_SetMin:SetProperty("DefaultEditBox", "True");
	SafeTime_SetMin:SetSelected( 0, -1 );
	local dblefttime = DataPool:GetDBLeftProtectTime();
	if(tonumber(dblefttime) <= 0) then
		SafeTime_CurrentTime:SetText("#{FDH_090227_4}");
		SafeTime_StopWatch_Text:SetText("");
	else
		SafeTime_DBUpdateLeftSafeTime(tonumber(dblefttime));
		dblefttime =DataPool:GetLeftProtectTime();
		SafeTime_UpdateLeftSafeTime(tonumber(dblefttime));
	end

	local safeTimePos = Variable:GetVariable("SafeTimePos");
	if(safeTimePos ~= nil) then
		SafeTime_Frame:SetProperty("UnifiedPosition", safeTimePos);
	end

	SafeTime_AQtime:SetCheck(1)
	SafeTime_Erjimima:SetCheck(0)
	SafeTime_TelMibao:SetCheck(0)
end

function CheckIfOK()
	local Min = SafeTime_SetMin:GetText();
	if(Min~=nil and tonumber(Min)~=nil) then
		if(tonumber(Min)>60) then
			PushDebugMessage("S� ph�t m� c�c h� nh�p v�o kh�ng th� l�n h�n 60 ph�t, vui l�ng nh�p l�i.")
			SafeTime_SetMin:SetText("3")
		elseif (tonumber(Min)<1) then
			PushDebugMessage("Th�i gian an to�n �t nh�t l� 1 ph�t, vui l�ng nh�p l�i.")
			SafeTime_SetMin:SetText("10")
		end
	end
end

function SafeTime_ResetSelect(idx)
	if(idx==0) then
		--SafeTime_SetHour:SetSelected( 0, -1 );
	else
		SafeTime_SetMin:SetSelected( 0, -1 );
	end
end

function SafeTime_OK_Click()
	local Min = SafeTime_SetMin:GetText();
	--local Hor = SafeTime_SetHour:GetText();
	local dblefttime =DataPool:GetLeftProtectTime();
	if(tonumber(dblefttime)>0)then
		PushDebugMessage("Trong th�i gian an to�n kh�ng cho ph�p thi�t l�p l�i th�i gian an to�n!")
		return
	end

	if(Min~=nil and tonumber(Min)~=nil) then
		if(tonumber(Min)>60) then
			PushDebugMessage("S� ph�t m� c�c h� nh�p v�o kh�ng th� l�n h�n 60 ph�t, vui l�ng nh�p l�i.")
			return
		elseif (tonumber(Min)<1) then
			PushDebugMessage("Th�i gian an to�n �t nh�t l� 1 ph�t, vui l�ng nh�p l�i.")
			return
		end
	else
		PushDebugMessage("Thi�t l�p kh�ng th�nh c�ng! Th�i gian an to�n kh�ng th� l� � tr�ng!")
		return
	end

	Lua_SetProtectTime(0,tonumber(Min));

  this:Hide();
end

function SafeTime_Erjimima_Clicked()
	SafeTime_Close();
	OpenMinorPassword();
end

function SafeTime_OnHide()
	Variable:SetVariable("SafeTimePos", SafeTime_Frame:GetProperty("UnifiedPosition"), 1);
end

function SafeTime_TelMibao_Clicked()
	SafeTime_Close();
	OpenDianhuaMibao();
end
function SafeTime_Frame_ResetPos()
	SafeTime_Frame:SetProperty("UnifiedXPosition", g_SafeTime_Frame_UnifiedXPosition);
	SafeTime_Frame:SetProperty("UnifiedYPosition", g_SafeTime_Frame_UnifiedYPosition);
end