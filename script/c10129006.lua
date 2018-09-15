--梦魇融合
function c10129006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10129006+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10129006.target)
	e1:SetOperation(c10129006.activate)
	c:RegisterEffect(e1)	
end
c10129006.card_code_list={10129007}
function c10129006.filter1(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c10129006.exfilter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c10129006.exfilter1(c,e)
	return c10129006.exfilter0(c) and not c:IsImmuneToEffect(e)
end
function c10129006.exfilter2(c)
	return not c:IsRace(RACE_ZOMBIE) or c:IsFacedown()
end
function c10129006.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c.outhell_fusion and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+101,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c10129006.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=3
end
function c10129006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		if not Duel.IsExistingMatchingCard(c10129006.exfilter2,tp,LOCATION_MZONE,0,1,nil) then
			local sg=Duel.GetMatchingGroup(c10129006.exfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
			if sg:GetCount()>0 then
				mg1:Merge(sg)
				Auxiliary.FCheckAdditional=c10129006.fcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c10129006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10129006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10129006.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf,c=tp,e:GetHandler()
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10129006.filter1,nil,e)
	local gymat=false
	if not Duel.IsExistingMatchingCard(c10129006.exfilter2,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(c10129006.exfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
		if sg:GetCount()>0 then
			mg1:Merge(sg)
			gymat=true
		end
	end
	if gymat then Auxiliary.FCheckAdditional=c10129006.fcheck end
	local sg1=Duel.GetMatchingGroup(c10129006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10129006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if gymat then Auxiliary.FCheckAdditional=c10129006.fcheck end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			local rmat=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			if rmat then 
			   Duel.Remove(rmat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			   c10129006.matfilter(c,rmat)
			   mat1:Sub(rmat)
			end
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			c10129006.matfilter(c,mat1)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+101,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			c10129006.matfilter(c,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c10129006.matfilter(c,matg)
	local g=matg:Clone()
	local tc=g:GetFirst()
	while tc do
		 c:RegisterFlagEffect(10129007,RESET_EVENT+0x1fe0000,0,0)
	tc=g:GetNext()
	end
end
