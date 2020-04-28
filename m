Return-Path: <SRS0=V7f6=6N=lists.openwall.com=kernel-hardening-return-18680-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960CAC83003
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 10:11:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F186B2074A
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 10:11:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F186B2074A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=deneb.enyo.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18680-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29750 invoked by uid 550); 29 Apr 2020 10:11:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3541 invoked from network); 28 Apr 2020 21:22:26 -0000
From: Florian Weimer <fw@deneb.enyo.de>
To: Jann Horn <jannh@google.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,  kernel list
 <linux-kernel@vger.kernel.org>,  Aleksa Sarai <cyphar@cyphar.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,  Andy
 Lutomirski <luto@kernel.org>,  Christian Heimes <christian@python.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Deven Bowers
 <deven.desai@linux.microsoft.com>,  Eric Chiang <ericchiang@google.com>,
    James Morris <jmorris@namei.org>,  Jan Kara <jack@suse.cz>,  Jonathan
 Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Matthew
 Garrett <mjg59@google.com>,  Matthew Wilcox <willy@infradead.org>,
  Michael Kerrisk <mtk.manpages@gmail.com>,  =?iso-8859-1?Q?Micka=EBl_Sala?=
 =?iso-8859-1?Q?=FCn?=
 <mickael.salaun@ssi.gouv.fr>,  Mimi Zohar <zohar@linux.ibm.com>,  Philippe
 =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Steve
 Dower <steve.dower@python.org>,  Steve Grubb <sgrubb@redhat.com>,  Thibaut
 Sautereau <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Kernel Hardening
 <kernel-hardening@lists.openwall.com>,  Linux API
 <linux-api@vger.kernel.org>,  linux-security-module
 <linux-security-module@vger.kernel.org>,  linux-fsdevel
 <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] Add support for RESOLVE_MAYEXEC
References: <20200428175129.634352-1-mic@digikod.net>
	<CAG48ez1bKzh1YvbD_Lcg0AbMCH_cdZmrRRumU7UCJL=qPwNFpQ@mail.gmail.com>
Date: Tue, 28 Apr 2020 23:20:20 +0200
In-Reply-To: <CAG48ez1bKzh1YvbD_Lcg0AbMCH_cdZmrRRumU7UCJL=qPwNFpQ@mail.gmail.com>
	(Jann Horn's message of "Tue, 28 Apr 2020 21:21:48 +0200")
Message-ID: <87blnb48a3.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain

* Jann Horn:

> Just as a comment: You'd probably also have to use RESOLVE_MAYEXEC in
> the dynamic linker.

Absolutely.  In typical configurations, the kernel does not enforce
that executable mappings must be backed by files which are executable.
It's most obvious with using an explicit loader invocation to run
executables on noexec mounts.  RESOLVE_MAYEXEC is much more useful
than trying to reimplement the kernel permission checks (or what some
believe they should be) in userspace.
