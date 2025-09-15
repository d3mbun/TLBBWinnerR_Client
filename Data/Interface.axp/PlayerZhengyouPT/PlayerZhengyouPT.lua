--����ƽ̨����������б� cuiyinjie 2008.10.20
-- �б�������̣� lua�ű����������������ҳ�� ���������غ�ͻ���pushevent����lua��luaȻ��ȡ������һ����ȡ��Ϣ��ʾ���б�

-- Ƶ�����ͺ��Ա���
local g_Genders = { "N�", "Nam" };
local g_Channels = {"#{ZYPT_081103_008}", "#{ZYPT_081103_009}", "#{ZYPT_081103_010}", "#{ZYPT_081103_011}",}; --{"�ɲ�Ůò", "������", "��ʦѰͽ", "������"};
local g_TypesDesc = {"K�t H�n", "Bang H�i", "S� а", "K�t Ngh�a"};   --���ʼ�ʱ�޷�ת��
local g_MenPaiName = {"Thi�u L�m", "Minh Gi�o", "C�i Bang", "V� �ang", "Nga My", "Tinh T�c", "Thi�n Long", "Thi�n S�n", "Ti�u Dao", "M� Dung"};
local g_MarryDesc = {"Ch�a k�t h�n", "�� k�t h�n"};
--local g_ZhengyouMudi = { {"����","��������","Ѱ�Ұ���",}, {"����","��ʦ","��ͽ",},};

-- ������������Ҫ���ﶨ��һ�£�Ҫͬʱ����,�ǵ��±��1
local g_Conditions = {
	MenPai = {"To�n b�", "Thi�u L�m", "Minh Gi�o", "C�i Bang", "V� �ang", "Nga My", "Tinh T�c", "Thi�n Long", "Thi�n S�n", "Ti�u Dao"},
	Level = {"B�t k�", "D߾i c�p 10", "C�p 10 �n 20", "C�p 20 �n 30", "C�p 30 �n 40", "C�p 40 �n 50", "C�p 50 �n 60", "C�p 60 �n 70", "C�p 70 �n 80", "C�p 80 �n 90", "C�p 90 �n 100", "Tr�n c�p 100"},
	Sexy = {"Kh�ng gi�i h�n", "Nam", "N�"},
	Mudi = { {"B�t k�","Bang ph�i chi�u m�","T�m bang ph�i",}, {"B�t k�","B�i s�","Thu nh�n � t�",},}, 
};

-- �Եȵ������ʾ
local g_strWaitClickTipText = "#{ZYPT_081127_2}"; --"����������������Ե�Ƭ�̺��ٵ����";

-- ��ǰƵ�������ҳ��
local g_totalPlayerCount = 1
local g_curChannel = 0
local g_curPageIndex = 1
local g_totalPageCount = 1

-- ��ǰ��ҹ������������
local g_curZhengyouType = 1; 

-- ��ǰ��ѯ������ͣ�������ʾ��ʾ��Ϣ 
local g_curSearchResultType = -1; 

local MAXPAGECOUNT 		= 200;
local MAXCOUNTPERPAGE 	= 20;
local LEVEL_LIMIT 		= 10;						--10�������޷���

-- ִ�в�ѯ�;������������
local OPT_FABU 			= 1;
local OPT_CHEXIAO 		= 2;
local OPT_EDIT  		= 3;

local OPT_VOTE			= 1;
local OPT_VIEWVOTE		= 2;

local OPT_CHECK_EDIT	= 3;
local OPT_CHECK_FABU    = 4;
local OPT_CHECK_CHEXIAO = 5;
local OPT_CHECK_GUANLI  = 6;

-- ����ؼ�
local BtnPageUpDown = {};
local g_Ctrls = {};

-- ��ȴʱ����� 
local g_iLastTime = 0;

local g_Timers = {0, 0, 0, 0, 0}; -- ��ȴʱ�����
local TIMER_TAB = 1;     --tabҳ     timer������ֵ
local TIMER_SEARCH = 2;  --����
local TIMER_UPDATE = 3; --ˢ��
local TIMER_COMMONBTN = 4; --һ�㰴ť

local MIN_TABTIME = 3; --��tab��ʱ�� 
local MIN_SEARCHTIME = 10; 
local MIN_BTNTIME = 3; --�㹦�ܰ�ť�ļ�� ���룩 
local MIN_UPDATETIME = 3;

function PlayerZhengyouPT_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("UPDATE_FINDFRIEND_LIST"); -- ����������ǰҳ����
	this:RegisterEvent("ZHENGYOUPT_RESPONSE_PLAYERDETAILINFO");  -- ��ʾϸ����Ϣ
	this:RegisterEvent("ZHENGYOUPT_RESPONSE_QUERYRESULT");
	this:RegisterEvent("ZHENGYOUPT_FOCUSROW");
	this:RegisterEvent("ZHENGYOUPT_RESPONSE_SEARCHPLAYERLIST");  -- ��ʾ 

end

function PlayerZhengyouPT_GetTypeName(eType)
	if PlayerZhengyouPT_IsRealType(eType) then
		return g_Channels[eType];
	end
	return "#{ZYPT_081103_007}" --"ȫ��";
end

function PlayerZhengyouPT_GetGenderDesc(eSex)
	if ( 0 == eSex ) then
		return g_Genders[1];
	else
		return g_Genders[2];
	end
end

function PlayerZhengyouPT_GetMarryDesc(iMarry)
	if ( 0 == iMarry ) then
		return g_MarryDesc[1];
	else
		return g_MarryDesc[2];
	end
end

