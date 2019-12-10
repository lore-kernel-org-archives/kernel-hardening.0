Return-Path: <SRS0=0mXB=2A=lists.openwall.com=kernel-hardening-return-17488-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127F9C00454
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Dec 2019 22:05:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 324212053B
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Dec 2019 22:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oQoy24F4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 324212053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17488-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18039 invoked by uid 550); 10 Dec 2019 22:05:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17997 invoked from network); 10 Dec 2019 22:05:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8j1utx508S5/TvNItlGvK7J8skQp+XJtz585eAmQOY=;
        b=oQoy24F4W+3HEnQHY3kqxhyCRrgbihW2p+NtMsvMO+yWUSnGsN7KjaZ/j12OZqylPG
         RDTSD78gK1nTi8JszGUq2QB3PcUE5yKacpkgCSbhkdr+OMP/LIf1oBF3QHqfa5HN5H4X
         V98yTsV/FAVlwMRhY5YVG7FsTnJO9UEbXI3XWtVx7U9BMHQkZMLRKChzan7V91XQWURr
         1aPZgtmtuhs9aHOC66Ef62wcCUDJXaLLJwwWih8PMjugAGqOnJb/X+O0jLbIinIqwhH1
         WsP7k1R2W5hFniX99RJGyvIkpX/mJTbd59jsax0I2eS0lBUOoKtwQPHvuEcRn0H1jt3W
         l3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8j1utx508S5/TvNItlGvK7J8skQp+XJtz585eAmQOY=;
        b=McMno6ZKoMZHXyIySNsolcsozjNgPRUzQWyX7+7iJMvUrPClbNaRqaxqh9HYoP0kbH
         mhwHPRDUqQhhnKXHCBraGfDnfyu77Fh050kdeDEH7ljChJkyhL3NjeFSJPsQ0vi9rQAz
         JFSHRknLzRef9LOyLT829qMAzevTlWaP8DcxGJBB3Ax+YTbcDFpOVoQ7UiJTldCLaIoc
         8ekIi+Xt1ek05Gxo5NPAnu+9j22VbTMRsISY/QwOj/B6zl7hrSCfMNes50ceH6aC//n2
         5gzjdKW1ghLoCwzejRYcQZoXkjrXmI0YXMWiJ88f+6oUOcOWbNMYefYNcKp1fj7aZOf8
         0lgw==
X-Gm-Message-State: APjAAAU4JAB7QFj+FIPYoMDlUYqoHmiv+/UdMbY/W+cB7T2AUut6wmnt
	Bi4LA+QElLni8pLA4JfuIMOpbJruvkwFpL+37VKs8w==
X-Google-Smtp-Source: APXvYqw9AHcZc7P3F/ugnCZTqo/2VwWhuZ4lejg+yte3f6J4FIMjtd/N6HKWzeO7qr80QJRuV8TXt6qnPUCzanMfF5o=
X-Received: by 2002:a9d:6481:: with SMTP id g1mr29371otl.180.1576015524724;
 Tue, 10 Dec 2019 14:05:24 -0800 (PST)
MIME-Version: 1.0
References: <20191210155742.5844-1-axboe@kernel.dk> <20191210155742.5844-8-axboe@kernel.dk>
In-Reply-To: <20191210155742.5844-8-axboe@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Tue, 10 Dec 2019 23:04:58 +0100
Message-ID: <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Will Deacon <will@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

[context preserved for additional CCs]

On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> Recently had a regression that turned out to be because
> CONFIG_REFCOUNT_FULL was set.

I assume "regression" here refers to a performance regression? Do you
have more concrete numbers on this? Is one of the refcounting calls
particularly problematic compared to the others?

I really don't like it when raw atomic_t is used for refcounting
purposes - not only because that gets rid of the overflow checks, but
also because it is less clear semantically.

> Our ref count usage is really simple,

In my opinion, for a refcount to qualify as "really simple", it must
be possible to annotate each relevant struct member and local variable
with the (fixed) bias it carries when alive and non-NULL. This
refcount is more complicated than that.

