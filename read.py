import pantab
import datetime
import os
import pandas as pd
from tableauhyperapi import TableName

def read_table(x):
    table=TableName("Extract", "Extract")
    return pantab.frame_from_hyper(x, table=table)


dir_list = os.listdir('data')

for file in dir_list:
    try:
        df = read_table(os.path.join('data', file))
        print(df.columns)
    except TypeError:
        pass
    
    if df.columns.isin(['wwtp_name']).any():
        file_time = datetime.datetime.now().strftime("%Y-%m-%d_")
        file_name = file_time + r'raw.csv' 
        df.to_csv(os.path.join("output",file_name), index=False)
        df.to_csv(os.path.join("output",'latest.csv'), index=False)
        print("Got it!")
        
    if df.columns.isin(['RSV-like']).any():
        file_time = datetime.datetime.now().strftime("%Y-%m-%d_")
        file_name = file_time + r'raw.csv' 
        df.to_csv(os.path.join("ili",file_name), index=False)
        df.to_csv(os.path.join("ili",'latest.csv'), index=False)
        print("Got it!")
    else:
        print("Not it.")
        
        
        
