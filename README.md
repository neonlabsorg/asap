The application is a centralized registry of various security alerts. The alert may represent anything you can treat as potential security or privacy issue. You may think of the app as a dashboard of alerts, where you have convinient way to respond to every single alert or bunch of alerts.

## How to install

TBD

## How to create alert?

Send a single POST request. An alert should at least contain severity, title, asset and source. The app takes md5 hash of title + asset and uses it as ID, so it could be recognized and updated on next occurrence.

##### Example with curl:
```bash
curl -X POST -H "Content-Type: application/json" -H 'X-API-Key: FakeAPIkey'  \
-d '{"title": "SSL certificate is about to expire", "asset": "dev.example.com", "severity": "High", "source": "cert-watcher"}' \
https://asap.mydomain.com/api/v1/alerts
```
##### Example with httpie:
```bash
http POST 'http://asap.mydomain.com/api/v1/alerts'  X-API-Key:FakeAPIkey \
title:="Vulnerability detected" \
asset:="10.10.0.105:8880" \
severity:="Critical" \
source:="nessus-watcher"
```
##### Supported params:
| Field | Required | Type | Description |
|-----------------|-----------------|-----------------|-----------------|
| title    | yes | string  | alerts title    |
| asset    | yes | string  | e.g. ip-address, user, domain name    |
| severity | yes | string  | must be one of Critical, High, Medium, Low    |
| source   | yes | string  | name of your watcher    |
| output   | no  | text  | displayed as is for convinience ignoring HTML tags |
| remediation | no | text  | e.g. from Nessus report or a link to SOC runbook |
| issue | no | string | field for response, e.g. comment or link to ticket |
| cve_list | no | array of strings | for CVEs |

## How to close alert?
Alerts may be simply closed manually. Also, there is source field that identifies a script or so-colled watcher where the entry comes from. The watcher is a sort of automation around some processes, systems, application and so on that result to posting alerts to the application. If the alerts created by watcher supposed to be closed at some point, watcher should provide a list with IDs of currently active alerts. So, old alerts will be closed according to the list.

##### Example with curl:
```bash
curl -X POST -H "Content-Type: application/json" -H 'X-API-Key: FakeAPIkey'  \
-d '{"source": "cert-watcher", "current_alerts": ["b4d10b7a-9385-332b-a2eb-55c6bf5f82a3", "94e62d48-f57b-3c26-bb61-84d74ebe3793"]' \
https://asap.mydomain.com/api/v1/arrange_alerts
```

## How to respond to alert?
You may assign a ticket to an alert by setting a link to the issue field in UI. Otherise, it's just a string which may be used as a short note or comment. Also if you have a guides/runbooks for you alerts you may put a link to remediation field when posting an alert.

## TODO
 - Dockerize the application
 - Implement tests