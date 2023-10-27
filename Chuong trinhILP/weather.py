import urllib2
import json
import time
from datetime import datetime

while True:
	now = datetime.now()
	try:
		f1 = open('weather.csv', 'a+') #luu du lieu
	except Exception:
		print "Oops!  Can't load data because you open file" #khi mo file thi chuong trinh se khong chay
		time.sleep(60)
		continue
	try:
		f = urllib2.urlopen('http://api.wunderground.com/api/76b34f8da4c5baf5/geolookup/conditions/q/pws:IHANOIHA6.json')
		json_string = f.read()
	except Exception:
		print "Oops!  No Internet  Try again..." #khong co Internet cung khong the lay du lieu
		time.sleep(60)
		continue
	parsed_json = json.loads(json_string)
	location = parsed_json['location']['city']
	temp_c = parsed_json['current_observation']['temp_c'] #Nhiet do
	relative_humidity = parsed_json['current_observation']	['relative_humidity'] #Do am
	wind_dir = parsed_json['current_observation']['wind_dir'] #Huong gio
	wind_kph = parsed_json['current_observation']['wind_kph'] #Toc do gio
	visibility_km = parsed_json['current_observation']['visibility_km'] #Tam nhin Km
	UV = parsed_json['current_observation']	['UV'] #Chi so UV
	precip_1hr_in = parsed_json['current_observation']['precip_1hr_in'] #Luong mua trong 1 gio
	weather = parsed_json['current_observation']['weather'] #Thoi tiet
	line = "%02s.%02s.%s, %02s:%02s:%02s, %s C, %s, %s, %s km/h, %s km, %s, %s, %s\n" % (now.day, now.month, now.year, now.hour, now.minute, now.second, temp_c, relative_humidity, wind_dir, wind_kph, visibility_km, UV, precip_1hr_in, weather)
	print "%02s.%02s.%s, %02s:%02s:%02s, %s C, %s, %s, %s km/h, %s km, %s, %s, %s" % (now.day, now.month, now.year, now.hour, now.minute, now.second,  temp_c, relative_humidity, wind_dir, wind_kph, visibility_km, UV, precip_1hr_in, weather)	
	f1.write(line)
	f.close()
	f1.close()
	time.sleep(300)
	
