date_str=`date +%Y%m%d`
mysqldump -u root --password=******** wordpress | gzip > ~/wordpress_$date_str.sql.gz
