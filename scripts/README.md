This folder contains illustrative bash scripts used to
emulate various wireless backhaul topologies on the
PRONTO testbed. Please begin by reading the included
paper

brassil-2021-5gwf.pdf

Subdirectories in the ./scripts directory contain
scripts running on a node emulating User Equipment (scripts/ue)
and a server within the local 5g core's mobile edge cloud
(scripts/mec-server). Separate scripts realize linear multi-hop
wireless topologies with 2 and 3 hops. Listings of routing
tables and iptables rules are included to clarify packet
recirculation.

