Return-Path: <SRS0=7n81=FQ=lists.openwall.com=kernel-hardening-return-20603-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94260C4361B
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Dec 2020 21:04:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 734EB22507
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Dec 2020 21:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 734EB22507
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mailbox.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20603-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24262 invoked by uid 550); 12 Dec 2020 21:03:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18149 invoked from network); 12 Dec 2020 20:09:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
	content-disposition:content-type:content-type:mime-version
	:message-id:subject:subject:from:from:date:date:received; s=
	mail20150812; t=1607803737; bh=Xj1flQWDOxbxBnPikXPC/e8zX3XcIcAu5
	aIzAelrwZ0=; b=vQpB9GcCnt1xiMvLTq8gEQWuc+MetgUjNp2TAXiBmpEt617C2
	Pyoj9nHeRHSNEu371rnJWnLe6qAvFIF7c2cc9WIfjmJ9wRRm0iGMYnqBPVPajJlC
	gM+DiwOhJaNRrmMfMXSh2mIWgP+AV5JPD8GYburFkL+vtRjL6ytG3vjIHJVO2MHW
	ENCxA772AyFn3ncZ2baqkUnZx8L2ILrEAPY/sJk2qAaXKC79Y/Zxj4QEsXumlmk0
	E7WysGbsboxfmtQAg9M/xHkfBREy10ArUa8asvrEiLPza+TJ2o4YqUG4sbuYmgrr
	439lYpANzR0UKFrbpd4aosshixofHJCjSggAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1607803738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=KqOHX2iNaWVc1HNxhPsUJUeXa937LGzwzA/nNt4AW6A=;
	b=b4bvEpnIhkP/Wxo5Px9TIAepoM5DVx79599hPVduaw0AXOw3ygyyw63Y7x5fQ+Pj5cV83o
	S0X2PZ3vxK0ieEP0jJKOKEb3v0vcoCmCFWmhb58Hx0pgTDoeCTZ3EfLSwkKLKs+zdSrEPh
	bpibBq+dm/NaAbkeNgyyl0R6spnwU8eOquOoCi1T/3lHZvgJXUOus9fFdd6vWDljEN0OR2
	vwrVsV/zPHFDt826aSxHkpVsuJMppEsq95+VEFWkh9uBcuLe3B6T/bTAxhWfPjTlYtGoYX
	o5rYAzihWN12ONKHD65dHp4b+8/Y3InhrxxnMGMOXEFsK3gQvgH+EYgzr+jy/g==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date: Sat, 12 Dec 2020 21:08:52 +0100
From: stefan.bavendiek@mailbox.org
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Subject: Kernel complexity
Message-ID: <X9UjVOuTgwuQwfFk@mailbox.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3r6ooBtApSUnPmvJ"
Content-Disposition: inline
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.41 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3E03D17F6
X-Rspamd-UID: a6f645


--3r6ooBtApSUnPmvJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

first of all, thanks to everyone here for this awesome project and the work=
 you do.

Personally I am interested in Linux Kernel Security and especially features=
 supporting attack surface reduction. In the past I did some work on sandbo=
xing features like seccomp support in user space applications. I have been =
rather hesitant to get involved here, since I am not a full time developer =
and certainly not an expert in C programming.=20

However I am currently doing a research project that aims to identify risk =
areas in the kernel by measuring code complexity metrics and assuming this =
might help this project, I would like to ask for some feedback in case this=
 work can actually help with this project.

My approach is basically to take a look at the different system calls and m=
easure the complexity of the code involved in their execution. Since code c=
omplexity has already been found to have a strong correlation with the prob=
ability of existing vulnerabilities, this might indicate kernel areas that =
need a closer look.
Additionally the functionality of the syscall will also be considered for a=
 final risk score, although most of the work for this part has already been=
 done in [1].
The objective is to create a risk score matrix for linux syscalls that cons=
ists of the functionality risk according to [1], times the measured complex=
ity.
This will (hopefully) be helpful to identify risk areas in the kernel and p=
rovide user space developers with an measurement that can help design secur=
e software and sandboxing features.  =20


One major aspect I am still not sure about is the challenges regarding the =
dynamic measure of code path execution. While it is possible to measure the=
 cyclomatic complexity of the kernel code with existing tools, I am not sur=
e how much value the results would have, given that this does not include t=
he dynamic code path behind each syscall. I was thinking of using ftrace to=
 follow and measure the execution path. Any feedback and advise on this for=
 this would be appreciated.


-- Stefan

Ref.
[1] Massimo Bernaschi, Emanuele Gabrielli, and Luigi Mancini. Remus: A secu=
rity-enhanced Operating system (2002)

--3r6ooBtApSUnPmvJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAABCAAdFiEEjLwAv8xLYF1doyZLdIuckz2DLQMFAl/VI0QACgkQdIuckz2D
LQPn8Q/1HuBDyaFgYUI8+JlTtSr7iSR8jOAKYrG3AE3KPeAgmBIHRtI/ygwREX1v
KE+xqJcptnWMrRFUNY82wsCXVYmakNvLoiM0YTaBnFb1IKutN2HgtoRZtkr6RS0e
/mPrnai4vTl4FCtrFWFv43wqXzbOyiq7FYbcI+RV6+rfZ5N9Gpu6IFDgQCdq4VWG
DbybZILiktZ8sYQgskx2/gkXkx1kElbD1UltU4VsElUtPGih2Ax8nKynDAt+Z/XT
Wb9mRVmH+nHkznh6VqYh9Ulh0Qpl0HIbOtFVL/ie8PDsBIYxjVx2V+yKacxx2kfO
YENZBYFL0JVYfbi5hDlXVkGN/r3tpB+z6Zk5Sf/IagR5oQdAJVlsl+48JEAFwwVI
U2V5bkyNAKDyzYJivPPyYVLsWME/L4D7sm7Fc/CbsG2J4hSbyHhkwilXaSRD9if+
7hXwYHMkpnSKU3H3tV+cu9WIgxxuiBbovpUqGlAhRprc2it9rT8owlh5mSgc06ib
kzr/1N1BPO8tAEJfstrUigkuIUwQDwTY9P1ZVhtdW3lE1Uamea0r9RXkxW8kqb18
BXKfVA20tmi6nie5ZlHtxavZqPEJaixhi0BM3t8+wRgWKPgZvUF2cMnqmNuAJFUP
hGflZw/1HLAm7+62Z9A3/I1zF5S+Rk4WmrbpJXFBxSRlVpHXAw==
=236y
-----END PGP SIGNATURE-----

--3r6ooBtApSUnPmvJ--
