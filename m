Return-Path: <SRS0=H+r/=U6=lists.openwall.com=kernel-hardening-return-16329-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D015C0650E
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 17:49:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 77B6921721
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 17:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dDxXBYrf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77B6921721
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16329-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24115 invoked by uid 550); 1 Jul 2019 17:49:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24073 invoked from network); 1 Jul 2019 17:49:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GaSNs2HPkef+Bju56da9n81KJMEMrMttgso442g/QFQ=;
        b=dDxXBYrffpjFtM2c0mbpgHYAdQWFOMC7Pg5wS3+aSRf27a4WL/vMFFEEX1k0Q+UEoD
         PxEbvX5YtveVeJbRRR4L+QvEY7JZXKaXWsmDMieqT3Vqa+ldWVs3Crj4SSUSk68x+TMW
         4rzGe83wXA28h4lBdWyPq2UXIHWh4/a9tWqhLsEArfRSxVKpx+7/XT7ej0qWYPRmDgX0
         jpo5P91s5ji/fLtheR47BG337NnW36xNfAwK8NbTVCjf90H1eMlSEfXst9tbCQD06Zq6
         luM/3dSzwvzTENJmBQw3gfDnXPyJUA1OZ0YEU2BaLqSnJ9aKLDmMBpZDG1wWGJe2Gd+V
         MNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GaSNs2HPkef+Bju56da9n81KJMEMrMttgso442g/QFQ=;
        b=TRZyV8nrZw6d+DjIygk18qOvTdBnDDCnlFdRSPh1ap+3fH9EeodGS9nceFJFKXK58s
         c3J5T4rwcheJA5k0g46volbP1QJy6n08+z7LtN2+qImJff6gUmdwMFtnvYLi+Ei6WKFU
         76DKHdP/vkuJFi0fnJlVv22jWdwqcDePKL6VwtsQySuF69KdqwEaFO79ls2wur8FeCBr
         1pNIHOD1E9dT8ER1N//fjxlcXQsh9TOr/plNpIhWg8ArJhhj2tvU0bFgOIcUy7PZGqRj
         nqds8o55s5JRP/W5hIxVESlrbUj3p/c5ouPMi1RgMrEp2Ltq7G5Tbe7XLGGO2vIyiehB
         qI4Q==
X-Gm-Message-State: APjAAAWg5ZFnte1cz4pc3vP1eH5D51XZPjtFzTA6Ui/WICLjtQdjgoJo
	5DBL4txcxWfBeCKa0CeeWkdSOohmrIKoi0y19EtLOQ==
X-Google-Smtp-Source: APXvYqzAP7YijoRhhk214MeHXQ+UJykFo/oaWVZnDcnHgEvTrOR3/XiDyA6gSgJGl8ucI5kH6eOwSlRA7n2oWVQcFUg=
X-Received: by 2002:a9d:2f26:: with SMTP id h35mr21598797otb.183.1562003332560;
 Mon, 01 Jul 2019 10:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190628193442.94745-1-joel@joelfernandes.org>
In-Reply-To: <20190628193442.94745-1-joel@joelfernandes.org>
From: Jann Horn <jannh@google.com>
Date: Mon, 1 Jul 2019 19:48:26 +0200
Message-ID: <CAG48ez11aCEBmO=DM58+Rk7cthW1VWK2O35GWsSJWwQ_fQJ6Fg@mail.gmail.com>
Subject: Re: [PATCH v2] Convert struct pid count to refcount_t
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, 
	"Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Elena Reshetova <elena.reshetova@intel.com>, 
	Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 28, 2019 at 9:35 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
> struct pid's count is an atomic_t field used as a refcount. Use
> refcount_t for it which is basically atomic_t but does additional
> checking to prevent use-after-free bugs.
[...]
>  struct pid
>  {
> -       atomic_t count;
> +       refcount_t count;
[...]
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20881598bdfa..89c4849fab5d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -37,7 +37,7 @@
>  #include <linux/init_task.h>
>  #include <linux/syscalls.h>
>  #include <linux/proc_ns.h>
> -#include <linux/proc_fs.h>
> +#include <linux/refcount.h>
>  #include <linux/sched/task.h>
>  #include <linux/idr.h>
>
> @@ -106,8 +106,7 @@ void put_pid(struct pid *pid)

init_struct_pid is defined as follows:

struct pid init_struct_pid = {
        .count          = ATOMIC_INIT(1),
[...]
};

This should be changed to REFCOUNT_INIT(1).

You should have received a compiler warning about this; I get the
following when trying to build with your patch applied:

jannh@jannh2:~/git/foreign/linux$ make kernel/pid.o
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
  CC      kernel/pid.o
kernel/pid.c:44:30: warning: missing braces around initializer
[-Wmissing-braces]
 struct pid init_struct_pid = {
                              ^
kernel/pid.c:44:30: warning: missing braces around initializer
[-Wmissing-braces]
kernel/pid.c:44:30: warning: missing braces around initializer
[-Wmissing-braces]
kernel/pid.c:44:30: warning: missing braces around initializer
[-Wmissing-braces]
kernel/pid.c:44:30: warning: missing braces around initializer
[-Wmissing-braces]
