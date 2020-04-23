Return-Path: <SRS0=EGYC=6H=lists.openwall.com=kernel-hardening-return-18618-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFCDC55191
	for <kernel-hardening@archiver.kernel.org>; Thu, 23 Apr 2020 18:29:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 746D92071C
	for <kernel-hardening@archiver.kernel.org>; Thu, 23 Apr 2020 18:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="b6zdPxuh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 746D92071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18618-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28317 invoked by uid 550); 23 Apr 2020 18:28:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28291 invoked from network); 23 Apr 2020 18:28:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Y/9ITAGgGN1ObZLXZNElUJooxFBQUxzx7tXw0tLGrw=;
        b=b6zdPxuhwvf6mbGggB4PksAI1ex0t7K0elOYcg58ZwrTjn8AjcWwZGTTkOt8xtEop1
         QgJUSGvj+wJ1HD5HRDh4RvxxaMJq6yj8Ef8yIBSVdRMjVYw9bGTWpKc07ah08JcYCbF3
         RdvWKOb7jr8FUoUPlrx507urw3KMBQUv7F7bI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Y/9ITAGgGN1ObZLXZNElUJooxFBQUxzx7tXw0tLGrw=;
        b=NzsefbLPs3s5EmqSd/5w28PWd9Q5Mq2bUZhaZTA6DJ8RKFIqKe7ueaIZJNtChMDfTD
         9k+s8C8q4pkd0mpFPFD99hGjDRebj30YI4a1HYZyWREpdM8n64aBEZNlmqXmglvdTPdK
         X/YmTiBSvKFkJO19eawpxwsi0E4Yl5bPpT4sRIpT9YRczawGLRR0wZFsutO8kZ6Ch67C
         SZ31Tt4HuZH6ZyoN2oqMMIfkRMw7wI9uUziuTfUxaGj+d3jz7jOgm4k+ehDIRpu8jZKV
         A+kPj//8BG0JWscLLeJWqzmWNwGUnhCMpSt/biEN8XwBoTFndPjtv0DOMbfm3GDIcs61
         ngeg==
X-Gm-Message-State: AGi0PuYGWMHVMXgnaXb3ovLCswD67avVhNqtOPiKMLHU6Zd4KEv4A4cM
	CgTFLuZKOybBI6WhC35+I2vLhA==
X-Google-Smtp-Source: APiQypL3X1xlYzw2iOcrrAvDuDiryUSnxNiAeJYrDux+iWD+qj2k8HUN3EnuJVtWslaYhtMemGHUDw==
X-Received: by 2002:a62:1c97:: with SMTP id c145mr5322854pfc.68.1587666522523;
        Thu, 23 Apr 2020 11:28:42 -0700 (PDT)
Date: Thu, 23 Apr 2020 11:28:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
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
Message-ID: <202004231121.A13FDA100@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck>
 <20200420211830.GA5081@google.com>
 <20200422173938.GA3069@willie-the-truck>
 <20200422235134.GA211149@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422235134.GA211149@google.com>

On Wed, Apr 22, 2020 at 04:51:34PM -0700, Sami Tolvanen wrote:
> On Wed, Apr 22, 2020 at 06:39:47PM +0100, Will Deacon wrote:
> > On Mon, Apr 20, 2020 at 02:18:30PM -0700, Sami Tolvanen wrote:
> > > On Mon, Apr 20, 2020 at 06:17:28PM +0100, Will Deacon wrote:
> > > > > +	 * The shadow call stack is aligned to SCS_SIZE, and grows
> > > > > +	 * upwards, so we can mask out the low bits to extract the base
> > > > > +	 * when the task is not running.
> > > > > +	 */
> > > > > +	return (void *)((unsigned long)task_scs(tsk) & ~(SCS_SIZE - 1));
> > > > 
> > > > Could we avoid forcing this alignment it we stored the SCS pointer as a
> > > > (base,offset) pair instead? That might be friendlier on the allocations
> > > > later on.
> > > 
> > > The idea is to avoid storing the current task's shadow stack address in
> > > memory, which is why I would rather not store the base address either.
> > 
> > What I mean is that, instead of storing the current shadow stack pointer,
> > we instead store a base and an offset. We can still clear the base, as you
> > do with the pointer today, and I don't see that the offset is useful to
> > an attacker on its own.
> 
> I see what you mean. However, even if we store the base address +
> the offset, we still need aligned allocation if we want to clear
> the address. This would basically just move __scs_base() logic to
> cpu_switch_to() / scs_save().

Okay, so, I feel like this has gotten off into the weeds, or I'm really
dense (or both). :) Going back to the original comment:

> > > > Could we avoid forcing this alignment it we stored the SCS
> > > > pointer as a (base,offset) pair instead? That might be friendlier
> > > > on the allocations later on.

I think there was some confusion about mixing the "we want to be able to
wipe the value" combined with the masking in __scs_base(). These are
unrelated, as was correctly observed with "We can still clear the base".

What I don't understand here is the suggestion to store two values:

Why is two better than storing one? With one, we only need a single access.

Why would storing the base be "friendlier on the allocations later on"?
This is coming out of a single kmem cache, in 1K chunks. They will be
naturally aligned to 1K (unless redzoing has been turned on for some
slab debugging reason). The base masking is a way to avoid needing to
store two values, and only happens at task death.

Storing two values eats memory for all tasks for seemingly no meaningful
common benefit. What am I missing here?

-- 
Kees Cook
