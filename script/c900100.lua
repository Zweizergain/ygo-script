--秘封✿宇佐见莲子
require "nef/thcz"
function c900100.initial_effect(c)
	Thcz.TheSynchroSummonOfPaysageONLY(c,Thcz.Tfilter,Thcz.NTfilter,true,nil)	
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(900100,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c900100.retcon)
	e1:SetTarget(c900100.rettg)
	e1:SetOperation(c900100.retop)
	c:RegisterEffect(e1)	
end
function c900100.retcon(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	e:SetLabelObject(t)
	return t and t:IsRelateToBattle()
end
function c900100.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then	return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c900100.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsRelateToBattle() then
		Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
	end
end