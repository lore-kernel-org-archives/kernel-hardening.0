Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jan 2016 15:21:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
Message-ID: <20160111152159.GR28542@decadent.org.uk>
References: <20160111151958.GQ28542@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/iD2bb7ty46CBYRX"
Content-Disposition: inline
In-Reply-To: <20160111151958.GQ28542@decadent.org.uk>
Subject: [kernel-hardening] [PATCH 1/2] Documentation,perf: Document the perf sysctls
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--/iD2bb7ty46CBYRX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

perf_event_paranoid was only documented in source code and a perf
error message.  Move the documentation from the error message to
Documentation/sysctl/kernel.txt.

perf_cpu_time_max_percent was already documented but missing from the
list at the top, so add it there.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/sysctl/kernel.txt | 13 +++++++++++++
 tools/perf/util/evsel.c         |  7 ++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.=
txt
index af70d15..88a2c8e 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -58,6 +58,8 @@ show up in /proc/sys/kernel:
 - panic_on_stackoverflow
 - panic_on_unrecovered_nmi
 - panic_on_warn
+- perf_cpu_time_max_percent
+- perf_event_paranoid
 - pid_max
 - powersave-nap               [ PPC only ]
 - printk
@@ -624,6 +626,17 @@ allowed to execute.
=20
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
+perf_event_paranoid:
+
+Controls use of the performance events system by unprivileged
+users (without CAP_SYS_ADMIN).  The default value is 1.
+
+ -1: Allow use of (almost) all events by all users
+>=3D0: Disallow raw tracepoint access by users without CAP_IOC_LOCK
+>=3D1: Disallow CPU event access by users without CAP_SYS_ADMIN
+>=3D2: Disallow kernel profiling by users without CAP_SYS_ADMIN
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 pid_max:
=20
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 397fb4e..9b4df11 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2314,11 +2314,8 @@ int perf_evsel__open_strerror(struct perf_evsel *evs=
el, struct target *target,
 	case EACCES:
 		return scnprintf(msg, size,
 		 "You may not have permission to collect %sstats.\n"
-		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
-		 " -1 - Not paranoid at all\n"
-		 "  0 - Disallow raw tracepoint access for unpriv\n"
-		 "  1 - Disallow cpu events for unpriv\n"
-		 "  2 - Disallow kernel profiling for unpriv",
+		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid -\n"
+		 "see Documentation/sysctl/kernel.txt",
 				 target->system_wide ? "system-wide " : "");
 	case ENOENT:
 		return scnprintf(msg, size, "The %s event is not supported.",


--/iD2bb7ty46CBYRX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVpPIl+e/yOyVhhEJAQoyvxAAn8JUfs+c59/uICERkVkIDaVMaTb95e8s
M/DnZemMD+6D7rrZkV8n/mqcOE7uAER0uGZqxYt7Ni+NwKrqHs0aYDTPuUREO+Hp
/CiSXkSIkVIExbw0ePDFYc9PBnEV6n0QL/Jc4V1QZW15jlpoCJ1ubhKCgq4ZPYL+
TWyVNBuzStun8dh2yoE93+F8fnFsMCX1b/4xg3TCwpnhNNJx9E9/8zTSpdr/ueWD
MJ9/MR/nHymiEdzAv19YHwmwOMj/Wm1LVcIifUDlEX3B7tp6ARtWpo1qedO3GRSh
VhCpwKI8RhIH2LalQDKBgw5vc+UNA2EYFqJxY/3as1HUrgJlKMKTCl1OKR0Z8VZq
W4eGrSKsGft1AjcPJGmxpQsG+tlHhFb4avd+oW/jaysjh2AK4aUq83KlUWZI1EK6
pRT+jAG3zgugMm1AoCSiHNcEpGzvWHU3eRdkINerzSi8JWCe/gKbjaz72G3xz4Kk
1t0UbSS27JJSRkbXGeFMnLGXYy/xQs1A0HFLwQpD2ohjzYdEDbQi07E0KjVbjyxd
0dEj7M6VQCn4/6lQ9vQTfwitXIYd4VTomNBhHZgT2ZMCZthjnoLevIKc4GZVCT7N
LHOAEvPrkAvytn/PDh+yle8BU1Xzo2M1PVGD32D4T5mlL0zvpei+8mYWzMxDXJek
xWLxJBWQkCQ=
=yBAk
-----END PGP SIGNATURE-----

--/iD2bb7ty46CBYRX--
