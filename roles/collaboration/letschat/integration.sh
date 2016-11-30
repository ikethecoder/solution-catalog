
# DOWN SIDE: Can only get tokens via the UI
#

# 77b63ff9d520fd3670f0c5464d14b533c8710264211b90ea0683fda31c163353
# 344114ba349c2dfa466b10ca95d1b203003c19946f207c6765d974fa9706c8bb


# NTZmYTdiZjVlMDk1ZDIxNjAwMjZiZTg0OjRiYWExN2UxN2VhN2FlOGJmM2I5MGY4OWNiNGRkZjZjOTk0MDU1ZDFiZWNhZGM5Zg==

curl -v --raw http://104.236.136.167:8680/rooms -H "Authorization: Bearer NTZmYTdiZjVlMDk1ZDIxNjAwMjZiZTg0OjRiYWExN2UxN2VhN2FlOGJmM2I5MGY4OWNiNGRkZjZjOTk0MDU1ZDFiZWNhZGM5Zg=="

curl -v --raw -X POST http://104.236.136.167:8680/rooms/test/messages -d '{"text":"Test"}' -H "Authorization: Bearer NTZmYTdiZjVlMDk1ZDIxNjAwMjZiZTg0OjRiYWExN2UxN2VhN2FlOGJmM2I5MGY4OWNiNGRkZjZjOTk0MDU1ZDFiZWNhZGM5Zg=="


56fa7c17e095d2160026be85

curl -v --raw -X POST http://104.236.136.167:8680/messages -d '{"text":"Test","room":"56fa7c17e095d2160026be85"}' -H "Content-Type: application/json" -H "Authorization: Bearer NTZmYTdiZjVlMDk1ZDIxNjAwMjZiZTg0OjRiYWExN2UxN2VhN2FlOGJmM2I5MGY4OWNiNGRkZjZjOTk0MDU1ZDFiZWNhZGM5Zg=="

curl -v --raw -X POST http://104.236.136.167:8680/rooms/test/messages -d '{"text":"New code deployed version <font color=red>3.2.1</font>"}' -H "Content-Type: application/json" -H "Authorization: Bearer NTZmYTdiZjVlMDk1ZDIxNjAwMjZiZTg0OjRiYWExN2UxN2VhN2FlOGJmM2I5MGY4OWNiNGRkZjZjOTk0MDU1ZDFiZWNhZGM5Zg=="