function PlayerZhengyouPT_GetMenpaiName(iMenpai)
	if ( iMenpai >= 0 and iMenpai < 10 ) then
		return g_MenPaiName[iMenpai + 1];
	end
	return "";
end

-- ȡ��������������
function  PlayerZhengyouPT_GetMenpaiNeedDesc(iRet)
	local sDesc = g_Conditions.MenPai[iRet + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "";
	end
end

-- ȡ���Ա���������
function  PlayerZhengyouPT_GetSexyNeedDesc(iRet)
	local sDesc = g_Conditions.Sexy[iRet + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "";
	end
end

-- ȡ�õȼ���������
function  PlayerZhengyouPT_GetLevelNeedDesc(iRet)
	local sDesc = g_Conditions.Level[iRet + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "";
	end
end

-- ����Ŀ������
-- ���룺�������ͣ�Ŀ�� 
function  PlayerZhengyouPT_GetZhengyouMudiDesc(iAdtype, iMudi)
    local iIdx = 0;
    if ( 2 == tonumber(iAdtype) ) then 
       PlayerZhengyouPT_Text4:Show();
       iIdx = 1;
       iMudi = iMudi - 1;
    elseif( 3 == tonumber(iAdtype) ) then
       PlayerZhengyouPT_Text4:Show();
       iIdx = 2;
       iMudi = iMudi - 4;
    else
       PlayerZhengyouPT_Text4:Hide();
       return "Tr�ng h�u giao t�";
    end
	local sDesc = g_Conditions.Mudi[iIdx][iMudi + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "Tr�ng h�u giao t�";
	end
end 


function PlayerZhengyouPT_OnLoad()
    BtnPageUpDown = {PlayerZhengyouPT_PageUp, PlayerZhengyouPT_PageDown};
    g_Ctrls = {
        TxtName 	= PlayerZhengyouPT_Info2,     -- ������Ϣ
        TxtSexy 	= PlayerZhengyouPT_Info3,
        TxtLevel 	= PlayerZhengyouPT_Info4,
        TxtMenpai 	= PlayerZhengyouPT_Info5,
        
 		TxtBangpai 	= PlayerZhengyouPT_Info6,
        TxtMarry 	= PlayerZhengyouPT_Info7,
        TxtFabuTime	= PlayerZhengyouPT_Info8,   -- ����ʱ��
        TxtShyuTime = PlayerZhengyouPT_Info9,   -- ʣ��ʱ��
        
		TxtSexyNeed   = PlayerZhengyouPT_Text1,   -- ����Ҫ��
		TxtLevelNeed  = PlayerZhengyouPT_Text2,
		TxtMenpaiNeed = PlayerZhengyouPT_Text3,
		TxtZhengyouMudi = PlayerZhengyouPT_Text4,
		
		TxtRenqi1     = PlayerZhengyouPT_Info_1,  -- ������ʾ
		TxtRenqi2     = PlayerZhengyouPT_Info_2,
		TxtRenqi3     = PlayerZhengyouPT_Info_3,
		TxtRenqi4     = PlayerZhengyouPT_Info_4,
		
		CtrlList	  = PlayerZhengyouPT_List,
		
		BtnChangeInfo = PlayerZhengyouPT_Change,
		
		TabSearch	  = PlayerZhengyouPT_Tab6,
		
		TxtVoteFull	  = PlayerZhengyouPT_Info12,
		
		TxtSearchResultTip = PlayerZhengyouPT_ResultInfo,
		
		Tabs		  = {
						 PlayerZhengyouPT_Tab1,
						 PlayerZhengyouPT_Tab2,
						 PlayerZhengyouPT_Tab3,
						 PlayerZhengyouPT_Tab4,
						 PlayerZhengyouPT_Tab5,
						 PlayerZhengyouPT_Tab6,
						 },
    };
    
    g_Ctrls.TxtVoteFull:Hide(); --ͶƱ������ϢҪ���� 
    PlayerZhengyouPT_PageHeader:SetText("#{ZYPT_081103_006}");
end

-- ֪ͨ�ű�ȥ�ͻ���ȡ��ϸ��Ϣ
function PlayerZhengyouPT_NotifyPlayerDetailInfo(sResult, sMyInfo, sType)
	if ( "ok" ~= sResult ) then
	   -- û����������ϸ����Ϣ���������ʾ
	   PlayerZhengyouPT_CleanDetailInfo();
	   PushDebugMessage("R�t ti�c, kh�ng c� tin t�c c�a ng߶i ch�i n�y");    -- ������Ϣ��Ӧ�ò���ִ�е�
	   return;
	end
	if ( "myinfo" == sMyInfo ) then
	   g_curZhengyouType = tonumber(sType);
	   g_Ctrls.BtnChangeInfo:Show();
	else
	   g_Ctrls.BtnChangeInfo:Hide();
	end
	local iSexy = FindFriendDataPool:GetDetailInfo("SEX");
	local iMenpai = FindFriendDataPool:GetDetailInfo("MENPAI");
	local iMarry = FindFriendDataPool:GetDetailInfo("MARRY");
	local sFabuTime, sSpareTime = FindFriendDataPool:GetDetailInfo("SENDTIME");
	local iLevelNeed, iMenpaiNeed, iSexyNeed, iZhengyouMudi = FindFriendDataPool:GetDetailInfo("CONDITION");
	local iRenqi1, iRenqi2, iRenqi3, iRenqi4 = FindFriendDataPool:GetDetailInfo("HOTLEVEL");
	
    g_Ctrls.TxtName:SetText( "#{ZYPT_081103_024}" .. FindFriendDataPool:GetDetailInfo("NAME") );
    g_Ctrls.TxtSexy:SetText( "#{ZYPT_081103_035}" .. PlayerZhengyouPT_GetGenderDesc(iSexy) );
    g_Ctrls.TxtMarry:SetText( "#{ZYPT_081103_027}" .. PlayerZhengyouPT_GetMarryDesc(iMarry) );
    g_Ctrls.TxtLevel:SetText( "#{ZYPT_081103_025}" .. FindFriendDataPool:GetDetailInfo("LEVEL") );
    g_Ctrls.TxtMenpai:SetText( "#{ZYPT_081103_026}" .. PlayerZhengyouPT_GetMenpaiName(iMenpai) );
	g_Ctrls.TxtBangpai:SetText( "#{ZYPT_081103_028}" .. FindFriendDataPool:GetDetailInfo("GUILD") );
	g_Ctrls.TxtFabuTime:SetText( "#{ZYPT_081103_029}" .. sFabuTime );
	g_Ctrls.TxtShyuTime:SetText( "#{ZYPT_081103_030}" .. sSpareTime .."Ng�y");
	
	g_Ctrls.TxtSexyNeed:SetText( "#{ZYPT_081103_035}" .. PlayerZhengyouPT_GetSexyNeedDesc(iSexyNeed) );
    g_Ctrls.TxtLevelNeed:SetText( "#{ZYPT_081103_036}" .. PlayerZhengyouPT_GetLevelNeedDesc(iLevelNeed) );
    g_Ctrls.TxtMenpaiNeed:SetText( "#{ZYPT_081103_037}" .. PlayerZhengyouPT_GetMenpaiNeedDesc(iMenpaiNeed) );
    g_Ctrls.TxtZhengyouMudi:SetText( "M�c ��ch: " .. PlayerZhengyouPT_GetZhengyouMudiDesc(sType, iZhengyouMudi) );
    
    g_Ctrls.TxtRenqi1:SetText( tostring(iRenqi1) );
    g_Ctrls.TxtRenqi2:SetText( tostring(iRenqi2) );
    g_Ctrls.TxtRenqi3:SetText( tostring(iRenqi3) );
    g_Ctrls.TxtRenqi4:SetText( tostring(iRenqi4) );
end

function  PlayerZhengyouPT_CleanDetailInfo()
    g_Ctrls.TxtName:SetText( "#{ZYPT_081103_024}" );
    g_Ctrls.TxtSexy:SetText( "#{ZYPT_081103_035}" );
    g_Ctrls.TxtMarry:SetText( "#{ZYPT_081103_027}" );
    g_Ctrls.TxtLevel:SetText( "#{ZYPT_081103_025}" );
    g_Ctrls.TxtMenpai:SetText( "#{ZYPT_081103_026}" );
	g_Ctrls.TxtBangpai:SetText( "#{ZYPT_081103_028}" );
	g_Ctrls.TxtFabuTime:SetText( "#{ZYPT_081103_029}" );
	g_Ctrls.TxtShyuTime:SetText( "#{ZYPT_081103_030}" );

	g_Ctrls.TxtSexyNeed:SetText( "#{ZYPT_081103_035}" );
    g_Ctrls.TxtLevelNeed:SetText( "#{ZYPT_081103_036}"  );
    g_Ctrls.TxtMenpaiNeed:SetText( "#{ZYPT_081103_037}"  );
    g_Ctrls.TxtZhengyouMudi:SetText( "" );

    g_Ctrls.TxtRenqi1:SetText( "" );
    g_Ctrls.TxtRenqi2:SetText( "" );
    g_Ctrls.TxtRenqi3:SetText( "" );
    g_Ctrls.TxtRenqi4:SetText( "" );
    
    g_Ctrls.BtnChangeInfo:Hide();
end

function PlayerZhengyouPT_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "PlayerZhengyouPTWindow") then
			--����Ѿ���ʾ��Ӧ�ùص�
			if ( this:IsVisible() ) then
			   this:Hide();
			   return;
			end
			CloseWindow("ZhengyouWindow");
			InitAndShowZhengyouWindow();
		end
	
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "PlayerZhengyouPTWindow") then
			this:Hide();
		end	
	elseif(event == "UPDATE_FINDFRIEND_LIST") then
		PlayerZhengyouPT_UpdateFriendList(arg0, arg1);	
	elseif (event == "ZHENGYOUPT_RESPONSE_QUERYRESULT") then
	    PlayerZhengyouPT_OnQueryResponse(arg0, arg1, arg2, arg3);
	elseif ("ZHENGYOUPT_RESPONSE_PLAYERDETAILINFO" 	== event) then
	    PlayerZhengyouPT_NotifyPlayerDetailInfo(arg0, arg1, arg2);
	elseif ("ZHENGYOUPT_FOCUSROW" == event) then
	    PlayerZhengyouPT_SetFocusRowAndPageNo(arg0, arg1);
	elseif ("ZHENGYOUPT_RESPONSE_SEARCHPLAYERLIST" == event ) then
		PlayerZhengyouPT_OnSearchPlayerResponse(arg0, arg2); -- ��3��������ʾ���ͣ�Ϊintֵ
	end
end

function InitAndShowZhengyouWindow()
	PlayerZhengyouPT_UpdateBtnStatus();
	PlayerZhengyouPT_CleanPlayerList(); --��Ҫ������б���ֹ��ʾ���õ�
	PlayerZhengyouPT_SetCurrentTab(0);
	this:Show();
	-- �˴�������ʾȫ�����͵��б�
	RequestFindFriendList(g_curChannel, g_curPageIndex); -- 0���ͣ���1ҳ
end

--��������б�
function PlayerZhengyouPT_UpdateFriendList(iTotal, iTotalOfCurPage)
    PlayerZhengyouPT_CleanPlayerList();
	g_totalPlayerCount = iTotal; --���ݴ����������������ҳ��
	g_totalPageCount = math.floor(g_totalPlayerCount / MAXCOUNTPERPAGE) + 1;
	if(g_totalPageCount > MAXPAGECOUNT) then
		g_totalPageCount = MAXPAGECOUNT;
	end
	local playercount = iTotalOfCurPage;
	local i = 0;
	for i = 0, playercount -1 do
		local iGuid, strName, iGender, iRenqi, iType, iLevel = PlayerZhengyouPT_GetPlayerSimpleInfo(i);
		--AxTrace(0,0,"".. iGuid.." "..strName.." "..iGender.." "..iRenqi.." "..iType.." "..iLevel);
		PlayerZhengyouPT_List:AddNewItem(strName, 0, i);
		-- ȫ���Ͳ���ʱ��ʾ���ͣ� ������������ʾ�ȼ� 
		if ( 0 == g_curChannel or 5 == g_curChannel ) then
		    PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetTypeName(iType), 1, i);
		else
		    PlayerZhengyouPT_List:AddNewItem(iLevel, 1, i);			
		end
		
		PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetGenderDesc(iGender), 2, i);
		-- ���������ӱ��
		local strRenqi;
		if (iRenqi >= 80) then
		    strRenqi = tostring(iRenqi) .. "" .. "#cff0000(�y)";
		elseif ( iRenqi >= 60 ) then
		    strRenqi = tostring(iRenqi) .. "" .. "#cff6633(n�ng)";
		else
            strRenqi = tostring(iRenqi);
		end
		PlayerZhengyouPT_List:AddNewItem(strRenqi, 3, i);
		
	end
	PlayerZhengyouPT_UpdateBtnStatus();
