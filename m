Return-Path: <SRS0=9jbe=37=lists.openwall.com=kernel-hardening-return-17771-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100B8C3B187
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Feb 2020 09:15:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5F37420870
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Feb 2020 09:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="z7P4LQAq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F37420870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17771-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32568 invoked by uid 550); 11 Feb 2020 09:15:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32545 invoked from network); 11 Feb 2020 09:15:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581412494;
	bh=tb46MiN81vH1/UcBBXyXQyevhAUAyIvqCLgT+INhd9c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=z7P4LQAqyhoXtX/Vhz5CyJEfpz7BSlCpxQC/59C45/1y3W4didWfyBso2fKDFJfs4
	 rODuahjFDB1bS/GiXTX+EM0mIhpSdN7Nq+VOxOAYS240eeBnChNGR8X9ofBepUraOd
	 6DmvKlGOaxyK74q62QInJYLX72dwVHAnMQpHk9Jc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Feb 2020 09:14:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, Laura
 Abbott <labbott@redhat.com>, Nick Desaulniers <ndesaulniers@google.com>,
 Jann Horn <jannh@google.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com,
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/11] arm64: disable SCS for hypervisor code
In-Reply-To: <20200210180740.GA24354@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
 <20200128184934.77625-10-samitolvanen@google.com>
 <6f62b3c0-e796-e91c-f53b-23bd80fcb065@arm.com>
 <20200210175214.GA23318@willie-the-truck>
 <20200210180327.GB20840@lakrids.cambridge.arm.com>
 <20200210180740.GA24354@willie-the-truck>
Message-ID: <43839239237869598b79cab90e100127@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, samitolvanen@google.com, catalin.marinas@arm.com, rostedt@goodmis.org, mhiramat@kernel.org, ard.biesheuvel@linaro.org, Dave.Martin@arm.com, keescook@chromium.org, labbott@redhat.com, ndesaulniers@google.com, jannh@google.com, miguel.ojeda.sandonis@gmail.com, yamada.masahiro@socionext.com, clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2020-02-10 18:07, Will Deacon wrote:
> On Mon, Feb 10, 2020 at 06:03:28PM +0000, Mark Rutland wrote:
>> On Mon, Feb 10, 2020 at 05:52:15PM +0000, Will Deacon wrote:
>> > On Mon, Feb 10, 2020 at 05:18:58PM +0000, James Morse wrote:
>> > > On 28/01/2020 18:49, Sami Tolvanen wrote:
>> > > > Filter out CC_FLAGS_SCS and -ffixed-x18 for code that runs at a
>> > > > different exception level.
>> > >
>> > > Hmmm, there are two things being disabled here.
>> > >
>> > > Stashing the lr in memory pointed to by VA won't work transparently at EL2 ... but
>> > > shouldn't KVM's C code still treat x18 as a fixed register?
>> >
>> > My review of v6 suggested dropping the -ffixed-x18 as well, since it's only
>> > introduced by SCS (in patch 5) and so isn't required by anything else. Why
>> > do you think it's needed?
>> 
>> When EL1 code calls up to hyp, it expects x18 to be preserved across 
>> the
>> call, so hyp needs to either preserve it explicitly across a 
>> transitions
>> from/to EL1 or always preserve it.
> 
> I thought we explicitly saved/restored it across the call after
> af12376814a5 ("arm64: kvm: stop treating register x18 as caller save"). 
> Is
> that not sufficient?
> 
>> The latter is easiest since any code used by VHE hyp code will need 
>> x18
>> saved anyway (ans so any common hyp code needs to).
> 
> I would personally prefer to split the VHE and non-VHE code so they can 
> be
> compiled with separate options.

This is going to generate a lot of code duplication (or at least object 
duplication),
as the two code paths are intricately linked and splitting them to 
support different
compilation options and/or calling conventions.

I'm not fundamentally opposed to that, but it should come with ways to 
still
manage it as a unified code base as much as possible, as ways to discard 
the
unused part at runtime (which should become easy to do once we have two
distinct sets of objects).

         M.
-- 
Jazz is not dead. It just smells funny...
