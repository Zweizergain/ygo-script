--泣声龙
function c234032.initial_effect(c)
    --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
    --dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atk
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(234032,0))
	e12:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCountLimit(1)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCost(c234032.atkcost)
	e12:SetTarget(c234032.atktg)
	e12:SetOperation(c234032.atkop)
	c:RegisterEffect(e12)
	--atkup
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(234032,1))
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EVENT_BATTLED)
	e13:SetProperty(EFFECT_FLAG_REPEAT)
	e13:SetCondition(c234032.atkcon2)
	e13:SetOperation(c234032.atkop2)
	c:RegisterEffect(e13)
end
function c234032.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end	
function c234032.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c234032.filter(c)
    return not c:IsType(0x806040)
end
function c234032.atkop(e,tp,eg,ep,ev,re,r,rp)
      local c=e:GetHandler()
	  if Duel.GetFieldGroupCount(1-tp,0x4,0)>4 then
	  Duel.Draw(1-tp,1,0x40)
	  local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,0x4,nil) 
		if sg:GetCount()>0 then
		tt=sg:Select(1-tp,1,1,nil):GetFirst() 
		sg:RemoveCard(tt) 
		Duel.SendtoHand(sg,nil,0x40) 
		local tg=sg:Filter(c234032.filter,nil) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tg:GetSum(Card.GetLevel)*300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
	    c:RegisterEffect(e1) 
		end
	end	
	  repeat
	      local g=Duel.GetDecktopGroup(1-tp,1)
	      local tc=g:GetFirst()
		  e:SetLabelObject(tc)
		  if not tc then return Duel.Draw(1-tp,1,0x40) end
		    Duel.Draw(1-tp,1,0x40)
            Duel.ConfirmCards(tp,tc)
		    if tc:IsType(TYPE_MONSTER) then
		    Duel.SpecialSummon(tc,0,1-tp,1-tp,true,true,0x5) 
	   else
		     Duel.SendtoGrave(tc,0x40)
	    end 
    until Duel.GetFieldGroupCount(1-tp,0x4,0)>4 
	    local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,0x4,nil) 
		if sg:GetCount()>0 then
		tt=sg:Select(1-tp,1,1,nil):GetFirst() 
		sg:RemoveCard(tt) 
		Duel.SendtoHand(sg,nil,0x40) 
		local tg=sg:Filter(c234032.filter,nil) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tg:GetSum(Card.GetLevel)*300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
	    c:RegisterEffect(e1) 
	end	   
end
function c234032.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsRelateToBattle()
end
function c234032.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return atk>0 end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-atk)
	e:GetHandler():RegisterEffect(e1)
end