end

function PlayerZhengyouPT_GetPlayerSimpleInfo(iIdx)
	return FindFriendDataPool:GetSimpleInfoByPos(iIdx);
end

--	��ҳ
function OnPlayerZhengyouPT_PageUpClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_BTNTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = g_curPageIndex - 1;
	PlayerZhengyouPT_UpdateBtnStatus();
	if ( g_curPageIndex < 1 ) then g_curPageIndex = 1; end
	RequestFindFriendList(g_curChannel, g_curPageIndex);
end

function OnPlayerZhengyouPT_PageDownClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_BTNTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = g_curPageIndex + 1;
	PlayerZhengyouPT_UpdateBtnStatus();
	RequestFindFriendList(g_curChannel, g_curPageIndex);
end

function PlayerZhengyouPT_UpdateBtnStatus()
	if( g_curPageIndex <= 1 ) then
		BtnPageUpDown[1]:Disable();
		PlayerZhengyouPT_FirstPage:Disable();
	end
	if( g_curPageIndex >= g_totalPageCount ) then
		BtnPageUpDown[2]:Disable();
		PlayerZhengyouPT_LastPage:Disable();
	end
	if (g_curPageIndex > 1 ) then 
		BtnPageUpDown[1]:Enable(); 
		PlayerZhengyouPT_FirstPage:Enable();
	end
	if (g_curPageIndex < g_totalPageCount ) then 
		BtnPageUpDown[2]:Enable(); 
		PlayerZhengyouPT_LastPage:Enable();
	end
	
	local curPage = g_curPageIndex;
	if ( curPage > g_totalPageCount ) then curPage = g_totalPageCount; end
	PlayerZhengyouPT_Amount:SetText(curPage.."/"..g_totalPageCount);
	PlayerZhengyouPT_GotoEditBox:SetText(tostring(g_curPageIndex));
