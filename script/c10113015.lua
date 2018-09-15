--封印龙魂的书簿
function c10113015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113015+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c10113015.target)
	e1:SetOperation(c10113015.activate)
	c:RegisterEffect(e1)  
	--tohand or SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113015,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c10113015.spcon)
	e2:SetTarget(c10113015.sptg)
	e2:SetOperation(c10113015.spop)
	c:RegisterEffect(e2)  
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e1:SetLabelObject(e2)
end
function c10113015.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=e:GetLabelObject()
	local act=e:GetLabel()
	e:SetLabel(0)
	if act==1 and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY)
		and c:GetFlagEffect(10113015)~=0 then return true
	else rg:Clear() return false end
end
function c10113015.spfilter(c,e,tp,ct)
	return c:GetFlagEffect(10113015)~=0 and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct~=3) or (c:IsAbleToHand() and (ct==1 or ct==3)))
end
function c10113015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rg=e:GetLabelObject()
	if chk==0 then
		if rg:IsExists(c10113015.spfilter,1,nil,e,tp,1) then return true
		else rg:Clear() return false end
	end
end
function c10113015.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject()
	local rg1=rg:Filter(c10113015.spfilter,nil,e,tp,2)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>0 then ft=1 end
	if rg1:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(10113015,1)) then 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg=rg1:Select(tp,1,ft,nil)
	   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   rg:Sub(sg)
	end
	local tg=rg:Filter(c10113015.spfilter,nil,e,tp,3)
	if tg:GetCount()>0 then
	   Duel.SendtoHand(tg,tp,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	end
	rg:Clear()
end
function c10113015.filter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemove()
end
function c10113015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10113015.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c10113015.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10113015.filter,tp,LOCATION_DECK,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		e:GetLabelObject():SetLabel(1)
		e:GetLabelObject():GetLabelObject():Merge(g)
		local tc=g:GetFirst()
		while tc do
		  tc:RegisterFlagEffect(10113015,RESET_EVENT+0x1fe0000,0,1)
		tc=g:GetNext()
		end
		e:GetHandler():RegisterFlagEffect(10113015,RESET_EVENT+0x1680000,0,1)
	end
end
