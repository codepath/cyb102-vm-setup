# Machine Set-Up

## The Easy Way

- Run script: `~/scripts/setup.sh`

## The Hard Way

### RDP Setup

> This must be done to allow for RDP connections to the student VM

- Run script: `~/scripts/rdp_setup.sh`
- Tool(s) installed: `xrdp`, `xfce4`
- Files placed: None

### Unit 1: Lab

- Run script: `~/scripts/unit1_lab.sh`
- Tool(s) installed: `Wireshark` (and dependencies)
- Files placed: None

### Unit 1: Project

- N/A - Same as Lab

### Unit 2: Lab

- N/A - Students install their account-specific Wazuh agents during lab

### Unit 2: Project

- Run script: `~/scripts/unit2_project.sh`
- Tool(s) installed: N/A - Same as lab
- Files placed:
  - `/etc/wazuh/static.txt`
  - `/etc/wazuh/thisisit.txt`
  - `attack-part1.sh`
  - `attack-part2.sh`

### Unit 3: Lab

- Run script: `~/scripts/unit3_lab.sh`
- Tool(s) installed: `Snort` (and dependencies)
- Files placed: None

[*Instructions Source*](https://snort-org-site.s3.amazonaws.com/production/document_files/files/000/011/074/original/Snort_3_on_Ubuntu_18_and_20.pdf)

### Unit 3: Project

- Run script: `~/scripts/unit3_project.sh`
- Tool(s) installed: `npm`, `node`, `hftp` library
- Files placed: See below tree

```text
ftp_project
└── ftp_folder
    ├── activity.pcapng
    ├── attack.sh
    ├── cosmo
    │   ├── passwords.txt
    │   ├── reports_original.txt
    │   └── rocknames.txt
    ├── general
    │   ├── budget.txt
    │   └── reports.txt
    ├── scripts
    │   ├── attack.js
    │   └── start-server.js
    ├── timmy
    │   ├── fishnames.txt
    │   ├── passwords.txt
    │   └── reports_original.txt
    └── wanda
        ├── catnames.txt
        ├── passwords.txt
        └── reports_original.txt
```

### Unit 4: Lab

- N/A - Wireshark continued and mitmproxy installed in-lab

### Unit 4: Project

- Run script: `~/scripts/unit4_project.sh`
- Tool(s) installed: `nginx`, `slowloris`
- Files placed: None

### Unit 5: Lab

- Run script: `~/scripts/unit5_lab.sh`
- Tool(s) installed: `Splunk`
- Files placed: `netflix_titles.csv`, `Top Video Game sales.csv`, `webauth.csv` (Loaded into Splunk)

### Unit 5: Project

- Run script: `~/scripts/unit5_project.sh`
- Tool(s) installed: None (Splunk installed in lab)
- Files placed: `webserver02.csv`, `uploadedhashes.csv`, `failedlogins64.csv`, `BlueCoatProxy01.csv` (Loaded into Splunk)

### Unit 6: Lab

- N/A - Lab runs in browser

### Unit 6: Project

- N/A - Project runs in browser

### Unit 7: Lab

- Run script: `~/scripts/unit7_lab.sh`
- Tool(s) installed: `MISP`
- Files placed: None

#### 🚨 Manual Steps

- Login to 127.0.0.1 on the local machine (No port needed) 
- Change the user/password from `admin@admin.test/admin` to `admin@admin.test/Codepath123!`
- Click on `Sync Actions` > `Load Default Feed Metadata` > `Fetch and Store all feed data`
- Check all the options and select `Cache All Feeds`
  - (Note: This is NOT the blue button that says `Fetch and store all feed Data`!)

### Unit 7: Project

- N/A - Same as Lab

### Unit 8+

- N/A - Group Project
