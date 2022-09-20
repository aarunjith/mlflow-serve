#!/bin/sh

mlflow models serve --model-uri models:/$MODEL_NAME/Production -h 0.0.0.0 -p 80