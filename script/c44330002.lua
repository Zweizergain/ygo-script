--传说之魂 Frisk
function c44330002.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c44330002.matfilter,1)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c44330002.spcon)
	e0:SetOperation(c44330002.spop)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44330002,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c44330002.eqtg)
	e1:SetOperation(c44330002.eqop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
c44330002.setname="TaleSouls"
function c44330002.efgop(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local code=tc:GetCode()
	if c:IsSummonType(SUMMON_TYPE_LINK) and c:IsFaceup() then
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
	end
end
function c44330002.matfilter(c)
	return c:GetAttack()==500 
end
function c44330002.spcfilter(c)
	return c:IsCode(44330001) and c:IsAbleToHandAsCost()
end
function c44330002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c44330002.spcfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function c44330002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c44330002.spcfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c44330002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,RACE_WARRIOR) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c44330002.eqlimit(e,c)
	return e:GetOwner()==c
end
function c44330002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,RACE_WARRIOR):GetFirst()
	if not tc or not Duel.Equip(tp,tc,c,true) then return end
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c44330002.eqlimit)
	tc:RegisterEffect(e1)
	local cid=c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+0x1fe0000)
end
