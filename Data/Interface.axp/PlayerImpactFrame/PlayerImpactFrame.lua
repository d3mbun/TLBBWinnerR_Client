
--最多显示的效果数量
local IMPACT_NUM = 24;

local IMPACT_DESC = {};
IMPACT_DESC[1] = 0;
IMPACT_DESC[2] = 0;
IMPACT_DESC[3] = 0;
IMPACT_DESC[4] = 0;
IMPACT_DESC[5] = 0;
IMPACT_DESC[6] = 0;
IMPACT_DESC[7] = 0;
IMPACT_DESC[8] = 0;
IMPACT_DESC[9] = 0;
IMPACT_DESC[10] = 0;
IMPACT_DESC[11] = 0;
IMPACT_DESC[12] = 0;
IMPACT_DESC[13] = 0;
IMPACT_DESC[14] = 0;
IMPACT_DESC[15] = 0;
IMPACT_DESC[16] = 0;
IMPACT_DESC[17] = 0;
IMPACT_DESC[18] = 0;
IMPACT_DESC[19] = 0;
IMPACT_DESC[20] = 0;
IMPACT_DESC[21] = 0;
IMPACT_DESC[22] = 0;
IMPACT_DESC[23] = 0;
IMPACT_DESC[24] = 0;

local PlayerImpactFrame_TimeCtrl = {};
PlayerImpactFrame_TimeCtrl[1] = 0;
PlayerImpactFrame_TimeCtrl[2] = 0;
PlayerImpactFrame_TimeCtrl[3] = 0;
PlayerImpactFrame_TimeCtrl[4] = 0;
PlayerImpactFrame_TimeCtrl[5] = 0;
PlayerImpactFrame_TimeCtrl[6] = 0;
PlayerImpactFrame_TimeCtrl[7] = 0;
PlayerImpactFrame_TimeCtrl[8] = 0;
PlayerImpactFrame_TimeCtrl[9] = 0;
PlayerImpactFrame_TimeCtrl[10] = 0;
PlayerImpactFrame_TimeCtrl[11] = 0;
PlayerImpactFrame_TimeCtrl[12] = 0;
PlayerImpactFrame_TimeCtrl[13] = 0;
PlayerImpactFrame_TimeCtrl[14] = 0;
PlayerImpactFrame_TimeCtrl[15] = 0;
PlayerImpactFrame_TimeCtrl[16] = 0;
PlayerImpactFrame_TimeCtrl[17] = 0;
PlayerImpactFrame_TimeCtrl[18] = 0;
PlayerImpactFrame_TimeCtrl[19] = 0;
PlayerImpactFrame_TimeCtrl[20] = 0;
PlayerImpactFrame_TimeCtrl[21] = 0;
PlayerImpactFrame_TimeCtrl[22] = 0;
PlayerImpactFrame_TimeCtrl[23] = 0;
PlayerImpactFrame_TimeCtrl[24] = 0;

local PlayerImpactFrame_TextCtrl = {};
PlayerImpactFrame_TextCtrl[1] = 0;
PlayerImpactFrame_TextCtrl[2] = 0;
PlayerImpactFrame_TextCtrl[3] = 0;
PlayerImpactFrame_TextCtrl[4] = 0;
PlayerImpactFrame_TextCtrl[5] = 0;
PlayerImpactFrame_TextCtrl[6] = 0;
PlayerImpactFrame_TextCtrl[7] = 0;
PlayerImpactFrame_TextCtrl[8] = 0;
PlayerImpactFrame_TextCtrl[9] = 0;
PlayerImpactFrame_TextCtrl[10] = 0;
PlayerImpactFrame_TextCtrl[11] = 0;
PlayerImpactFrame_TextCtrl[12] = 0;
PlayerImpactFrame_TextCtrl[13] = 0;
PlayerImpactFrame_TextCtrl[14] = 0;
PlayerImpactFrame_TextCtrl[15] = 0;
PlayerImpactFrame_TextCtrl[16] = 0;
PlayerImpactFrame_TextCtrl[17] = 0;
PlayerImpactFrame_TextCtrl[18] = 0;
PlayerImpactFrame_TextCtrl[19] = 0;
PlayerImpactFrame_TextCtrl[20] = 0;
PlayerImpactFrame_TextCtrl[21] = 0;
PlayerImpactFrame_TextCtrl[22] = 0;
PlayerImpactFrame_TextCtrl[23] = 0;
PlayerImpactFrame_TextCtrl[24] = 0;
local IMPACT_BUTTONS = {};

