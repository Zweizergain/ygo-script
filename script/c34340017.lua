--白魔术足
function c34340017.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34340017,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c34340017.spcon)
	e1:SetTarget(c34340017.sptg)
	e1:SetOperation(c34340017.spop)
	c:RegisterEffect(e1) 
	--dr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340017,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c34340017.drtg)
	e2:SetOperation(c34340017.drop)
	c:RegisterEffect(e2)   
end
c34340017.setname="WhiteMagician"
function c34340017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0xc,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c34340017.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil) 
	if not Duel.IsPlayerCanDraw(tp,1) then return end
	local dt=1
	if Duel.IsPlayerCanDraw(tp,2) then dt=2 end
	local ct=math.min(dt,g:GetCount())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,ct,nil)
	Duel.HintSelection(dg)
	local ct2=Duel.Destroy(dg,REASON_EFFECT)
	if ct2>0 then
	   Duel.Draw(tp,ct2,REASON_EFFECT)
	end
end
function c34340017.spcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc.setname=="WhiteAlbum" and rp==tp
end
function c34340017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c34340017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
