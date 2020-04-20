# web crwaling 
library(httr)
library(rvest)
library(readr)
library(dplyr)

otp_url = "http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx?name=fileDown&filetype=csv&url=MKD/13/1302/13020401/mkd13020401&market_gubun=ALL&gubun=1&isu_cdnm=A005930%2F%EC%82%BC%EC%84%B1%EC%A0%84%EC%9E%90&isu_cd=KR7005930003&isu_nm=%EC%82%BC%EC%84%B1%EC%A0%84%EC%9E%90&isu_srt_cd=A005930&schdate=20200410&fromdate=20200403&todate=20200410&pagePath=%2Fcontents%2FMKD%2F13%2F1302%2F13020401%2FMKD13020401.jsp"


payload = list(
  name = 'fileDown',
  filetype = 'csv',
  url = "MKD/13/1302/13020401/mkd13020401",
  market_gubun = "ALL",
  gubun = '1',
  schdate = "20200412",
  pagePath = "/contents/MKD/13/1302/13020401/MKD13020401.jsp")

otp = POST(url = otp_url, query = payload) %>% 
  read_html() %>% 
  html_text()

url = "http://file.krx.co.kr/download.jspx"

data = POST(url = url, 
     query = list(code = otp),
     add_headers(referer = otp_url)) %>%
  read_html() %>% 
  html_text() %>% 
  read_csv()
csv = data %>% 
  select(종목코드, 종목명)
write.csv(csv, 'code.csv', row.names = F)
    