--多维释放
function c19001022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c19001022.cost)
	e1:SetTarget(c19001022.target)
	e1:SetOperation(c19001022.activate)
	c:RegisterEffect(e1)  
	--revive 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19001022,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19001022+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19001022.sptg)
	e2:SetOperation(c19001022.spop)
	c:RegisterEffect(e2)
end
function c19001022.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19001022.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c19001022.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c19001022.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c19001022.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c19001022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local tg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,tc:GetRace())
	   if tg:GetCount()>0 then
		  Duel.BreakEffect()
			Duel.Overlay(tc,tg)
	   end
	end
end
function c19001022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c19001022.cfilter(c,tp)
	local ct=c:GetOverlayCount()
	return Duel.IsPlayerCanDraw(tp,ct+1)
end
function c19001022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.CheckReleaseGroup(tp,c19001022.cfilter,1,nil,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c19001022.cfilter,1,1,nil,tp)
	e:SetValue(g:GetFirst():GetOverlayCount())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetValue()+1)
end
function c19001022.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetValue()+1,REASON_EFFECT)
end