function PlayerImpactFrame_PreLoad()
	this:RegisterEvent("IMPACT_SELF_UPDATE");
	this:RegisterEvent("IMPACT_SELF_UPDATE_TIME");

end

function PlayerImpactFrame_OnLoad()

	IMPACT_BUTTONS[1] = PlayerImpact_Image1;
	IMPACT_BUTTONS[2] = PlayerImpact_Image2;
	IMPACT_BUTTONS[3] = PlayerImpact_Image3;
	IMPACT_BUTTONS[4] = PlayerImpact_Image4;
	IMPACT_BUTTONS[5] = PlayerImpact_Image5;
	IMPACT_BUTTONS[6] = PlayerImpact_Image6;
	IMPACT_BUTTONS[7] = PlayerImpact_Image7;
	IMPACT_BUTTONS[8] = PlayerImpact_Image8;
	IMPACT_BUTTONS[9] = PlayerImpact_Image9;
	IMPACT_BUTTONS[10] = PlayerImpact_Image10;
	IMPACT_BUTTONS[11] = PlayerImpact_Image11;
	IMPACT_BUTTONS[12] = PlayerImpact_Image12;
	IMPACT_BUTTONS[13] = PlayerImpact_Image13;
	IMPACT_BUTTONS[14] = PlayerImpact_Image14;
	IMPACT_BUTTONS[15] = PlayerImpact_Image15;
	IMPACT_BUTTONS[16] = PlayerImpact_Image16;
	IMPACT_BUTTONS[17] = PlayerImpact_Image17;
	IMPACT_BUTTONS[18] = PlayerImpact_Image18;
	IMPACT_BUTTONS[19] = PlayerImpact_Image19;
	IMPACT_BUTTONS[20] = PlayerImpact_Image20;
	IMPACT_BUTTONS[21] = PlayerImpact_Image21;
	IMPACT_BUTTONS[22] = PlayerImpact_Image22;
	IMPACT_BUTTONS[23] = PlayerImpact_Image23;
	IMPACT_BUTTONS[24] = PlayerImpact_Image24;

	PlayerImpactFrame_TimeCtrl[1] = PlayerImpact_Text1;
	PlayerImpactFrame_TimeCtrl[2] = PlayerImpact_Text2;
	PlayerImpactFrame_TimeCtrl[3] = PlayerImpact_Text3;
	PlayerImpactFrame_TimeCtrl[4] = PlayerImpact_Text4;
	PlayerImpactFrame_TimeCtrl[5] = PlayerImpact_Text5;
	PlayerImpactFrame_TimeCtrl[6] = PlayerImpact_Text6;
	PlayerImpactFrame_TimeCtrl[7] = PlayerImpact_Text7;
	PlayerImpactFrame_TimeCtrl[8] = PlayerImpact_Text8;
	PlayerImpactFrame_TimeCtrl[9] = PlayerImpact_Text9;
	PlayerImpactFrame_TimeCtrl[10] = PlayerImpact_Text10;
	PlayerImpactFrame_TimeCtrl[11] = PlayerImpact_Text11;
	PlayerImpactFrame_TimeCtrl[12] = PlayerImpact_Text12;
	PlayerImpactFrame_TimeCtrl[13] = PlayerImpact_Text13;
	PlayerImpactFrame_TimeCtrl[14] = PlayerImpact_Text14;
	PlayerImpactFrame_TimeCtrl[15] = PlayerImpact_Text15;
	PlayerImpactFrame_TimeCtrl[16] = PlayerImpact_Text16;
	PlayerImpactFrame_TimeCtrl[17] = PlayerImpact_Text17;
	PlayerImpactFrame_TimeCtrl[18] = PlayerImpact_Text18;
	PlayerImpactFrame_TimeCtrl[19] = PlayerImpact_Text19;
	PlayerImpactFrame_TimeCtrl[20] = PlayerImpact_Text20;
	PlayerImpactFrame_TimeCtrl[21] = PlayerImpact_Text21;
	PlayerImpactFrame_TimeCtrl[22] = PlayerImpact_Text22;
	PlayerImpactFrame_TimeCtrl[23] = PlayerImpact_Text23;
	PlayerImpactFrame_TimeCtrl[24] = PlayerImpact_Text24;

	PlayerImpactFrame_TextCtrl[1] = PlayerImpact_NewText1;
	PlayerImpactFrame_TextCtrl[2] = PlayerImpact_NewText2;
	PlayerImpactFrame_TextCtrl[3] = PlayerImpact_NewText3;
	PlayerImpactFrame_TextCtrl[4] = PlayerImpact_NewText4;
	PlayerImpactFrame_TextCtrl[5] = PlayerImpact_NewText5;
	PlayerImpactFrame_TextCtrl[6] = PlayerImpact_NewText6;
	PlayerImpactFrame_TextCtrl[7] = PlayerImpact_NewText7;
	PlayerImpactFrame_TextCtrl[8] = PlayerImpact_NewText8;
	PlayerImpactFrame_TextCtrl[9] = PlayerImpact_NewText9;
	PlayerImpactFrame_TextCtrl[10] = PlayerImpact_NewText10;
	PlayerImpactFrame_TextCtrl[11] = PlayerImpact_NewText11;
	PlayerImpactFrame_TextCtrl[12] = PlayerImpact_NewText12;
	PlayerImpactFrame_TextCtrl[13] = PlayerImpact_NewText13;
	PlayerImpactFrame_TextCtrl[14] = PlayerImpact_NewText14;
	PlayerImpactFrame_TextCtrl[15] = PlayerImpact_NewText15;
	PlayerImpactFrame_TextCtrl[16] = PlayerImpact_NewText16;
	PlayerImpactFrame_TextCtrl[17] = PlayerImpact_NewText17;
	PlayerImpactFrame_TextCtrl[18] = PlayerImpact_NewText18;
	PlayerImpactFrame_TextCtrl[19] = PlayerImpact_NewText19;
	PlayerImpactFrame_TextCtrl[20] = PlayerImpact_NewText20;
	PlayerImpactFrame_TextCtrl[21] = PlayerImpact_NewText21;
	PlayerImpactFrame_TextCtrl[22] = PlayerImpact_NewText22;
	PlayerImpactFrame_TextCtrl[23] = PlayerImpact_NewText23;
	PlayerImpactFrame_TextCtrl[24] = PlayerImpact_NewText24;
