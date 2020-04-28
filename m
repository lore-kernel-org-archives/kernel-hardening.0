Return-Path: <SRS0=myW0=6M=lists.openwall.com=kernel-hardening-return-18668-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DBAC83000
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Apr 2020 22:02:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D077B206D6
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Apr 2020 22:02:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nb6/Li2p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D077B206D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18668-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15597 invoked by uid 550); 28 Apr 2020 22:02:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15577 invoked from network); 28 Apr 2020 22:02:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qgsuGKbVjYSeRuT0TDuIXexAYzlpaF3ybirX/bZdq/M=;
        b=Nb6/Li2pKgIuauzZc2N7D4986KwsAReiq+tNfzAVNQVdh/FoY66ln1u7c/OYs5nAIQ
         5UN/eOvHcUkIcP4q9blPXT94fH+WWdxswwCB5DKULdEHPi1YqR1dvk2z6PvlWWeAQAcm
         wQwwSDA8HHbq+YgMhNTWRBM/CImHC0LY9UotCwM0UgXh0tABr3MbTh+50pfQ0KbVJKi8
         cg4w5xhIpzuG6Bd892VjlS1HnODoa4vjODLOrKsg/dV5ZzXRX6o13x78TwXT7LaG0BJE
         xgEIremOXnl4KN3PAUhl/lbPEuA27Zm/tMJk1F0bDyX0J3fzcmWjvKcuxbldGRhUrvwA
         AVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qgsuGKbVjYSeRuT0TDuIXexAYzlpaF3ybirX/bZdq/M=;
        b=XMYUBKCZUZyWIKvdy0Knok8D3M+5TqeB1yM2yBwW/yEye+Vjs2roWHEvk++mflcmuH
         V/TLBwsiSEZT9gvl+Whwbjnphi3/Iyd1msgsiJ8UcbMPuXh8oMfFlaPqaYgWyY58cjMm
         qZk88CfV/D3YI3Aa/dn8cvr99JvESj0dFgO4BIP+C+rbxnAcHG9mMwvF5vVsUiNLK3ok
         DKHb8jsexi0MMcaUhVjdUQ8JTORMpP2TqZAa/g4GxhLAM/akxasR8psiA5yTzxVJQUsn
         tlR13HlpTlf6BucoGMsD00wMuKQcLYoX0B4x8+LzAfV6OLTaxuSLVCDdr6bXc+l35xCC
         DLoQ==
X-Gm-Message-State: AGi0PuZFNWeyFecQAUETIpqrorX6qvfUcrXW3biJ8EwqX05SgALhDaCd
	B9IQKUirBgaJRgLv0lDp32PnEVxh5Z0RK+TbPbbekQ==
X-Google-Smtp-Source: APiQypK6ydV759YI7StmjgOVJfSU2MfnmxevWP+lyXRgv9iMHdwfQp34+B8t21gh6ZdagByaUv/XhQqYXuOXjfVzfUY=
X-Received: by 2002:a2e:b249:: with SMTP id n9mr18998872ljm.221.1588111324730;
 Tue, 28 Apr 2020 15:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200428175129.634352-1-mic@digikod.net> <CAG48ez1bKzh1YvbD_Lcg0AbMCH_cdZmrRRumU7UCJL=qPwNFpQ@mail.gmail.com>
 <87blnb48a3.fsf@mid.deneb.enyo.de>
In-Reply-To: <87blnb48a3.fsf@mid.deneb.enyo.de>
From: Jann Horn <jannh@google.com>
Date: Wed, 29 Apr 2020 00:01:38 +0200
Message-ID: <CAG48ez2TphTj-VdDaSjvnr0Q8BhNmT3n86xYz4bF3wRJmAMsMw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add support for RESOLVE_MAYEXEC
To: Florian Weimer <fw@deneb.enyo.de>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	kernel list <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Deven Bowers <deven.desai@linux.microsoft.com>, 
	Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2020 at 11:21 PM Florian Weimer <fw@deneb.enyo.de> wrote:
> * Jann Horn:
>
> > Just as a comment: You'd probably also have to use RESOLVE_MAYEXEC in
> > the dynamic linker.
>
> Absolutely.  In typical configurations, the kernel does not enforce
> that executable mappings must be backed by files which are executable.
> It's most obvious with using an explicit loader invocation to run
> executables on noexec mounts.  RESOLVE_MAYEXEC is much more useful
> than trying to reimplement the kernel permission checks (or what some
> believe they should be) in userspace.

Oh, good point.

That actually seems like something Micka=C3=ABl could add to his series? If
someone turns on that knob for "When an interpreter wants to execute
something, enforce that we have execute access to it", they probably
also don't want it to be possible to just map files as executable? So
perhaps when that flag is on, the kernel should either refuse to map
anything as executable if it wasn't opened with RESOLVE_MAYEXEC or
(less strict) if RESOLVE_MAYEXEC wasn't used, print a warning, then
check whether the file is executable and bail out if not?

A configuration where interpreters verify that scripts are executable,
but other things can just mmap executable pages, seems kinda
inconsistent...
