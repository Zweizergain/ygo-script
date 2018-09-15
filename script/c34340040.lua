--白魔术贤者
function c34340040.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c34340040.ffilter,3,true) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(34340040,0))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c34340040.cttg)
	e4:SetOperation(c34340040.ctop)
	c:RegisterEffect(e4)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c34340040.reptg)
	e3:SetOperation(c34340040.repop)
	c:RegisterEffect(e3)
end
c34340040.setname="WhiteMagician"
function c34340040.repfilter(c,e)
	return c:IsFaceup() and c.setname=="WhiteMagician"
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c34340040.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c34340040.repfilter,tp,LOCATION_MZONE,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c34340040.repfilter,tp,LOCATION_MZONE,0,1,1,c,e)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c34340040.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c34340040.ctfilter(c)
	return c:IsControlerCanBeChanged()
end
function c34340040.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c34340040.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c34340040.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c34340040.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c34340040.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp) then
	   if tc.setname~="WhiteMagician" then
		  local code=tc:GetOriginalCodeRule()
		  local ccode=_G["c"..code]
		  ccode.setname="WhiteMagician"
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		  e1:SetCode(EVENT_LEAVE_FIELD_P)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetOperation(c34340040.leaveop)
		  tc:RegisterEffect(e1)
	   end
	end
end
function c34340040.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c.setname=nil
end
function c34340040.ffilter(c)
	return c.setname=="WhiteMagician"
end