end

function PlayerImpactFrame_OnEvent(event)

	if ( event == "IMPACT_SELF_UPDATE" ) then
		PlayerImpactFrame_Update( 1, 1 );
		return;
	end

	if ( event == "IMPACT_SELF_UPDATE_TIME" ) then
		PlayerImpactFrame_Update( 0, 1 );
		return;
	end

end

function PlayerImpactFrame_Update( bUpdateImage, bUpdateTime )

	local buff_num = Player:GetBuffNumber();

	if ( buff_num > IMPACT_NUM ) then
		buff_num = IMPACT_NUM;
	end

	if( buff_num == 0) then
		this:Hide();
		return;
	end

	this:Show();

	if ( bUpdateImage > 0 ) then
		local szIconName, szToolTips;
		local i, m;

		i = 0;
		m = 0;
		while i < buff_num do
			szIconName = Player:GetBuffIconNameByIndex(i);
			szToolTips = Player:GetBuffToolTipsByIndex(i);
			if szToolTips ~= "TTPS" then
				IMPACT_BUTTONS[m+1]:SetProperty("ShortImage", szIconName);
				IMPACT_BUTTONS[m+1]:SetProperty("MouseHollow","False");
				IMPACT_BUTTONS[m+1]:SetToolTip(szToolTips);
				IMPACT_BUTTONS[m+1]:Show();
				m = m + 1;
			end
			i = i + 1;
		end

		while m < IMPACT_NUM do
			IMPACT_BUTTONS[m+1]:SetProperty("MouseHollow","True");
			IMPACT_BUTTONS[m+1]:Hide();
			m = m+1;
		end
	end

	if ( bUpdateTime > 0 ) then
		local szTimeText;
		local i, m;

		i = 0;
		m = 0;
		while i<buff_num do
			szToolTips = Player:GetBuffToolTipsByIndex(i);
			szTimeText = Player:GetBuffTimeTextByIndex(i);
			if szToolTips ~= "TTPS" then
				if tonumber(szTimeText) <= 3600 then
					PlayerImpactFrame_TextCtrl[m+1]:Hide();
					PlayerImpactFrame_TimeCtrl[m+1]:SetProperty("Timer",tonumber(szTimeText));
					PlayerImpactFrame_TimeCtrl[m+1]:Show();
				else
					local szTimeTextSub = math.floor(tonumber(szTimeText)/3600);
					if szTimeTextSub >= 24 then
						szTimeTextSub = math.floor(szTimeTextSub/24);
						szTimeText = szTimeTextSub.."D";
					else
						szTimeText = szTimeTextSub.."H";
					end
					PlayerImpactFrame_TimeCtrl[m+1]:Hide();
					PlayerImpactFrame_TextCtrl[m+1]:SetText(szTimeText);
					PlayerImpactFrame_TextCtrl[m+1]:Show();
				end
				m = m + 1;
			end
			i = i+1;
		end

		while m<IMPACT_NUM do
			PlayerImpactFrame_TimeCtrl[m+1]:SetProperty("Timer","-2");
			PlayerImpactFrame_TimeCtrl[m+1]:Hide();
			PlayerImpactFrame_TextCtrl[m+1]:Hide();
			m = m+1;
		end
	end

