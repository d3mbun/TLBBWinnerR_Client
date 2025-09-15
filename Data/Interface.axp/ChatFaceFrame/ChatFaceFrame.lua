local g_AllAnimate = {};
local NewEmotion = {};
function ChatFaceFrame_PreLoad()
	this:RegisterEvent("CHAT_FACEMOTION_SELECT");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end

function ChatFaceFrame_OnLoad()
	g_AllAnimate = {
		Face_1,	Face_2,	Face_3,	Face_4,	Face_5,	Face_6,	Face_7,	Face_8, Face_9,	Face_10,
		Face_11,Face_12,Face_13,Face_14,Face_15,Face_16,Face_17,Face_18,Face_19,Face_20,
		Face_21,Face_22,Face_23,Face_24,Face_25,Face_26,Face_27,Face_28,Face_29,Face_30,
		Face_31,Face_32,Face_33,Face_34,Face_35,Face_36,Face_37,Face_38,Face_39,Face_40,
		Face_41,Face_42,Face_43,Face_44,Face_45,Face_46,Face_47,Face_48,Face_49,Face_50,
		Face_51,Face_52,Face_53,Face_54,Face_55,Face_56,Face_57,Face_58,Face_59,Face_60,
		Face_61,Face_62,Face_63,Face_64,Face_65,Face_66,Face_67,Face_68,Face_69,Face_70,
		Face_71,Face_72,Face_73,Face_74,Face_75,Face_76,Face_77,Face_78,Face_79,Face_80,
		Face_81,Face_82,Face_83,Face_84,Face_85,Face_86,Face_87,Face_88,Face_89,Face_90,
		Face_91,Face_92,Face_93,Face_94,Face_95,Face_96,Face_97,Face_98,Face_99,Face_100
	};
	
	for i = 1, table.getn(g_AllAnimate) do
		g_AllAnimate[i]:SetToolTip("##"..tostring(i));
	end
end

