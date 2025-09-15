local m_UI_NUM = 20090727	--һ��8��
local WuhunExtraPropertyDel_Index = -1
local WuhunExtraPropertyDel_Confirm = 0;
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local VoHon_Option = {}
	VoHon_Option[1] = {"B�ng c�ng (C�p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[2] = {"B�ng c�ng (C�p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[3] = {"B�ng c�ng (C�p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[4] = {"B�ng c�ng (C�p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[5] = {"B�ng c�ng (C�p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[6] = {"B�ng c�ng (C�p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[7] = {"B�ng c�ng (C�p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[8] = {"B�ng c�ng (C�p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[9] = {"B�ng c�ng (C�p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[10] = {"B�ng c�ng (C�p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[11] = {"H�a c�ng (C�p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[12] = {"H�a c�ng (C�p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[13] = {"H�a c�ng (C�p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[14] = {"H�a c�ng (C�p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[15] = {"H�a c�ng (C�p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[16] = {"H�a c�ng (C�p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[17] = {"H�a c�ng (C�p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[18] = {"H�a c�ng (C�p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[19] = {"H�a c�ng (C�p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[20] = {"H�a c�ng (C�p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[21] = {"Huy�n c�ng (C�p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[22] = {"Huy�n c�ng (C�p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[23] = {"Huy�n c�ng (C�p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[24] = {"Huy�n c�ng (C�p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[25] = {"Huy�n c�ng (C�p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[26] = {"Huy�n c�ng (C�p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[27] = {"Huy�n c�ng (C�p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[28] = {"Huy�n c�ng (C�p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[29] = {"Huy�n c�ng (C�p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[30] = {"Huy�n c�ng (C�p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[31] = {"еc c�ng (C�p 1)", 18, 21, 24, 27, 30}
	VoHon_Option[32] = {"еc c�ng (C�p 2)", 25, 29, 33, 37, 41}
	VoHon_Option[33] = {"еc c�ng (C�p 3)", 38, 44, 50, 57, 63}
	VoHon_Option[34] = {"еc c�ng (C�p 4)", 56, 65, 74, 84, 93}
	VoHon_Option[35] = {"еc c�ng (C�p 5)", 79, 92, 105, 118, 131}
	VoHon_Option[36] = {"еc c�ng (C�p 6)", 104, 122, 139, 157, 174}
	VoHon_Option[37] = {"еc c�ng (C�p 7)", 134, 156, 178, 201, 223}
	VoHon_Option[38] = {"еc c�ng (C�p 8)", 166, 194, 222, 249, 277}
	VoHon_Option[39] = {"еc c�ng (C�p 9)", 202, 235, 269, 302, 336}
	VoHon_Option[40] = {"еc c�ng (C�p 10)", 240, 280, 320, 360, 400}
	VoHon_Option[41] = {"Kh�ng b�ng (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[42] = {"Kh�ng b�ng (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[43] = {"Kh�ng b�ng (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[44] = {"Kh�ng b�ng (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[45] = {"Kh�ng b�ng (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[46] = {"Kh�ng b�ng (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[47] = {"Kh�ng b�ng (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[48] = {"Kh�ng b�ng (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[49] = {"Kh�ng b�ng (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[50] = {"Kh�ng b�ng (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[51] = {"Kh�ng h�a (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[52] = {"Kh�ng h�a (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[53] = {"Kh�ng h�a (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[54] = {"Kh�ng h�a (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[55] = {"Kh�ng h�a (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[56] = {"Kh�ng h�a (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[57] = {"Kh�ng h�a (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[58] = {"Kh�ng h�a (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[59] = {"Kh�ng h�a (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[60] = {"Kh�ng h�a (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[61] = {"Kh�ng huy�n (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[62] = {"Kh�ng huy�n (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[63] = {"Kh�ng huy�n (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[64] = {"Kh�ng huy�n (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[65] = {"Kh�ng huy�n (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[66] = {"Kh�ng huy�n (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[67] = {"Kh�ng huy�n (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[68] = {"Kh�ng huy�n (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[69] = {"Kh�ng huy�n (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[70] = {"Kh�ng huy�n (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[71] = {"Kh�ng �c (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[72] = {"Kh�ng �c (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[73] = {"Kh�ng �c (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[74] = {"Kh�ng �c (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[75] = {"Kh�ng �c (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[76] = {"Kh�ng �c (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[77] = {"Kh�ng �c (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[78] = {"Kh�ng �c (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[79] = {"Kh�ng �c (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[80] = {"Kh�ng �c (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[81] = {"Xuy�n kh�ng b�ng (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[82] = {"Xuy�n kh�ng b�ng (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[83] = {"Xuy�n kh�ng b�ng (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[84] = {"Xuy�n kh�ng b�ng (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[85] = {"Xuy�n kh�ng b�ng (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[86] = {"Xuy�n kh�ng b�ng (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[87] = {"Xuy�n kh�ng b�ng (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[88] = {"Xuy�n kh�ng b�ng (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[89] = {"Xuy�n kh�ng b�ng (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[90] = {"Xuy�n kh�ng b�ng (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[91] = {"Xuy�n kh�ng h�a (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[92] = {"Xuy�n kh�ng h�a (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[93] = {"Xuy�n kh�ng h�a (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[94] = {"Xuy�n kh�ng h�a (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[95] = {"Xuy�n kh�ng h�a (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[96] = {"Xuy�n kh�ng h�a (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[97] = {"Xuy�n kh�ng h�a (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[98] = {"Xuy�n kh�ng h�a (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[99] = {"Xuy�n kh�ng h�a (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[100] = {"Xuy�n kh�ng h�a (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[101] = {"Xuy�n kh�ng huy�n (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[102] = {"Xuy�n kh�ng huy�n (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[103] = {"Xuy�n kh�ng huy�n (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[104] = {"Xuy�n kh�ng huy�n (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[105] = {"Xuy�n kh�ng huy�n (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[106] = {"Xuy�n kh�ng huy�n (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[107] = {"Xuy�n kh�ng huy�n (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[108] = {"Xuy�n kh�ng huy�n (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[109] = {"Xuy�n kh�ng huy�n (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[110] = {"Xuy�n kh�ng huy�n (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[111] = {"Xuy�n kh�ng �c (C�p 1)", 5, 6, 6, 7, 8}
	VoHon_Option[112] = {"Xuy�n kh�ng �c (C�p 2)", 7, 8, 9, 10, 11}
	VoHon_Option[113] = {"Xuy�n kh�ng �c (C�p 3)", 10, 11, 13, 14, 16}
	VoHon_Option[114] = {"Xuy�n kh�ng �c (C�p 4)", 14, 17, 19, 22, 24}
	VoHon_Option[115] = {"Xuy�n kh�ng �c (C�p 5)", 20, 23, 26, 30, 33}
	VoHon_Option[116] = {"Xuy�n kh�ng �c (C�p 6)", 26, 31, 35, 40, 44}
	VoHon_Option[117] = {"Xuy�n kh�ng �c (C�p 7)", 34, 39, 45, 50, 56}
	VoHon_Option[118] = {"Xuy�n kh�ng �c (C�p 8)", 42, 49, 56, 63, 70}
	VoHon_Option[119] = {"Xuy�n kh�ng �c (C�p 9)", 50, 59, 67, 76, 84}
	VoHon_Option[120] = {"Xuy�n kh�ng �c (C�p 10)", 60, 70, 80, 90, 100}
	VoHon_Option[121] = {"GK B�ng �n �m (C�p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[122] = {"GK B�ng �n �m (C�p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[123] = {"GK B�ng �n �m (C�p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[124] = {"GK B�ng �n �m (C�p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[125] = {"GK B�ng �n �m (C�p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[126] = {"GK B�ng �n �m (C�p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[127] = {"GK B�ng �n �m (C�p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[128] = {"GK B�ng �n �m (C�p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[129] = {"GK B�ng �n �m (C�p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[130] = {"GK B�ng �n �m (C�p 10)", 12, 14, 16, 18, 20}
	VoHon_Option[131] = {"GK H�a �n �m (C�p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[132] = {"GK H�a �n �m (C�p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[133] = {"GK H�a �n �m (C�p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[134] = {"GK H�a �n �m (C�p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[135] = {"GK H�a �n �m (C�p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[136] = {"GK H�a �n �m (C�p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[137] = {"GK H�a �n �m (C�p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[138] = {"GK H�a �n �m (C�p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[139] = {"GK H�a �n �m (C�p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[140] = {"GK H�a �n �m (C�p 10)", 12, 14, 16, 18, 20}
	VoHon_Option[141] = {"GK Huy�n �n �m (C�p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[142] = {"GK Huy�n �n �m (C�p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[143] = {"GK Huy�n �n �m (C�p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[144] = {"GK Huy�n �n �m (C�p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[145] = {"GK Huy�n �n �m (C�p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[146] = {"GK Huy�n �n �m (C�p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[147] = {"GK Huy�n �n �m (C�p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[148] = {"GK Huy�n �n �m (C�p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[149] = {"GK Huy�n �n �m (C�p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[150] = {"GK Huy�n �n �m (C�p 10)", 12, 14, 16, 18, 20}
	VoHon_Option[151] = {"GK еc �n �m (C�p 1)", 1, 1, 2, 2, 2}
	VoHon_Option[152] = {"GK еc �n �m (C�p 2)", 2, 2, 2, 3, 3}
	VoHon_Option[153] = {"GK еc �n �m (C�p 3)", 2, 3, 3, 4, 4}
	VoHon_Option[154] = {"GK еc �n �m (C�p 4)", 3, 4, 4, 5, 5}
	VoHon_Option[155] = {"GK еc �n �m (C�p 5)", 4, 5, 6, 6, 7}
	VoHon_Option[156] = {"GK еc �n �m (C�p 6)", 5, 6, 7, 8, 9}
	VoHon_Option[157] = {"GK еc �n �m (C�p 7)", 7, 8, 10, 11, 12}
	VoHon_Option[158] = {"GK еc �n �m (C�p 8)", 8, 10, 11, 13, 14}
	VoHon_Option[159] = {"GK еc �n �m (C�p 9)", 10, 12, 14, 15, 17}
	VoHon_Option[160] = {"GK еc �n �m (C�p 10)", 12, 14, 16, 18, 20}
	
local VoHon_OpP1 = {14,17,20,23,26,29,32}
local VoHon_OpP2 = {16,19,22,25,28,31,34}

local m_sel = -1

local INDEX_ATTRUP_BEGIN	= 20310122	--���ʯ������1����
local INDEX_ATTRUP_END		= 20310157	--���ʯ������9����

local m_AttrBnList = {}

local isComfirmed = 0
--PreLoad
function WuhunExtraPropertyDel_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFSATTR_DEL")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

--Onload
function WuhunExtraPropertyDel_OnLoad()
	m_AttrBnList[1] = WuhunExtraPropertyDel_Property1
	m_AttrBnList[2] = WuhunExtraPropertyDel_Property2
	m_AttrBnList[3] = WuhunExtraPropertyDel_Property3
	m_AttrBnList[4] = WuhunExtraPropertyDel_Property4
	m_AttrBnList[5] = WuhunExtraPropertyDel_Property5
	m_AttrBnList[6] = WuhunExtraPropertyDel_Property6
	m_AttrBnList[7] = WuhunExtraPropertyDel_Property7
	m_AttrBnList[8] = WuhunExtraPropertyDel_Property8
	m_AttrBnList[9] = WuhunExtraPropertyDel_Property9
	m_AttrBnList[10] = WuhunExtraPropertyDel_Property10
end

function WuhunExtraPropertyDel_LoadOption()
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

function WuhunExtraPropertyDel_UpdateItem(Pos)
	if WuhunExtraPropertyDel_Index == -1 then
		local Index1 = EnumAction(Pos, "packageitem")
		local Index1ID = Index1:GetDefineID()
		if Index1ID == -1 then
			return
		end
		
		if Index1ID < 10308001 or Index1ID > 10308004 then
			PushDebugMessage("N�i n�y ch� c� th� �t v�o V� H�n.")
			return
		end
		
		WuhunExtraPropertyDel_Object1:SetActionItem(Index1:GetID())
		LifeAbility:Lock_Packet_Item( Pos, 1 )
		WuhunExtraPropertyDel_Index = Pos
		
		WuhunExtraPropertyDel_LoadOption()
	end
	
	if WuhunExtraPropertyDel_Index ~= -1 and m_sel ~= -1 then
		WuhunExtraPropertyDel_OK:Enable()
		WuhunExtraPropertyDel_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunExtraPropertyDel_OK:Disable()
		WuhunExtraPropertyDel_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

function WuhunExtraPropertyDel_ClearItem()

	if WuhunExtraPropertyDel_Index ~= -1 then
		WuhunExtraPropertyDel_Object1:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item( WuhunExtraPropertyDel_Index, 0 )
		WuhunExtraPropertyDel_Index = -1
	end
	for i = 1, 10 do
		m_AttrBnList[i]:Disable();
		m_AttrBnList[i]:SetText("");
		m_AttrBnList[i]:SetCheck(0);
	end

	if WuhunExtraPropertyDel_Index == -1 or m_sel == -1 then
		WuhunExtraPropertyDel_DemandMoney:SetProperty("MoneyNumber", 0)
		WuhunExtraPropertyDel_OK:Disable()
	end
end

--OnEvent
function WuhunExtraPropertyDel_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 10102017) then
		if IsWindowShow("WuhunExtraPropertyDel") then
			WuhunExtraPropertyDel_UpdateItem(tonumber(arg1))
		end
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunExtraPropertyDel_Confirm = 0;
		WuhunExtraPropertyDel_BeginCareObj( Get_XParam_INT(0) );
		
		for i = 1, 10 do
			m_AttrBnList[i]:Disable();
			m_AttrBnList[i]:SetText("");
			m_AttrBnList[i]:SetCheck(0);
		end
		
		WuhunExtraPropertyDel_Update(-1)
		this:Show();

	elseif (event == "UPDATE_KFSATTR_DEL" and this:IsVisible() ) then
		if arg0 ~= nil then
			WuhunExtraPropertyDel_Update( tonumber(arg0) )
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunExtraPropertyDel_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunExtraPropertyDel_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunExtraPropertyDel_Update(m_Equip_Idx)
		end 
	end
end

--Update UI
function WuhunExtraPropertyDel_Update(itemIdx)

	WuhunExtraPropertyDel_UICheck()
end

--OK
function WuhunExtraPropertyDel_OK_Clicked()
	if WuhunExtraPropertyDel_Confirm == 0 then
		ShowSystemInfo("WH_090817_01");
		WuhunExtraPropertyDel_Confirm = 1;
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(45001)
		Set_XSCRIPT_Parameter(0, 1098) --8 for pos, 01 for function--
		Set_XSCRIPT_Parameter(1, WuhunExtraPropertyDel_Index)
		Set_XSCRIPT_Parameter(2, m_sel)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	
	WuhunExtraPropertyDel_OnHiden()
end

--
function WuhunExtraPropertyDel_Resume_Equip()
	WuhunExtraPropertyDel_Update(-1)

end

--Select 1 Attr
function WuhunExtraPropertyDel_Select_AttrEx(idx)
	m_sel = idx
	if WuhunExtraPropertyDel_Index ~= -1 and m_sel ~= -1 then
		WuhunExtraPropertyDel_OK:Enable()
		WuhunExtraPropertyDel_DemandMoney:SetProperty("MoneyNumber", 50000)
	else
		WuhunExtraPropertyDel_OK:Disable()
		WuhunExtraPropertyDel_DemandMoney:SetProperty("MoneyNumber", 0)
	end
end

--Close UI
function WuhunExtraPropertyDel_Close()
	this:Hide();
end

--Care Obj
function WuhunExtraPropertyDel_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnHiden
function WuhunExtraPropertyDel_OnHiden()
	WuhunExtraPropertyDel_ClearItem()
	this:Hide()
end


function WuhunExtraPropertyDel_UICheck()
	
	WuhunExtraPropertyDel_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunExtraPropertyDel_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 

end