# Open Source Software Audit: Git (VCS)
**Author:** Harsh Kumar (24BCE10531)  
**Course:** Open Source Software (OSS) - NGMC  
**Slot:** B22  
**University:** VIT Bhopal University 

## Project Overview
This repository contains the practical deliverables for the OSS Capstone Audit[cite: 225]. The subject of this audit is Git, a distributed version control system[cite: 234]. The project explores the technical transition of the Linux kernel from BitKeeper to Git in 2005, the implications of the GPL v2 license, and the decentralized architecture that ensures software sovereignty[cite: 238, 240, 261, 281].

The objective was to analyze Git's functionality as an open-source tool and to automate system auditing tasks using Bash scripting[cite: 14, 15].

## Technical Components (Bash Scripts)

The following scripts demonstrate system administration and log analysis within a Linux environment[cite: 90]:

1. **script1_identity.sh**: Displays a formatted banner with student credentials and basic system telemetry including Kernel version and OS distribution[cite: 93, 94, 95].
2. **script2_inspector.sh**: A package auditor that checks for the presence of Git and validates its current version against system repositories[cite: 125, 126].
3. **script3_disk_audit.sh**: Monitors disk partition usage and owner permissions to ensure development environments remain stable[cite: 145, 146].
4. **script4_log_analyzer.sh**: Scans system-level logs (/var/log/syslog) for specific error patterns or failed events[cite: 163, 164]. Note: This script requires root (sudo) privileges[cite: 169].
5. **script5_manifesto.sh**: An interactive command-line utility that generates a personalized .txt manifesto based on user responses regarding open-source philosophy[cite: 185, 186].

## Instructions for Execution

To run these scripts on a Debian/Ubuntu-based system, follow the steps below[cite: 92]:

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/harshkumarcodes/OSS-Audit-Git](https://github.com/harshkumarcodes/OSS-Audit-Git)
   cd OSS-Audit-Git
