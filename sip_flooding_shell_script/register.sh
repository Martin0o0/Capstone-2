#!/bin/bash

# 메시지를 보낼 P-CSCF 주소와 포트 설정
PCSCF_ADDRESS="sip:192.168.0.18:5060"
BATCH_SIZE=1000
# RURI 설정
RURI="sip:ims.mnc001.mcc001.3gppnetwork.org"
# 기본 헤더 값 설정
FUSER="fuser:001010000044701"
FDOMAIN="fdomain:ims.mnc001.mcc001.3gppnetwork.org"
TUSER="tuser:sip:001010000044701"
TDOMAIN="tdomain:ims.mnc001.mcc001.3gppnetwork.org"
SESSION_ID="7846bb8e3e98cedf61f78b2392e66c2a"
PAN_INFO="3GPP-E-UTRAN-FDD;utran-cell-id-3gpp=0010100010019b01"
ALLOW="ACK,BYE,CANCEL,INFO,INVITE,MESSAGE,NOTIFY,OPTIONS,PRACK,REFER,UPDATE"

# 전송할 총 메시지 개수
TOTAL_MESSAGES=100000

# 로그 파일 설정
LOG_FILE="sipexer_register.log"

# 로그 초기화
echo "" > "$LOG_FILE"
# 메시지 전송 루프
send_message() {
    # 랜덤 IP 생성 (192.168.100.X)
    RANDOM_IP="192.168.100.$((RANDOM % 254 + 1))"
    # SIPExer 명령어 실행
    CMD="./sipexer -method register \
        -ruri $RURI \
        -ex 0 \
        -fv \"$FUSER\" \
        -fv \"$FDOMAIN\" \
        -fv \"$TUSER\" \
        -fv \"$TDOMAIN\" \
        -xh \"Contact: <sip:$RANDOM_IP:5060>\" \
        -xh \"Session-ID: $SESSION_ID\" \
        -xh \"P-Access-Network-Info: $PAN_INFO\" \
        -xh \"Allow: $ALLOW\" \
        $PCSCF_ADDRESS"
   
    # 실행하고 로그에 결과 기록
    echo "[$i/$TOTAL_MESSAGES] Sending REGISTER with Contact: $RANDOM_IP" | tee -a "$LOG_FILE"
    eval "$CMD" >> "$LOG_FILE" 2>&1

}
for ((i=1; i<=TOTAL_MESSAGES; i+=BATCH_SIZE))
do
    echo "Starting batch $((i / BATCH_SIZE + 1))..." | tee -a "$LOG_FILE"
    for ((j=0; j<BATCH_SIZE; j++))
    do
        CURRENT_TASK=$((i + j))
        if [ $CURRENT_TASK -le $TOTAL_MESSAGES ]; then
            send_message $CURRENT_TASK &
        fi
    done
    wait  # 현재 배치의 모든 작업이 끝날 때까지 대기
    echo "Batch $((i / BATCH_SIZE + 1)) completed." | tee -a "$LOG_FILE"
done
