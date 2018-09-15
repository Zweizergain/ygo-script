--虚太古龙·耀星神
function c10163002.initial_effect(c)
	c:SetSPSummonOnce(10163002)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10163002.spcon)
	e2:SetOperation(c10163002.spop)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10163002,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,10163002)
	e3:SetCost(c10163002.poscost)
	e3:SetTarget(c10163002.postg)
	e3:SetOperation(c10163002.posop)
	c:RegisterEffect(e3)  
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10163002.antarget)
	c:RegisterEffect(e8)
end
function c10163002.antarget(e,c)
	return c~=e:GetHandler()
end
function c10163002.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10163002.thfilter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsLevelAbove(8)
end
function c10163002.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10163002.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c10163002.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
	  Duel.BreakEffect()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g=Duel.SelectMatchingCard(tp,c10163002.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	  if g:GetCount()>0 then
		  if g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
			  Duel.NegateEffect(0)
			  return
		  end
		  Duel.SendtoHand(g,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,g)
	  end
	end
end
function c10163002.cfilter(c)
	return c:IsLevelAbove(8) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c10163002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetReleaseGroup(tp,true):Filter(c10163002.cfilter,c)
	return g:GetCount()>=2 and ft>-2 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft
end
function c10163002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local g=Duel.GetReleaseGroup(tp,true):Filter(c10163002.cfilter,c)
	local sg=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<2 then
			g:Sub(sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local sg1=g:Select(tp,2-ct,2-ct,nil)
			sg:Merge(sg1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:Select(tp,2,2,nil)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end