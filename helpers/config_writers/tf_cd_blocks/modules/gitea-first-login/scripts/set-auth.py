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


def sign_in(login, password, csrf, cookies):
    data = {
        "user_name": login,
        "password": password,
        "_csrf": csrf
    }
    r = requests.post(login_route, data=data, cookies=cookies)
    print("sign_in RESULT", r.cookies, csrf)
    r.raise_for_status()
    token = r.cookies['_csrf']
    # print(r.headers)
    return token, r.cookies


# def obtain_personal_access_token(name, expires_at, csrf, cookies):
#     data = {
#         "personal_access_token[expires_at]": expires_at,
#         "personal_access_token[name]": name,
#         "personal_access_token[scopes][]": "api"
#     }
#     data.update(csrf)
#     r = requests.post(pat_route, data=data, cookies=cookies)
#     soup = BeautifulSoup(r.text, "lxml")
#     token = soup.find('input', id='created-personal-access-token').get('value')
#     return token

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


def enable_authentication (csrf, cookies):
    data = {
        "_csrf" : unquote(csrf),
        "type": "6",
        "name": "keycloak",
        "oauth2_provider": "openidConnect",
        "oauth2_key": os.environ['OIDC_CLIENT_ID'],
        "oauth2_secret": os.environ['OIDC_CLIENT_SECRET'],
        "open_id_connect_auto_discovery_url": "%s/.well-known/openid-configuration" % os.environ['OIDC_ISSUER'],
        "is_active": "on"
    }
    headers = {
        "Content-Type" : "application/x-www-form-urlencoded"
    }

    r = requests.post(auth_new_route, headers=headers, data=data, cookies=cookies)

    if r.status_code == 400:
        print(r.text)
    print(r)
    r.raise_for_status()

def main():
    csrf, cookies = obtain_csrf_token()
    print("root", csrf, cookies)

    # csrf, cookies = obtain_csrf_token()
    csrf, _cookie = sign_in(os.environ['ADMIN_USERNAME'], os.environ['ADMIN_PASSWORD'], csrf, cookies)

    enable_authentication (csrf, cookies)


if __name__ == "__main__":
    main()
