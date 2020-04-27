Return-Path: <SRS0=QE4H=6L=lists.openwall.com=kernel-hardening-return-18658-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BC6C4CECC
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 20:46:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C8B672070B
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 20:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vr00ZiG5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8B672070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18658-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28525 invoked by uid 550); 27 Apr 2020 20:46:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28502 invoked from network); 27 Apr 2020 20:46:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bcag0IOMjkeMKf6Qdaig8RmUgJulOZ6Dwcg/kc7mWuw=;
        b=vr00ZiG50BbHCZgiGhKzUig8ebmcxwNyAuSZDS9Fy9++/+lBSJLPHB5VE0jqKA8VVp
         g5hGQKYr39R1dLfLNK2DxhYc//BK+yuzOcm5KbUsvU99ovE352pXh2+A8+7w7icg/xqJ
         RQwcjXxsQigIv1hDNScho2GwzEDFZfzHHQaRH/4pVYxLOayrJSWaOEVPwPB4xxrhdIoU
         RiQO1uExeEqZgKgR01+xq+u4cWEz7Wt1sbzS+NfXx7/JhBbJnsVGfWrstDJ129Ge1XMZ
         SuSTWs1W3SCWz53yl1fhzUC1dT7hlEqmdxcZgxuyk4Ah4zyhUKRpkoeUu5rKpqLSHkg7
         Q6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bcag0IOMjkeMKf6Qdaig8RmUgJulOZ6Dwcg/kc7mWuw=;
        b=iKJJBpL+d0qNUotKNXnd1yIrN52IX+bX2gcGYHfvCF/6Ma9y5BspkhzasRG9CyktKO
         wNWN0mOfi4cGZmErTtuBDqL4eb4LxYq1MAQE3MGUTBYgs679W8FWJNP2cmSYVj7MB4Gr
         5cyIIHU8nmUIPBb+kU0ZyjKXGHAbso+97oXkbn6DhOi3BoGr4IJ6HDfMSZpeLSgQ7ALV
         R1zN3G7y3tDZrJxgpmcyO5VH4xmBXbLJ92v8IvI3WU2ZaUuRUZA5LrTC6udubnxlehdW
         m29Clyaf9zYiWYJ+NZYac0gmTZgGmk7nZ2wrUgWBFhJwVqa6kA1sFd2nXlHuB3FTATDI
         FyUw==
X-Gm-Message-State: AGi0PuZuZ80gDfAGoxGS4B+NjFRK8GzmeZS2OTSAcVj+Efq5YUtjj0vN
	kCpWSFXgP15UMAuaSMOH8vvtEw==
X-Google-Smtp-Source: APiQypIdmfjwcDuAuA2SB4pP8kr68I93NPWhf6BxSPVcCeqZMEvirYIWHKdGIJ3TN8iKQ9IKNzr4sA==
X-Received: by 2002:aa7:9218:: with SMTP id 24mr25789630pfo.312.1588020353394;
        Mon, 27 Apr 2020 13:45:53 -0700 (PDT)
Date: Mon, 27 Apr 2020 13:45:46 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>
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
Message-ID: <20200427204546.GA80713@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck>
 <20200420211830.GA5081@google.com>
 <20200422173938.GA3069@willie-the-truck>
 <20200422235134.GA211149@google.com>
 <202004231121.A13FDA100@keescook>
 <20200424112113.GC21141@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424112113.GC21141@willie-the-truck>

On Fri, Apr 24, 2020 at 12:21:14PM +0100, Will Deacon wrote:
> Also, since you mentioned the lack of redzoning, isn't it a bit dodgy
> allocating blindly out of the kmem_cache? It means we don't have a redzone
> or a guard page, so if you can trigger something like a recursion bug then
> could you scribble past the SCS before the main stack overflows? Would this
> clobber somebody else's SCS?

I agree that allocating from a kmem_cache isn't ideal for safety. It's a
compromise to reduce memory overhead.

> The vmap version that I asked Sami to drop
> is at least better in this regard, although the guard page is at the wrong
> end of the stack and we just hope that the allocation below us didn't pass
> VM_NO_GUARD. Looks like the same story for vmap stack :/

SCS grows up and the guard page is after the allocation, so how is it at
the wrong end? Am I missing something here?

> If we split the pointer in two (base, offset) then we could leave the
> base live in the thread_info, not require alignment of the stacks (which
> may allow for unconditional redzoning?) and then just update the offset
> value on context switch, which could be trivially checked as part of the
> existing stack overflow checking on kernel entry.

I sent out v13 with split pointers, but I'm not sure it's convenient to
add an overflow check to kernel_ventry where the VMAP_STACK check is
done. I suppose I could add a check to kernel_entry after we load x18
from tsk. Thoughts?

Sami
