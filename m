Return-Path: <kernel-hardening-return-21535-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 4D314C433FE
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Jan 2022 21:57:49 +0000 (UTC)
Received: (qmail 12095 invoked by uid 550); 13 Jan 2022 21:57:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12075 invoked from network); 13 Jan 2022 21:57:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642111050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TMX/kWIlUA1AE1kmxxn6oC9JgTpebsg3ohbjH9GEsvI=;
	b=Pzzp/ruRU7iKZbOx1eaGwMakGi+EswA1NlTeCsjrEnAjJErFmfUCdH8QrkkUF4MOM0nsFk
	5rVikFRoswC++s8on2sDD3ioJZRpY3lfXVdu5XwL9CUAtmIBAD0n3l6ZQaHpNh+UGhDvai
	AEGaNk8F6hScToBj9/7ODWtqEHHv8pI=
X-MC-Unique: L8FNEgkdMraDDmpSMaBG_A-1
From: Florian Weimer <fweimer@redhat.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,  Linux API <linux-api@vger.kernel.org>,
  linux-x86_64@vger.kernel.org,  kernel-hardening@lists.openwall.com,
  linux-mm@kvack.org,  the arch/x86 maintainers <x86@kernel.org>,
  musl@lists.openwall.com,  libc-alpha@sourceware.org,
  linux-kernel@vger.kernel.org,  Dave Hansen <dave.hansen@intel.com>,  Kees
 Cook <keescook@chromium.org>,  Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v3 3/3] x86: Add test for arch_prctl(ARCH_VSYSCALL_CONTROL)
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
	<54ae0e1f8928160c1c4120263ea21c8133aa3ec4.1641398395.git.fweimer@redhat.com>
	<564ba9d6b8f88d139be556d039aadb4b8e078eba.1641398395.git.fweimer@redhat.com>
	<4db8cff9-8bf8-0c45-6956-4b1b19b53b2f@kernel.org>
Date: Thu, 13 Jan 2022 22:57:20 +0100
In-Reply-To: <4db8cff9-8bf8-0c45-6956-4b1b19b53b2f@kernel.org> (Andy
	Lutomirski's message of "Thu, 13 Jan 2022 13:31:04 -0800")
Message-ID: <87pmovxprz.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

* Andy Lutomirski:

> On 1/5/22 08:03, Florian Weimer wrote:
>> Signed-off-by: Florian Weimer <fweimer@redhat.com>
>
> This seems like a respectable test case, but why does it work so hard
> to avoid using libc?

Back when this was still a true lockout and not a toggle, it was
necessary to bypass the startup code, so that the test still works once
the (g)libc startup starts activating the lockout.  The /proc mounting
is there to support running as init in a VM (which makes development so
much easier).

I could ditch the /proc mounting, perform some limited data gathering in
a pre-_start routine, undo a potential lockout before the tests, and
then use libc functions for the actual test.  It would probably be a bit
less code (printf is nice), but I'd probably have to use direct system
calls for the early data gathering anyway, so those parts would still be
there.

Thanks,
Florian

