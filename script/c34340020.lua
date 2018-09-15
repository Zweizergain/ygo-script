--白色乐章–献祭
function c34340020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c34340020.target)
	e1:SetOperation(c34340020.activate)
	c:RegisterEffect(e1)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340020,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c34340020.thcon)
	e2:SetTarget(c34340020.thtg)
	e2:SetOperation(c34340020.thop)
	c:RegisterEffect(e2)
end
c34340020.setname="WhiteAlbum"
function c34340020.thfilter1(c,tp)
	return c.setname=="WhiteMagician" and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c34340020.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c34340020.thfilter2(c)
	return c.setname=="WhiteAlbum" and c:IsAbleToHand()
end
function c34340020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340020.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c34340020.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c34340020.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c34340020.thfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c34340020.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
end
function c34340020.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c34340020.dfilter,tp,LOCATION_MZONE,0,nil,e)
	local mg=mg1:Clone()
	mg:Merge(mg2)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c34340020.ritfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
	   mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
	   local mat=nil
	   if ft>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		  mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
	   else
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		  mat=mg:FilterSelect(tp,Auxiliary.RPGFilterF,1,1,nil,tp,mg,tc)
		  Duel.SetSelectedCard(mat)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		  local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
		  mat:Merge(mat2)
	   end
	   tc:SetMaterial(mat)
	   local bool=true
	   if mg2:GetCount()>0 then
		  local g=mat:Filter(c34340020.cfilter,nil,mg2)
		  if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(34340020,0)) then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			 local dg=g:Select(tp,1,99,nil)
			 Duel.HintSelection(dg)
			 local ct=Duel.SendtoGrave(dg,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_DESTROY)
			 if ct~=dg:GetCount() then bool=false end
			 mat:Sub(dg)
		  end
	   end
	   if mat:GetCount()>0 then
		  Duel.ReleaseRitualMaterial(mat)
	   end
	   Duel.BreakEffect()
	   if bool then
		  Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		  tc:CompleteProcedure()
	   else
		  local g=Group.CreateGroup()
		  tc:SetMaterial(g)
	   end
	end
end
function c34340020.cfilter(c,mg2)
	return mg2:IsContains(c)
end
function c34340020.dfilter(c,e)
	return c:IsDestructable(e) and c:IsFaceup() and c:IsLevelAbove(1)
end
function c34340020.ritfilter(c,e,tp,m,ft)
	if c.setname~="WhiteMagician" or not c:IsType(TYPE_RITUAL) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c)
	else
		return mg:IsExists(Auxiliary.RPGFilterF,1,nil,tp,mg,c)
	end
end
function c34340020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	   local mg=Duel.GetRitualMaterial(tp)
	   local mg2=Duel.GetMatchingGroup(c34340020.dfilter,tp,LOCATION_MZONE,0,nil,e)
	   mg:Merge(mg2)
	   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	   return ft>-1 and Duel.IsExistingMatchingCard(c34340020.ritfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
