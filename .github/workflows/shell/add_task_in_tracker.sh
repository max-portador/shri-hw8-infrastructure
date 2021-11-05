#!/usr/bin/env bash

#------------------------------------------------------------------------
# Отправляем запрос на создание задачи в Яндекс-трекере и получаем ответ
#------------------------------------------------------------------------

ADD_TASK_RESPONSE=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request POST "$HOST"'/v2/issues/' \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORGANIZATION_ID" \
  --header 'Content-Type: application/json' \
  --data "$REQUEST_BODY"
)

#------------------------------------------------------------------------
# Если уже был такой релизный тэг, то в ответе вернется статус 409
#------------------------------------------------------------------------

if [ "$ADD_TASK_RESPONSE" = "409" ]; then

#------------------------------------------------------------------------
# Обновляем задачу в Яндекс Трекер, если статус в ответе 409
#------------------------------------------------------------------------
  chmod +x ./.github/workflows/shell/udate_task_in_tracker.sh
  ./.github/workflows/shell/udate_task_in_tracker.sh

  if [ $? != 0 ]; then
    exit $?
  fi
else
  FIRST_NUM_OF_RESPONSE=$(echo "$ADD_TASK_RESPONSE" | cut -c 1)

  [ "$FIRST_NUM_OF_RESPONSE" = "2" ]
  exit $?
fi