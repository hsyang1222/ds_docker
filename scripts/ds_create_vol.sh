# Team mapping
HOSTNAME=`hostname`
case $HOSTNAME in
    "ds1") TEAMS=(1 2 3) ;;
    "ds2") TEAMS=(4 5 6) ;;
    "ds3") TEAMS=(7 8 9) ;;
    "ds4") TEAMS=(10 11 12) ;;
    "ds5") TEAMS=(3 6 9 12) ;;
esac

for (( i=0; i<${#TEAMS[@]}; i++ ));
do
    if [ ${#TEAMS[@]} -gt 3 ]
    then
        d=$i
    else
        d=$(($i + 1))
    fi
    p="/data/disk${d}/ds_docker_volumes/team${TEAMS[$i]}-home"
    sudo mkdir -p $p
    docker volume create --driver local --opt type=none --opt device=$p --opt o=bind team${TEAMS[$i]}-home
    echo $p
done
