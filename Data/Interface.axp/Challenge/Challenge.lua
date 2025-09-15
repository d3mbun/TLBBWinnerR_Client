local g_iRoleSel = 0;

local g_Challenge_FakeObject = {};
local g_Challenge_Name   = {};
local g_Challenge_Level  = {};
local g_Challenge_MenPai = {};

local g_Challenge_close = 0

function Challenge_PreLoad()

	-- ´ò¿ª½çÃæ
	this:RegisterEvent("OPEN_CHALLENGE_DLG");

	this:RegisterEvent("CLOSE_CHALLENGE_DLG");

end

-- ×¢²áonLoadÊÂ¼þ
function Challenge_OnLoad()

	g_Challenge_FakeObject[0] = Challenge_FakeObject1;
	g_Challenge_FakeObject[1] = Challenge_FakeObject2;
	g_Challenge_FakeObject[2] = Challenge_FakeObject3;
	g_Challenge_FakeObject[3] = Challenge_FakeObject4;
	g_Challenge_FakeObject[4] = Challenge_FakeObject5;
	g_Challenge_FakeObject[5] = Challenge_FakeObject6;

	g_Challenge_Name[0]   = Challenge_PlayerInfo1_Name;
	g_Challenge_Name[1]   = Challenge_PlayerInfo2_Name;
	g_Challenge_Name[2]   = Challenge_PlayerInfo3_Name;
	g_Challenge_Name[3]   = Challenge_PlayerInfo4_Name;
	g_Challenge_Name[4]   = Challenge_PlayerInfo5_Name;
	g_Challenge_Name[5]   = Challenge_PlayerInfo6_Name;

	g_Challenge_Level[0]  = Challenge_PlayerInfo1_Level;
	g_Challenge_Level[1]  = Challenge_PlayerInfo2_Level;
	g_Challenge_Level[2]  = Challenge_PlayerInfo3_Level;
	g_Challenge_Level[3]  = Challenge_PlayerInfo4_Level;
	g_Challenge_Level[4]  = Challenge_PlayerInfo5_Level;
	g_Challenge_Level[5]  = Challenge_PlayerInfo6_Level;

	g_Challenge_MenPai[0] = Challenge_PlayerInfo1_School;
	g_Challenge_MenPai[1] = Challenge_PlayerInfo2_School;
	g_Challenge_MenPai[2] = Challenge_PlayerInfo3_School;
	g_Challenge_MenPai[3] = Challenge_PlayerInfo4_School;
	g_Challenge_MenPai[4] = Challenge_PlayerInfo5_School;
	g_Challenge_MenPai[5] = Challenge_PlayerInfo6_School;

	Challenge_Die_Icon1:Hide();
	Challenge_Die_Icon2:Hide();
	Challenge_Die_Icon3:Hide();
	Challenge_Die_Icon4:Hide();
	Challenge_Die_Icon5:Hide();
	Challenge_Die_Icon6:Hide();

	Challenge_Downline_Icon1:Hide();
	Challenge_Downline_Icon2:Hide();
	Challenge_Downline_Icon3:Hide();
	Challenge_Downline_Icon4:Hide();
	Challenge_Downline_Icon5:Hide();
	Challenge_Downline_Icon6:Hide();

end

-- OnEvent
function Challenge_OnEvent(event)

	-- ´ò¿ª½çÃæÊÂ¼þ.
	--
	if ( event == "OPEN_CHALLENGE_DLG" ) then

			Challenge_GetChallengeInfo();
			this:Show();
		return;
	end;


	if ( event == "CLOSE_CHALLENGE_DLG" ) then

			this:Hide();
		return;
	end;

end



