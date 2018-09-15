--拟兽 天龙
function c10124002.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pset
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10124002,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c10124002.pscon)
	e1:SetTarget(c10124002.pstg)
	e1:SetOperation(c10124002.psop)
	c:RegisterEffect(e1)
	--toextra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10124002,1))
	--e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c10124002.tdtg)
	e2:SetOperation(c10124002.tdop)
	e2:SetCountLimit(1,10124002)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)  
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10124002,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,10124002)
	e4:SetCondition(c10124002.descon)
	e4:SetTarget(c10124002.destg)
	e4:SetOperation(c10124002.desop)
	c:RegisterEffect(e4)  
end

function c10124002.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA) 
end

function c10124002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end

function c10124002.desop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if dg and dg:GetCount()>0 then
		  Duel.HintSelection(dg)
		  Duel.Destroy(dg,REASON_EFFECT)
		end
end

function c10124002.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10124002.tdfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
end

function c10124002.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c10124002.tdfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
	 Duel.SendtoExtraP(tc,nil,REASON_EFFECT) 
	end
end

function c10124002.tdfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6334) and c:IsAbleToExtra()
end

function c10124002.pscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function c10124002.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq) 
	if chk==0 then return pc and pc:IsDestructable()
		and Duel.IsExistingMatchingCard(c10124002.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,pc,1,0,0)  
end

function c10124002.psop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq) 
	if pc and Duel.Destroy(pc,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10124002.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	  if g:GetCount()>0 then
		 Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	  end
	end
end

function c10124002.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6334) and not c:IsCode(10124002)
end