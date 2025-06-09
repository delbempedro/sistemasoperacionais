set -euo pipefail

diretory="${1:-.}"
[[ -d "$diretory" ]] || { echo "Invalid directory"; exit 1; }

biggersize=0
biggerfile=""
smallersize=100000000000000000
smallerfile=""
for file in "$diretory"/*; do
    [[ -f "$file" ]] || continue
    size=$(stat -c%s $file)
    if (( size > biggersize )); then
        biggerfile=$file
        biggersize=$size
    fi
    if (( size < smallersize )); then
        smallerfile=$file
        smallersize=$size
    fi
done

echo "Bigger file: $biggerfile ($biggersize bytes)"
echo "Smaller file: $smallerfile ($smallersize bytes)"