end

function PlayerZhengyouPT_PassTime(iIdx, iSeconds)
   local iCur = FindFriendDataPool:GetTickCount();
   if ( iCur - g_Timers[iIdx] < iSeconds * 1000) then
      return false;
   else
      g_Timers[iIdx] = iCur;
   	  return true;
   end
end 

-- ѡ��ͬ�ı�ǩ����ʾ ,  �˴�Ӧ��ʱ����ֹ�������
function PlayerZhengyouPT_ChannalChange(iChannel)
	-- �����ǰѡ�еı�ǩӦ���޲���
	if (g_curChannel == iChannel) then
		return;
	end
	-- ���ܹ�Ƶ�л���ǩ
	if not PlayerZhengyouPT_PassTime(TIMER_TAB, MIN_TABTIME) then
		--PlayerZhengyouPT_SetCurrentTab(g_curChannel);
       		g_Ctrls.Tabs[g_curChannel + 1]:SetCheck(1);
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	PlayerZhengyouPT_CleanPlayerList();
	
	-- �㵽��ѯtabʱӦ����б����ύ����
	--if ( 5 == iChannel ) then
	   --return;
	--end 
	
	g_curChannel 		= iChannel;
	g_curPageIndex 		= 1;
	g_totalPageCount 	= 0;
	
	PlayerZhengyouPT_UpdateBtnStatus(); --��ֹ�㵽��ҳʱ��ťû��� 
	
	PlayerZhengyouPT_SetCurrentTab(iChannel);
	
	RequestFindFriendList(g_curChannel, g_curPageIndex); -- ���ͣ�ҳ
end

