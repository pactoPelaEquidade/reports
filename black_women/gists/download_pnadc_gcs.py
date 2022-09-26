import pandas as pd
import os
from google.cloud import storage
from tqdm import tqdm

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/home/dell/gcloud_credentials/original-folio-296420-c6835ebfbfe7.json'

storage_client = storage.Client()
bucket = storage_client.get_bucket('pacto-report-women')

blobs = list(bucket.list_blobs(prefix='pnadc/'))

dfs = []

for blob in tqdm(blobs):
    df=pd.read_parquet(f'gs://pacto-report-women/{blob.name}')
    dfs.append(df)

df = dfs[0].append(dfs[1:])

df.to_csv('/home/dell/Documents/pacto/reports/black_women/data/pnadc.csv', index=False)