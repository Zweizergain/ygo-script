--季雨 XX绿紫
function c10118017.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,false) 
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false) 
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118017,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10118017)
	e1:SetCost(c10118017.rcost)
	e1:SetTarget(c10118017.rtg)
	e1:SetOperation(c10118017.rop)
	c:RegisterEffect(e1)
	--P set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118017,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,10118117)
	e2:SetCondition(c10118017.pscon)
	e2:SetTarget(c10118017.pstg)
	e2:SetOperation(c10118017.psop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(10118017,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c10118017.spcost)
	e3:SetTarget(c10118017.sptg)
	e3:SetOperation(c10118017.spop)
	c:RegisterEffect(e3)
end
function c10118017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,2,nil,RACE_SPELLCASTER) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,2,2,nil,RACE_SPELLCASTER)
	Duel.Release(g,REASON_COST)
end
function c10118017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10118017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
end
function c10118017.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10118017.rfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK) and Duel.IsExistingMatchingCard(c10118017.tfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,c)
end
function c10118017.tfilter(c,rc)
	if c:IsFacedown() or not c:IsAbleToDeck() then return false end
	local table={}
	table[0]=TYPE_RITUAL 
	table[1]=TYPE_FUSION 
	table[2]=TYPE_SYNCHRO 
	table[3]=TYPE_XYZ 
	table[4]=TYPE_PENDULUM 
	table[5]=TYPE_LINK 
	for ct,cardtype in ipairs(table) do
		if rc:IsType(cardtype) and c:IsType(cardtype) then 
		return true 
		end
	end
	return false
end
function c10118017.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupEx(tp,c10118017.rfilter,1,nil,tp)
	end
	local tc=Duel.SelectReleaseGroupEx(tp,c10118017.rfilter,1,1,nil,tp):GetFirst()
	e:SetLabelObject(tc)
	Duel.Release(tc,REASON_COST)
	local g=Duel.IsExistingMatchingCard(c10118017.tfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),1-tp,LOCATION_MZONE+LOCATION_GRAVE)
end
function c10118017.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.IsExistingMatchingCard(c10118017.tfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e:GetLabelObject())
	if g:GetCount()>0 then
	   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c10118017.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_SPELLCASTER) and re:GetHandler():IsControler(tp)
end
function c10118017.tdtg(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10118017.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c10118017.pscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA) 
end
function c10118017.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c10118017.psop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end