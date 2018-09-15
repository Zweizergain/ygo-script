--白魔术手
function c34340016.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34340016,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,34340016)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c34340016.descon)
	e1:SetTarget(c34340016.destg)
	e1:SetOperation(c34340016.desop)
	c:RegisterEffect(e1)
	--se
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340016,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c34340016.tgtg)
	e2:SetOperation(c34340016.tgop)
	c:RegisterEffect(e2)
end
c34340016.setname="WhiteMagician"
function c34340016.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c34340016.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local tc=g:Select(1-tp,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
	   local tg=Duel.GetMatchingGroup(c34340016.thfilter,tp,LOCATION_DECK,0,nil,tc:GetCode())
	   if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(34340016,2)) then
		  Duel.BreakEffect()
		  local tg2=tg:Select(tp,1,100,nil)
		  Duel.SendtoHand(tg2,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg2)
	   end
	end
end
function c34340016.thfilter(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c34340016.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_PZONE) and c:IsFaceup()
end
function c34340016.dfilter(c,rc,tp)
	if rc:IsLocation(LOCATION_EXTRA) then return Duel.GetLocationCountFromEx(tp,tp,c)>0 
	else
	return Duel.GetMZoneCount(tp,c,tp)>0
	end
end
function c34340016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c34340016.dfilter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0xc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c34340016.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c34340016.dfilter,tp,LOCATION_ONFIELD,0,1,1,nil,c,tp)
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
