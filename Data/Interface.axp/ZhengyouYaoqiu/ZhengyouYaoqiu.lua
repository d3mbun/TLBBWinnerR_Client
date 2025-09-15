-- ����ƽ̨ : ����Ҫ�� cuiyinjie 2008.10.21

local OPT_ADD = 0;  -- ������Ϣ
local OPT_EDIT = 1; -- ������Ϣ
local g_CurStatus = OPT_EDIT;
local g_FriendType = 1;

-- ��������PlayerZhengyouPT.lua�ﶨ��һ�£�Ҫͬʱ����
local g_Conditions = {
	MenPai = {"Kh�ng gi�i h�n", "Thi�u L�m", "Minh Gi�o", "C�i Bang", "V� �ang", "Nga My", "Tinh T�c", "Thi�n Long", "Thi�n S�n", "Ti�u Dao", "M� Dung"},
	Level = {"Kh�ng gi�i h�n", "D߾i c�p 10", "C�p 10 �n 20", "C�p 20 �n 30", "C�p 30 �n 40", "C�p 40 �n 50", "C�p 50 �n 60", "C�p 60 �n 70", "C�p 70 �n 80", "C�p 80 �n 90", "C�p 90 �n 100", "Tr�n c�p 100"},
	Sexy = {"Kh�ng gi�i h�n", "Nam", "N�"},
	Mudi = { {"Kh�ng gi�i h�n","Bang ph�i chi�u m�","T�m bang ph�i",}, {"Kh�ng gi�i h�n","B�i s�","Thu nh�n � t�",}, },
}

local g_Ctrls = {};

function ZhengyouYaoqiu_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("ZHENGYOUPT_NOTIFY_INPUT_YAOQIU");
end

function ZhengyouYaoqiu_OnLoad()
	ZhengyouYaoqiu_SetControls();
  ZhengyouYaoqiu_OnInitDialog();
  ZhengyouYaoqiu_Frame:SetProperty("AlwaysOnTop","True");
end

function ZhengyouYaoqiu_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "ZhengyouYaoqiu") then
			this:Show();
		end

	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "ZhengyouYaoqiu") then
			this:Hide();
		end

	elseif ("ZHENGYOUPT_NOTIFY_INPUT_YAOQIU" == event ) then
	  ZhengyouYaoqiu_ShowWindow( arg0, arg2 );	-- arg1����
	end
end

function ZhengyouYaoqiu_Close()
   this:Hide();
end

--
function ZhengyouYaoqiu_SetControls()
	g_Ctrls = {
	    MenpaiCombo = ZhengyouYaoqiu_MenPai,
	    LevelCombo = ZhengyouYaoqiu_Level,
	    SexyCombo = ZhengyouYaoqiu_Sexy,
	    MudiCombo = ZhengyouYaoqiu_Mudi,
	};
end

-- ��ʼ�����ؼ�
function ZhengyouYaoqiu_OnInitDialog()
	for i = 1, table.getn(g_Conditions.MenPai) do
	   g_Ctrls.MenpaiCombo:ComboBoxAddItem(g_Conditions.MenPai[i], i - 1);
	end
	g_Ctrls.MenpaiCombo:SetCurrentSelect(0);

	for i = 1, table.getn(g_Conditions.Level) do
	   g_Ctrls.LevelCombo:ComboBoxAddItem(g_Conditions.Level[i], i - 1);
	end
	g_Ctrls.LevelCombo:SetCurrentSelect(0);

	for i = 1, table.getn(g_Conditions.Sexy) do
	   g_Ctrls.SexyCombo:ComboBoxAddItem(g_Conditions.Sexy[i], i - 1);
	end
	g_Ctrls.SexyCombo:SetCurrentSelect(0);

	ZhengyouYaoqiu_DragTitle:SetText("#{ZYPT_081103_064}");
end

