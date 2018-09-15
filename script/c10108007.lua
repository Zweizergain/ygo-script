--糖果派 派对时间
function c10108007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10108007,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c10108007.sumcon)
	e2:SetTarget(c10108007.sumtg)
	e2:SetOperation(c10108007.sumop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(10108007,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c10108007.thcon)
	e3:SetTarget(c10108007.thtg) 
	e3:SetOperation(c10108007.thop)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10108007,2))
	e4:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c10108007.spcon)
	e4:SetTarget(c10108007.sptg)
	e4:SetOperation(c10108007.spop)
	c:RegisterEffect(e4)
end
function c10108007.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsCode(10108008)
end
function c10108007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10108007.cfilter,1,nil,1-tp)
end
function c10108007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	   local t={}
	   local p=1
	   for i=1,4 do 
		  if Duel.IsPlayerCanSpecialSummonMonster(tp,10108009,0,0x4011,0,0,i,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)
		  then t[p]=i p=p+1 
		  end
	   end
	   t[p]=nil
	return t[1]
	end
	local t={}
	local p=1
	for i=1,4 do 
		if Duel.IsPlayerCanSpecialSummonMonster(tp,10108009,0,0x4011,0,0,i,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)
		then t[p]=i p=p+1 
		end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10108007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,10108009,0,0x4011,0,0,e:GetLabel(),RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,10108009)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CHANGE_LEVEL)
	   e1:SetValue(e:GetLabel())
	   e1:SetReset(RESET_EVENT+0xfe0000)
	   token:RegisterEffect(e1)
	end
end
function c10108007.thfilter(c)
	return c:IsSetCard(0x9338) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c10108007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10108007.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10108007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10108007.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10108007.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c10108007.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c10108007.sumfilter(c)
	return c:IsSetCard(0x9338) and c:IsSummonable(true,nil)
end
function c10108007.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10108007.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10108007.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10108007.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end