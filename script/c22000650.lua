--梦幻召唤
function c22000650.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22000650+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22000650.target)
	e1:SetOperation(c22000650.activate)
	c:RegisterEffect(e1)
end
function c22000650.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c22000650.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c22000650.spfilter(c,e,tp,code)
	return aux.IsMaterialListCode(c,code) and c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c22000650.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22000650.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22000650.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22000650.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22000650.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c22000650.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			local fid=e:GetHandler():GetFieldID()
			sc:RegisterFlagEffect(22000650,RESET_EVENT+0x1fe0000,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(sc)
			e1:SetCondition(c22000650.descon)
			e1:SetOperation(c22000650.desop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c22000650.descon(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	if sc:GetFlagEffectLabel(22000650)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c22000650.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
