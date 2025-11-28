Nmad – Advanced Nmap Toolkit

    Nmad is an interactive Bash wrapper around Nmap that makes advanced scans easier and more user-friendly.

    It provides a colorful TUI-style flow for selecting targets, timing templates, OS detection, and NSE categories.

Features

    Interactive target prompt with basic host-up check using nmap -sn.

    Timing template selection (T0–T5) for both primary and full scans.

    Optional OS detection using the -O flag.

    Menu-driven selection of NSE script categories (auth, brute, vuln, malware, etc.).

    Primary fast SYN scan with service discovery flags.

    Optional “sneaky” full -A scan with separate timing choice.

Requirements

    Bash

    Nmap installed and available in PATH

    sudo rights for SYN and -A scans

Usage

    Make the script executable:

        chmod +x nmad.sh

    Run the tool:

        simply type "nmad"

    Follow the prompts to:

        Enter an IP or domain

        Choose scan speed (T0–T5)

        Enable or disable OS detection

        Select one or more NSE categories

        Optionally run an additional full -A scan

Notes

    Use Nmad and Nmap only on hosts and networks you own or are explicitly authorized to test.

    Some NSE categories (exploit, intrusive, dos, malware) can be noisy or risky on production systems.
