--MisDescBegin
x600026_g_ScriptId = 600026
x600026_g_MissionId = 1110
x600026_g_Name = "��ng Ph� Dung"
x600026_g_MissionLevel = 10000
x600026_g_MissionKind = 50
x600026_g_IfMissionElite = 0
x600026_g_IsMissionOkFail			=0	--0 ������ɱ��
x600026_g_MissionParam_SubId		=1	--1 ������ű��Ŵ��λ��
x600026_g_Param_sceneid				=2	--2 ��ǰ��������ĳ�����
x600026_g_MissionParam_Phase		=3	--3 �׶κ� �˺��������ֵ�ǰ����UI��������Ϣ
x600026_g_MissionParam_MasterId		=4	--4 �������ŵ�NPCId��
x600026_g_MissionParam_MenpaiIndex	=5	--5 ĳ���ɵ��������ֱ����ڲ����ַ����б���ĳ���ɵ�����[�ͻ���]�Լ�������������ص���Ϣ[��������]
x600026_g_MissionRound = 55
x600026_g_MissionName = "Nhi�m v� khu�ch tr߽ng"
x600026_g_MissionInfo = ""														--��������
x600026_g_MissionTarget = "%f"													--����Ŀ��
x600026_g_ContinueInfo = "    Nhi�m v� c�a c�c h� v�n ch�a ho�n th�nh �?"							--δ��������npc�Ի�
x600026_g_SubmitInfo = "    S� t�nh ti�n tri�n nh� th� n�o r�i?"									--���δ�ύʱ��npc�Ի�
x600026_g_MissionComplete = "    R�t t�t, L�n h�nh �ng giang h� n�y ai ai c�ng bi�t, kh�ng h� danh bang ta ��i ��c ��i ngh�a. "	--�������npc˵���Ļ�
x600026_g_StrForePart = 3
x600026_g_FormatList = {
"",
"    T�m %1n c�u vi�n kh� kh�n cho m�n ph�i n�y.#r#{BHRW_091224_1}",
"    H� t�ng � t� %2s ra kh�i c�m �a.#r#{BHRW_091224_1}",
}
x600026_g_StrList = {
[0] = "Thi�u L�m",
[1] = "Minh Gi�o",
[2] = "C�i Bang",
[3] = "V� �ang",
[4] = "Nga My",
[5] = "Thi�n Long T� ",
[6] = "Tinh T�c",
[7] = "Thi�n S�n",
[8] = "Ti�u Dao",
[9] = "M� Dung",
}
x600026_g_MenpaiInfo = {
[0] = { Name = "Thi�u L�m",		NpcId = 1700008,	CopySceneName = "Th�p L�m",		Type = FUBEN_TALIN1,		    Map = "tongrenxiang_2.nav",		Exit = "tongrenxiang_2_area.ini",	Monster = "tongrenxiang_2_monster_%d.ini", 	EntrancePos = { x = 28, z = 52 },	BackPos = { x = 38, z = 97 }, },
[1] = { Name = "Minh Gi�o",		NpcId = 1700009,	CopySceneName = "Quang Minh �ng",	Type = FUBEN_GUANGMINGDONG1,	Map = "guangmingdong_2.nav",	Exit = "guangmingdong_2_area.ini",	Monster = "guangmingdong_2_monster_%d.ini", EntrancePos = { x = 19, z = 42 },	BackPos = { x = 98, z = 57 }, },
[2] = { Name = "C�i Bang",		NpcId = 1700010,	CopySceneName = "H�m r��u",		Type = FUBEN_JIUJIAO1,			Map = "jiujiao_2.nav",			Exit = "jiujiao_2_area.ini",		Monster = "jiujiao_2_monster_%d.ini", 		EntrancePos = { x = 45, z = 47 },	BackPos = { x = 91, z = 99 }, },
[3] = { Name = "V� �ang",		NpcId = 1700011,	CopySceneName = "Linh T�nh Phong",	Type = FUBEN_LINGXINGFENG1,		Map = "lingxingfeng_2.nav",		Exit = "lingxingfeng_2_area.ini",	Monster = "lingxingfeng_2_monster_%d.ini", 	EntrancePos = { x = 42, z = 46 },	BackPos = { x = 77, z = 86 }, },
[4] = { Name = "Nga My",		NpcId = 1700012,	CopySceneName = "��o Hoa Tr�n",	Type = FUBEN_TAOHUAZHEN1,		Map = "taohuazhen_2.nav",		Exit = "taohuazhen_2_area.ini",		Monster = "taohuazhen_2_monster_%d.ini", 	EntrancePos = { x = 26, z = 46 },	BackPos = { x = 96, z = 73 }, },
[5] = { Name = "Thi�n Long T� ",	NpcId = 1700013,	CopySceneName = "Ch�n th�p",		Type = FUBEN_TADI1,				Map = "tadi_2.nav",				Exit = "tadi_2_area.ini",			Monster = "tadi_2_monster_%d.ini", 			EntrancePos = { x = 45, z = 48 },	BackPos = { x = 96, z = 67 }, },
[6] = { Name = "Tinh T�c",		NpcId = 1700014,	CopySceneName = "Ng� Th�n еng",	Type = FUBEN_WUSHENDONG1,		Map = "wushendong_2.nav",		Exit = "wushendong_2_area.ini",		Monster = "wushendong_2_monster_%d.ini", 	EntrancePos = { x = 14, z = 40 },	BackPos = { x = 142, z = 56 }, },
[7] = { Name = "Thi�n S�n",		NpcId = 1700015,	CopySceneName = "Chi�t Mai Phong",	Type = FUBEN_ZHEMEIFENG1,		Map = "zhemeifeng_2.nav",		Exit = "zhemeifeng_2_area.ini",		Monster = "zhemeifeng_2_monster_%d.ini", 	EntrancePos = { x = 29, z = 49 },	BackPos = { x = 90, z = 45 }, },
[8] = { Name = "Ti�u Dao",		NpcId = 1700016,	CopySceneName = "C�c �a",		Type = FUBEN_GUDI1,				Map = "gudi_2.nav",				Exit = "gudi_2_area.ini",			Monster = "gudi_2_monster_%d.ini", 			EntrancePos = { x = 42, z = 47 },	BackPos = { x = 124, z = 145 }, },
[9] = { Name = "M� Dung",		NpcId = 1700153,	CopySceneName = "Th�y C�c",		Type = FUBEN_SHUIGE1,				Map = "gusufb_2.nav",				Exit = "gusufb_2_area.ini",			Monster = "gusufb_2_monster_%d.ini", 			EntrancePos = { x = 23, z = 45 },	BackPos = { x = 69, z = 111 }, },--newmenpai
}
x600026_g_CityMissionScript = 600001
x600026_g_ExpandScript = 600023
--MisDescEnd
