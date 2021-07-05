if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 2
fi

CPU='8'
MEM='100GB'
MEMANDSWAP='130GB'

# Team mapping
HOSTNAME=`hostname`
case $HOSTNAME in
    "ds1") TEAMS=(1 2);    GPUS=("0,1,2" "3,4,5") ;;
    "ds2") TEAMS=(3 4);    GPUS=("0,1,2" "3,4,5") ;;
    "ds3") TEAMS=(5 6);    GPUS=("0,1,2" "3,4,5") ;;
    "ds4") TEAMS=(7 8);    GPUS=("0,1,2" "3,4,5") ;;
    "ds5") TEAMS=(9 10);   GPUS=("0,1,2" "3,4,5") ;;
    "ds6") TEAMS=(11 12);  GPUS=("0,1,2" "3,4,5") ;;
esac

TAG=$1
SSH_PORT_BASE=8900
JUP_PORT_BASE=9000
EXT_PORT_BASE=10000
for (( i=0; i<${#TEAMS[@]}; i++ ));
do
    team=${TEAMS[$i]}
    gpu=${GPUS[$i]}
    ssh_port=$((SSH_PORT_BASE + $i))
    jupyterhub_port=$((JUP_PORT_BASE + $i))
    team_tag=${TAG}_team$team
    echo "Team: $team, Image: $team_tag, GPU: $gpu, SSH Port: $ssh_port, JupyterHub Port: $jupyterhub_port"
    echo '"device=$gpu"'
    gpu_arg=\""device=$gpu"\"
    docker run --cpus $CPU --gpus $gpu_arg --memory $MEM --memory-swap $MEMANDSWAP \
               -p $ssh_port:22 -p $jupyterhub_port:8000 $EXT_PORT_BASE-$EXT_PORT_BASE+5:$EXT_PORT_BASE-$EXT_PORT_BASE+5 \ 
    	       -v team${team}-home:/home -d $team_tag --shm-size 2G 
done

