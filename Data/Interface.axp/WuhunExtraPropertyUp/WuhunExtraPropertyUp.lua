local m_UI_NUM = 20090720
local WuhunExtraPropertyUp_Confirm = 0;
local VoHon_Option = {}
	VoHon_Option[1] = {"Bång công (C¤p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[2] = {"Bång công (C¤p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[3] = {"Bång công (C¤p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[4] = {"Bång công (C¤p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[5] = {"Bång công (C¤p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[6] = {"Bång công (C¤p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[7] = {"Bång công (C¤p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[8] = {"Bång công (C¤p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[9] = {"Bång công (C¤p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[10] = {"Bång công (C¤p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[11] = {"Höa công (C¤p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[12] = {"Höa công (C¤p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[13] = {"Höa công (C¤p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[14] = {"Höa công (C¤p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[15] = {"Höa công (C¤p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[16] = {"Höa công (C¤p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[17] = {"Höa công (C¤p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[18] = {"Höa công (C¤p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[19] = {"Höa công (C¤p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[20] = {"Höa công (C¤p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[21] = {"Huy«n công (C¤p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[22] = {"Huy«n công (C¤p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[23] = {"Huy«n công (C¤p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[24] = {"Huy«n công (C¤p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[25] = {"Huy«n công (C¤p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[26] = {"Huy«n công (C¤p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[27] = {"Huy«n công (C¤p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[28] = {"Huy«n công (C¤p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[29] = {"Huy«n công (C¤p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[30] = {"Huy«n công (C¤p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[31] = {"Ðµc công (C¤p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[32] = {"Ðµc công (C¤p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[33] = {"Ðµc công (C¤p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[34] = {"Ðµc công (C¤p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[35] = {"Ðµc công (C¤p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[36] = {"Ðµc công (C¤p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[37] = {"Ðµc công (C¤p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[38] = {"Ðµc công (C¤p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[39] = {"Ðµc công (C¤p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[40] = {"Ðµc công (C¤p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[41] = {"Kháng bång (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[42] = {"Kháng bång (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[43] = {"Kháng bång (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[44] = {"Kháng bång (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[45] = {"Kháng bång (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[46] = {"Kháng bång (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[47] = {"Kháng bång (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[48] = {"Kháng bång (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[49] = {"Kháng bång (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[50] = {"Kháng bång (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[51] = {"Kháng höa (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[52] = {"Kháng höa (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[53] = {"Kháng höa (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[54] = {"Kháng höa (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[55] = {"Kháng höa (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[56] = {"Kháng höa (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[57] = {"Kháng höa (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[58] = {"Kháng höa (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[59] = {"Kháng höa (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[60] = {"Kháng höa (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[61] = {"Kháng huy«n (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[62] = {"Kháng huy«n (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[63] = {"Kháng huy«n (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[64] = {"Kháng huy«n (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[65] = {"Kháng huy«n (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[66] = {"Kháng huy«n (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[67] = {"Kháng huy«n (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[68] = {"Kháng huy«n (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[69] = {"Kháng huy«n (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[70] = {"Kháng huy«n (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[71] = {"Kháng ðµc (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[72] = {"Kháng ðµc (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[73] = {"Kháng ðµc (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[74] = {"Kháng ðµc (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[75] = {"Kháng ðµc (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[76] = {"Kháng ðµc (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[77] = {"Kháng ðµc (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[78] = {"Kháng ðµc (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[79] = {"Kháng ðµc (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[80] = {"Kháng ðµc (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[81] = {"Xuyên kháng bång (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[82] = {"Xuyên kháng bång (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[83] = {"Xuyên kháng bång (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[84] = {"Xuyên kháng bång (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[85] = {"Xuyên kháng bång (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[86] = {"Xuyên kháng bång (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[87] = {"Xuyên kháng bång (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[88] = {"Xuyên kháng bång (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[89] = {"Xuyên kháng bång (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[90] = {"Xuyên kháng bång (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[91] = {"Xuyên kháng höa (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[92] = {"Xuyên kháng höa (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[93] = {"Xuyên kháng höa (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[94] = {"Xuyên kháng höa (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[95] = {"Xuyên kháng höa (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[96] = {"Xuyên kháng höa (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[97] = {"Xuyên kháng höa (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[98] = {"Xuyên kháng höa (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[99] = {"Xuyên kháng höa (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[100] = {"Xuyên kháng höa (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[101] = {"Xuyên kháng huy«n (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[102] = {"Xuyên kháng huy«n (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[103] = {"Xuyên kháng huy«n (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[104] = {"Xuyên kháng huy«n (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[105] = {"Xuyên kháng huy«n (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[106] = {"Xuyên kháng huy«n (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[107] = {"Xuyên kháng huy«n (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[108] = {"Xuyên kháng huy«n (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[109] = {"Xuyên kháng huy«n (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[110] = {"Xuyên kháng huy«n (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[111] = {"Xuyên kháng ðµc (C¤p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[112] = {"Xuyên kháng ðµc (C¤p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[113] = {"Xuyên kháng ðµc (C¤p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[114] = {"Xuyên kháng ðµc (C¤p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[115] = {"Xuyên kháng ðµc (C¤p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[116] = {"Xuyên kháng ðµc (C¤p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[117] = {"Xuyên kháng ðµc (C¤p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[118] = {"Xuyên kháng ðµc (C¤p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[119] = {"Xuyên kháng ðµc (C¤p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[120] = {"Xuyên kháng ðµc (C¤p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[121] = {"GK Bång ðªn âm (C¤p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[122] = {"GK Bång ðªn âm (C¤p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[123] = {"GK Bång ðªn âm (C¤p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[124] = {"GK Bång ðªn âm (C¤p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[125] = {"GK Bång ðªn âm (C¤p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[126] = {"GK Bång ðªn âm (C¤p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[127] = {"GK Bång ðªn âm (C¤p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[128] = {"GK Bång ðªn âm (C¤p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[129] = {"GK Bång ðªn âm (C¤p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[130] = {"GK Bång ðªn âm (C¤p 10)", 12, 14, 16, 18, 20}
	VoHon_Option[131] = {"GK Höa ðªn âm (C¤p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[132] = {"GK Höa ðªn âm (C¤p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[133] = {"GK Höa ðªn âm (C¤p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[134] = {"GK Höa ðªn âm (C¤p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[135] = {"GK Höa ðªn âm (C¤p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[136] = {"GK Höa ðªn âm (C¤p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[137] = {"GK Höa ðªn âm (C¤p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[138] = {"GK Höa ðªn âm (C¤p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[139] = {"GK Höa ðªn âm (C¤p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[140] = {"GK Höa ðªn âm (C¤p 10)", 12, 14, 16, 18, 20}
	VoHon_Option[141] = {"GK Huy«n ðªn âm (C¤p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[142] = {"GK Huy«n ðªn âm (C¤p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[143] = {"GK Huy«n ðªn âm (C¤p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[144] = {"GK Huy«n ðªn âm (C¤p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[145] = {"GK Huy«n ðªn âm (C¤p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[146] = {"GK Huy«n ðªn âm (C¤p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[147] = {"GK Huy«n ðªn âm (C¤p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[148] = {"GK Huy«n ðªn âm (C¤p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[149] = {"GK Huy«n ðªn âm (C¤p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[150] = {"GK Huy«n ðªn âm (C¤p 10)", 12, 14, 16, 18, 20}
	VoHon_Option[151] = {"GK Ðµc ðªn âm (C¤p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[152] = {"GK Ðµc ðªn âm (C¤p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[153] = {"GK Ðµc ðªn âm (C¤p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[154] = {"GK Ðµc ðªn âm (C¤p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[155] = {"GK Ðµc ðªn âm (C¤p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[156] = {"GK Ðµc ðªn âm (C¤p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[157] = {"GK Ðµc ðªn âm (C¤p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[158] = {"GK Ðµc ðªn âm (C¤p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[159] = {"GK Ðµc ðªn âm (C¤p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[160] = {"GK Ðµc ðªn âm (C¤p 10)", 12, 14, 16, 18, 20}
	
local VoHon_OpP1 = {14,17,20,23,26,29,32}
local VoHon_OpP2 = {16,19,22,25,28,31,34}

local WuhunExtraPropertyUp_Index1 = -1
local WuhunExtraPropertyUp_Index2 = -1

local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local m_sel = -1

local INDEX_ATTRUP_BEGIN	= 20310122	--Èó»êÊ¯¡¤Óù£¨1¼¶£©
local INDEX_ATTRUP_END		= 20310157	--Èó»êÊ¯¡¤±©£¨9¼¶£©

local m_AttrBnList = {}
--PreLoad
function WuhunExtraPropertyUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFSATTRLEVELUP")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

--Onload
function WuhunExtraPropertyUp_OnLoad()
	m_AttrBnList[1] = WuhunExtraPropertyUp_Property1
	m_AttrBnList[2] = WuhunExtraPropertyUp_Property2
	m_AttrBnList[3] = WuhunExtraPropertyUp_Property3
	m_AttrBnList[4] = WuhunExtraPropertyUp_Property4
	m_AttrBnList[5] = WuhunExtraPropertyUp_Property5
	m_AttrBnList[6] = WuhunExtraPropertyUp_Property6
	m_AttrBnList[7] = WuhunExtraPropertyUp_Property7
	m_AttrBnList[8] = WuhunExtraPropertyUp_Property8
	m_AttrBnList[9] = WuhunExtraPropertyUp_Property9
	m_AttrBnList[10] = WuhunExtraPropertyUp_Property10
end

function WuhunExtraPropertyUp_LoadOption()
	m_sel = -1;
	local WuhunAuthor = GlobalWuhunAuthor()
	if WuhunAuthor ~= "No_Author" then
		local VoHon_Base = tonumber(string.sub(WuhunAuthor,9,9)) - 5;
		for i = 1, 7 do
			local VoHon_OptionAttr = string.sub(WuhunAuthor,VoHon_OpP1[i],VoHon_OpP2[i])
			if VoHon_OptionAttr ~= "---" then
				VoHon_OptionAttr = tonumber(VoHon_OptionAttr)
				m_AttrBnList[i]:SetText(VoHon_Option[VoHon_OptionAttr][1].." +"..VoHon_Option[VoHon_OptionAttr][VoHon_Base+2]);
				m_AttrBnList[i]:Enable();
			end
		end
	end
end

function WuhunExtraPropertyUp_UpdateItem(Pos)
	if WuhunExtraPropertyUp_Index1 == -1 then
		local Index1 = EnumAction(Pos, "packageitem")
		local Index1ID = Index1:GetDefineID()
		if Index1ID == -1 then
			return
		end
		
		if Index1ID < 10308001 or Index1ID > 10308004 then
			PushDebugMessage("N½i này chï có th¬ ð£t vào Võ H°n.")
			return
		end
		
		WuhunExtraPropertyUp_Object1:SetActionItem(Index1:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunExtraPropertyUp_Index1 = Pos
		
		WuhunExtraPropertyUp_LoadOption()
		
	elseif WuhunExtraPropertyUp_Index2 == -1 then
		local Index2 = EnumAction(Pos, "packageitem")
		local Index2ID = Index2:GetDefineID()
		if Index2ID == -1 then
			return
		end
		
		if Index2ID < 20310122 or Index2ID > 20310157 then
			PushDebugMessage("N½i này chï có th¬ ð£t vào Nhu§n H°n ThÕch.")
			return
		end
		
		WuhunExtraPropertyUp_Object2:SetActionItem(Index2:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunExtraPropertyUp_Index2 = Pos
	end
	
	if WuhunExtraPropertyUp_Index1 ~= -1 and WuhunExtraPropertyUp_Index2 ~= -1 and m_sel ~= -1 then
		WuhunExtraPropertyUp_OK:Enable()
		WuhunExtraPropertyUp_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunExtraPropertyUp_OK:Disable()
		WuhunExtraPropertyUp_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

function WuhunExtraPropertyUp_ClearItem(Num)
	if Num == 1 then
		if WuhunExtraPropertyUp_Index1 ~= -1 then
			WuhunExtraPropertyUp_Object1:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item( WuhunExtraPropertyUp_Index1, 0 )
			WuhunExtraPropertyUp_Index1 = -1
		end
		for i = 1, 10 do
			m_AttrBnList[i]:Disable();
			m_AttrBnList[i]:SetText("");
			m_AttrBnList[i]:SetCheck(0);
		end
	end
	
	if Num == 2 then
		if WuhunExtraPropertyUp_Index2 ~= -1 then
			WuhunExtraPropertyUp_Object2:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item( WuhunExtraPropertyUp_Index2, 0 )
			WuhunExtraPropertyUp_Index2 = -1
		end
	end
	
	if WuhunExtraPropertyUp_Index1 == -1 or WuhunExtraPropertyUp_Index2 == -1 and m_sel ~= -1 then
		WuhunExtraPropertyUp_DemandMoney:SetProperty("MoneyNumber", 0)
		WuhunExtraPropertyUp_OK:Disable()
	end
end

--OnEvent
function WuhunExtraPropertyUp_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017) then
		if IsWindowShow("WuhunExtraPropertyUp") then
			WuhunExtraPropertyUp_UpdateItem(tonumber(arg1))
		end
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunExtraPropertyUp_Confirm = 0;
		WuhunExtraPropertyUp_BeginCareObj( Get_XParam_INT(0) );
		
		for i = 1, 10 do
			m_AttrBnList[i]:Disable();
			m_AttrBnList[i]:SetText("");
			m_AttrBnList[i]:SetCheck(0);
		end
		
		WuhunExtraPropertyUp_Update(-1)
		WuhunExtraPropertyUp_Update_Sub(-1)
		this:Show();

	elseif (event == "UPDATE_KFSATTRLEVELUP" and this:IsVisible() ) then
		if arg1 ~= nil and tonumber(arg1) == 0 and arg0 ~= nil then
			WuhunExtraPropertyUp_Update( tonumber(arg0) )
	
		elseif arg1 ~= nil and tonumber(arg1) == 1 and arg0 ~= nil then
			WuhunExtraPropertyUp_Update_Sub( tonumber(arg0) )
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunExtraPropertyUp_Update(m_Equip_Idx)
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			WuhunExtraPropertyUp_Update_Sub(m_Equip_Item)
		end 
	end
end

--Update UI
function WuhunExtraPropertyUp_Update(itemIdx)
	WuhunExtraPropertyUp_UICheck()
end

function WuhunExtraPropertyUp_Update_Sub(itemIdx)
	WuhunExtraPropertyUp_UICheck()
end

--Care Obj
function WuhunExtraPropertyUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OK
function WuhunExtraPropertyUp_OK_Clicked()
	-- if Enchase_IsBind(WuhunExtraPropertyUp_Index2) == 1 then
		-- if WuhunExtraPropertyUp_Confirm == 0 then
			-- ShowSystemInfo("BIND_CONFIRM");
			-- WuhunExtraPropertyUp_Confirm = 1;
			-- return
		-- end
	-- end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(45001)
		Set_XSCRIPT_Parameter(0, 1099) --8 for pos, 01 for function--
		Set_XSCRIPT_Parameter(1, WuhunExtraPropertyUp_Index1)
		Set_XSCRIPT_Parameter(2, WuhunExtraPropertyUp_Index2)
		Set_XSCRIPT_Parameter(3, m_sel)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	
	WuhunExtraPropertyUp_OnHiden()
end

--Select 1 Attr
function WuhunExtraPropertyUp_Select_AttrEx(idx)
	m_sel = idx
	if WuhunExtraPropertyUp_Index1 ~= -1 and WuhunExtraPropertyUp_Index2 ~= -1 and m_sel ~= -1 then
		WuhunExtraPropertyUp_OK:Enable()
		WuhunExtraPropertyUp_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunExtraPropertyUp_OK:Disable()
		WuhunExtraPropertyUp_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

--Close UI
function WuhunExtraPropertyUp_Close()
	this:Hide();
end

--Handle UI Closed
function WuhunExtraPropertyUp_OnHiden()
	WuhunExtraPropertyUp_ClearAll()
	this:Hide()
end

function WuhunExtraPropertyUp_ClearAll()
	if WuhunExtraPropertyUp_Index1 ~= -1 then
		WuhunExtraPropertyUp_Object1:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunExtraPropertyUp_Index1, 0 )
		WuhunExtraPropertyUp_Index1 = -1
	end
	
	if WuhunExtraPropertyUp_Index2 ~= -1 then
		WuhunExtraPropertyUp_Object2:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunExtraPropertyUp_Index2, 0 )
		WuhunExtraPropertyUp_Index2 = -1
	end
end

--
function WuhunExtraPropertyUp_Resume_Equip()
	WuhunExtraPropertyUp_Update(-1)
end

function WuhunExtraPropertyUp_Resume_Item()
	WuhunExtraPropertyUp_Update_Sub(-1)
end


function WuhunExtraPropertyUp_UICheck()
	WuhunExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
end