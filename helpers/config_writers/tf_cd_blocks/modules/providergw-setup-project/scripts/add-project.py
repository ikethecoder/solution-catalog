import sys
import os
import json
import requests
from urllib.parse import unquote
from urllib.parse import urljoin
from urllib.parse import urlparse
from urllib.parse import parse_qs
from bs4 import BeautifulSoup


endpoint = os.environ['PROVIDERGW_HOST']
login_route = urljoin(endpoint, "/red/auth/strategy")
set_user_route = urljoin(endpoint, "/red/settings/user")
projects_route = urljoin(endpoint, "/red/projects")

def sign_in(login, password):
    data = {
        "username": login,
        "password": password,
    }
    session = requests.Session()

    page = session.get(login_route)
    page.raise_for_status()
    print(session.cookies.get_dict())
    print(page.cookies.get_dict())
    soup = BeautifulSoup(page.text, 'html.parser')
    action = soup.find_all('form')[0].attrs['action']
    print("ACTION = ", action, login, password)

    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    r = session.post(action, headers=headers, data=data, cookies=page.cookies, allow_redirects=False)
    r.raise_for_status()
    while (r.status_code == 301 or r.status_code == 302):
        print("REDIRECT::: ", r.status_code, r.headers['Location'], r.headers)
        location = r.headers['Location']
        if (not location.startswith('http')):
            location = "%s%s" % (endpoint, location)
        parsed = parse_qs(urlparse(location).query)
        if ('access_token' in parsed):
            return parsed['access_token'][0], r.cookies
        r = session.get(location, headers=r.headers, data=r.text, cookies=r.cookies, allow_redirects=False)

    print(r.cookies)
    print(r.headers)
    print(session.cookies.get_dict())
    return session.cookies

def set_user (user, email, token, cookies):
    data = {
        "editor": {
            "view": {
                "view-grid-size":20,
                "view-node-status":True,
                "view-show-tips":True,
                "view-snap-grid":True,
                "view-show-grid":True
            }
        },
        "git": {
            "user": {
                "name":user,
                "email":email
            }
        }
    }

    headers = {
        "Authorization" : "Bearer %s" % token,
        "Content-Type" : "application/json"
    }

    r = requests.post(set_user_route, headers=headers, data=json.dumps(data), cookies=cookies)

    if r.status_code == 400:
        print(r.text)
    r.raise_for_status()

def set_project (name, credentialSecret, url, username, password, token, cookies):
    data = {
        "name":name,
        "credentialSecret":credentialSecret,
        "git":{
            "remotes":{
                "origin":{
                    "url":url,
                    "username":username,
                    "password":password
                }
            }
        }
    }

    headers = {
        "Authorization" : "Bearer %s" % token,
        "Content-Type" : "application/json"
    }

    r = requests.post(projects_route, headers=headers, data=json.dumps(data), cookies=cookies)

    if r.status_code == 400:
        data = r.json()
        if (data['error'] == "project_exists"):
            return
        print(r.text)
    r.raise_for_status()

def main():

    token, _cookies = sign_in(os.environ['ADMIN_USERNAME'], os.environ['ADMIN_PASSWORD'])

    set_user(os.environ['GIT_USER'], os.environ['GIT_EMAIL'], token, _cookies)

    set_project(os.environ['GIT_NAME'], os.environ['GIT_SECRET'], os.environ['GIT_URL'], os.environ['GIT_USERNAME'], os.environ['GIT_PASSWORD'], token, _cookies)


if __name__ == "__main__":
    main()