function Chat_FaceFrame_Page_Switch(nIndex)
	NewEmotion1 = {
		Face_101,Face_102,Face_103,Face_104,Face_105,Face_106,
		Face_107,Face_108,Face_109,Face_110,Face_111,Face_112,
		Face_113,Face_114,Face_115,Face_116,Face_117,Face_118,
		Face_119,Face_120,Face_121,Face_122,Face_123,Face_124,
		Face_125,Face_126,Face_127,Face_128,Face_129,Face_130,
		Face_131,Face_132,Face_133,Face_134,Face_135,Face_136
	};
	NewEmotion2 = {
		Face_201,Face_202,Face_203,Face_204,Face_205,Face_206,
		Face_207,Face_208,Face_209,Face_210,Face_211,Face_212,
		Face_213,Face_214,Face_215,Face_216,Face_217,Face_218,
		Face_219,Face_220,Face_221,Face_222,Face_223,Face_224,
		Face_225,Face_226,Face_227,Face_228,Face_229,Face_230,
		Face_231,Face_232,Face_233,Face_234,Face_235,Face_236
	};
	NewEmotion3 = {
		Face_301,Face_302,Face_303,Face_304,Face_305,Face_306,
		Face_307,Face_308,Face_309,Face_310,Face_311,Face_312,
		Face_313,Face_314,Face_315,Face_316,Face_317,Face_318,
		Face_319,Face_320,Face_321,Face_322,Face_323,Face_324,
		Face_325,Face_326,Face_327,Face_328,Face_329,Face_330,
		Face_331,Face_332,Face_333,Face_334,Face_335,Face_336
	};
	NewEmotion4 = {
		Face_401,Face_402,Face_403,Face_404,Face_405,Face_406,
		Face_407,Face_408,Face_409,Face_410,Face_411,Face_412,
		Face_413,Face_414,Face_415,Face_416,Face_417,Face_418,
		Face_419,Face_420,Face_421,Face_422,Face_423,Face_424,
		Face_425,Face_426,Face_427,Face_428,Face_429,Face_430,
		Face_431,Face_432,Face_433,Face_434,Face_435,Face_436
	};
	
	NewEmotion6 = {
		Face_601,Face_602,Face_603,Face_604,Face_605,Face_606,
		Face_607,Face_608,Face_609,Face_610,Face_611,Face_612,
		Face_613,Face_614,Face_615,Face_616,Face_617,Face_618,
		Face_619,Face_620,Face_621,Face_622,Face_623,Face_624,
		Face_625,Face_626,Face_627,Face_628,Face_629,Face_630,
		Face_631,Face_632,Face_633,Face_634,Face_635,Face_636
	};
	
	NewEmotion7 = {
		Face_701,Face_702,Face_703,Face_704,Face_705,Face_706,
		Face_707,Face_708,Face_709,Face_710,Face_711,Face_712,
		Face_713,Face_714,Face_715,Face_716,Face_717,Face_718,
		Face_719,Face_720,Face_721,Face_722,Face_723,Face_724,
		Face_725,Face_726,Face_727,Face_728,Face_729,Face_730,
		Face_731,Face_732,Face_733,Face_734,Face_735,Face_736
	};
	
	if nIndex == 1 then
		for i = 1, 36 do
			NewEmotion1[i]:Hide();
			NewEmotion2[i]:Hide();
			NewEmotion3[i]:Hide();
			NewEmotion4[i]:Hide();
			NewEmotion6[i]:Hide();
			NewEmotion7[i]:Hide();
		end
		
		for i = 1, table.getn(g_AllAnimate) do
			g_AllAnimate[i]:Show();
			g_AllAnimate[i]:SetToolTip("##"..tostring(i));
		end
	end
	
	if nIndex == 2 then
		for i = 1, table.getn(g_AllAnimate) do
			g_AllAnimate[i]:Hide();
		end	
		
		for i = 1, 36 do
			--NewEmotion1[i]:Hide();
			NewEmotion2[i]:Hide();
			NewEmotion3[i]:Hide();
			NewEmotion4[i]:Hide();
			NewEmotion6[i]:Hide();
			NewEmotion7[i]:Hide();
		end
		
		for i = 1, 36 do
			NewEmotion1[i]:Show();
			NewEmotion1[i]:SetToolTip("##"..tostring(100+i));
		end
	end

	if nIndex == 3 then
		for i = 1, table.getn(g_AllAnimate) do
			g_AllAnimate[i]:Hide();
		end	
		
		for i = 1, 36 do
			NewEmotion1[i]:Hide();
			--NewEmotion2[i]:Hide();
			NewEmotion3[i]:Hide();
			NewEmotion4[i]:Hide();
			NewEmotion6[i]:Hide();
			NewEmotion7[i]:Hide();
		end
		
		for i = 1, 36 do
			NewEmotion2[i]:Show();
			NewEmotion2[i]:SetToolTip("##"..tostring(200+i));
		end
	end	
	
	if nIndex == 4 then
		for i = 1, table.getn(g_AllAnimate) do
			g_AllAnimate[i]:Hide();
		end	
		
		for i = 1, 36 do
			NewEmotion1[i]:Hide();
			NewEmotion2[i]:Hide();
			--NewEmotion3[i]:Hide();
			NewEmotion4[i]:Hide();
			NewEmotion6[i]:Hide();
			NewEmotion7[i]:Hide();
		end
		
		for i = 1, 33 do
			NewEmotion3[i]:Show();
			NewEmotion3[i]:SetToolTip("##"..tostring(300+i));
		end
	end
	
	if nIndex == 5 then
		for i = 1, table.getn(g_AllAnimate) do
			g_AllAnimate[i]:Hide();
		end	
		
		for i = 1, 36 do
			NewEmotion1[i]:Hide();
			NewEmotion2[i]:Hide();
			NewEmotion3[i]:Hide();
			--NewEmotion4[i]:Hide();
			NewEmotion6[i]:Hide();
			NewEmotion7[i]:Hide();
		end
		
		for i = 1, 36 do
			NewEmotion4[i]:Show();
			NewEmotion4[i]:SetToolTip("##"..tostring(400+i));
		end
	end
	
	if nIndex == 6 then
		for i = 1, table.getn(g_AllAnimate) do
			g_AllAnimate[i]:Hide();
		end	
		
		for i = 1, 36 do
			NewEmotion1[i]:Hide();
			NewEmotion2[i]:Hide();
			NewEmotion3[i]:Hide();
			NewEmotion4[i]:Hide();
			NewEmotion7[i]:Hide();
		end
		
		for i = 1, 24 do
			NewEmotion6[i]:Show();
			NewEmotion6[i]:SetToolTip("##"..tostring(600+i));
		end
	end
	
	if nIndex == 7 then
		for i = 1, table.getn(g_AllAnimate) do
			g_AllAnimate[i]:Hide();
		end	
		
		for i = 1, 36 do
			NewEmotion1[i]:Hide();
			NewEmotion2[i]:Hide();
			NewEmotion3[i]:Hide();
			NewEmotion4[i]:Hide();
			NewEmotion6[i]:Hide();
		end
		
		for i = 1, 9 do
			NewEmotion7[i]:Show();
			NewEmotion7[i]:SetToolTip("##"..tostring(700+i));
		end
	end
end

function ChatFaceFrame_OnEvent( event )
	if( event == "CHAT_FACEMOTION_SELECT" and arg0 == "select") then
		if(this:IsVisible() or this:ClickHide())then
			this:Hide();
		else
			this:Show();
			Chat_FaceFrame_ChangePosition(arg1,arg2);		
		end
	elseif (event == "CHAT_ADJUST_MOVE_CTL" and this:IsVisible()) then
		Chat_FaceFrame_AdjustMoveCtl();
	end
end

function Chat_FaceFrame_SelectMotion(nIndex)
	--AxTrace(0, 0, "click Chat_FaceFrame_SelectMotion");
	if(1 > nIndex) then
		return;
	end
	
	local strResult = "#"..tostring(nIndex).." ";
	Talk:SelectFaceMotion("sucess", strResult);
end

function Chat_FaceFrame_AdjustMoveCtl()
	this:Hide();
end

function Chat_FaceFrame_ChangePosition(pos1,pos2)


	if(tonumber(pos1)~=0) then
		Face_Frame:SetProperty("UnifiedXPosition", "{0.0,"..pos1.."}");
	end;
	if(tonumber(pos2)~=0) then
		Face_Frame:SetProperty("UnifiedYPosition", "{0.0,"..pos2.."}");
	end;
end