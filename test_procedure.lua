> myTablesize = math.random(25,300)
> 
> =#tblAlchemy
42
> 
> for i=1,myTablesize do
>> rand = math.random(1,42)
>> randbool = (math.random(100))%2
>> if randbool == 0 then mybool = true else mybool = false end
>> randNum1 = math.random(80,400)
>> randNum2 = math.random(1,5)
>> randNum3 = randNum1 + math.random(1,50)
>> randNum4 = randNum1 - math.random(1,50)
>> add_Listing(tblAlchemy[rand].name, randNum1, randbool, randNum2, randNum3, randNum4)
>> end

