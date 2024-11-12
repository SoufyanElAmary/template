#!/bin/sh

#Run API
export FLASK_APP=src/api/app.py
# export FLASK_RUN_PORT=5050
export FLASK_DEBUG=1
API_PID_FILE=api_pid.txt
if test -f "$API_PID_FILE";
then
    pid=`cat "$API_PID_FILE"`
    echo $pid
    if [ "$pid" != '' ]
    then
        kill -9 $pid
        rm "$API_PID_FILE"
    fi
    echo "RUNNING INFERENCE API"
    nohup sh -c 'python -m flask run' 2>&1 > api.log &
    echo $! > "$API_PID_FILE"
fi

#Run Streamlit
STREAMLIT_PID_FILE=streamlit_pid.txt
if test -f "$STREAMLIT_PID_FILE";
then
    pid=`cat "$STREAMLIT_PID_FILE"`
    echo $pid
    if [ "$pid" != '' ]
    then
        kill -9 $pid
        rm "$STREAMLIT_PID_FILE"
    fi
    echo "RUNNING STREAMLIT DASHBOARD"
    nohup sh -c 'python -m streamlit run --server.port 8000 src\\dashboard\\main.py' 2>&1 > streamlit.log &
    echo $! > "$STREAMLIT_PID_FILE"
fi