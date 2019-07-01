Return-Path: <SRS0=YujF=U6=lists.openwall.com=kernel-hardening-return-16330-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEB0C46478
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:25:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5383F21721
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="Ehn/I4B4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5383F21721
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16330-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28340 invoked by uid 550); 1 Jul 2019 18:25:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28313 invoked from network); 1 Jul 2019 18:25:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=727aBBfWqYrKy3zdRdkTXxLgWwNQre9utWIB8UaiK2g=;
        b=Ehn/I4B4HkIjvHy6V9HxTRXh3F8YWylu8ympYyLVqIQxwF/qtaM/RDmkvNnTNQbdoQ
         MOFe3neeigVp0ZlIqijol7rr9IKmlQzgxVUOy++18cE2QEElAiMYSoOcKxqTNtyQ1PG0
         z6axRHN3bwo8z7KVbfu0m/73XA9Bx+wc8BqyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=727aBBfWqYrKy3zdRdkTXxLgWwNQre9utWIB8UaiK2g=;
        b=OI70gYcqOXS+mvD7CdhzLbQ/gqoDjEFOZCN26mikE6nWcjLwtne161DOLXeiLe4MCL
         fX78pi2qTuFUvKyFpAPnIy6AkqnCQE2PSbQxuxRSSeCsp91vkoS8Ycqi0jynj0+iizCr
         LdAt1hE6VnbZeEGPJVrsWS2EDJwgHFffFmquNNfQXQbgLCvlNDPs0aO85/zCeH8R2Djt
         IbUKjBLsTt4gLBTSaAHBl7L1rAgke3y9q5sS7v/Jxf0sEiRPqpKi5G9EQ6Mk0+c9zbqc
         oWfM6PHj/2JgBAvewqqvgiwOyjdqc+3AJXwwmktv6g4GAl5WdwWkj25xXQQ8tu9rJEhH
         /aCg==
X-Gm-Message-State: APjAAAWkGuos8oLwVAzEkbn1El6wb0GH5SUCtRfzFAEBTieZQBgw81Bz
	btfbgJ6Mut35XAP/LCvDdBG1mQ==
X-Google-Smtp-Source: APXvYqxbjX3RJLpO0anArjOh5JUBRzWK/fY7e05ZbhUnH9NIahw6rvOQWHz+4F/sxkMdBuuda3lNGg==
X-Received: by 2002:a63:7b18:: with SMTP id w24mr22771702pgc.328.1562005521251;
        Mon, 01 Jul 2019 11:25:21 -0700 (PDT)
Date: Mon, 1 Jul 2019 14:25:19 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	"Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Kees Cook <keescook@chromium.org>,
	kernel-team <kernel-team@android.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2] Convert struct pid count to refcount_t
Message-ID: <20190701182519.GA125555@google.com>
References: <20190628193442.94745-1-joel@joelfernandes.org>
 <CAG48ez11aCEBmO=DM58+Rk7cthW1VWK2O35GWsSJWwQ_fQJ6Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez11aCEBmO=DM58+Rk7cthW1VWK2O35GWsSJWwQ_fQJ6Fg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2019 at 07:48:26PM +0200, Jann Horn wrote:
> On Fri, Jun 28, 2019 at 9:35 PM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
> > struct pid's count is an atomic_t field used as a refcount. Use
> > refcount_t for it which is basically atomic_t but does additional
> > checking to prevent use-after-free bugs.
> [...]
> >  struct pid
> >  {
> > -       atomic_t count;
> > +       refcount_t count;
> [...]
> > diff --git a/kernel/pid.c b/kernel/pid.c
> > index 20881598bdfa..89c4849fab5d 100644
> > --- a/kernel/pid.c
> > +++ b/kernel/pid.c
> > @@ -37,7 +37,7 @@
> >  #include <linux/init_task.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/proc_ns.h>
> > -#include <linux/proc_fs.h>
> > +#include <linux/refcount.h>
> >  #include <linux/sched/task.h>
> >  #include <linux/idr.h>
> >
> > @@ -106,8 +106,7 @@ void put_pid(struct pid *pid)
> 
> init_struct_pid is defined as follows:
> 
> struct pid init_struct_pid = {
>         .count          = ATOMIC_INIT(1),
> [...]
> };
> 
> This should be changed to REFCOUNT_INIT(1).
> 
> You should have received a compiler warning about this; I get the
> following when trying to build with your patch applied:

Thanks. Andrew had fixed this in patch v1 but Linus dropped it for other
reasons. Anyway, I should have fixed this in my resubmit.

Sorry, I'll fix and resend!

 - Joel


