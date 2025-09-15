
-- 1-ÕıÔÚÍË³öÓÎÏ·...
-- 2-ºÍ·şÎñÆ÷µÄÁ¬½Ó±»¶Ï¿ª£¬ÊÇ·ñ³¢ÊÔÖØĞÂÁ´½Ó? 
-- 3-ÕıÔÚÖØĞÂÁ¬½Ó·şÎñÆ÷...
-- 4-Á¬½Ó³É¹¦£¬ÕıÔÚÖØĞÂ½øÈë³¡¾°...
-- 5-Á¬½ÓÊ§°Ü
local QuitRelative_Status = 0;


--===============================================
-- OnLoad()
--===============================================
function QuitRelative_PreLoad()
	this:RegisterEvent("QUIT_RELATIVE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function QuitRelative_OnLoad()

end


--===============================================
-- OnEvent()
--===============================================
function QuitRelative_OnEvent(event)
	if(event == "QUIT_RELATIVE") then
		if(arg0 == "QuitGaming...") then
			
			this:Show();
			QuitRelative_OK_Button:Hide();
			QuitRelative_Cancel_Button:Hide();
			QuitRelative_Text:SetText("Ğang thoát khöi trò ch½i...");
			QuitRelativeSelectUpdateRect();
			QuitRelative_Status=1;
		elseif(arg0 == "AskReconnect") then
			this:Show();
			QuitRelative_OK_Button:Show();
			QuitRelative_OK_Button:Enable();
			QuitRelative_Cancel_Button:Show();
			QuitRelative_Cancel_Button:Enable();
			QuitRelative_Text:SetText("M¤t kªt n¯i v¾i server, có kªt n¯i lÕi bình thß¶ng không?");
			QuitRelativeSelectUpdateRect();
			QuitRelative_Status=2;
		elseif(arg0 == "EnterScene") then
			if(this:IsVisible()) then
				QuitRelative_Text:SetText("Kªt n¯i thành công, b¡t ğ¥u vào trò ch½i...");
				QuitRelative_Status=4;
			end
		elseif(arg0 == "ConnFailed") then
			this:Show();
			QuitRelative_OK_Button:Disable();
			QuitRelative_Cancel_Button:Enable();
			QuitRelative_Text:SetText("Kªt n¯i th¤t bÕi, nguyên do sai sót: #r" .. arg1);
			QuitRelative_Status=5;
		end
		
	elseif(event == "PLAYER_ENTERING_WORLD") then
		this:Hide();
	end
end

function QuitRelative_OK_Clicked()
	if(QuitRelative_Status == 2) then
		--½øÈë¶ÏÏßÖØÁ¬
		QuitRelative_OK_Button:Hide();
		QuitRelative_Cancel_Button:Enable();
		QuitRelative_Text:SetText("Ğang kªt n¯i máy chü...");
		QuitRelativeSelectUpdateRect();
		QuitRelative_Status=3;
		EnterReconnect(true);
	end
end

function QuitRelative_Cancel_Clicked()
	--ÕıÔÚÑ¯ÎÊÊÇ·ñÖØÁ¬»òÕßÕıÔÚÖØÁ¬
	if(QuitRelative_Status == 2 or QuitRelative_Status == 3) then
		--·ÅÆúÖØÁ¬£¬Ö±½ÓÍË³ö
		EnterReconnect(false);
	elseif(QuitRelative_Status == 5) then
		QuitApplication("quit");
	end
end


function QuitRelativeSelectUpdateRect()
	local nWidth, nHeight = QuitRelative_Text:GetWindowSize();
	local nTitleHeight = 0;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	QuitRelative_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end