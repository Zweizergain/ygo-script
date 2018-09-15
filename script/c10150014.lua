--霸王断碎斩
function c10150014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10150014.condition)
	e1:SetTarget(c10150014.target)
	e1:SetOperation(c10150014.activate)
	c:RegisterEffect(e1)	
end

function c10150014.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRankAbove(7)
end

function c10150014.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return Duel.IsExistingMatchingCard(c10150014.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsChainNegatable(ev) and ( loc==LOCATION_MZONE or loc==LOCATION_SZONE ) and ep~=tp
end

function c10150014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function c10150014.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.NegateActivation(ev)
	local g=Duel.GetMatchingGroup(c10150014.filter,tp,LOCATION_MZONE,0,nil)
	if rc:IsRelateToEffect(re) and rc:IsAbleToChangeControler()
		and not rc:IsType(TYPE_TOKEN) and g:GetCount()>0 and not rc:IsImmuneToEffect(e) then
		rc:CancelToGrave()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
			local og=rc:GetOverlayGroup()
			if og:GetCount()>0 then
			  Duel.SendtoGrave(og,REASON_RULE)
			end
			 Duel.Overlay(tc,Group.FromCards(rc))
	end
end

