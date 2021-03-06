--自由斗士·释魂的卡雷拉斯
function c10131010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true) 
	--xyz summon
	aux.AddXyzProcedure(c,c10131010.xyzfilter,4,2)
	c:EnableReviveLimit()
	--tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10131010,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10131010.tbtg)
	e1:SetOperation(c10131010.tbop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(10131010,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetCondition(c10131010.descon)
	e2:SetTarget(c10131010.destg)
	e2:SetOperation(c10131010.desop)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c10131010.dacon)
	c:RegisterEffect(e3)
end
c10131010.pendulum_level=4
function c10131010.dacon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c10131010.xyzfilter(c)
	return c:IsRace(RACE_WARRIOR) or c:IsHasEffect(10131016)
end
function c10131010.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c10131010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10131010.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:GetPreviousControler()==tp and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10131010,2)) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	   Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c10131010.tbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,0,LOCATION_MZONE)
end
function c10131010.tbop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 then
	   Duel.HintSelection(g1)
	   Duel.Release(g1,REASON_RULE)
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
	   local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	   if g2:GetCount()>0 then
		  Duel.HintSelection(g2)
		  Duel.Release(g2,REASON_RULE)
	   end
	end
end