--����Ŀ�ĸ��ݰ�ʦ�Ͱ��ɶ���ͬ������Ϊ��
function ZhengyouYaoqiu_ResetMudiCombo()
   g_Ctrls.MudiCombo:ResetList();
   g_Ctrls.MudiCombo:SetText("");
   local i = 1;
   if ( 2 == tonumber(g_FriendType) ) then -- ����
   		ZhengyouYaoqiu_Mudi:Show();
        ZhengyouYaoqiu_Text6:Show();
        for i = 1, table.getn(g_Conditions.Mudi[1]) do
           g_Ctrls.MudiCombo:ComboBoxAddItem(g_Conditions.Mudi[1][i], i - 1);
        end
           g_Ctrls.MudiCombo:SetCurrentSelect(0);
   elseif ( 3 == tonumber(g_FriendType) ) then
   		ZhengyouYaoqiu_Mudi:Show();
        ZhengyouYaoqiu_Text6:Show();
        for i = 1, table.getn(g_Conditions.Mudi[2]) do
           g_Ctrls.MudiCombo:ComboBoxAddItem(g_Conditions.Mudi[2][i], i - 1);
        end
        g_Ctrls.MudiCombo:SetCurrentSelect(0);
   else
        ZhengyouYaoqiu_Mudi:Hide();
        ZhengyouYaoqiu_Text6:Hide();
   end

   	--�༭ʱҪ����������е�����
   if (g_CurStatus == OPT_EDIT) then
   		local iLevelNeed, iMenpaiNeed, iSexyNeed, iZhengyouMudi = FindFriendDataPool:GetDetailInfo("CONDITION");

   		if(iMenpaiNeed < 0 or iMenpaiNeed > table.getn(g_Conditions.MenPai)) then
   			iMenpaiNeed = 0;
  		 end

   		if(iLevelNeed < 0 or iLevelNeed > table.getn(g_Conditions.Level)) then
   			iLevelNeed = 0;
   		end

   		if(iSexyNeed < 0 or iSexyNeed > table.getn(g_Conditions.Sexy)) then
   			iSexyNeed = 0;
   		end

   		if ( 2 == tonumber(g_FriendType) ) then -- ����
   			 if ((iZhengyouMudi - 1) >= 0 and (iZhengyouMudi - 1) <= table.getn(g_Conditions.Mudi[1])) then
        		g_Ctrls.MudiCombo:SetCurrentSelect(iZhengyouMudi - 1);
       		 else
        		g_Ctrls.MudiCombo:SetCurrentSelect(0);
        	 end
   		elseif ( 3 == tonumber(g_FriendType) ) then
   			 if ((iZhengyouMudi - 4) >= 0 and (iZhengyouMudi - 4) <= table.getn(g_Conditions.Mudi[2])) then
        		g_Ctrls.MudiCombo:SetCurrentSelect(iZhengyouMudi - 4);
        	 else
        		g_Ctrls.MudiCombo:SetCurrentSelect(0);
        	 end
   		end

   		g_Ctrls.MenpaiCombo:SetCurrentSelect(iMenpaiNeed);
   		g_Ctrls.LevelCombo:SetCurrentSelect(iLevelNeed);
   		g_Ctrls.SexyCombo:SetCurrentSelect(iSexyNeed);

   elseif (g_CurStatus == OPT_ADD) then
   		g_Ctrls.MenpaiCombo:SetCurrentSelect(0);
   		g_Ctrls.LevelCombo:SetCurrentSelect(0);
   		g_Ctrls.SexyCombo:SetCurrentSelect(0);
   		g_Ctrls.MudiCombo:SetCurrentSelect(0);
   end

end

function ZhengyouYaoqiu_ShowWindow(sOption, iFriendType)
  g_FriendType = iFriendType;

	if ( "add" == sOption ) then
	  g_CurStatus = OPT_ADD;
	elseif ("edit" == sOption ) then
	  g_CurStatus = OPT_EDIT;
	end

	CloseWindow("ZhengyouSearch");
  CloseWindow("ZhengyouInfoFabu");
  CloseWindow("VotedPlayer");

	this:Show();

	ZhengyouYaoqiu_ResetMudiCombo();
end

-- ȷ�����������
function OnZhengyouYaoqiu_OkClicked()
	-- ��������
	local sLevel, iLevel =  g_Ctrls.LevelCombo:GetCurrentSelect();
	local sMenpai, iMenpai = g_Ctrls.MenpaiCombo:GetCurrentSelect();
	local sSexy, iSexy = g_Ctrls.SexyCombo:GetCurrentSelect();
	local sMudi, iMudi = g_Ctrls.MudiCombo:GetCurrentSelect();

	if (tonumber(g_FriendType) == 2) then
		iMudi = iMudi + 1;
	elseif (tonumber(g_FriendType) == 3) then
		iMudi = iMudi + 4;
	else
		iMudi = 0;
	end

	RequestAddOrEditFindFriendInfo( tonumber(g_CurStatus), tonumber(g_FriendType),
		tonumber(iLevel),
		tonumber(iMenpai),
		tonumber(iSexy),
		tonumber(iMudi)	);

	this:Hide();
end