-- ȫ����״̬�´򿪷�����Ϣ���棬�ھ������ͱ�ǩ�´������趨����
function OnPlayerZhengyouPT_FabuClicked()
	local level = Player:GetData("LEVEL");
	if level < LEVEL_LIMIT then
		PushDebugMessage("R�t ti�c, c�n ��t �n c�p " .. LEVEL_LIMIT .. "m�i ���c c�ng b� " .. PlayerZhengyouPT_GetTypeName(g_curChannel) .. "Th�ng tin");
		return;
	end
	-- ѡ���˾���������ֱ�Ӳ�ѯ�Ƿ����㷢�����������������ѡ�����
	if ( not PlayerZhengyouPT_SendCheckRequest(g_curChannel, OPT_CHECK_FABU) ) then
		OpenWindow("ZhengyouInfoFabu_fabu"); --ûѡ���������
	end
end

-- ȫ����״̬�´򿪷�����Ϣ���棬�ھ������ͱ�ǩ�´������趨����
function OnPlayerZhengyouPT_ChexiaoClicked()
	if ( not PlayerZhengyouPT_SendCheckRequest(g_curChannel, OPT_CHECK_CHEXIAO) ) then
		OpenWindow("ZhengyouInfoFabu_chexiao");
	end
end

-- ȫ����״̬�´򿪷�����Ϣ���棬�ھ������ͱ�ǩ�´������趨����
function OnPlayerZhengyouPT_GuanliClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_BTNTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	if ( not PlayerZhengyouPT_SendCheckRequest(g_curChannel, OPT_CHECK_GUANLI) ) then
		OpenWindow("ZhengyouInfoFabu_guanli");
	end
end

-- ִ�з�������������������
-- eType : ��������
-- opt   : ִ�е��������ͣ� ����, ���� ,����
function PlayerZhengyouPT_SendCheckRequest(eType, opt)
	if (not PlayerZhengyouPT_IsRealType(eType) ) then
	    return false;
	end
	
	-- ���;����ѯ����
	FindFriendQuery(opt, eType);
	return true;
end

-- ���ȷ��Ҫ����
function PlayerZhengyouPT_MessageChexiaoOK(eType)
    RequestDeleteFindFriendInfo(tonumber(eType));
end

function PlayerZhengyouPT_MessageChexiaoCancel()

end

-- ��ѯ��ִ�в����ķ������� 
function PlayerZhengyouPT_OnQueryResponse(sOptType, sRet, eType, iReserve)
	local iType = tonumber(eType);
	if ( nil == iType ) then
	    PushDebugMessage("Thao t�c Ch�nh H�u ph�n h�i th�ng tin sai");
	    return;
	end
	if ( "check_guanli" == sOptType ) then
	    if ( "ok" == sRet ) then
			--��λ���������Ӧ���ͱ�ǩ
			PlayerZhengyouPT_SetCurrentTab(iType); 
	    elseif ( "noinfo" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_068}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_073}");
	    else
	    
	    end
	elseif ( "check_chexiao" == sOptType ) then
	    if ("sure"  == sRet ) then -- Ҫ��ȷ��ɾ��
	        --PushDebugMessage("��ȷ��Ҫ����" .. PlayerZhengyouPT_GetTypeName(iType) .. "��Ϣ�𣿳������������������Ϣ��ʱ�䲻��24Сʱ�����޷��ٴη�����");
	        MessageBoxCommon("#{ZYPT_081103_101}", "#{ZYPT_081103_070}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_071}",
				"PlayerZhengyouPT", "MessageChexiaoOK(" .. iType .. ")", "MessageChexiaoCancel()");
	    elseif ("noinfo" == sRet) then
	        PushDebugMessage("#{ZYPT_081103_068}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_069}");
	    end
	elseif ( "check_fabu" == sOptType ) then
	    if ( "ok" == sRet) then
	        --PushDebugMessage("��ʾ��������");
	    elseif ( "in24hours" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_060}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_061}");
	    elseif ( "exist" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_058}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_059}");
	    elseif ( "full" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_062}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_063}");
	    end
	elseif ( "fabu" == sOptType ) then
		if ( "ok" == sRet ) then
		   PushDebugMessage("#{ZYPT_081103_106}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_107}");    -- �����ɹ�����ʾ 
		   PlayerZhengyouPT_SetCurrentTab(iType); 
		end
	elseif ("view_vote" == sOptType) then
		if ( "noinfo" == sRet ) then 
		    PushDebugMessage("R�t ti�c, tr߾c m�t ch�a c� ai b� phi�u ");
		end
    elseif ("vote" == sOptType) then
        if ("done" == sRet) then
            PushDebugMessage("#{ZYPT_081103_080}"); --("�Բ������Ѿ��Ա�����ϢͶ��Ʊ�ˣ������ٴ�ͶƱ��");
        elseif("full" == sRet) then
            PushDebugMessage("#{ZYPT_081103_079}"); --("�Բ��𣬱�����ϢͶƱ�����������޷�����ͶƱ��");
		elseif("ok" == sRet) then
		    -- ��tab�͸���ʾ
        	if (g_curChannel == 5) then
        		PlayerZhengyouPT_SetCurrentTab(iType); 
        	end
		    --PushDebugMessage(PlayerZhengyouPT_GetTypeName(iType));
		    local sVoteOkTip = string.format("C�c h� �� b� phi�u cho %s th�nh c�ng", FindFriendDataPool:GetDetailInfo("NAME") );
		    PushDebugMessage( sVoteOkTip );
        end
    elseif ("delete" == sOptType) then
	    if( "ok" == sRet ) then
    		PlayerZhengyouPT_SetCurrentTab(iType);
	        PushDebugMessage("C�c h� gi�i kh�a th�nh c�ng" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_107}");
	    end
	elseif ("editcondition" == sOptType ) then
		if( "ok" == sRet ) then
    		PlayerZhengyouPT_SetCurrentTab(iType);
	        PushDebugMessage("S�a �i th�ng tin th�nh c�ng");
	    end
	end

