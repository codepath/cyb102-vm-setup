# Machine Set-Up

## The Easy Way (`install_tool.sh`)

- **Get a fresh linux VM with the following minimum specs:**
  - Ubuntu Server 20.04 LTS
  - 2 cores
  - 4GB RAM
  - 128GB Standard SSD

- **Download and run the `install_tool.sh` script**
  - This script will install all the tools and place all the files needed for the course
  - This might take a while (est 30-45m), so open Youtube or something
  - You will be able to choose between installing all units or just one unit at a time

## The Hard Way (Manual Set-Up)

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

- N/A - Students download files during lab

### Unit 2: Project

- N/A - Students download files during project

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

- N/A - Students download files during lab

### Unit 7: Project

- N/A - Students download files during project

### Unit 8+

- N/A - Group Project
