Return-Path: <SRS0=BSVH=HY=lists.openwall.com=kernel-hardening-return-20808-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BC5C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:50:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9A67964F04
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A67964F04
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20808-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10040 invoked by uid 550); 22 Feb 2021 17:49:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10010 invoked from network); 22 Feb 2021 17:49:51 -0000
Date: Mon, 22 Feb 2021 12:49:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] tracing/probe: Manual replacement of the
 deprecated strlcpy() with return values
Message-ID: <20210222124936.03103585@gandalf.local.home>
In-Reply-To: <20210222151231.22572-17-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
	<20210222151231.22572-17-romain.perier@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Feb 2021 16:12:27 +0100
Romain Perier <romain.perier@gmail.com> wrote:

> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.
> It can lead to linear read overflows, crashes, etc...
> 
> As recommended in the deprecated interfaces [1], it should be replaced
> by strscpy.
> 
> This commit replaces all calls to strlcpy that handle the return values
> by the corresponding strscpy calls with new handling of the return
> values (as it is quite different between the two functions).
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  kernel/trace/trace_uprobe.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 3cf7128e1ad3..f9583afdb735 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -154,12 +154,11 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
>  	u8 *dst = get_loc_data(dest, base);
>  	void __user *src = (void __force __user *) addr;
>  
> -	if (unlikely(!maxlen))
> -		return -ENOMEM;

Don't remove the above. You just broke the else side.

> -
> -	if (addr == FETCH_TOKEN_COMM)
> -		ret = strlcpy(dst, current->comm, maxlen);
> -	else
> +	if (addr == FETCH_TOKEN_COMM) {
> +		ret = strscpy(dst, current->comm, maxlen);
> +		if (ret == -E2BIG)
> +			return -ENOMEM;

I'm not sure the above is what we want. current->comm is always nul
terminated, and not only that, it will never be bigger than TASK_COMM_LEN.
If the "dst" location is smaller than comm (maxlen < TASK_COMM_LEN), it is
still OK to copy a partial string. It should not return -ENOMEM which looks
to be what happens with this patch.

In other words, it looks like this patch breaks the current code in more
ways than one.

-- Steve


> +	} else
>  		ret = strncpy_from_user(dst, src, maxlen);
>  	if (ret >= 0) {
>  		if (ret == maxlen)

