Return-Path: <SRS0=M6XA=6S=lists.openwall.com=kernel-hardening-return-18713-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302B1C47258
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 18:06:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 804C02075A
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 18:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VfjjNs3D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 804C02075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18713-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7936 invoked by uid 550); 4 May 2020 18:06:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7913 invoked from network); 4 May 2020 18:06:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5H5y0GT0IX1bjv46W43wTOmcN/3DzOsesayYr+f385c=;
        b=VfjjNs3D1ejtb+5tDVnv4xIxeWbWw/o38mrHwOZ5Gwkc82EKTZ7pb9asTgtjF5BOl5
         Zqs4vbc5AMjqxgNOipERymQfeg78d3WB44sQWSCPyzc8fjFCFil4qhPuqg1dVU2c7TEV
         A6XlZfrUYCmdVmssHy2yO3uNUZUiSM/Gfc3ko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5H5y0GT0IX1bjv46W43wTOmcN/3DzOsesayYr+f385c=;
        b=PAnR2oS5p4sk5JtPZ0VTWvKOUr8tfEQrC1fxjvsa8fwcJF03pYWK6G4+nu9xkSH0oz
         A7x2ro4TcYBaTmWvZqrfst9Uac8SKZXv8EzXCF5HT83G/ZQZO3otU5b+DjiFlAMGsDLg
         MTRf/KvMDT2kO9MbJy/gS2FIlpxWtkSOHzqUWUOQHNOcALxBZE/BL4aQHRac8WJ8tj7/
         ByMnKzIfPYs4FJJJuJtZUDHCQrYt+AN6bM7pYI/M1ki2dMyX7puEcfoHUatTiasG6iu/
         GL99uunUgGVNY1qN+BDCL78floRdLV/UQBgCCcHZEF/mWR212961i8iKgifbh2Tv3cMZ
         gLdQ==
X-Gm-Message-State: AGi0PuYvq5qi9jX9JVmviFcFaYVBqi5oLyIVp93gB7S8FCuO2NyYzAGE
	nVfXFdJQDiWb44UhwsuA7PeEFQ==
X-Google-Smtp-Source: APiQypIlcStIRBl6cHaGQp3N0+X9MfO14Oi4jnSZEiTTEcv+6ntBV7uerro/crzxcPaqm3zz3v5luA==
X-Received: by 2002:a65:4c83:: with SMTP id m3mr201796pgt.128.1588615568087;
        Mon, 04 May 2020 11:06:08 -0700 (PDT)
Date: Mon, 4 May 2020 11:06:06 -0700
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
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
Message-ID: <202005041050.7E29A56637@keescook>
References: <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck>
 <20200420211830.GA5081@google.com>
 <20200422173938.GA3069@willie-the-truck>
 <20200422235134.GA211149@google.com>
 <202004231121.A13FDA100@keescook>
 <20200424112113.GC21141@willie-the-truck>
 <20200427204546.GA80713@google.com>
 <20200504165227.GB1833@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504165227.GB1833@willie-the-truck>

On Mon, May 04, 2020 at 05:52:28PM +0100, Will Deacon wrote:
> On Mon, Apr 27, 2020 at 01:45:46PM -0700, Sami Tolvanen wrote:
> > On Fri, Apr 24, 2020 at 12:21:14PM +0100, Will Deacon wrote:
> > > The vmap version that I asked Sami to drop
> > > is at least better in this regard, although the guard page is at the wrong
> > > end of the stack and we just hope that the allocation below us didn't pass
> > > VM_NO_GUARD. Looks like the same story for vmap stack :/
> > 
> > SCS grows up and the guard page is after the allocation, so how is it at
> > the wrong end? Am I missing something here?
> 
> Sorry, I'd got the SCS upside-down in my head (hey, that second 'S' stands
> for 'Stack'!). But I think I'm right about vmap stack, which feels a
> little fragile even though it seems to work out today with the very limited
> uses of VM_NO_GUARD.

Yeah, when VMAP_STACK was originally being developed, IIRC, there was
an effort made to eliminate all the users of VM_NO_GUARD, and it looks
like it's mostly there. Really the only use left is arm64's kernel image
mapping routines, and then it's not actually used in the traditional
sense -- it's just a boolean for whether to toss in a guard page at the
end of the data section, and the VMAs are built manually. I think that
code could actually be refactored to drop it too and then the only user
would be KASAN, which, IIUC, wants to build consecutive vmap areas.

-- 
Kees Cook
