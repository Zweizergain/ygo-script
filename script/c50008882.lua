--Stars 北斗·T
local m=50008882
local cm=_G["c"..m]
function cm.initial_effect(c)
    --token
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008882,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,50008882)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c50008882.tg)
    e1:SetOperation(c50008882.op)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --salvage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50008882,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,500088821)
    e3:SetCost(c50008882.thcost)
    e3:SetTarget(c50008882.thtg)
    e3:SetOperation(c50008882.thop)
    c:RegisterEffect(e3)
end

function c50008882.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
        Duel.IsPlayerCanSpecialSummonMonster(tp,500088888,0,0x4011,2000,1000,2,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,tp)  end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c50008882.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tps,500088888,0,0x4011,2000,1000,2,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,tp)  then
            local token=Duel.CreateToken(tp,500088888)
            Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
            Duel.SpecialSummonComplete()
    end
end
--
function c50008882.cfilter(c)
    return c:IsType(TYPE_TOKEN)
end
function c50008882.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c50008882.cfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c50008882.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c50008882.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50008882.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
