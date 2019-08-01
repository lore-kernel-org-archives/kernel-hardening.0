Return-Path: <SRS0=peLf=V5=lists.openwall.com=kernel-hardening-return-16688-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85FBC19759
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 17:49:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 168B32087E
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 17:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w0gH11WS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 168B32087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16688-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11313 invoked by uid 550); 1 Aug 2019 17:49:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11281 invoked from network); 1 Aug 2019 17:49:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/wQ1T27awT3hqgJbloxgvOfdBCqajpO4xm94w+4G9Do=; b=w0gH11WScMc6U6c0/193f4lVGY
	pJ5Va3+tj/TSEWluBZbB3EsZdE+5fi40Hd7sR4n8NRx+T69RBSZmHZ/UoJHMHoQqhP0bN7L7xwpnd
	PnyuEOEWkSHWMDK4bwLVQOrsAZuYdJkbpUohRpAB/vTiDgEeNENBjcpfppf159WsUPFbRzRBYdiS2
	B4yBu2ZX/XwmYyMam1kq+dPc+qgHtzng5hOraEFbZeQWxzCZ5ytD4CBej0CrS8EFW10k3lit3r5ul
	1VLKt68FO3Nz279TNa/NMYzQtnkvCu2SBByGuhcqnupvhyqUPFTBrEug8bQuR/lE/4Arfluds3QCk
	VKAOrv0w==;
Subject: Re: [PATCH bpf-next v10 10/10] landlock: Add user and kernel
 documentation for Landlock
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Drysdale
 <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>,
 "Eric W . Biederman" <ebiederm@xmission.com>,
 James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
 John Johansen <john.johansen@canonical.com>, Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>,
 Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
 Tejun Heo <tj@kernel.org>, Tetsuo Handa
 <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Graf <tgraf@suug.ch>,
 Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 netdev@vger.kernel.org
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-11-mic@digikod.net>
 <88e90c22-1b78-c2f2-8823-fa776265361c@infradead.org>
 <2ced8fc8-79a6-b0fb-70fe-6716fae92aa7@ssi.gouv.fr>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <08c94f99-68e0-4866-3eba-28fa71347fca@infradead.org>
Date: Thu, 1 Aug 2019 10:49:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2ced8fc8-79a6-b0fb-70fe-6716fae92aa7@ssi.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 8/1/19 10:03 AM, Mickaël Salaün wrote:
>>> +Ptrace restrictions
>>> +-------------------
>>> +
>>> +A landlocked process has less privileges than a non-landlocked process and must
>>> +then be subject to additional restrictions when manipulating another process.
>>> +To be allowed to use :manpage:`ptrace(2)` and related syscalls on a target
>>> +process, a landlocked process must have a subset of the target process programs.
>>             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> Maybe that last statement is correct, but it seems to me that it is missing something.
> What about this:
> 
> To be allowed to trace a process (using :manpage:`ptrace(2)`), a
> landlocked tracer process must only be constrained by a subset (possibly
> empty) of the Landlock programs which are also applied to the tracee.
> This ensure that the tracer has less or the same constraints than the

       ensures

> tracee, hence protecting against privilege escalation.

Yes, better.  Thanks.


-- 
~Randy
