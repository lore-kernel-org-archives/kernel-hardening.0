Return-Path: <SRS0=6/mR=77=lists.openwall.com=kernel-hardening-return-19027-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5709BC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 16:42:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA83A20707
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 16:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA83A20707
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19027-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3851 invoked by uid 550); 18 Jun 2020 16:42:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3818 invoked from network); 18 Jun 2020 16:42:12 -0000
Date: Thu, 18 Jun 2020 12:41:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jann Horn <jannh@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Kees Cook <keescook@chromium.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, Oscar Carter <oscar.carter@gmx.com>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing: Use linker magic instead of recasting
 ftrace_ops_list_func()
Message-ID: <20200618124157.0b9b8807@oasis.local.home>
In-Reply-To: <CAG48ez04Fj=1p61KAxAQWZ3f_z073fVUr8LsQgtKA9c-kcHmDQ@mail.gmail.com>
References: <20200617165616.52241bde@oasis.local.home>
	<CAG48ez2pOns4vF9M_4ubMJ+p9YFY29udMaH0wm8UuCwGQ4ZZAQ@mail.gmail.com>
	<20200617183628.3594271d@oasis.local.home>
	<CAG48ez04Fj=1p61KAxAQWZ3f_z073fVUr8LsQgtKA9c-kcHmDQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Jun 2020 01:12:37 +0200
Jann Horn <jannh@google.com> wrote:

> static ftrace_func_t ftrace_ops_get_list_func(struct ftrace_ops *ops)
> +static ftrace_asm_func_t ftrace_ops_get_list_func(struct ftrace_ops *ops)
>  {
> +#if FTRACE_FORCE_LIST_FUNC
> +       return ftrace_ops_list_func;
> +#else
>         /*
>          * If this is a dynamic, RCU, or per CPU ops, or we force list func,
>          * then it needs to call the list anyway.
>          */
> -       if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_RCU) ||
> -           FTRACE_FORCE_LIST_FUNC)
> +       if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_RCU))
>                 return ftrace_ops_list_func;
> 
>         return ftrace_ops_get_func(ops);

But ftrace_ops_get_func() returns ftrace_func_t type, wont this complain?

-- Steve


> +#endif
>  }

