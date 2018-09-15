--白魔术尸鬼–影
function c34340041.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,34340002,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,false,false)
	--des
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34340041,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c34340041.descon)
	e1:SetTarget(c34340041.destg)
	e1:SetOperation(c34340041.desop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340041,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c34340041.setcon)
	e2:SetTarget(c34340041.settg)
	e2:SetOperation(c34340041.setop)
	c:RegisterEffect(e2)
end
c34340041.setname="WhiteMagician"
function c34340041.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) and Duel.GetTurnPlayer()~=tp
end
function c34340041.setfilter(c)
	return c.setname=="WhiteAlbum" and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c34340041.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340041.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c34340041.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c34340041.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SSet(tp,g)
	end
end
function c34340041.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c34340041.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c34340041.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,2,nil)
	if dg:GetCount()>0 then
	   Duel.Destroy(dg,REASON_EFFECT)
	end
end
