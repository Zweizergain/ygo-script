--糖果派 宗师级吃货
function c10108012.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c10108012.fuscon)
	e0:SetOperation(c10108012.fusop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10108012.spcon)
	e1:SetOperation(c10108012.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c10108012.splimit)
	c:RegisterEffect(e2)
	--effectgain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10108012,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetTarget(c10108012.eftg)
	e3:SetOperation(c10108012.efop)
	c:RegisterEffect(e3)
	--cannot be fusion material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c10108012.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c10108012.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_TOKEN) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_TOKEN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_TOKEN)
end
function c10108012.efop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsLocation(LOCATION_MZONE) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10108012,5))
	local op,n1,n2,op2=Duel.SelectOption(tp,aux.Stringid(10108012,1),aux.Stringid(10108012,2),aux.Stringid(10108012,3),aux.Stringid(10108012,4)),0,0,10
	local e0=Effect.CreateEffect(tc)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_EFFECT)
	e0:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e0)
	c10108012.effect_gain_operation(tc,op,n1,n2,n3)
	if e:GetHandler():IsHasEffect(10108006) and Duel.SelectYesNo(tp,aux.Stringid(10108006,3)) then
	  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10108012,5))
	  op=Duel.SelectOption(tp,aux.Stringid(10108012,n1),aux.Stringid(10108012,n2),aux.Stringid(10108012,n3))
	  if op==0 then op2=n1
	  elseif op==1 then op2=n2
	  else op2=n3
	  end
	c10108012.effect_gain_operation(tc,op2,n1,n2,n3)
   end
end
function c10108012.effect_gain_operation(tc,ct,n1,n2,n3)
	if ct==0 then
	   local e1=Effect.CreateEffect(tc)
	   e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	   e1:SetDescription(aux.Stringid(10108012,1))
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_UPDATE_ATTACK)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetValue(2500)
	   tc:RegisterEffect(e1)
	   local e5=e1:Clone()
	   e5:SetCode(EFFECT_UPDATE_DEFENSE)  
	   tc:RegisterEffect(e5)	 
	   n1,n2,n3=1,2,3
	elseif ct==1 then
	   local e2=Effect.CreateEffect(tc)
	   e2:SetDescription(aux.Stringid(10108012,2))
	   e2:SetCategory(CATEGORY_DESTROY)
	   e2:SetType(EFFECT_TYPE_IGNITION)
	   e2:SetRange(LOCATION_MZONE)
	   e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	   e2:SetCountLimit(1)
	   e2:SetTarget(c10108012.destg)
	   e2:SetOperation(c10108012.desop)
	   tc:RegisterEffect(e2)
	   n1,n2,n3=0,2,3
	elseif ct==2 then
	   local e3=Effect.CreateEffect(tc)
	   e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	   e3:SetDescription(aux.Stringid(10108001,4))
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetCode(EFFECT_SYNCHRO_MATERIAL)
	   e3:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e3)
	   n1,n2,n3=0,1,3
	else
	   local e4=Effect.CreateEffect(tc)
	   e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	   e4:SetDescription(aux.Stringid(10108002,4))
	   e4:SetType(EFFECT_TYPE_SINGLE)
	   e4:SetCode(10108002)
	   e4:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e4)
	   n1,n2,n3=0,2,3
   end
end
function c10108012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,LOCATION_ONFIELD)
end
function c10108012.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(Group.FromCards(tc,e:GetHandler()),REASON_EFFECT)
	end
end
function c10108012.sprfilter1(c,tp,fc)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and not c:IsFusionType(TYPE_TUNER) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable() and (c:IsControler(tp) or c:IsHasEffect(10108002)) and Duel.IsExistingMatchingCard(c10108012.sprfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,c,tp,fc)
end
function c10108012.sprfilter2(c,tp,fc)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and not c:IsFusionType(TYPE_TUNER) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable() and (c:IsControler(tp) or c:IsHasEffect(10108002))
end
function c10108012.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE 
	if ft<=0 then loc=0 end
	return Duel.IsExistingMatchingCard(c10108012.sprfilter1,tp,LOCATION_MZONE,loc,1,nil,tp,c)
end
function c10108012.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft,loc=Duel.GetLocationCount(tp,LOCATION_MZONE),LOCATION_MZONE 
	if ft<=0 then loc=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c10108012.sprfilter1,tp,LOCATION_MZONE,loc,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c10108012.sprfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,g1:GetFirst(),tp,c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c10108012.ffilter1(c,gc)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and not c:IsHasEffect(6205579) and c~=gc
end
function c10108012.ffilter2(c,mg,gc)
	return c10108012.ffilter1(c,ni) and mg:IsExists(c10108012.ffilter1,1,c,gc)
end
function c10108012.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsHasEffect(10108002) and not g:IsContains(c)
end
function c10108012.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local tp=e:GetHandlerPlayer()
	local exg=Group.CreateGroup()
	local sg=Duel.GetMatchingGroup(c10108012.exfilter,tp,0,LOCATION_MZONE,nil,mg)
	if sg:GetCount()>0 then
	   exg:Merge(sg)
	end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return c10108012.ffilter2(gc) and (mg:IsExists(c10108012.ffilter1,2,gc,nil) or exg:IsExists(c10108012.ffilter2,1,gc,mg,gc) or exg:IsExists(c10108012.ffilter1,2,gc,nil))	
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		if c10108012.ffilter1(tc,nil) then
			g1:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g2:AddCard(tc) end
		end
		tc=mg:GetNext()
	end
	local exg1=exg:Filter(c10108012.ffilter1,nil,nil)
	if chkf~=PLAYER_NONE then
		return (g2:GetCount()>=3
			or g2:IsExists(aux.FConditionFilterF2,2,nil,exg1)
			or exg1:IsExists(aux.FConditionFilterF2,2,nil,g2))
	else
		return (g1:GetCount()>=3
			or g1:IsExists(aux.FConditionFilterF2,2,nil,exg1)
			or exg1:IsExists(aux.FConditionFilterF2,2,nil,g1))
	end
end
function c10108012.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local fg=Duel.GetMatchingGroup(c10108012.exfilter,tp,0,LOCATION_MZONE,nil,g)
	if fg:GetCount()>0 then
	   g:Merge(fg)
	end
	if gc then
		local sg1=Group.CreateGroup()
		if c10108012.ffilter1(gc) then
			sg1:Merge(g:Filter(c10108012.ffilter1,gc,nil))
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg1:Select(tp,2,2,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(c10108012.ffilter1,nil,nil)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	local sg1=Group.CreateGroup()
	sg1:Merge(sg:Filter(c10108012.ffilter1,tc1,nil))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg1:Select(tp,2,2,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end