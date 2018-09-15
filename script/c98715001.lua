--灵摆降临
function c98715001.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98715001+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98715001.target)
	e1:SetOperation(c98715001.activate)
	c:RegisterEffect(e1)
end
function c98715001.filter(c)
	return c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c98715001.pfilter1(c,g)
	return c:GetCode()~=88935103 and g:IsExists(c98715001.pfilter2,1,nil,c,g)
end
function c98715001.pfilter2(c,cc,g)
	local sc1=c:GetLeftScale()
	local sc2=cc:GetLeftScale()
	local delta=0
	if sc1>sc2 then
		delta=sc1-sc2
	else
		delta=sc2-sc1
	end
	g:RemoveCard(cc)
	return delta>=2 and g:IsExists(c98715001.pfilter3,1,c,c,g)
end
function c98715001.pfilter3(c,cc,g)
	return c:GetCode()~=88935103 and g:IsExists(c98715001.pfilter4,1,cc,c:GetCode())
end
function c98715001.pfilter4(c,code)
	return c:GetCode()~=code
end
function c98715001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=Duel.GetMatchingGroup(c98715001.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local p3=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	local p4=Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)
	if chk==0 then return Duel.IsExistingMatchingCard(c98715001.pfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,pg)
		and (p1 or p2 or p3 or p4) end
	local g=Group.CreateGroup()
	if p1 then
		g:AddCard(p1)
	end
	if p2 then
		g:AddCard(p2)
	end
	if p3 then
		g:AddCard(p3)
	end
	if p4 then
		g:AddCard(p4)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98715001.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c98715001.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c98715001.spfilter(c,e,tp)
	return c:IsSetCard(0x98) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98715001.zfilter(c,e,tp)
	return c:IsCode(13331639) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c98715001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(c98715001.tdfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,nil)
	if dg:GetCount()>0 then
		Duel.SendtoDeck(dg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	end
	local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local p3=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	local p4=Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)
	local g=Group.CreateGroup()
	if p1 then
		g:AddCard(p1)
	end
	if p2 then
		g:AddCard(p2)
	end
	if p3 then
		g:AddCard(p3)
	end
	if p4 then
		g:AddCard(p4)
	end
	local gct=g:GetCount()
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct~=gct then
		local g0=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if g0:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98715001,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g0:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
	local pg=Duel.GetMatchingGroup(c98715001.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if ct==gct and Duel.IsExistingMatchingCard(c98715001.pfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,pg) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98715001,1))
		local pc1=pg:Select(tp,1,1,nil):GetFirst()
		pg:RemoveCard(pc1)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98715001,1))
		local pc2=pg:FilterSelect(tp,c98715001.pfilter2,1,1,nil,pc1,pg):GetFirst()
		pg:RemoveCard(pc2)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98715001,2))
		local pc3=pg:FilterSelect(tp,c98715001.pfilter3,1,1,nil,pc2,pg):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98715001,2))
		local pc4=pg:FilterSelect(tp,c98715001.pfilter4,1,1,nil,pc3:GetCode()):GetFirst()
		if pc1 and pc2 then
			Duel.MoveToField(pc1,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveToField(pc2,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		if pc3 and pc4 then
			Duel.MoveToField(pc3,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveToField(pc4,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	local g1=Duel.GetMatchingGroup(c98715001.tgfilter,tp,LOCATION_DECK,0,nil)
	if ct>=1 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98715001,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
	local g2=Duel.GetMatchingGroup(c98715001.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>=2 and ft>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98715001,4)) then
		Duel.BreakEffect()
		if ft>2 then ft=2 end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,ft,nil)
		if sg2:GetCount()~=0 then
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
		local syng=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		local sc=syng:GetCount()
		local xc=xyzg:GetCount()
		local op=0
		if sc>0 or xc>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(98715001,5)) then
				if sc>0 and xc>0 then
					op=Duel.SelectOption(tp,1063,1073)+1
				elseif sc>0 then
					op=1
				else
					op=2
				end
			end
		end
		if op==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local syn=syng:Select(tp,1,1,nil):GetFirst()
			Duel.SynchroSummon(tp,syn,nil)
		end
		if op==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,nil)
		end
	end
	local set=false
	if ct>=3 and c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(98715001,6)) then
		set=true
	end
	local g3=Duel.GetMatchingGroup(c98715001.zfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if ct==4 and g3:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(98715001,7)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local zg=g3:Select(tp,1,1,nil)
		if zg:GetCount()>0 then
			Duel.SpecialSummon(zg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
	if set==true then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
