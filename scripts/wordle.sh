#!/bin/bash
##
## Calculate WORDLE Stats for a player
## 

SEPARATOR="•"

grep "/6" wordle.txt | sed "s|.*\([X0-9]\)/6.*|\1|g" > wordle.results.txt

RESULTS=(1 2 3 4 5 6 X)
R=()
P=()
TOTAL=$(wc -l < wordle.results.txt)
TOTAL=$(( TOTAL + 0 ))

rm -f wordle.results.hist.txt

for x in ${RESULTS[@]}
do
    count=$(grep -c ${x} wordle.results.txt)
    percent=$(( count * 100 / TOTAL ))
    R+=( "${count}" )
    P+=( "${percent}" )
    echo "${x} ${count} ${percent}" >> wordle.results.hist.txt
done

OUT=wordle.results.hist.ascii.txt
rm -f ${OUT}

function number {
    digit=$1
    case $digit in
        1)
            printf "1️⃣ "
            ;;
        2)
            printf "2️⃣ "
            ;;
        3)
            printf "3️⃣ "
            ;;
        4)
            printf "4️⃣ "
            ;;
        5)
            printf "5️⃣ "
            ;;
        6)
            printf "6️⃣ "
            ;;
        X)
            printf "*️⃣ "
            ;;
    esac
}

echo "" | tee -a ${OUT}
echo "WORDLE Stats" | tee -a ${OUT}

echo "-------------------------------" | tee -a ${OUT}
while read d p n
do
    number $d | tee -a ${OUT}
    m=$(( n / 4 ))
    if [[ "${p}" != "0" ]]
    then
        if [[ "${m}" == "0" ]]
        then
            m=1
        fi
        printf ".%${m}s" | tr ' ' '🟩' | tr '.' ' ' | tee -a ${OUT}
    fi
    printf " ${n}%% ${SEPARATOR} ${p}\n" | tee -a ${OUT}
done < wordle.results.hist.txt

echo "-------------------------------" | tee -a ${OUT}
echo "☑️  $TOTAL total games played" | tee -a ${OUT}
echo "-------------------------------" | tee -a ${OUT}
date | tee -a ${OUT}
