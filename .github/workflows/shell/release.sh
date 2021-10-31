#!/usr/bin/env bash

export CURRENT_TAG=$(git tag | tail -1 | head -n1)
PREV_TAG=$(git tag | tail -2 | head -n1)
export CURRENT_TAG_AUTHOR=$(git show "$CURRENT_TAG" --pretty=format:"%an" --no-patch)

export CURRENT_TAG_DATE=$(git show "$CURRENT_TAG" --pretty=format:"%ar" --no-patch)
CHANGELOG=$(git log "$PREV_TAG".. --pretty=format:"%h - %s (%an, %ar)\n" | tr -s" ")

export HOST="https://api.tracker.yandex.net"
export TOKEN="AQAAAAAC1VeLAAd4_gC07TbFXUOOisZhlAqEIhI"
export ORGANIZATION_ID="6461097"
export QUEUE_NAME="TMP"
export UNIQUE_VALUE="portador"

export REQUEST_BODY'{
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

chmod +x ./.github/workflows/sh/tests.sh
./.github/workflows/sh/tests.sh

if [ $? != 0 ]; then
  exit $?
fi

#----------------------------------------
# Артефакт
#----------------------------------------
chmod +x ./.github/workflows/sh/artifact.sh
./.github/workflows/sh/artifact.sh

if [ $? != 0 ]; then
  exit $?
fi