GREENTEC static software repository

Host this folder behind an HTTP/HTTPS web server. DEPOT/ComputerCraft clients should request index.json first.
Package checksums are SHA-256 values recorded by GREENTEC Studio.
Node-specific bootstrap scripts are under bootstrap/<node-uuid>.lua.
facility.json contains the published node directory. Bootstrap scripts only enroll identity and verify connectivity.
This folder contains no server-side code or database; it is the portable/offline-friendly repository format.
