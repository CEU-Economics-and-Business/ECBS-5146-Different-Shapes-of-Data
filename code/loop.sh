for item in {1..5}
do
    sleep 1
done

for item in {1..10} 
do
    for other_item in {1..10} 
    do
        if [ $item -gt $other_item ]
        then
            break
        else
            sleep 1
        fi
    done
done