> so let's just use atomic_t and get rid of the dependency on the full
> reference count checking being enabled or disabled.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9a596b819334..05419a152b32 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -360,7 +360,7 @@ struct io_kiocb {
>         };
>         struct list_head        link_list;
>         unsigned int            flags;
> -       refcount_t              refs;
> +       atomic_t                refs;
>  #define REQ_F_NOWAIT           1       /* must not punt to workers */
>  #define REQ_F_IOPOLL_COMPLETED 2       /* polled IO has completed */
>  #define REQ_F_FIXED_FILE       4       /* ctx owns file */
> @@ -770,7 +770,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
>                 WRITE_ONCE(ctx->rings->cq_overflow,
>                                 atomic_inc_return(&ctx->cached_cq_overflow));
>         } else {
> -               refcount_inc(&req->refs);
> +               atomic_inc(&req->refs);
>                 req->result = res;
>                 list_add_tail(&req->list, &ctx->cq_overflow_list);
>         }
> @@ -852,7 +852,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>         req->ctx = ctx;
>         req->flags = 0;
>         /* one is dropped after submission, the other at completion */
> -       refcount_set(&req->refs, 2);
> +       atomic_set(&req->refs, 2);
>         req->result = 0;
>         INIT_IO_WORK(&req->work, io_wq_submit_work);
>         return req;
> @@ -1035,13 +1035,13 @@ static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
>  {
>         io_req_find_next(req, nxtptr);
>
> -       if (refcount_dec_and_test(&req->refs))
> +       if (atomic_dec_and_test(&req->refs))
>                 __io_free_req(req);
>  }
>
>  static void io_put_req(struct io_kiocb *req)
>  {
> -       if (refcount_dec_and_test(&req->refs))
> +       if (atomic_dec_and_test(&req->refs))
>                 io_free_req(req);
>  }
>
> @@ -1052,14 +1052,14 @@ static void io_put_req(struct io_kiocb *req)
>  static void __io_double_put_req(struct io_kiocb *req)
>  {
>         /* drop both submit and complete references */
> -       if (refcount_sub_and_test(2, &req->refs))
> +       if (atomic_sub_and_test(2, &req->refs))
>                 __io_free_req(req);
>  }
>
>  static void io_double_put_req(struct io_kiocb *req)
>  {
>         /* drop both submit and complete references */
> -       if (refcount_sub_and_test(2, &req->refs))
> +       if (atomic_sub_and_test(2, &req->refs))
>                 io_free_req(req);
>  }
>
> @@ -1108,7 +1108,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>                 io_cqring_fill_event(req, req->result);
>                 (*nr_events)++;
>
> -               if (refcount_dec_and_test(&req->refs)) {
> +               if (atomic_dec_and_test(&req->refs)) {
>                         /* If we're not using fixed files, we have to pair the
>                          * completion part with the file put. Use regular
>                          * completions for those, only batch free for fixed
> @@ -3169,7 +3169,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>         if (!list_empty(&req->link_list)) {
>                 prev = list_entry(req->link_list.prev, struct io_kiocb,
>                                   link_list);
> -               if (refcount_inc_not_zero(&prev->refs)) {
> +               if (atomic_inc_not_zero(&prev->refs)) {
>                         list_del_init(&req->link_list);
>                         prev->flags &= ~REQ_F_LINK_TIMEOUT;
>                 } else
> @@ -4237,7 +4237,7 @@ static void io_get_work(struct io_wq_work *work)
>  {
>         struct io_kiocb *req = container_of(work, struct io_kiocb, work);
>
> -       refcount_inc(&req->refs);
> +       atomic_inc(&req->refs);
>  }
>
>  static int io_sq_offload_start(struct io_ring_ctx *ctx,
> @@ -4722,7 +4722,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>                         if (req->work.files != files)
>                                 continue;
>                         /* req is being completed, ignore */
> -                       if (!refcount_inc_not_zero(&req->refs))
> +                       if (!atomic_inc_not_zero(&req->refs))
>                                 continue;
>                         cancel_req = req;
>                         break;
> --
> 2.24.0
>
