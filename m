Return-Path: <SRS0=ZApm=L5=lists.openwall.com=kernel-hardening-return-21333-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58616C07E99
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Jul 2021 12:52:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 561A46101C
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Jul 2021 12:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 561A46101C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=pm.me
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21333-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13785 invoked by uid 550); 5 Jul 2021 12:52:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13765 invoked from network); 5 Jul 2021 12:52:43 -0000
Date: Mon, 05 Jul 2021 12:52:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
	t=1625489551; bh=dq32cO+ZKMc2KufqrF4+FnLvbFSGJWzWZn6wbfbMESE=;
	h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
	b=cyZj2YMaYNkr4jiUBKyEhByXqRY4GqSUbvRAV4TlzeDS9K+pjTqqqRFwKML2FLT16
	 3pnh/Jd6n8vZxjiE/2ikOgbXPUO74ADH8wp9vQNgQGS8YcYOnZT2GfZa7aDVAYfP9E
	 ccB081e/Cw9bYvnOT640hohJLBOoIV+f6W9FBO8yoKrkEAfqlDIWZCGIca0LqfoJ0v
	 fyBI9AhZtXVH089ReSXOzjAilHRu3lS3drA4AjBp9QTo4Wxrxco81JjkbH50zmlBK0
	 kYf7ZXLXKIZ1EVHlsUELa34VhiLjGcsh5cMy2/yvMjzkN9ylTmagiX/mhxaNzfVkLI
	 gJKCfcSSxJ43w==
To: John Wood <john.wood@gmx.com>
From: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Lobakin <alobakin@pm.me>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Andi Kleen <ak@linux.intel.com>, valdis.kletnieks@vt.edu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v8 3/8] security/brute: Detect a brute force attack
Message-ID: <20210705124446.45320-1-alobakin@pm.me>
In-Reply-To: <20210704140108.GA2742@ubuntu>
References: <20210701234807.50453-1-alobakin@pm.me> <20210702145954.GA4513@ubuntu> <20210702170101.16116-1-alobakin@pm.me> <20210703105928.GA2830@ubuntu> <20210704140108.GA2742@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: John Wood <john.wood@gmx.com>
Date: Sun, 4 Jul 2021 16:01:08 +0200

> On Sat, Jul 03, 2021 at 12:59:28PM +0200, John Wood wrote:
> > Hi,
> >
> > On Fri, Jul 02, 2021 at 05:08:09PM +0000, Alexander Lobakin wrote:
> > >
> > > On the other hand, it leaves a potentional window for attackers to
> > > perform brute force from xattr-incapable filesystems. So at the end
> > > of the day I think that the current implementation (a strong
> > > rejection of such filesystems) is way more secure than having
> > > a fallback I proposed.
> >
> > I've been thinking more about this: that the Brute LSM depends on xattr
> > support and I don't like this part. I want that brute force attacks can
> > be detected and mitigated on every system (with minimal dependencies).
> > So, now I am working in a solution without this drawback. I have some
> > ideas but I need to work on it.
>
> I have been coding and testing a bit my ideas but:
>
> Trying to track the applications faults info using kernel memory ends up
> in an easy to abuse system (denied of service due to large amount of memo=
r=3D
> y
> in use) :(
>
> So, I continue with the v8 idea: xattr to track application crashes info.
>
> > > I'm planning to make a patch which will eliminate such weird rootfs
> > > type selection and just always use more feature-rich tmpfs if it's
> > > compiled in. So, as an alternative, you could add it to your series
> > > as a preparatory change and just add a Kconfig dependency on
> > > CONFIG_TMPFS && CONFIG_TMPFS_XATTR to CONFIG_SECURITY_FORK_BRUTE
> > > without messing with any fallbacks at all.
> > > What do you think?
> >
> > Great. But I hope this patch will not be necessary for Brute LSM :)
>
> My words are no longer valid ;)

Ok, so here's the patch that prefers tmpfs for rootfs over ramfs
if it's built-in (which is true for 99% of systems): [0]

For now it hasn't been reviewed by anyone yet, will see. I'm running
my system with this patch for several days already and there were no
issues with rootfs or Brute so far.

[0] https://lore.kernel.org/lkml/20210702233727.21301-1-alobakin@pm.me/

> Thanks,
> John Wood

Thanks,
Al

