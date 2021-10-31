#!/usr/bin/env bash

#------------------------------------------------------------------------
# Ищем задачу, данные которой требуют обновления
#------------------------------------------------------------------------
TARGET_TASK=$(
  curl --location --request POST "$HOST"'/v2/issues/_search' \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORGANIZATION_ID" \
  --header 'Content-Type: application/json' \
  --data '{
    "filter": {
      "unique": "'"$UNIQUE_VALUE"'_'"$CURRENT_TAG"'"
    }
  }'
)

TASK_ID=$(echo "$TARGET_TASK" | awk -F '"id":"' '{ print $2 }' | awk -F '","' '{ print $1 }')

# Запрос на обновление задачи
UPDATE_TASK_RESPONSE=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request PATCH "$HOST"'/v2/issues/'"$TASK_ID" \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORGANIZATION_ID" \
  --header 'Content-Type: application/json' \
  --data "$REQUEST_BODY"
)

FIRST_NUM_OF_RESPONSE=$(echo "$UPDATE_TASK_RESPONSE" | cut -c 1)

[ "$FIRST_NUM_OF_RESPONSE" = "2" ]
exit $?