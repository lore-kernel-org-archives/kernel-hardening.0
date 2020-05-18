Return-Path: <SRS0=Hqxs=7A=lists.openwall.com=kernel-hardening-return-18826-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88719C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 May 2020 07:27:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DB51D207D8
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 May 2020 07:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxwDHCZ+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB51D207D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18826-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9684 invoked by uid 550); 18 May 2020 07:27:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9658 invoked from network); 18 May 2020 07:27:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1589786814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b/DaoBS5+cv0POCp9ooXqRzsTuOXn2M8MJgW8T9wUD0=;
	b=CxwDHCZ+31/rHf5KGQE7TxPXxDvXGm1R1Xh1RyIw78bafb9YU8sSe+1+HaB/DHMYyb6+Nu
	L9j4BWqbC8FjhQ+wzMADqGbRzrWBhOFL4dt6vWguOP+HE5fACh+DgCqjXsxs247YT2qr0P
	eEHsN1NZpYPwSu7sUltTD414IHUdZjM=
X-MC-Unique: dXOuRvKLNjK0fPagzimQ0g-1
From: Florian Weimer <fweimer@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,  Al Viro
 <viro@zeniv.linux.org.uk>,
  Aleksa Sarai <cyphar@cyphar.com>,  Andy Lutomirski <luto@kernel.org>,
  Mimi Zohar <zohar@linux.ibm.com>,  Stephen Smalley
 <stephen.smalley.work@gmail.com>,  Christian Heimes
 <christian@python.org>,  Deven Bowers <deven.desai@linux.microsoft.com>,
  Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,  John Johansen
 <john.johansen@canonical.com>,  Kentaro Takeda <takedakn@nttdata.co.jp>,
  "Lev R. Oshvang ." <levonshe@gmail.com>,  Alexei Starovoitov
 <ast@kernel.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Eric Chiang
 <ericchiang@google.com>,  James Morris <jmorris@namei.org>,  Jan Kara
 <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
  Matthew Garrett <mjg59@google.com>,  Matthew Wilcox
 <willy@infradead.org>,  Michael Kerrisk <mtk.manpages@gmail.com>,
  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
  Philippe =?utf-8?Q?Tr=C3=A9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell <scottsh@microsoft.com>,
  Sean Christopherson <sean.j.christopherson@intel.com>,  Shuah Khan
 <shuah@kernel.org>,  Steve Dower <steve.dower@python.org>,  Steve Grubb
 <sgrubb@redhat.com>,  Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
  Vincent Strubel <vincent.strubel@ssi.gouv.fr>,  linux-kernel
 <linux-kernel@vger.kernel.org>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-integrity@vger.kernel.org,  LSM List
 <linux-security-module@vger.kernel.org>,  Linux FS Devel
 <linux-fsdevel@vger.kernel.org>
Subject: Re: How about just O_EXEC? (was Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec through O_MAYEXEC)
References: <202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
	<CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>
	<202005140830.2475344F86@keescook>
	<CAEjxPJ4R_juwvRbKiCg5OGuhAi1ZuVytK4fKCDT_kT6VKc8iRg@mail.gmail.com>
	<b740d658-a2da-5773-7a10-59a0ca52ac6b@digikod.net>
	<202005142343.D580850@keescook>
	<87a729wpu1.fsf@oldenburg2.str.redhat.com>
	<202005150732.17C5EE0@keescook>
	<87r1vluuli.fsf@oldenburg2.str.redhat.com>
	<202005150847.2B1ED8F81@keescook>
Date: Mon, 18 May 2020 09:26:34 +0200
In-Reply-To: <202005150847.2B1ED8F81@keescook> (Kees Cook's message of "Fri,
	15 May 2020 08:50:16 -0700")
Message-ID: <87ftbxg0ut.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

* Kees Cook:

> I think I misunderstood what you meant (Micka=C3=83=C2=ABl got me sorted =
out
> now). If O_EXEC is already meant to be "EXEC and _not_ READ nor WRITE",
> then yes, this new flag can't be O_EXEC. I was reading the glibc
> documentation (which treats it as a permission bit flag, not POSIX,
> which treats it as a complete mode description).

I see.  I think this part of the manual is actually very Hurd-specific
(before the O_ACCMODE description).  I'll see if I can make this clearer
in the markup.

Thanks,
Florian

