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

map_region={'AC': 'Norte',
 'AL': 'Nordeste',
 'AP': 'Norte',
 'AM': 'Norte',
 'BA': 'Nordeste',
 'CE': 'Nordeste',
 'DF': 'Centro-Oeste',
 'ES': 'Sudeste',
 'GO': 'Centro-Oeste',
 'MA': 'Nordeste',
 'MT': 'Centro-Oeste',
 'MS': 'Centro-Oeste',
 'MG': 'Sudeste',
 'PA': 'Norte',
 'PB': 'Nordeste',
 'PR': 'Sul',
 'PE': 'Nordeste',
 'PI': 'Nordeste',
 'RJ': 'Sudeste',
 'RN': 'Nordeste',
 'RS': 'Sul',
 'RO': 'Norte',
 'RR': 'Norte',
 'SC': 'Sul',
 'SP': 'Sudeste',
 'SE': 'Nordeste',
 'TO': 'Norte'}


df['regiao']=df.sigla_uf.map(map_region)


df.to_csv('/home/dell/Documents/pacto/reports/black_women/data/pnadc.csv', index=False)