end


	--*****************************************
	--CEGUI��һ��д�Ĳ�����ĵط�(Bug?)....���¶����б���������ʱ�����һЩ����....
	--����Ϊ��
	--��XML�и������б�������ColumnsSizable=True....�ͻ����øÿؼ���ColumnsSizable=True....���������������е�ColumnsSizable=True....
	--��Щ�����б��籾���ڵ���Ҫ�ڽű��ж�̬�Ĳ�����....��ʱXML�����õ�ColumnsSizable=Trueֻ�����øÿؼ���ColumnsSizable=True....���������е�ColumnsSizable=True(��Ϊ��ʱһ���ж�û��)....
	--����ڽű��ж�̬�����к��е�ColumnsSizable��Ϊû�����ù��Ͳ���True....
	--������ڶ�̬�����к��ڽű��������¸������б�����ColumnsSizable=TrueҲ����....
	--��Ϊ���ø����Ե�ֵʱ���ж��Ƿ��뵱ǰ�����Ե�ֵһ��....���һ����ֱ�ӷ���....���ÿؼ���ColumnsSizable�ڳ�ʼ��XML��ʱ�����True�����Ի�ֱ�ӷ���....Ҳ�Ͳ�������������ø�����....
	--�������붯̬�����о���Ҫ�ڶ�̬����������ú����йص�����....ͬʱ��XML�в��ܶԺ����йص����Խ�������....
	--*****************************************
	
	-- ע�� �ϱߵĽ�������AutoSearch.lua, �˴������ڽű��������ó��Լ�Ҫ���óɵ�����ֵ���෴ֵ�������ó�Ŀ��ֵ��֤���ǿ��еġ� by cuiyinjie 2008-10-29 
    -- ע��Ҫ�ȵ��ô˺�������listctrl����룬�����ɾ��1�е���Ϣ�� 
-- ����ָ���ı�ǩ 
function PlayerZhengyouPT_SetCurrentTab(iTab)
   local sText = "#{ZYPT_081103_014}"; --"����";

   if ( 0 == iTab ) then
        
   elseif ( iTab > 0 and iTab < 5 ) then
   		sText = "��ng c�p";       
   elseif( 5 == iTab ) then
   
   end
   
   g_Ctrls.CtrlList:SetProperty("ColumnsSizable", "True");
   g_Ctrls.CtrlList:SetProperty("ColumnsMovable", "True");
   g_Ctrls.CtrlList:SetProperty("ColumnsAdjust", "False");
   
   --local sTmpInfo = {};
   --local i = 1;
   --local iTmpSel = g_Ctrls.CtrlList:GetSelectItem();
   --for i = 0, g_Ctrls.CtrlList:GetItemCount() - 1 do
   --     sTmpInfo[i + 1] = g_Ctrls.CtrlList:GetItemText(i, 1);
   --end
   
   PlayerZhengyouPT_CleanPlayerList(); --���������ֹ�����ݻ�������ֿ���
   g_Ctrls.CtrlList:RemoveColumnByPos(1);
   g_Ctrls.CtrlList:InsertColumn(sText, 1, 0.32, 1);
   
   --for i = 0, g_Ctrls.CtrlList:GetItemCount() - 1 do
   --      g_Ctrls.CtrlList:AddNewItem(sTmpInfo[i + 1], 1, i);
   --end
   
   g_Ctrls.CtrlList:SetProperty("ColumnsSizable", "False");
   g_Ctrls.CtrlList:SetProperty("ColumnsMovable", "False");
   g_Ctrls.CtrlList:SetProperty("ColumnsAdjust", "True");
   
   if ( iTab >= 0 and iTab < 6 ) then
       g_Ctrls.Tabs[iTab + 1]:SetCheck(1);
       g_curChannel = iTab;
   end
   PlayerZhengyouPT_UpdateSearchTip();
   --g_Ctrls.CtrlList:SetSelectItem(iTmpSel);
end

-- �Ƿ��������
function PlayerZhengyouPT_IsRealType(eType)
    local iType = tonumber(eType);
	if ( nil == iType ) then
	    PushDebugMessage("Thao t�c Ch�nh H�u ph�n h�i th�ng tin sai");
	end
	
    if ( iType > 0 and iType < 5 ) then
       return true;
    end
    return false;
end

-- �б���ѡ��
function PlayerZhengyouPT_List_OnSelectionChanged()
   local nSel = PlayerZhengyouPT_List:GetSelectItem();
   local nSearchTab = g_Ctrls.TabSearch:GetCheck();
   if ( nSel < 0 ) then
		return;
   else
      RequestFindFriendDetailInfo(nSel, nSearchTab); -- ����c++�ĺ���,Ҫ�����Ƿ��ڲ��ҽ����ѡ�񣬿ͻ���Ҫ�Ӳ�ͬ�Ľ�����ﷵ�ؽ�� 
   end
end

-- ����ѡ���к͵�ǰҳ�� 
function PlayerZhengyouPT_SetFocusRowAndPageNo(iRowIndex, iPageNo)
   local iRow = tonumber(iRowIndex);
   if (PlayerZhengyouPT_List:GetItemCount() > iRow) then
		PlayerZhengyouPT_List:SetSelectItem(iRow);
	end
	g_curPageIndex = tonumber(iPageNo);
	PlayerZhengyouPT_UpdateBtnStatus();
end

