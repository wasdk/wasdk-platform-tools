#/bin/bash
TARGET=$1
if [ "$TARGET" = "" ]; then
  echo "TARGET is not specified" >&2
  exit 1
fi
rm -rf ../tmp/wasm-stat-${TARGET}.url
NOT_FOUND=1
INDEX=0
while [ $NOT_FOUND -ne 0 ]; do
  let INDEX=INDEX+1
  if [ $INDEX -gt 100 ]; then
    echo "too many tries" >&2
    exit 2
  fi
  echo "Trying build -$INDEX"
  curl https://wasm-stat.us/json/builders/${TARGET}/builds/-${INDEX}?as_text=1 > ../tmp/current_${TARGET}_build.json
  grep 'wasm-binaries' ../tmp/current_${TARGET}_build.json
  let NOT_FOUND=$?
done
ARCHIVE_URL=`grep 'wasm-binaries' ../tmp/current_${TARGET}_build.json | awk '{split($0,a,"\"");print(a[4])}'`
echo $ARCHIVE_URL > ../tmp/wasm-stat-${TARGET}.url
