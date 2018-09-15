--四季雨
function c10118021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118021,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10118021.target)
	e1:SetOperation(c10118021.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118021,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10118021)
	e2:SetCondition(c10118021.thcon)
	e2:SetTarget(c10118021.thtg)
	e2:SetOperation(c10118021.thop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c10118021.confilter(c,e)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetFlagEffect(10118021)~=0 and c==e:GetLabelObject()
end
function c10118021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10118021.confilter,1,nil,e)
end
function c10118021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10118021.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c10118021.filter1(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c10118021.exfilter0(c)
	return c:IsSetCard(0x5331) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c10118021.exfilter1(c,e)
	return c10118021.exfilter0(c) and not c:IsImmuneToEffect(e)
end
function c10118021.filter2(c,e,tp,mg1,f,chkf,exg,ischeck)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_SPELLCASTER) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and ((c:CheckFusionMaterial(mg1,nil,chkf) and ischeck==2) or (exg:IsExists(c10118021.checkfilter,1,c,mg1,c,chkf) and ischeck~=0 and Duel.GetFlagEffect(tp,10118021)<=0))
end
function c10118021.checkfilter(c,mg1,fc,chkf)
	local mg2=mg1:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	mg2:AddCard(c)
	return fc:CheckFusionMaterial(mg2,c,chkf)
end
function c10118021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		local exg=Duel.GetMatchingGroup(c10118021.exfilter0,tp,LOCATION_EXTRA,0,nil)
		local res=Duel.IsExistingMatchingCard(c10118021.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,exg,2)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10118021.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,exg,0)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10118021.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10118021.filter1,nil,e)
	local exg=Duel.GetMatchingGroup(c10118021.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c10118021.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,exg,2)
	local sgex=Duel.GetMatchingGroup(c10118021.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,exg,1)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10118021.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,exg,0)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local fmc=nil
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if sgex:GetCount()>0 and sgex:IsContains(tc) and Duel.SelectYesNo(tp,aux.Stringid(10118021,2)) then
			   Duel.RegisterFlagEffect(tp,10118021,RESET_PHASE+PHASE_END,0,1)
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			   fmc=exg:FilterSelect(tp,c10118021.checkfilter,1,1,nil,mg1,tc,chkf):GetFirst()
			   mg1=mg1:Filter(Card.IsLocation,nil,LOCATION_MZONE)
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,fmc,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:RegisterFlagEffect(10118021,RESET_EVENT+0x17a0000,0,1)
		e:GetLabelObject():SetLabelObject(tc)
		tc:CompleteProcedure()
	end
end