Return-Path: <SRS0=Zftu=VA=lists.openwall.com=kernel-hardening-return-16344-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AC0C5B578
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jul 2019 22:46:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D769A218A0
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jul 2019 22:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GKzIDz9H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D769A218A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16344-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28222 invoked by uid 550); 3 Jul 2019 22:46:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28185 invoked from network); 3 Jul 2019 22:46:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CCLUnSJ05T4ZJCa+LTuvNahUcmyncAYyyRulg3XHFcY=;
        b=GKzIDz9Hl9rtuOHXxS9mlaSncV1dbuCyQKHjfN4G6JW6K+D++XGM/tcEh1UMji4zRH
         3ZJ77u/cdY3sHOJsbLweRD9b6KoAWFLBHdmHV5ZJp0B6Hmvh1J9BeimcRHWkH5js17VG
         TXPvBUEkyOaaWZMolMuAYSYn9t1QkgBV3eFHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CCLUnSJ05T4ZJCa+LTuvNahUcmyncAYyyRulg3XHFcY=;
        b=RCxElG1ESp7ZQRwqAddIkfeT5tpvVcgagesXHe5RwCu/3FHSemISt7tXCG/kDava75
         Tfj9cKDBrvACv/DWgPx1g4UQ/rqRn6DTG93vJVKctuc3/K+4C5JYgOzPJ1LLR0MprbxH
         do8KMfGfBkgsg13FNqvN0lhcCOldCsjBoZ24/FGTZuThI68HvMg6ZkrlmjkoVyS9evlr
         +QeN5USOkvvHEzlyN3Q+LQMzkjrfu/8ZZpXZMyCIQ6rAHRhFAh4q4KfdnNMmyLkAn4EH
         QIvcOdsNhtSmQbjLAbHw7TgSe6BWQSHGyUk0qjFm9WkvRUQJ4LQMMdi6hN8AsZTVHkYE
         m0rw==
X-Gm-Message-State: APjAAAXh4jcZuI5Zw3Pu7tqchoUkUaor1LGCPxlRVK71tgzb+ZUdMWAv
	o3czQZvOWZko1dS7cx/+2zrYkw==
X-Google-Smtp-Source: APXvYqwLEwnFlJ2W6xxEyKs37AWajrUSUbtPyxYlO6EoVWQpw1XR9JSkWo9jeYJV8rR4OgOsb19YEQ==
X-Received: by 2002:a17:902:6b0c:: with SMTP id o12mr43806452plk.113.1562193962906;
        Wed, 03 Jul 2019 15:46:02 -0700 (PDT)
Date: Wed, 3 Jul 2019 15:46:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <201907031513.8E342FF@keescook>
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook>
 <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>

On Wed, Jul 03, 2019 at 05:48:42PM +0200, Romain Perier wrote:
> Mhhh, so If I understand it right, the purpose of this task is to
> remove the "unsigned long data"  argument passed to tasklet_init() ,
> that
> is mostly used to pass the pointer of the parent structure that
> contains the tasklet_struct to the handler.

Right. The idea being that when a tasklet is stored in memory, it no
longer contains both the callback function pointer AND the argument to
pass it. This is the same problem that existed for struct timer_list.
You can see more details about this in at the start of the timer_list
refactoring:
https://git.kernel.org/linus/686fef928bba6be13cabe639f154af7d72b63120

> We don't change the API of tasklet, we simply remove the code that use
> this "unsigned long data" wrongly to pass the pointer of the parent
> structure
> (by using container_of() or something equivalent).

Kind of. In the timer_list case, there were some places were actual data
(and not a pointer) was being passed -- those needed some thought to
convert sanely. I'm hoping that the tasklets are a much smaller part of
the kernel and won't pose as much of a problem, but I haven't studied
it.

> For example this is the case in:   drivers/firewire/ohci.c   or
> drivers/s390/block/dasd.c  .

Right:

struct ar_context {
	...
        struct tasklet_struct tasklet;
};

static void ar_context_tasklet(unsigned long data)
{
        struct ar_context *ctx = (struct ar_context *)data;
...

static int ar_context_init(...)
{
	...
        tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);


this could instead be:

static void ar_context_tasklet(struct tasklet_struct *tasklet)
{
	struct ar_context *ctx = container_of(tasklet, typeof(*ctx), tasklet);
...

static int ar_context_init(...)
{
	...
        tasklet_setup(&ctx->tasklet, ar_context_tasklet);

> Several question come:
> 
> 1. I am not sure but, do we need to modify the prototype of
> tasklet_init() ?  well, this "unsigned long data" might be use for
> something else that pass the pointer of the parent struct. So I would
> say "no"

Yes, the final step in the refactoring would be to modify the tasklet_init()
prototype. I've included some example commits from the timer_list
refactoring, but look at the history of include/linux/timer.h and
kernel/time/timer.c for more details.

I would expect the refactoring to follow similar changes to timer_list:

- add a new init API (perhaps tasklet_setup() to follow timer_setup()?)
  that passes the tasklet pointer to tasklet_init(), and casts the
  callback.
	https://git.kernel.org/linus/686fef928bba6be13cabe639f154af7d72b63120
- convert all users to the new prototype
	https://git.kernel.org/linus/e99e88a9d2b067465adaa9c111ada99a041bef9a
- remove the "data" member and convert the callback infrastructure to
  pass the tasklet pointer
	https://git.kernel.org/linus/c1eba5bcb6430868427e0b9d1cd1205a07302f06
- and then clean up anything (cast macros, etc)
	https://git.kernel.org/linus/354b46b1a0adda1dd5b7f0bc2a5604cca091be5f

Hopefully tasklet doesn't have a lot of open-coded initialization. This
is what made timer_list such a challenge. Stuff like this:
	https://git.kernel.org/linus/b9eaf18722221ef8b2bd6a67240ebe668622152a

> 2. In term of security, this is a problem ? Or this is just an
> improvement to force developpers to do things correctly ?

It's a reduction in attack surface (attacker has less control
over the argument if the function pointer is overwritten) and it
provides a distinct prototype for CFI, to make is separate from other
functions that take a single unsigned long argument (e.g. before the
timer_list refactoring, all timer callbacks had the same prototype as
native_write_cr4(), making them a powerful target to control on x86).

For examples of the timer_list attacks (which would likely match a
tasklet attack if one got targeted), see "retire_blk_timer" in:
https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-via-packet.html

There's also some more detail on the timer_list work in my blog post
for v4.15:
https://outflux.net/blog/archives/2018/02/05/security-things-in-linux-v4-15/

> I will update the WIKI

Awesome!

Thanks for looking at this! I hope it's not at bad as timer_list. :)

-- 
Kees Cook
