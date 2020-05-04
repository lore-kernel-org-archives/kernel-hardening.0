Return-Path: <SRS0=Vr8g=6S=lists.openwall.com=kernel-hardening-return-18710-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4610BC3A5A9
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 16:52:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 89E64206D9
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 16:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uyMa7may"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89E64206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18710-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27780 invoked by uid 550); 4 May 2020 16:52:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27758 invoked from network); 4 May 2020 16:52:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588611155;
	bh=pHevdodwKI9AchWwf20bTvyMZmY/KXT51VAk5UHfloY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uyMa7mayYmQKcwMDm+GOx012e1zqDeyv+W5L6bDtfpKFAZ+E7dHLgSdsy/T09kHTW
	 ixd15enHaJKKfVWzOVcZQBM4JTXKH1eXGREFx5btkK873B8qrSEX32IqtAqg24KSMC
	 y7A6s2xNnFeJRxYbjVN/DbsKn+VXK3WbXoGH2kNQ=
Date: Mon, 4 May 2020 17:52:28 +0100
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 01/12] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20200504165227.GB1833@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck>
 <20200420211830.GA5081@google.com>
 <20200422173938.GA3069@willie-the-truck>
 <20200422235134.GA211149@google.com>
 <202004231121.A13FDA100@keescook>
 <20200424112113.GC21141@willie-the-truck>
 <20200427204546.GA80713@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427204546.GA80713@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Apr 27, 2020 at 01:45:46PM -0700, Sami Tolvanen wrote:
> On Fri, Apr 24, 2020 at 12:21:14PM +0100, Will Deacon wrote:
> > Also, since you mentioned the lack of redzoning, isn't it a bit dodgy
> > allocating blindly out of the kmem_cache? It means we don't have a redzone
> > or a guard page, so if you can trigger something like a recursion bug then
> > could you scribble past the SCS before the main stack overflows? Would this
> > clobber somebody else's SCS?
> 
> I agree that allocating from a kmem_cache isn't ideal for safety. It's a
> compromise to reduce memory overhead.

Do you think it would be a problem if we always allocated a page for the
SCS?

> > The vmap version that I asked Sami to drop
> > is at least better in this regard, although the guard page is at the wrong
> > end of the stack and we just hope that the allocation below us didn't pass
> > VM_NO_GUARD. Looks like the same story for vmap stack :/
> 
> SCS grows up and the guard page is after the allocation, so how is it at
> the wrong end? Am I missing something here?

Sorry, I'd got the SCS upside-down in my head (hey, that second 'S' stands
for 'Stack'!). But I think I'm right about vmap stack, which feels a
little fragile even though it seems to work out today with the very limited
uses of VM_NO_GUARD.

> > If we split the pointer in two (base, offset) then we could leave the
> > base live in the thread_info, not require alignment of the stacks (which
> > may allow for unconditional redzoning?) and then just update the offset
> > value on context switch, which could be trivially checked as part of the
> > existing stack overflow checking on kernel entry.
> 
> I sent out v13 with split pointers, but I'm not sure it's convenient to
> add an overflow check to kernel_ventry where the VMAP_STACK check is
> done. I suppose I could add a check to kernel_entry after we load x18
> from tsk. Thoughts?

I'll take a look at v13, since at this stage I'm keen to get something
queued up so that we can use it as a base for further improvements without
you having to repost the whole stack every time.

Cheers,

Will
