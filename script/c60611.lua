--「Scarlet Imprecate(绯色的诅咒)」
function c60611.initial_effect(c)
	--这个效果都能写出来！就问还有谁！还有谁！！！ --2018年1月8日18:43:54
	if not c60611.global_check then 
		c60611.global_check=true
		--adjust
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_ADJUST)
		e4:SetOperation(c60611.adjustop)
		Duel.RegisterEffect(e4,0)
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetDescription(aux.Stringid(1231610,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60611.sumtg)
	e1:SetOperation(c60611.sumop)
	c:RegisterEffect(e1)	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c60611.reptg)
	e2:SetValue(c60611.repval)
	e2:SetOperation(c60611.repop)
	c:RegisterEffect(e2)
end
function c60611.homofilter(c)
	return c:IsSetCard(0x813) and c:GetFlagEffect(60611976)==0
end
function c60611.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwnerPlayer()
	local ag=Duel.GetMatchingGroup(c60611.homofilter,tp,LOCATION_HAND,LOCATION_HAND,nil)
	local tc9=ag:GetFirst()
	if ag:GetCount()==0 then return end 
	while tc9 do
		local e1=Effect.CreateEffect(tc9)
		e1:SetDescription(aux.Stringid(60611,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetTargetRange(POS_FACEUP_ATTACK,1)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(c60611.otcon)
		e1:SetOperation(c60611.otop)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		tc9:RegisterEffect(e1)
		tc9:RegisterFlagEffect(60611976,RESET_EVENT+0x1ff0000,0,0)
		tc9=ag:GetNext()
	end 
end
function c60611.sumfilter(c)
	return c:IsSetCard(0x813) and c:IsSummonable(true,nil,1)
end
function c60611.sumfilterX(c)
	return c:IsSetCard(0x813) and (c60611.otcon(100,c) or c:IsSummonable(true,nil,1))
end
function c60611.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60611.sumfilterX,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c60611.mzfilter(c)
	return c:GetSequence()<5
end
function c60611.otcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=-ft+1
	local rt=0
	if c:GetOriginalCode()~=1231300 then rt=rt+1 end 
	if type(e)=="number" then 
		return ft>-2+rt and rg:GetCount()>1-rt and (ft>0-rt or rg:IsExists(c60611.mzfilter,ct,nil)) 
	else
		return ft>-2+rt and rg:GetCount()>1-rt and (ft>0-rt or rg:IsExists(c60611.mzfilter,ct,nil)) 
			and Duel.GetFlagEffect(tp,6061199)>0
	end 
end
function c60611.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local g=nil
	local rt=0
	if c:GetOriginalCode()~=1231300 then rt=rt+1 end 
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2-rt,2-rt,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c60611.mzfilter,1,1,nil)
		if rt==0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g2=rg:Select(tp,1,1,g:GetFirst())
			g:Merge(g2)
		end 
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c60611.mzfilter,2-rt,2-rt,nil)
	end
	Duel.Release(g,REASON_COST)
end
function c60611.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,6061199,EVENT_CHAIN_END,0,1)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c60611.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1) 
	end
	Duel.ResetFlagEffect(tp,6061199)
end
function c60611.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x814) and c:IsLocation(LOCATION_SZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c60611.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c60611.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c60611.repval(e,c)
	return c60611.repfilter(c,e:GetHandlerPlayer())
end
function c60611.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