function PlayerZhengyouPT_CleanPlayerList()
   PlayerZhengyouPT_List:RemoveAllItem();
   PlayerZhengyouPT_CleanDetailInfo();
end

-- �򿪲�����������
function OnPlayerZhengyouPT_ChazhaoClicked()
	
	if not PlayerZhengyouPT_PassTime(TIMER_SEARCH, MIN_SEARCHTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	OpenWindow("ZhengyouSearch" .. g_curChannel);
end

-- ��ͶƱ�鿴����
function OnPlayerZhengyouPT_Chakan1Clicked(iVoteViewId)
	if not PlayerZhengyouPT_PassTime(TIMER_TAB, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	if( iVoteViewId < 0 or iVoteViewId > 3 ) then
		return;
	end 
	--OpenWindow("VotedPlayer");
	PlayerZhengyouPT_CloseOtherWindow();
	
	local  nRowIndex =  PlayerZhengyouPT_List:GetSelectItem();
	if (nRowIndex < 0 ) then 
   		return; 
    end
    --local nSearchTab = g_Ctrls.TabSearch:GetCheck();
    local nSearchTab = g_curChannel;
	RequestVoteFindFriendInfo( OPT_VIEWVOTE, nRowIndex, iVoteViewId , nSearchTab);
end

-- ͶƱ 0 ~ 3 
function PlayerZhengyouPT_Toupiao(iSel)
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end

	local nSel = PlayerZhengyouPT_List:GetSelectItem();
	if ( nSel < 0 ) then
	PushDebugMessage("Mong h�y t� b�n tr�i ch�n ra m�t ng߶i c�ng b� th�ng tin");
	return;
	end

	local szName = FindFriendDataPool:GetDetailInfo("NAME");
	local player = Player:GetName();
	if(szName == player) then
		PushDebugMessage(" Kh�ng th� b� phi�u cho m�nh.");
		return;
	end
		
   if ( iSel < 0 or iSel > 3 ) then
      return;
   end
   -- ����ͶƱ���� 
   local  nRowIndex =  PlayerZhengyouPT_List:GetSelectItem();
   if (nRowIndex < 0 ) then 
   		return; 
   end
   --local nSearchTab = g_Ctrls.TabSearch:GetCheck();
   local nSearchTab = g_curChannel;
   RequestVoteFindFriendInfo( OPT_VOTE, nRowIndex, iSel , nSearchTab);
end

-- �����������Ҫ�� 
function PlayerZhengyouPT_Change_OnClick()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	FindFriendQuery(OPT_CHECK_EDIT, g_curZhengyouType);
end


function PlayerZhengyouPT_OnSearchPlayerResponse(sRet, eType)
   local iType = tonumber(eType);
   if ( "ok" ==  sRet ) then
        g_Ctrls.TxtSearchResultTip:SetText(PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_012}");   -- ע�⣬ֻ�з���okʱ���ܸ��²�ѯ�����ʾ
        --g_Ctrls.TabSearch:SetCheck(1); --ѡ�в��ҽ����ǩ
   		PlayerZhengyouPT_CleanPlayerList();
   		g_curChannel 		= 5;
   		g_curPageIndex    = 1;
	    g_totalPageCount = 1;
	    PlayerZhengyouPT_SetCurrentTab(5);   --ѡ�в��ҽ����ǩ
      	PlayerZhengyouPT_ShowSearchPlayerResult();
      	PlayerZhengyouPT_UpdateBtnStatus();
      	PlayerZhengyouPT_UpdateSearchTip();
   elseif( "noinfo" == sRet ) then
      PushDebugMessage("Kh�ng t�m ���c ng߶i ch�i ph� h�p �i�u ki�n.");
   end
end

-- ��ʾ������ҽ�� 
function PlayerZhengyouPT_ShowSearchPlayerResult()
   local iCount = FindFriendDataPool:GetSearchRetInfoNum();
   	local i = 0;
	for i = 0, iCount -1 do
		local iGuid, strName, iGender, iRenqi, iType, iLevel = FindFriendDataPool:GetSearchRetInfoByPos(i);
		PlayerZhengyouPT_List:AddNewItem(strName, 0, i);
		PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetTypeName(iType), 1, i);
		PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetGenderDesc(iGender), 2, i);
		PlayerZhengyouPT_List:AddNewItem(iRenqi, 3, i);
	end
end

-- �鿴�������
function PlayerZhengyouPT_View_OnClick()

   local nSel = PlayerZhengyouPT_List:GetSelectItem();
   if ( nSel < 0 ) then
		return;
   end
   
    -- �ر������Ѿ��򿪵Ķ������ѽ���
    CloseWindow("VotedPlayer");
    PlayerZhengyouPT_CloseOtherWindow();
   
	-- �������������ȡ���� 
    local szName = FindFriendDataPool:GetDetailInfo("NAME"); 
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
end 

function PlayerZhengyouPT_CloseOtherWindow()
   local OtherWindows = {
   		"ZhengyouInfoFabu",
   		"ZhengyouYaoqiu",
   		"ZhengyouSearch",
   };
   local i = 1;
   for i = 1, table.getn( OtherWindows ) do
      CloseWindow( OtherWindows[i] );
   end
end

