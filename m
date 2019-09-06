Return-Path: <SRS0=2/KP=XB=lists.openwall.com=kernel-hardening-return-16846-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7185BC43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 16:06:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A9CE02070C
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 16:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ssi.gouv.fr header.i=@ssi.gouv.fr header.b="rvdNIvMb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9CE02070C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ssi.gouv.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16846-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3890 invoked by uid 550); 6 Sep 2019 16:06:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3868 invoked from network); 6 Sep 2019 16:06:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
	s=20160407; t=1567785987;
	bh=FwyTlVCqm8aP3xoN7suXSpGig40n/ST/gCqz/6H+pJg=;
	h=Subject:To:CC:References:From:Date:In-Reply-To:From:Subject;
	b=rvdNIvMbXElr2pL5DlaPYCAoEQ4gCJcigMVtxhzkc9XgVjWGP5lDlgpwyRzEDC11D
	 ozsDEfHCHPNwt6IIN/rFneyehInkshXlhaj88Mm7rEZ6fa3os/yGNCRaPfZzGt3Oe0
	 QG1Ercf9tHLDWoaBsG6/ukDLiBPrjB5Myyg4MBP0oz1q31qbtXmyp88E1gnMvKcFw2
	 LvEYL4upJAai1Aciu/tyNFtf0ptWrKOyzgVkh3LWlh6EfljZ3aS6z8I8elg+KYIquS
	 4AEBbUxmUEW87/C2ueqmJvbBNuMEWI5F+APrdwiTW9qYjGwMROhUju0SOQsCZt9+br
	 fhTtuqPfDzn2Q==
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
To: Florian Weimer <fweimer@redhat.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
	<mic@digikod.net>
CC: <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Alexei
 Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy
 Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James
 Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn
	<jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook
	<keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox
	<willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar
	<zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?=
	<philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean
 Christopherson <sean.j.christopherson@intel.com>, Shuah Khan
	<shuah@kernel.org>, Song Liu <songliubraving@fb.com>, Steve Dower
	<steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau
	<thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel
	<vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez
	<yves-alexis.perez@ssi.gouv.fr>, <kernel-hardening@lists.openwall.com>,
	<linux-api@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
References: <20190906152455.22757-1-mic@digikod.net>
 <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Message-ID: <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
Date: Fri, 6 Sep 2019 18:06:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:52.0) Gecko/20100101
 Thunderbird/52.9.0
MIME-Version: 1.0
In-Reply-To: <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 06/09/2019 17:56, Florian Weimer wrote:
> Let's assume I want to add support for this to the glibc dynamic loader,
> while still being able to run on older kernels.
>
> Is it safe to try the open call first, with O_MAYEXEC, and if that fails
> with EINVAL, try again without O_MAYEXEC?

The kernel ignore unknown open(2) flags, so yes, it is safe even for
older kernel to use O_MAYEXEC.

>
> Or do I risk disabling this security feature if I do that?

It is only a security feature if the kernel support it, otherwise it is
a no-op.

>
> Do we need a different way for recognizing kernel support.  (Note that
> we cannot probe paths in /proc for various reasons.)

There is no need to probe for kernel support.

>
> Thanks,
> Florian
>

--
Micka=C3=ABl Sala=C3=BCn

Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=A9=
es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=99ex=
=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=A8re=
nt dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessaire =C3=
=A0 cette relation. Si vous souhaitez faire usage de vos droits de consulta=
tion, de rectification et de suppression de vos donn=C3=A9es, veuillez cont=
acter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message par err=
eur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9diteur e=
t de d=C3=A9truire le message. The personal data collected and processed du=
ring this exchange aims solely at completing a business relationship and is=
 limited to the necessary duration of that relationship. If you wish to use=
 your rights of consultation, rectification and deletion of your data, plea=
se contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message i=
n error, we thank you for informing the sender and destroying the message.
