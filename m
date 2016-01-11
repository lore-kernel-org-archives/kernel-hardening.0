Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jan 2016 15:23:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
Message-ID: <20160111152355.GS28542@decadent.org.uk>
References: <20160111151958.GQ28542@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I4nrT0RnkqKX/8P2"
Content-Disposition: inline
In-Reply-To: <20160111151958.GQ28542@decadent.org.uk>
Subject: [kernel-hardening] [PATCH 2/2] security,perf: Allow further restriction of
 perf_event_open
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--I4nrT0RnkqKX/8P2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

When kernel.perf_event_open is set to 3 (or greater), disallow all
access to performance events by users without CAP_SYS_ADMIN.
Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that
makes this value the default.

This is based on a similar feature in grsecurity
(CONFIG_GRKERNSEC_PERF_HARDEN).  This version doesn't include making
the variable read-only.  It also allows enabling further restriction
at run-time regardless of whether the default is changed.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
I made a similar change to Debian's kernel packages in August,
including the more restrictive default, and no-one has complained yet.

Ben.

 Documentation/sysctl/kernel.txt | 4 +++-
 include/linux/perf_event.h      | 5 +++++
 kernel/events/core.c            | 8 ++++++++
 security/Kconfig                | 9 +++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.=
txt
index 88a2c8e..76e2ca8 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -629,12 +629,14 @@ allowed to execute.
 perf_event_paranoid:
=20
 Controls use of the performance events system by unprivileged
-users (without CAP_SYS_ADMIN).  The default value is 1.
+users (without CAP_SYS_ADMIN).  The default value is 3 if
+CONFIG_SECURITY_PERF_EVENTS_RESTRICT is set, or 1 otherwise.
=20
  -1: Allow use of (almost) all events by all users
 >=3D0: Disallow raw tracepoint access by users without CAP_IOC_LOCK
 >=3D1: Disallow CPU event access by users without CAP_SYS_ADMIN
 >=3D2: Disallow kernel profiling by users without CAP_SYS_ADMIN
+>=3D3: Disallow all event access by users without CAP_SYS_ADMIN
=20
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f9828a4..aa72940 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -989,6 +989,11 @@ extern int perf_cpu_time_max_percent_handler(struct ct=
l_table *table, int write,
 		loff_t *ppos);
=20
=20
+static inline bool perf_paranoid_any(void)
+{
+	return sysctl_perf_event_paranoid > 2;
+}
+
 static inline bool perf_paranoid_tracepoint_raw(void)
 {
 	return sysctl_perf_event_paranoid > -1;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index cfc227c..85bc810 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -175,8 +175,13 @@ static struct srcu_struct pmus_srcu;
  *   0 - disallow raw tracepoint access for unpriv
  *   1 - disallow cpu events for unpriv
  *   2 - disallow kernel profiling for unpriv
+ *   3 - disallow all unpriv perf event use
  */
+#ifdef CONFIG_SECURITY_PERF_EVENTS_RESTRICT
+int sysctl_perf_event_paranoid __read_mostly =3D 3;
+#else
 int sysctl_perf_event_paranoid __read_mostly =3D 1;
+#endif
=20
 /* Minimum for 512 kiB + 1 user control page */
 int sysctl_perf_event_mlock __read_mostly =3D 512 + (PAGE_SIZE / 1024); /*=
 'free' kiB per user */
@@ -8265,6 +8270,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
=20
+	if (perf_paranoid_any() && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
 	err =3D perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
diff --git a/security/Kconfig b/security/Kconfig
index e452378..30a2603 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -18,6 +18,15 @@ config SECURITY_DMESG_RESTRICT
=20
 	  If you are unsure how to answer this question, answer N.
=20
+config SECURITY_PERF_EVENTS_RESTRICT
+	bool "Restrict unprivileged use of performance events"
+	depends on PERF_EVENTS
+	help
+	  If you say Y here, the kernel.perf_event_paranoid sysctl
+	  will be set to 3 by default, and no unprivileged use of the
+	  perf_event_open syscall will be permitted unless it is
+	  changed.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS

--I4nrT0RnkqKX/8P2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVpPJC+e/yOyVhhEJAQryyw//Z7++QBA02Djwyd3nBdbKO/redJJNW3dZ
wfaVne8M4auVP8ylsctOAcfK/V7kY/E1T3903jVWw5IjgfGa78sU3OAxZfEw1zGt
jZfMJzapUpbx3x0zr1I7tmO+HQPnsDLQCR9d5mgSnbDJ0jrSC3uQH3YIVmIlrZQv
qcAATIvgiY1V1nbQc2XRPosRjX21c0Ssfu8+ENBrcI0bHTkWToa1PR19kq0bNWOL
q3XeQWd8eeBLSzZIasPvzYJFawoKzto2HaAJ7rCsf5dUFqDSQcPnPJ8g6Y0O0Tm4
AuEdxTS4ytVIpfWlPn3f2L1bB74o//XBGMlaaPLYGTwJL5aX5UsqRMKEehzuP8lx
bE0o28IaM96AkT8zYByByS6YXNshyyn9lcCsqQh3WWSJl0WN8+ytzaOcJgkhrlkm
FIiwOgt0BBG8QturmCnBcVn/xx9k9RcEFdB2+0voZ4A88btEsKQaprDuWBK1anhL
PFv0TXZcmEpiB5ELJjj6TKooWoijLT8rLq5PLljHdoEAopR/yV1JrbVpLDVs3BGe
uINsPssb9rlB2S9hwtdq9dYSV7tVaQe54NtyShxckic8tTZbiHKMa+6B3L1YzuG7
+xHF+5yP1Bx0zPjKQdlacBv/UjOZUE1kNWInWVaaez1UWhenIRxPhpmVJFusSenk
mMcyqUMnI2o=
=BlNn
-----END PGP SIGNATURE-----

--I4nrT0RnkqKX/8P2--