-- ��ʶ���
function PlayerZhengyouPT_Jieshi_OnClick()
     --�Բ��������ܺ��Լ���ʶ��
     --���ո��Ѿ��͸���ҽ�ʶ���ˣ�������ʱ�����б��в��ҡ�
     --������Ѿ������ĳ����б��У��޷���ʶ��
     --������Ѿ������ĺ����б��У����ں����б��в��ҡ�
     --������Ѿ���������ʱ�����б��У�������ʱ�����б��в��ҡ�
     --��ʶ�ɹ������Ѿ�������Ҽ�����ʱ�����б�
     --���XXX��������������������Ϣ����������ʶ���Ѿ���������ʱ�����б��С�
     
        local nSel = PlayerZhengyouPT_List:GetSelectItem();
   		if ( nSel < 0 ) then
			return;      --���û��ѡ�е��û������ܽ�ʶ
  		end
     -- �����ж��Ƿ��Լ�     
     	local owner = FindFriendDataPool:GetDetailInfo("NAME"); 
		local player = Player:GetName();
		if(owner == player) then
			PushDebugMessage("#{ZYPT_081103_046}"); --("�Բ��������ܺ��Լ���ʶ��");
			return;
		end
	 --  �ж��Ƿ���� 
	 	local currentList = 6; -- ���� 
	 	local friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	local index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("#{ZYPT_081103_048}"); --("������Ѿ������ĳ����б��У��޷���ʶ��");
	 			return;
	 		end
	 		index = index + 1;
	    end
	--  �ж��Ƿ������
	 	local currentList = 5; -- ������ 
	 	local friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	local index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("Ng߶i ch�i n�y c� t�n trong danh s�ch �en c�a c�c h�, kh�ng th� k�t b�n.");
	 			return;
	 		end
	 		index = index + 1;
	    end
	-- �ж��Ƿ�����ʱ�����б� 
	    currentList = 8; -- temp friend 
	 	friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("#{ZYPT_081103_050}"); --("������Ѿ���������ʱ�����б��У�������ʱ�����б��в��ҡ�");
	 			return;
	 		end
	 		index = index + 1;
	    end
	-- �ж��Ƿ����
	local iTmp = 1;
	for iTmp = 1, 4 do
	   	currentList = iTmp; -- friend 
	 	friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("#{ZYPT_081103_049}"); --("������Ѿ������ĺ����б��У����ں����б��в��ҡ�");
	 			return;
	 		end
	 		index = index + 1;
	    end
	end
		-- �ѶԷ������Լ���ʱ�����б�
		DataPool:AddFriend(8, owner);
		PushDebugMessage("#{ZYPT_081103_051}"); --��ʶ�ɹ������Ѿ�������Ҽ�����ʱ�����б�
	-- �����ʼ� 
	    local iAdType = FindFriendDataPool:GetDetailInfo("ADTYPE");
		local sType = g_TypesDesc[iAdType];
		if ( nil == sType ) then sType = ""; end
		
		DataPool:OpenMail( owner,"Xin ch�o, t�i h� th�y c�c h� c�ng b�" .. sType .. "th�ng tin Ch�nh H�u, mu�n c�ng c�c h� k�t b�n!" );
	  
end 

-- ���л���ǩʱ�����ѯ��ʾ������б��ڴ�С 
function  PlayerZhengyouPT_UpdateSearchTip()
	 -- ����ʾʱ����б�top = 23, height = 272  
	 -- <Property Name="UnifiedPosition" Value="{{0.000000,1.000000},{0.000000,23.000000}" />
	 -- <Property Name="AbsoluteSize" Value="w:399 h:272" />
	 -- ����ʾʱ
	 --<Property Name="UnifiedPosition" Value="{{0.000000,1.000000},{0.000000,47.000000}" />
     --<Property Name="AbsoluteSize" Value="w:399 h:248" />
     if ( 5 == g_curChannel ) then
         --PlayerZhengyouPT_Result:Show();
         g_Ctrls.CtrlList:SetProperty("UnifiedPosition", "{{0.000000,1.000000},{0.000000,68.000000}");
         g_Ctrls.CtrlList:SetProperty("AbsoluteSize", "w:567 h:248");
     else
         --PlayerZhengyouPT_Result:Hide();
         g_Ctrls.CtrlList:SetProperty("UnifiedPosition", "{{0.000000,1.000000},{0.000000,23.000000}");
         g_Ctrls.CtrlList:SetProperty("AbsoluteSize", "w:567 h:272");
     end
end

function OnPlayerZhengyouPT_RefreshClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_UPDATE, MIN_UPDATETIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	if (g_curChannel == 5) then      --���ҽ���в���ˢ��
		return;
	end
	PlayerZhengyouPT_UpdateBtnStatus();
	if ( g_curPageIndex < 1 ) then g_curPageIndex = 1; end
	RequestFindFriendList(g_curChannel, g_curPageIndex);	
end

function OnPlayerZhengyouPT_GotoClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	local nPage = PlayerZhengyouPT_GotoEditBox:GetText();
	if(nPage~=nil and tonumber(nPage)~=nil) then 
		if(tonumber(nPage)>g_totalPageCount or tonumber(nPage) < 1) then
			PushDebugMessage("Xin nh�p s� trang ch�nh x�c.")
		else
			g_curPageIndex = tonumber(nPage);
			PlayerZhengyouPT_UpdateBtnStatus();
			RequestFindFriendList(g_curChannel, g_curPageIndex);	
		end
	end
	
end

function OnPlayerZhengyouPT_FirstPageClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_UPDATE, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = 1;
	PlayerZhengyouPT_UpdateBtnStatus();
	RequestFindFriendList(g_curChannel, g_curPageIndex);	
end

function OnPlayerZhengyouPT_LastPageClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_UPDATE, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = g_totalPageCount;
	PlayerZhengyouPT_UpdateBtnStatus();
	RequestFindFriendList(g_curChannel, g_curPageIndex);	
end
