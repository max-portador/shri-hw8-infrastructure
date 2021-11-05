#!/usr/bin/env bash

export CURRENT_TAG=$(git tag | tail -1 | head -n1)
PREV_TAG=$(git tag | tail -2 | head -n1)
export CURRENT_TAG_AUTHOR=$(git show "$CURRENT_TAG" --pretty="format:%an" --no-patch -1)

export CURRENT_TAG_DATE=$(git show "$CURRENT_TAG" --pretty="format:%ar" --no-patch -1)
CHANGELOG=$(git log "$PREV_TAG" --pretty=format:"%h - %s (%an, %ar)\n" | tr -s "\n" " ")

export HOST="https://api.tracker.yandex.net"
export TOKEN="$1"
export ORGANIZATION_ID="$2"
echo "got secrets"
export QUEUE_NAME="TMP"
export UNIQUE_VALUE="portador"

export REQUEST_BODY='{
  "queue": "'$QUEUE_NAME'",
  "summary": "'"$CURRENT_TAG"'| Author: '"$CURRENT_TAG_AUTHOR"' | released '"$CURRENT_TAG_DATE"'",
  "description": "'"$CHANGELOG"'",
  "unique": "'"$UNIQUE_VALUE"'_'"$CURRENT_TAG"'"
}'

#----------------------------------------
# создаем тикет в Яндекс-трекере
#----------------------------------------

chmod +x ./.github/workflows/shell/add_task_in_tracker.sh
./.github/workflows/shell/add_task_in_tracker.sh


if [ $? != 0 ]; then
  exit $?
fi

#----------------------------------------
# Тесты
#----------------------------------------

chmod +x ./.github/workflows/shell/test.sh
./.github/workflows/shell/test.sh

if [ $? != 0 ]; then
  exit $?
fi

#----------------------------------------
# Артефакт
#----------------------------------------
chmod +x ./.github/workflows/shell/artifact.sh
./.github/workflows/shell/artifact.sh

if [ $? != 0 ]; then
  exit $?
fi