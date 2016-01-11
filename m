Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jan 2016 15:19:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
Message-ID: <20160111151958.GQ28542@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PNhKGIEA4V+P7uXi"
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH 0/2] Document and extend kernel.perf_event_paranoid
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--PNhKGIEA4V+P7uXi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This moves documentation for the kernel.perf_event_paranoid to the
Documentation directory, then adds a more paranoid level.

Ben.

Ben Hutchings (2):
  Documentation,perf: Document the perf sysctls
  security,perf: Allow further restriction of perf_event_open

 Documentation/sysctl/kernel.txt | 15 +++++++++++++++
 include/linux/perf_event.h      |  5 +++++
 kernel/events/core.c            |  8 ++++++++
 security/Kconfig                |  9 +++++++++
 tools/perf/util/evsel.c         |  7 ++-----
 5 files changed, 39 insertions(+), 5 deletions(-)


--PNhKGIEA4V+P7uXi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVpPIHee/yOyVhhEJAQp7tA/+MukahoxfDvaQ530qc/JFY24VoKtH04qE
1cW1lUWXegTkhbzufY2+UoH2Dlj8J7HxS7KckeThKUtK4TxO2db15rwww/RKhRs+
WawPMiijzr28j3FNHjSeqLEGPG6oRl126XUs4Hhteh/dW/W5GfwALcSIlhQmIoKF
/PEvcGoC6dTs6N0+tFrG2kaxHY8eLE9AVh5Hm1/FyeWlzHevhE6hO3XrOl4vX3m5
Y+3+raeX2FxMXFk2qwngcXcKiE910PkuvlgwR9co0tXbHo5y64xz7p7NSERsiOyb
RHf2eqMa8t2/rinw/gBWwWt579YOQQzYq0FLr8sCJQM05c56i4/OkLgYnqwdKVG+
CJFMrTI6NjP3TJQ23WnR/KtUjmJMtfIzpTuSMQ7QRaC4Hl+RuCtPtwFuIiVI2Pc+
cQHTvl7HL1Qk8ggMhUSUGixY9Dl6xCvbUl+y+oQLchXTxj9SXQqV41dcgXxFo1Jb
jLum/dsMzUYLEicinmEMjtvpa5YL/eerkGQgGlDn5RnuCv9exqjYyxQUdXLD1dA5
nJ08XNIiDhMtRt8HwrC79rlbRqNmtXuhdUFS1yTcYhrbUxy0hzgeLlfHy/THgtJd
bdJ/qp3O9z7UWMaYN2w2V9X6oIHb9WsYgsCIlfves90EJr+mca9jSi3Y3zAZGCPG
yHkoIVVnX0U=
=KtBw
-----END PGP SIGNATURE-----

--PNhKGIEA4V+P7uXi--
