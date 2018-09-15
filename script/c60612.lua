--「Scarlet Trap」
function c60612.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,60612+EFFECT_COUNT_CODE_OATH)
	e1:SetDescription(aux.Stringid(60612,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60612.target)
	e1:SetOperation(c60612.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60612,1))
	e2:SetCountLimit(1,60612+EFFECT_COUNT_CODE_OATH)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c60612.distarget)
	e2:SetOperation(c60612.disop)
	c:RegisterEffect(e2)
end
function c60612.filter(c)
	return c:IsSetCard(0x813) 
end
function c60612.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(c60612.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)	
end
function c60612.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c60612.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g and g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then	
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end 
end
function c60612.sfilter(c)
	return c:IsSetCard(0x814) and c:IsSSetable()
end
function c60612.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60612.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c60612.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and (Duel.GetLocationCount(tp,LOCATION_SZONE))>0 end
	e:SetLabel(e:GetHandler():GetSequence())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)	
end
function c60612.disop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.SelectMatchingCard(tp,c60612.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if pg and pg:GetCount()>0 and Duel.Destroy(pg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c60612.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
			if g:GetFirst():IsType(TYPE_TRAP) then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				g:GetFirst():RegisterEffect(e3)
			end
		end
	end 
end