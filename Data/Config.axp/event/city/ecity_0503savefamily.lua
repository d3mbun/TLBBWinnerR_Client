--MisDescBegin
x600026_g_ScriptId = 600026
x600026_g_MissionId = 1110
x600026_g_Name = "Ðông Phù Dung"
x600026_g_MissionLevel = 10000
x600026_g_MissionKind = 50
x600026_g_IfMissionElite = 0
x600026_g_IsMissionOkFail			=0	--0 ÈÎÎñÍê³É±ê¼Ç
x600026_g_MissionParam_SubId		=1	--1 ×ÓÈÎÎñ½Å±¾ºÅ´æ·ÅÎ»ÖÃ
x600026_g_Param_sceneid				=2	--2 µ±Ç°¸±±¾ÈÎÎñµÄ³¡¾°ºÅ
x600026_g_MissionParam_Phase		=3	--3 ½×¶ÎºÅ ´ËºÅÓÃÓÚÇø·Öµ±Ç°ÈÎÎñUIµÄÃèÊöÐÅÏ¢
x600026_g_MissionParam_MasterId		=4	--4 ÃÅÅÉÕÆÃÅµÄNPCIdºÅ
x600026_g_MissionParam_MenpaiIndex	=5	--5 Ä³ÃÅÅÉµÄË÷Òý£¬·Ö±ðÓÃÓÚ²éÕÒ×Ö·û´®ÁÐ±íÖÐÄ³ÃÅÅÉµÄÃû³Æ[¿Í»§¶Ë]ÒÔ¼°ÈÎÎñÓëÃÅÅÉÏà¹ØµÄÐÅÏ¢[·þÎñÆ÷¶Ë]
x600026_g_MissionRound = 55
x600026_g_MissionName = "Nhi®m vø khuªch trß½ng"
x600026_g_MissionInfo = ""														--ÈÎÎñÃèÊö
x600026_g_MissionTarget = "%f"													--ÈÎÎñÄ¿±ê
x600026_g_ContinueInfo = "    Nhi®m vø cüa các hÕ vçn chßa hoàn thành à?"							--Î´Íê³ÉÈÎÎñµÄnpc¶Ô»°
x600026_g_SubmitInfo = "    Sñ tình tiªn tri¬n nhß thª nào r°i?"									--Íê³ÉÎ´Ìá½»Ê±µÄnpc¶Ô»°
x600026_g_MissionComplete = "    R¤t t¯t, L¥n hành ðµng giang h° này ai ai cûng biªt, không h± danh bang ta ðÕi ðÑc ðÕi nghîa. "	--Íê³ÉÈÎÎñnpcËµ»°µÄ»°
x600026_g_StrForePart = 3
x600026_g_FormatList = {
"",
"    Tìm %1n cÑu vi®n khó khån cho môn phái này.#r#{BHRW_091224_1}",
"    Hµ t¯ng ð® tØ %2s ra khöi c¤m ð¸a.#r#{BHRW_091224_1}",
}
x600026_g_StrList = {
[0] = "Thiªu Lâm",
[1] = "Minh Giáo",
[2] = "Cái Bang",
[3] = "Võ Ðang",
[4] = "Nga My",
[5] = "Thiên Long Tñ ",
[6] = "Tinh Túc",
[7] = "Thiên S½n",
[8] = "Tiêu Dao",
[9] = "Mµ Dung",
}
x600026_g_MenpaiInfo = {
[0] = { Name = "Thiªu Lâm",		NpcId = 1700008,	CopySceneName = "Tháp Lâm",		Type = FUBEN_TALIN1,		    Map = "tongrenxiang_2.nav",		Exit = "tongrenxiang_2_area.ini",	Monster = "tongrenxiang_2_monster_%d.ini", 	EntrancePos = { x = 28, z = 52 },	BackPos = { x = 38, z = 97 }, },
[1] = { Name = "Minh Giáo",		NpcId = 1700009,	CopySceneName = "Quang Minh ðµng",	Type = FUBEN_GUANGMINGDONG1,	Map = "guangmingdong_2.nav",	Exit = "guangmingdong_2_area.ini",	Monster = "guangmingdong_2_monster_%d.ini", EntrancePos = { x = 19, z = 42 },	BackPos = { x = 98, z = 57 }, },
[2] = { Name = "Cái Bang",		NpcId = 1700010,	CopySceneName = "H¥m rßþu",		Type = FUBEN_JIUJIAO1,			Map = "jiujiao_2.nav",			Exit = "jiujiao_2_area.ini",		Monster = "jiujiao_2_monster_%d.ini", 		EntrancePos = { x = 45, z = 47 },	BackPos = { x = 91, z = 99 }, },
[3] = { Name = "Võ Ðang",		NpcId = 1700011,	CopySceneName = "Linh Tính Phong",	Type = FUBEN_LINGXINGFENG1,		Map = "lingxingfeng_2.nav",		Exit = "lingxingfeng_2_area.ini",	Monster = "lingxingfeng_2_monster_%d.ini", 	EntrancePos = { x = 42, z = 46 },	BackPos = { x = 77, z = 86 }, },
[4] = { Name = "Nga My",		NpcId = 1700012,	CopySceneName = "Ðào Hoa Tr§n",	Type = FUBEN_TAOHUAZHEN1,		Map = "taohuazhen_2.nav",		Exit = "taohuazhen_2_area.ini",		Monster = "taohuazhen_2_monster_%d.ini", 	EntrancePos = { x = 26, z = 46 },	BackPos = { x = 96, z = 73 }, },
[5] = { Name = "Thiên Long Tñ ",	NpcId = 1700013,	CopySceneName = "Chân tháp",		Type = FUBEN_TADI1,				Map = "tadi_2.nav",				Exit = "tadi_2_area.ini",			Monster = "tadi_2_monster_%d.ini", 			EntrancePos = { x = 45, z = 48 },	BackPos = { x = 96, z = 67 }, },
[6] = { Name = "Tinh Túc",		NpcId = 1700014,	CopySceneName = "Ngû Th¥n Ðµng",	Type = FUBEN_WUSHENDONG1,		Map = "wushendong_2.nav",		Exit = "wushendong_2_area.ini",		Monster = "wushendong_2_monster_%d.ini", 	EntrancePos = { x = 14, z = 40 },	BackPos = { x = 142, z = 56 }, },
[7] = { Name = "Thiên S½n",		NpcId = 1700015,	CopySceneName = "Chiªt Mai Phong",	Type = FUBEN_ZHEMEIFENG1,		Map = "zhemeifeng_2.nav",		Exit = "zhemeifeng_2_area.ini",		Monster = "zhemeifeng_2_monster_%d.ini", 	EntrancePos = { x = 29, z = 49 },	BackPos = { x = 90, z = 45 }, },
[8] = { Name = "Tiêu Dao",		NpcId = 1700016,	CopySceneName = "C¯c ð¸a",		Type = FUBEN_GUDI1,				Map = "gudi_2.nav",				Exit = "gudi_2_area.ini",			Monster = "gudi_2_monster_%d.ini", 			EntrancePos = { x = 42, z = 47 },	BackPos = { x = 124, z = 145 }, },
[9] = { Name = "Mµ Dung",		NpcId = 1700153,	CopySceneName = "Thüy Các",		Type = FUBEN_SHUIGE1,				Map = "gusufb_2.nav",				Exit = "gusufb_2_area.ini",			Monster = "gusufb_2_monster_%d.ini", 			EntrancePos = { x = 23, z = 45 },	BackPos = { x = 69, z = 111 }, },--newmenpai
}
x600026_g_CityMissionScript = 600001
x600026_g_ExpandScript = 600023
--MisDescEnd
