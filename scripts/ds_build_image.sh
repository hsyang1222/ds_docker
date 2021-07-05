if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    exit 2
fi

# Team mapping
HOSTNAME=`hostname`
case $HOSTNAME in
    "ds1") TEAMS=(1 2 3) ;;
    "ds2") TEAMS=(4 5 6) ;;
    "ds3") TEAMS=(7 8 9) ;;
    "ds4") TEAMS=(10 11 12) ;;
    "ds5") TEAMS=(3 6 9 12) ;;
esac

PASSWORDS=()
TAG=$2
for i in ${TEAMS[@]}
do
    pw=`openssl rand -base64 15`
    docker build -f $1 -t ${TAG}_team$i --build-arg user=team$i --build-arg pw=$pw .
    PASSWORDS+=($pw)
done

for (( i=0; i<${#TEAMS[@]}; i++ ));
do
    echo "Image: ${TAG}_team${TEAMS[$i]}"
    echo "User: team${TEAMS[$i]}, PW: ${PASSWORDS[$i]}"
done
