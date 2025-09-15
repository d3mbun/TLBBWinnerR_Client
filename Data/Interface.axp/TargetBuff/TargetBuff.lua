local TARGET_BUFF_MAX = 20;
local TARGET_IMPACT_CTL = {};

function TargetBuff_PreLoad()
	this:RegisterEvent("MAINTARGET_CHANGED");
	this:RegisterEvent("MAINTARGET_OPEN");
	this:RegisterEvent("MAINTARGET_BUFF_REFRESH");
end

function TargetBuff_OnLoad()
	TARGET_IMPACT_CTL[1] = TargetBuff_Image1;
	TARGET_IMPACT_CTL[2] = TargetBuff_Image2;
	TARGET_IMPACT_CTL[3] = TargetBuff_Image3;
	TARGET_IMPACT_CTL[4] = TargetBuff_Image4;
	TARGET_IMPACT_CTL[5] = TargetBuff_Image5;
	TARGET_IMPACT_CTL[6] = TargetBuff_Image6;
	TARGET_IMPACT_CTL[7] = TargetBuff_Image7;
	TARGET_IMPACT_CTL[8] = TargetBuff_Image8;
	TARGET_IMPACT_CTL[9] = TargetBuff_Image9;
	TARGET_IMPACT_CTL[10] = TargetBuff_Image10;
	TARGET_IMPACT_CTL[11] = TargetBuff_Image11;
	TARGET_IMPACT_CTL[12] = TargetBuff_Image12;
	TARGET_IMPACT_CTL[13] = TargetBuff_Image13;
	TARGET_IMPACT_CTL[14] = TargetBuff_Image14;
	TARGET_IMPACT_CTL[15] = TargetBuff_Image15;
	TARGET_IMPACT_CTL[16] = TargetBuff_Image16;
	TARGET_IMPACT_CTL[17] = TargetBuff_Image17;
	TARGET_IMPACT_CTL[18] = TargetBuff_Image18;
	TARGET_IMPACT_CTL[19] = TargetBuff_Image19;
	TARGET_IMPACT_CTL[20] = TargetBuff_Image20;
end

function TargetBuff_OnEvent( event )
	if(0 == TargetBuff_IsTargetValid()) then
		TargetBuff_Clear();
		this:Hide();
		return;
	end
	
	if(event == "MAINTARGET_OPEN") then
		--AxTrace(0,0,"event1:"..event);
		TargetBuff_Update();
		this:Show();
	elseif(event == "MAINTARGET_CHANGED") then
		if(-1 ~= tonumber(arg0)) then
			--AxTrace(0,0,"event2.1:"..event);
			TargetBuff_Update();
			this:Show();
		else
			--AxTrace(0,0,"event2.2:"..event);
			TargetBuff_Clear();
			this:Hide();
		end
	elseif(event == "MAINTARGET_BUFF_REFRESH") then
		--AxTrace(0,0,"event3:"..event);
		TargetBuff_Update();
		this:Show();
	end
end

-- 返回0，不显示。返回1，显示。
function TargetBuff_IsTargetValid()
	if(Target:IsPresent()) then
		return 1;
	elseif(Target:IsTargetTeamMember()) then
		return 1;
	else
		return 0;
	end
end

function TargetBuff_Update()
	local nBuffNum = Target:GetBuffNumber();
	if(0 == nBuffNum) then
		TargetBuff_Clear();
		this:Hide();	
	end
	if(nBuffNum > TARGET_BUFF_MAX) then nBuffNum = TARGET_BUFF_MAX; end
	
	local i = 0;
	local m = 0;
	while i < nBuffNum do
		local szIconName;
		local szTipInfo;
		
		szIconName,szTipInfo = Target:GetBuffIconNameByIndex(i);
		if szTipInfo ~= "TTPS" and m <= 19 then
			TARGET_IMPACT_CTL[m+1]:SetProperty("ShortImage", szIconName);
			TARGET_IMPACT_CTL[m+1]:Show();
			TARGET_IMPACT_CTL[m+1]:SetToolTip(szTipInfo);
			m = m + 1;
		end
		i = i + 1;
	end
	
	while m < TARGET_BUFF_MAX do
		TARGET_IMPACT_CTL[m+1]:SetToolTip("");
		TARGET_IMPACT_CTL[m+1]:Hide();
		m = m + 1;
	end
end

function TargetBuff_Clear()
	local i = 0;
	while i < TARGET_BUFF_MAX do
		TARGET_IMPACT_CTL[i+1]:SetToolTip("");
		TARGET_IMPACT_CTL[i+1]:Hide();
		i = i + 1;
	end
end