--µÃµ½ÌôÕ½¶ÓÎéÐÅÏ¢¡£
function Challenge_GetChallengeInfo()

	local iCount = DataPool:GetChallengeTeamMemberCount();
	local strName = "";
	local strModelName = "";
	local iLevel  = 0;
	local iMenPai = 0;
	local strMenPai = ""

	-- Çå³ýÌôÕ½ÐÅÏ¢¡£
	Challenge_ClearChallengeInfo();

	for i = 0, iCount - 1 do

		-- µÃµ½uiÄ£ÐÍÐÅÏ¢
		strModelName
		, strName
		, iLevel
		, menpai = DataPool:GetChallengeTeamMemberInfo(i);

		-- ÏÔÊ¾Ä£ÐÍ
		g_Challenge_FakeObject[i]:SetFakeObject(strModelName);

		-- ÏÔÊ¾Ãû×Ö
		g_Challenge_Name[i]:SetText(strName);

		AxTrace( 0,0, "Tên mô hình khiêu chiªn"..tostring(strModelName).."player name:"..strName.."level:"..tostring(iLevel).."menpai:"..tostring( menpai ));
		-- ÏÔÊ¾µÈ¼¶
		g_Challenge_Level[i]:SetText(tostring(iLevel));

		-- µÃµ½ÃÅÅÉÃû³Æ.
		if(0 == menpai) then
			strMenPai = "Thiªu Lâm";

		elseif(1 == menpai) then
			strMenPai = "Minh Giáo";

		elseif(2 == menpai) then
			strMenPai = "Cái Bang";

		elseif(3 == menpai) then
			strMenPai = "Võ Ðang";

		elseif(4 == menpai) then
			strMenPai = "Nga My";

		elseif(5 == menpai) then
			strMenPai = "Tinh Túc";

		elseif(6 == menpai) then
			strMenPai = "Thiên Long";

		elseif(7 == menpai) then
			strMenPai = "Thiên S½n";

		elseif(8 == menpai) then
			strMenPai = "Tiêu Dao";

		elseif(10 == menpai) then
			strMenPai = "Mµ Dung";

		else
			strMenPai = "Không có";
		end

		-- ÏÔÊ¾ÃÅÅÉ
		g_Challenge_MenPai[i]:SetText(strMenPai);

	end;

end



--µÃµ½ÌôÕ½¶ÓÎéÐÅÏ¢¡£
function Challenge_ClearChallengeInfo()

	g_Challenge_FakeObject[0]:SetFakeObject("");
	g_Challenge_FakeObject[1]:SetFakeObject("");
	g_Challenge_FakeObject[2]:SetFakeObject("");
	g_Challenge_FakeObject[3]:SetFakeObject("");
	g_Challenge_FakeObject[4]:SetFakeObject("");
	g_Challenge_FakeObject[5]:SetFakeObject("");

	g_Challenge_Name[0]:SetText("");
	g_Challenge_Name[1]:SetText("");
	g_Challenge_Name[2]:SetText("");
	g_Challenge_Name[3]:SetText("");
	g_Challenge_Name[4]:SetText("");
	g_Challenge_Name[5]:SetText("");

	g_Challenge_Level[0]:SetText("");
	g_Challenge_Level[1]:SetText("");
	g_Challenge_Level[2]:SetText("");
	g_Challenge_Level[3]:SetText("");
	g_Challenge_Level[4]:SetText("");
	g_Challenge_Level[5]:SetText("");

	g_Challenge_MenPai[0]:SetText("");
	g_Challenge_MenPai[1]:SetText("");
	g_Challenge_MenPai[2]:SetText("");
	g_Challenge_MenPai[3]:SetText("");
	g_Challenge_MenPai[4]:SetText("");
	g_Challenge_MenPai[5]:SetText("");

end;


-- Í¬ÒâÌôÕ½
function Challenge_Yes_Click()

	DataPool:RespondChallenge(1);
	g_Challenge_close = 1
	this:Hide();
end;


-- ¾Ü¾øÌôÕ½¡£
function Challenge_No_Click()
	if g_Challenge_close == 1 then
		g_Challenge_close = 0
		return
	end
	if g_Challenge_close == 0 then
		DataPool:RespondChallenge(0);
		this:Hide();
	end
end;

