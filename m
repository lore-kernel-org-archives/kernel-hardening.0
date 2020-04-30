Return-Path: <SRS0=CqoW=6O=lists.openwall.com=kernel-hardening-return-18681-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF49C83000
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Apr 2020 01:55:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B9C702083B
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Apr 2020 01:55:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9C702083B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cyphar.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18681-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31923 invoked by uid 550); 30 Apr 2020 01:55:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31897 invoked from network); 30 Apr 2020 01:55:07 -0000
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date: Thu, 30 Apr 2020 11:54:29 +1000
From: Aleksa Sarai <cyphar@cyphar.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Add support for RESOLVE_MAYEXEC
Message-ID: <20200430015429.wuob7m5ofdewubui@yavin.dot.cyphar.com>
References: <20200428175129.634352-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="udruashf3djnhxyp"
Content-Disposition: inline
In-Reply-To: <20200428175129.634352-1-mic@digikod.net>
X-Rspamd-Queue-Id: 185431774
X-Rspamd-Score: -5.53 / 15.00 / 15.00


--udruashf3djnhxyp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-04-28, Micka=EBl Sala=FCn <mic@digikod.net> wrote:
> The goal of this patch series is to enable to control script execution
> with interpreters help.  A new RESOLVE_MAYEXEC flag, usable through
> openat2(2), is added to enable userspace script interpreter to delegate
> to the kernel (and thus the system security policy) the permission to
> interpret/execute scripts or other files containing what can be seen as
> commands.
>=20
> This third patch series mainly differ from the previous one by relying
> on the new openat2(2) system call to get rid of the undefined behavior
> of the open(2) flags.  Thus, the previous O_MAYEXEC flag is now replaced
> with the new RESOLVE_MAYEXEC flag and benefits from the openat2(2)
> strict check of this kind of flags.

My only strong upfront objection is with this being a RESOLVE_ flag.

RESOLVE_ flags have a specific meaning (they generally apply to all
components, and affect the rules of path resolution). RESOLVE_MAYEXEC
does neither of these things and so seems out of place among the other
RESOLVE_ flags.

I would argue this should be an O_ flag, but not supported for the
old-style open(2). This is what the O_SPECIFIC_FD patchset does[1] and I
think it's a reasonable way of solving such problems.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--udruashf3djnhxyp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXqov0QAKCRCdlLljIbnQ
Es1XAP4pdpkX/auZ9BMKqDz4Q71lNx9hZ2pPWO2GKtz3HxWg3QD/d346yEY1nSmz
4QrB06Se4f0JFMG5Fy1QoGIpSoBx+Qk=
=DOB3
-----END PGP SIGNATURE-----

--udruashf3djnhxyp--
