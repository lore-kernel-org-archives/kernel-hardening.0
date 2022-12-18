Return-Path: <kernel-hardening-return-21597-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 97CD7C4332F
	for <kernel-hardening@archiver.kernel.org>; Sun, 18 Dec 2022 19:29:40 +0000 (UTC)
Received: (qmail 24107 invoked by uid 550); 18 Dec 2022 19:29:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24075 invoked from network); 18 Dec 2022 19:29:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1671391753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=iy61Bv29b7eU5u1BuQzjFi316i/jl5kEL6q4Ed1CqWI=;
	b=N1FTRwvT92pNoF+fotwoH+e487aoYThJfw9DwNNwbVFQ7nPdPadaZChV4RqqRKNdgK+BFE
	HUaD+Su4CoYXRNMdyn9qW858DZ6qUi9JWRrotheNCzfGX9/osTMCrX3+g3Z8EFHMSaN1zy
	PyWjrkdakNmISfTUCvY/IrrAx4F3Wd09CHu46y7MazT0BToDHeJqem5v2REsf6nDoUE0Ty
	/TGf8BYhQzhZQlRExvEBeuy5E4KXQfm81P3J9oL7Qr+qpMMOA4cb8ZXAVpobGSR2h/wIEQ
	NQEMu/oU8r8U6Smr7zJ1vYvYUvAalI3RdVJ22o12e/UBYGZJ5oVCWx+Jp8WEzg==
Date: Sun, 18 Dec 2022 20:29:10 +0100
From: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Subject: Isolating abstract sockets
Message-ID: <Y59qBh9rRDgsIHaj@mailbox.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4SpAY+DyRUPjL6EC"
Content-Disposition: inline
X-MBO-RS-ID: a0bd702a9cf4f698059
X-MBO-RS-META: gqg5ww8xstoc7um9t59atpnpi4saufmh


--4SpAY+DyRUPjL6EC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When building userspace application sandboxes, one issue that does not seem trivial to solve is the isolation of abstract sockets.

While most IPC mechanism can be isolated by mechanisms like mount namespaces, abstract sockets are part of the network namespace.
It is possible to isolate abstract sockets by using a new network namespace, however, unprivileged processes can only create a new empty network namespace, which removes network access as well and makes this useless for network clients.

Same linux sandbox projects try to solve this by bridging the existing network interfaces into the new namespace or use something like slirp4netns to archive this, but this does not look like an ideal solution to this problem, especially since sandboxing should reduce the kernel attack surface without introducing more complexity.

Aside from containers using namespaces, sandbox implementations based on seccomp and landlock would also run into the same problem, since landlock only provides file system isolation and seccomp cannot filter the path argument and therefore it can only be used to block new unix domain socket connections completely.

Currently there does not seem to be any way to disable network namespaces in the kernel without also disabling unix domain sockets.

The question is how to solve the issue of abstract socket isolation in a clean and efficient way, possibly even without namespaces.
What would be the ideal way to implement a mechanism to disable abstract sockets either globally or even better, in the context of a process.
And would such a patch have a realistic chance to make it into the kernel?

- Stefan

--4SpAY+DyRUPjL6EC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEjLwAv8xLYF1doyZLdIuckz2DLQMFAmOfafUACgkQdIuckz2D
LQPBvA/+N4WC1HWkoKk72tdHgduIFCoMS+xXF2H2aCGVUKQ5w5ZsZ3dXmHH1oT4T
smPOQf8yXHLZMriKx/neOcibX99G4Ta9OLXR37UOsz58psMoVXobJN33GuoDpWMx
+2yxVD2AeUNzoUJiRxQI7onDYN786Hdsd+tJP9KHFJ6Uwk3xo8rtpBjOPyaMEWRC
uGy9ljltt5khLAEojdNGyZN64mFj6GdTU6xecHHnN/lA/JYNWyTWIGIxVPp6nny6
doL1QJi/3h6D2sWWdaTiYzIErBmSbWn1OYO+hcEcyIe8HJMpJi+mm6zQ85YkhB1i
zvBc5H9i/7/N0V/9qzCCZ/9yaEimNzGDIAp4DCBDqoqt983EkQTMeqdNEU022L9r
rY9SUHnA+KagrYyk4979/Z9k12B7ldIT+oCqZ5SMQBElV6dVw/SJBq4Uepgc1Z++
wc7FQtz+nlaWib9c0z6GC4jc7BtGV+BHWeoLnTH0xj9nRym/r7HDXD7Xycbwwwne
8CUceP0cdVyd09+Ztd20OTRrMAzxAqacJi54zBm/HYYa0GEXsAP05+fZvC0/pHs1
0l3WHXoxUDNzfrPn7RDnTuTW9c9BJ51xcd9GrKXOb+HN8/eiLXHGZyuLuYp50DLj
A+3xUUIhMJpuRuW3EwQ1rf4S1y9mW01AES01H5rG7WocbeEwyT0=
=Rz8x
-----END PGP SIGNATURE-----

--4SpAY+DyRUPjL6EC--
