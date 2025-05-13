import os
import urllib.request

path_osm="./Data/Osm"


Latitude_up = 39.98528
Latitude_down = 39.92185
Longitude_left = 116.29990
Longitude_right = 116.36805
Latitude_interval = 0.002
Longitude_interval = 0.002
coordinate = []
num_1 = int((Latitude_up - Latitude_down) // Latitude_interval)
num_2 = int((Longitude_right - Longitude_left) // Longitude_interval)
for i in range(num_1):
    for j in range(num_2):
        down = round(Latitude_down + Latitude_interval * i, 4)
        up = round(Latitude_down + Latitude_interval * (i + 1), 4)
        left = round(Longitude_left + Longitude_interval * j, 4)
        right = round(Longitude_left + Longitude_interval * (j + 1), 4)
        coordinate.append(str(left) + ',' + str(down) + ',' + str(right) + ',' + str(up))

# download
for i in range(len(coordinate)):
    url = f'https://overpass-api.de/api/map?bbox={coordinate[i]}'
    filename = f'map_{str(i)}_{coordinate[i]}'
    if filename in os.listdir(f'{path_osm}'):
        continue
    for j in range(3):  # 重复三次
        print('download', i, url)
        try:
            urllib.request.urlretrieve(url, f'{path_osm}/map_{str(i)}_{coordinate[i]}.osm')
            break
        except:
            continue

