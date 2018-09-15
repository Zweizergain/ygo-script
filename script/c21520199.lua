--急流精怪-瀑布体
function c21520199.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c21520199.sfilter2,nil,nil,aux.Tuner(Card.IsAttribute,ATTRIBUTE_WATER),1,99)
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520199,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21520199.atkcon)
	e1:SetTarget(c21520199.atktg)
	e1:SetOperation(c21520199.atkop)
	c:RegisterEffect(e1)
	--synchro lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c21520199.lvval)
	c:RegisterEffect(e2)
	--synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520199,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520199.sccon)
	e3:SetTarget(c21520199.sctg)
	e3:SetOperation(c21520199.scop)
	c:RegisterEffect(e3)
end
function c21520199.sfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER)
end
function c21520199.sfilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO)
end
function c21520199.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c21520199.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c21520199.atkfilter(c,e,tp)
	return c:IsAttackBelow(500) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21520199.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterial():GetCount()
	local lv=0
	local sum=0
	local rct=0
	local tc=nil
	for i=1,ct+1 do
		Duel.Hint(HINT_SELECTMSG,1-tp,567)
		lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
		tc=Duel.GetDecktopGroup(tp,1):GetFirst()
		Duel.ConfirmDecktop(tp,1)
		Duel.ShuffleDeck(tp)
		if tc:IsType(TYPE_MONSTER) and tc:GetLevel()==lv then 
			sum=sum+lv
			rct=rct+1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(lv*500)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
		else
			Duel.Damage(tp,1000,REASON_RULE)
		end
		c:SetHint(CHINT_NUMBER,sum)
	end
	if rct>Duel.GetLocationCount(tp,LOCATION_MZONE) then rct=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	if sum>0 and rct>0 and Duel.IsExistingMatchingCard(c21520199.atkfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(21520199,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c21520199.atkfilter,tp,LOCATION_GRAVE,0,1,rct,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21520199.lvval(e,c)
	local lv=e:GetHandler():GetLevel()
	if not c:IsAttribute(ATTRIBUTE_WATER) then return lv
	else
		return 4*65536+lv
	end
end
function c21520199.sccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c21520199.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520199.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c21520199.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21520199.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c21520199.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
