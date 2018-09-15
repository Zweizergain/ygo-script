--季雨 XX绿白
function c10118018.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)  
	--CalculateDamage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118018,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10118018)
	e1:SetTarget(c10118018.cdtg)
	e1:SetOperation(c10118018.cdop)
	c:RegisterEffect(e1)
	--P set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118018,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,10118118)
	e2:SetCondition(c10118018.pscon)
	e2:SetTarget(c10118018.pstg)
	e2:SetOperation(c10118018.psop)
	c:RegisterEffect(e2) 
	--P to E
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118018,2))
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c10118018.tdcost)
	e3:SetTarget(c10118018.tdtg)
	e3:SetOperation(c10118018.tdop)
	c:RegisterEffect(e3)
end
function c10118018.cfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c10118018.tdcost(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_SPELLCASTER) and re:GetHandler():IsControler(tp)
end
function c10118018.tdtg(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10118018.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c10118018.pscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA) 
end
function c10118018.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c10118018.psop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c10118018.cdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK) and Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
end
function c10118018.cdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_ATTACK)
	local g2=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	if g1:GetCount()>0 and g2:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	   local tc1=g1:Select(tp,1,1,nil):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	   local tc2=g2:Select(tp,1,1,nil):GetFirst()
	   Duel.HintSelection(Group.FromCards(tc1,tc2))
	   Duel.CalculateDamage(tc1,tc2)
	end
end