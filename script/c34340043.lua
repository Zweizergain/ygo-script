--白色乐章–融合
function c34340043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,34340043+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c34340043.target)
	e1:SetOperation(c34340043.activate)
	c:RegisterEffect(e1)
end
c34340043.setname="WhiteAlbum"
function c34340043.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsDestructable()
end
function c34340043.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsDestructable(e)
end
function c34340043.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c.setname=="WhiteMagician" and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c34340043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsDestructable,nil,e)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=3 then
			local mg2=Duel.GetMatchingGroup(c34340043.filter0,tp,LOCATION_DECK,0,nil)
			mg1:Merge(mg2)
		end
		local res=Duel.IsExistingMatchingCard(c34340043.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c34340043.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c34340043.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c34340043.filter1,nil,e)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=3 then
		local mg2=Duel.GetMatchingGroup(c34340043.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
	end
	local sg1=Duel.GetMatchingGroup(c34340043.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c34340043.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			if Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)~=mat1:GetCount() then return end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
