Return-Path: <SRS0=UlDs=6B=lists.openwall.com=kernel-hardening-return-18547-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FDBC2BB1D
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Apr 2020 23:20:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1BCA6221EA
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Apr 2020 23:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O3KHKU0k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BCA6221EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18547-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19486 invoked by uid 550); 17 Apr 2020 23:19:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19460 invoked from network); 17 Apr 2020 23:19:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eZN/WzOYxhMTyXM1n4Hh0KjKOonGokmtIz9JOOeY5Vg=;
        b=O3KHKU0k3dInIICnUfIysdWxzBUY+XUTDdijeLAiDhdFnA8PBKuhSQpvogX9RxTlrx
         kTA/e34YdRHp6WhC8hlBrw/wHMQiAsB5baO1CXMAOyQ8ifvtNvMIs4s159Dofwdzj2+m
         xmOBe5OL0lfhhbpZGbUM2gQ8jnidHc+1xlY/fOe26n2CzbTPuNkpasriAoOqZ07DoWfI
         xFKb+gMgSzaUOzRj2fy3suByEC/htSW+YF9Iyf3GrQ2l41nZaLnZ/2iMxm16wj+3V8iu
         ZKOI3sDWFzGtyd0JvAiuvKjTy/lgLrzbwdLv8B0BzgGvUDUm8aMYaJdtnU/2KyLI1DQe
         j/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eZN/WzOYxhMTyXM1n4Hh0KjKOonGokmtIz9JOOeY5Vg=;
        b=Ze90yxrUWBlIIkRwk50jN0zl57AGloQgfeh4crcVd4qOZaU0GzHC10SqQAEw4VnKy7
         R9sguHBsRlgZn6tx8FJR8DXnS6mKS+V8KoNn3fuzH9EVb85VuUeD6pTPzqhEjw9ttMvz
         XwgH0i0wTOo4vJ2a3Uq+x/38J/UL0nJWxr9n+jCologqUExmDGvmbKu33WGVzE5EjWGe
         i5xJ71NAWTlwks5MLW+x66ldiVuv84nN48rs8NfuAYELJMYNM11rZvYyib4foawcIgWK
         I6dleWbxIDMy6g08CYaQ+jqX+MnnZceIBGpiMNeezPB6v8USPEqQqrvoryUT8hcbFgWW
         dnEQ==
X-Gm-Message-State: AGi0PuZkx6i3CcbPbmMEOdXUVmIm5Ur/Pa890lgpF/o2iJpGY8FgjrfP
	M5hn8asfpnKmC/rsv/ezWaWm1w==
X-Google-Smtp-Source: APiQypI+0JpweCt3GR455upZub8Lrjz/gzQ722UCFMq+C5APeD7it5UYnLinXZ4wa5mxzmtEsNYr0Q==
X-Received: by 2002:a17:902:bd09:: with SMTP id p9mr6170885pls.25.1587165584157;
        Fri, 17 Apr 2020 16:19:44 -0700 (PDT)
Date: Fri, 17 Apr 2020 16:19:37 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 04/12] scs: disable when function graph tracing is
 enabled
Message-ID: <20200417231937.GA214321@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-5-samitolvanen@google.com>
 <20200417100039.GS20730@hirez.programming.kicks-ass.net>
 <20200417144620.GA9529@lakrids.cambridge.arm.com>
 <20200417152645.GH20730@hirez.programming.kicks-ass.net>
 <20200417154613.GB9529@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417154613.GB9529@lakrids.cambridge.arm.com>

On Fri, Apr 17, 2020 at 04:46:14PM +0100, Mark Rutland wrote:
> If KRETPROBES works by messing with the LR at the instnat the function
> is entered, that should work similarly. If it works by replacing the
> RET it should also work out since any pauth/SCS work will have been
> undone by that point. If it attempts to mess with the return address in
> the middle of a function then it's not reliable today.

I did initially have a patch to disable kretprobes (until v5), but as
Mark pointed out back then, the return address is modified before it
gets pushed to the shadow stack, so there was no conflict with SCS. I
confirmed this on arm64, but haven't looked at other architectures.

Sami
