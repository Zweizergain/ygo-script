--白色乐章–血偿
function c34340034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c34340034.cost)
	e1:SetTarget(c34340034.target)
	e1:SetOperation(c34340034.operation)
	c:RegisterEffect(e1)	
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340020,1))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c34340034.thcon)
	e2:SetTarget(c34340034.thtg)
	e2:SetOperation(c34340034.thop)
	c:RegisterEffect(e2)
end
c34340034.setname="WhiteAlbum"
function c34340034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>2 end
end
function c34340034.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(1-tp,3)
	Duel.SortDecktop(tp,1-tp,3)
end
function c34340034.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
end
function c34340034.cfilter(c,e,tp)
	return c.setname=="WhiteMagician" and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsPublic() and Duel.IsExistingMatchingCard(c34340034.rfilter,tp,LOCATION_GRAVE,0,c:GetLevel(),nil) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c34340034.rfilter(c)
	return c:IsType(TYPE_MONSTER)  and c:IsAbleToRemove()
end
function c34340034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c34340034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=1 then return false end
	   e:SetLabel(0)
	   return Duel.IsExistingMatchingCard(c34340034.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c34340034.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.SetTargetCard(tc)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,tc:GetLevel(),tp,LOCATION_GRAVE)
end
function c34340034.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,true,true) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c34340034.rfilter,tp,LOCATION_GRAVE,0,tc:GetLevel(),tc:GetLevel(),nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then 
	   Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
