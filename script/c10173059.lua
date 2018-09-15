--连接融合者
function c10173059.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173059,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10173059)
	e1:SetTarget(c10173059.target)
	e1:SetOperation(c10173059.operation)
	c:RegisterEffect(e1)
	--Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetDescription(aux.Stringid(10173059,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10173059.fustg)
	e2:SetOperation(c10173059.fusop)
	c:RegisterEffect(e2)
end
function c10173059.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c10173059.filter2(c,e,tp,m,f,chkf,zone,linkc)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and (linkc or zone~=0) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP,tp) and c:CheckFusionMaterial(m,linkc,chkf)
end
function c10173059.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local zone=c:GetLinkedZone(tp)
		local chkf=tp
		local linkc=nil
		local mg1=Duel.GetFusionMaterial(tp)
		mg1:RemoveCard(c)
		local lg=c:GetLinkedGroup():Filter(Card.IsControler,nil,tp)
		if lg:GetCount()>0 then 
		   linkc=lg:GetFirst() 
		end
		local res=((not linkc or mg1:IsContains(linkc)) and Duel.IsExistingMatchingCard(c10173059.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,zone,linkc))
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):RemoveCard(c)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10173059.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,zone,linkc)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10173059.fusop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local linkc=nil
	local lg=c:GetLinkedGroup():Filter(Card.IsControler,nil,tp)
	if lg:GetCount()>0 then 
	   linkc=lg:GetFirst() 
	end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10173059.filter1,e:GetHandler(),e)
	local sg1=Duel.GetMatchingGroup(c10173059.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,zone,linkc)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10173059.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,zone,linkc)
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
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP,zone)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c10173059.filter(c,e,tp,zone)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or ((zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone))))
end
function c10173059.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c10173059.filter(chkc,e,tp,e:GetHandler():GetLinkedZone()) end
	if chk==0 then return Duel.IsExistingTarget(c10173059.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,e:GetHandler():GetLinkedZone()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10173059.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,e:GetHandler():GetLinkedZone())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10173059.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if zone>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(10173059,2))) then
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	else
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tc)
	end
end