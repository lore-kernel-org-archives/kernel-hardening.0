Return-Path: <SRS0=v+Fu=XB=lists.openwall.com=kernel-hardening-return-16853-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290F1C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 18:45:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6C6E6208C3
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 18:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2hfBkg1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C6E6208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16853-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1856 invoked by uid 550); 6 Sep 2019 18:45:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15495 invoked from network); 6 Sep 2019 16:49:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567788543;
	bh=xWpSJFUS4h9orrA331aLGvjdzbINh7yeaGYKw2j49vE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=f2hfBkg1hv++7RhCjFnGYFYZ7UpLwMTDlXmWlwYszll17PrezP1cyi1PEEmnh+HNN
	 pnFT3OLPKxEOE5McxRb6hxqaoesj0DEtnoHNAQbAtp1/Ro9WmKNQ4jdHnENi4ZBFiz
	 IKixR/rSalsZdHuMF3yJ3i0ZTpyfCcai5ni0Vlng=
Message-ID: <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
From: Jeff Layton <jlayton@kernel.org>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, 
 Florian Weimer <fweimer@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?=
 <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei
 Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy
 Lutomirski <luto@kernel.org>,  Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang
 <ericchiang@google.com>,  James Morris <jmorris@namei.org>, Jan Kara
 <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett
 <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk
 <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, Philippe
 =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell
 <scottsh@microsoft.com>, Sean Christopherson
 <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, Song Liu
 <songliubraving@fb.com>, Steve Dower <steve.dower@python.org>, Steve Grubb
 <sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez
 <yves-alexis.perez@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org,  linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 06 Sep 2019 12:48:59 -0400
In-Reply-To: <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
References: <20190906152455.22757-1-mic@digikod.net>
	 <20190906152455.22757-2-mic@digikod.net>
	 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
	 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2019-09-06 at 18:06 +0200, Mickaël Salaün wrote:
> On 06/09/2019 17:56, Florian Weimer wrote:
> > Let's assume I want to add support for this to the glibc dynamic loader,
> > while still being able to run on older kernels.
> > 
> > Is it safe to try the open call first, with O_MAYEXEC, and if that fails
> > with EINVAL, try again without O_MAYEXEC?
> 
> The kernel ignore unknown open(2) flags, so yes, it is safe even for
> older kernel to use O_MAYEXEC.
> 

Well...maybe. What about existing programs that are sending down bogus
open flags? Once you turn this on, they may break...or provide a way to
circumvent the protections this gives.

Maybe this should be a new flag that is only usable in the new openat2()
syscall that's still under discussion? That syscall will enforce that
all flags are recognized. You presumably wouldn't need the sysctl if you
went that route too.

Anyone that wants to use this will have to recompile anyway. If the
kernel doesn't support openat2 or if the flag is rejected then you know
that you have no O_MAYEXEC support and can decide what to do.

> > Or do I risk disabling this security feature if I do that?
> 
> It is only a security feature if the kernel support it, otherwise it is
> a no-op.
> 

With a security feature, I think we really want userland to aware of
whether it works.

> > Do we need a different way for recognizing kernel support.  (Note that
> > we cannot probe paths in /proc for various reasons.)
> 
> There is no need to probe for kernel support.
> 
> > Thanks,
> > Florian
> > 
> 
> --
> Mickaël Salaün
> 
> Les données à caractère personnel recueillies et traitées dans le cadre de cet échange, le sont à seule fin d’exécution d’une relation professionnelle et s’opèrent dans cette seule finalité et pour la durée nécessaire à cette relation. Si vous souhaitez faire usage de vos droits de consultation, de rectification et de suppression de vos données, veuillez contacter contact.rgpd@sgdsn.gouv.fr. Si vous avez reçu ce message par erreur, nous vous remercions d’en informer l’expéditeur et de détruire le message. The personal data collected and processed during this exchange aims solely at completing a business relationship and is limited to the necessary duration of that relationship. If you wish to use your rights of consultation, rectification and deletion of your data, please contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message in error, we thank you for informing the sender and destroying the message.

-- 
Jeff Layton <jlayton@kernel.org>

