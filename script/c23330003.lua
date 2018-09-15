--残霞魂 迷幻之霞
function c23330003.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetCondition(c23330003.sprcon)
	e2:SetOperation(c23330003.sprop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77428945,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,23330003)
	e4:SetTarget(c23330003.target)
	e4:SetOperation(c23330003.operation)
	c:RegisterEffect(e4)
end
function c23330003.sprfilter(c)
	return c:IsSetCard(0x1555) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c23330003.mzfilter(c)
	return c:GetSequence()<3 and c:IsLocation(LOCATION_MZONE)
end
function c23330003.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c23330003.sprfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-3 and g:GetClassCount(Card.GetCode)>=3 and (ft>0 or g:IsExists(c23330003.mzfilter,ct,nil))
end
function c23330003.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c23330003.sprfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local rg=Group.CreateGroup()
	for i=1,3 do
		local sc=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if ct>0 then
			sc=g:FilterSelect(tp,c23330003.mzfilter,1,1,nil):GetFirst()
		else
			sc=g:Select(tp,1,1,nil):GetFirst()
		end
		rg:AddCard(sc)
		g:Remove(Card.IsCode,nil,sc:GetCode())
		ct=ct-1
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c23330003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end

function c23330003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c23330003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c23330003.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23330003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end