end

function PlayerImpactFrame_Image1_Click()
  PlayerImpactFrame_Image_Click(1)
end

function PlayerImpactFrame_Image2_Click()
  PlayerImpactFrame_Image_Click(2)
end

function PlayerImpactFrame_Image3_Click()
  PlayerImpactFrame_Image_Click(3)
end

function PlayerImpactFrame_Image4_Click()
  PlayerImpactFrame_Image_Click(4)
end

function PlayerImpactFrame_Image5_Click()
  PlayerImpactFrame_Image_Click(5)
end

function PlayerImpactFrame_Image6_Click()
  PlayerImpactFrame_Image_Click(6)
end

function PlayerImpactFrame_Image7_Click()
  PlayerImpactFrame_Image_Click(7)
end

function PlayerImpactFrame_Image8_Click()
  PlayerImpactFrame_Image_Click(8)
end

function PlayerImpactFrame_Image9_Click()
  PlayerImpactFrame_Image_Click(9)
end

function PlayerImpactFrame_Image10_Click()
  PlayerImpactFrame_Image_Click(10)
end

function PlayerImpactFrame_Image11_Click()
  PlayerImpactFrame_Image_Click(11)
end

function PlayerImpactFrame_Image12_Click()
  PlayerImpactFrame_Image_Click(12)
end

function PlayerImpactFrame_Image13_Click()
  PlayerImpactFrame_Image_Click(13)
end

function PlayerImpactFrame_Image14_Click()
  PlayerImpactFrame_Image_Click(14)
end

function PlayerImpactFrame_Image15_Click()
  PlayerImpactFrame_Image_Click(15)
end

function PlayerImpactFrame_Image16_Click()
  PlayerImpactFrame_Image_Click(16)
end

function PlayerImpactFrame_Image17_Click()
  PlayerImpactFrame_Image_Click(17)
end

function PlayerImpactFrame_Image18_Click()
  PlayerImpactFrame_Image_Click(18)
end

function PlayerImpactFrame_Image19_Click()
  PlayerImpactFrame_Image_Click(19)
end

function PlayerImpactFrame_Image20_Click()
  PlayerImpactFrame_Image_Click(20)
end

function PlayerImpactFrame_Image21_Click()
  PlayerImpactFrame_Image_Click(21)
end

function PlayerImpactFrame_Image22_Click()
  PlayerImpactFrame_Image_Click(22)
end

function PlayerImpactFrame_Image23_Click()
  PlayerImpactFrame_Image_Click(23)
end

function PlayerImpactFrame_Image24_Click()
  PlayerImpactFrame_Image_Click(24)
end

function PlayerImpactFrame_Image_Click(id)
	local buff_num = Player:GetBuffNumber()
	local szToolTips
	local i, m

	i = 0
	m = 0
	while i<buff_num do
		szToolTips = Player:GetBuffToolTipsByIndex(i)
		if szToolTips ~= "TTPS" then
			m = m + 1
		end
		if m == id then
			Player:DispelBuffByIndex( i )
      break
		end
		i = i + 1
	end
end