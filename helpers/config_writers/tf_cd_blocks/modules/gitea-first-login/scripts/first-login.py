import sys
import os
import requests
from urllib.parse import unquote
from urllib.parse import urljoin
from bs4 import BeautifulSoup


endpoint = os.environ['GITEA_HOST']
root_route = urljoin(endpoint, "/")
login_route = urljoin(endpoint, "/user/login")
sign_up_route = urljoin(endpoint, "/user/sign_up")
auth_new_route = urljoin(endpoint, "/admin/auths/new")

def obtain_csrf_token():
    r = requests.get(login_route)
    r.raise_for_status()
    token = r.cookies['_csrf']
    return token, r.cookies

def set_first_login (csrf, cookies):
    data_tuples = [
        ("_csrf", csrf),
        ("user_name", os.environ['ADMIN_USERNAME']),
        ("email", os.environ['ADMIN_EMAIL']),
        ("password", os.environ['ADMIN_PASSWORD']),
        ("retype", os.environ['ADMIN_PASSWORD'])
    ]
    r = requests.post(sign_up_route, data=data_tuples, cookies=cookies)
    r.raise_for_status()


def main():
    csrf, cookies = obtain_csrf_token()
    print("root", csrf, cookies)

    set_first_login(csrf, cookies)


if __name__ == "__main__":
    main()
