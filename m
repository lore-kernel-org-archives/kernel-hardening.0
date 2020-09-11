Return-Path: <SRS0=bQzH=CU=lists.openwall.com=kernel-hardening-return-19878-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5012C43461
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 00:21:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9CFD208FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 00:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SijTA2JB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9CFD208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19878-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25975 invoked by uid 550); 11 Sep 2020 00:21:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25955 invoked from network); 11 Sep 2020 00:21:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IyAAsSx7nFV/dq/SzL35IFpVJ+Yn15D4pJKs31u9n78=;
        b=SijTA2JBh2igQyUFhnGY43n8X9KiE/1xBjEYzMfT6RvTVPBWKIf2S98WFdxu9pntLY
         3FWTWsLcOBbZZP+uQKQQFz4ztqRQDTHyvvYDTLpZ/Yx9mHMQtmxixW2u+2Iv/F2pmzx0
         9Shwb8Rd2BYkk5HW11A7nj4k+Z9OU+m6AuaF06ISqWp+Wo0Dxl3Ftte6cYPtPbWW1yZR
         JLLqu2Dvol/xqraTUN3AMxutXgpUnMwIbPWTFot3PWxuMyymTw8Kv6tYWx+E0bQ1fw0S
         kVuDX8lq+sS+iKyOplLtlkXB4ZB4Y983W8fe/h7lUU2TIMbQmGvwGw79xY/i1sapn5fC
         JATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IyAAsSx7nFV/dq/SzL35IFpVJ+Yn15D4pJKs31u9n78=;
        b=Kf6DfvEvGH9Ia4ytQOH5iLyC+u2+KzjchgfxeGa+fMi50u9W+tUofPRJPrzc8cAhGV
         1yQGqqmdAe3/sI4OfdYlY6UAQsxstciOod9v6QUL9kHJr0eReLwDkP9gbD8Tm23XXd/d
         +ftmFcbVTno2uIGOX5bMSFjeoWDrIupw54myt4/F93hxlZkrtqhjLGJ+zjVyljg0YKMR
         Hii93AwcRKI78X4eZ+50KExEMt7Op4GHjFDFXWfIQyJC2wtrFuQbqqwaN1iytbtD1J64
         fPtSXvR0XgO/iebnufXnuTtKpokdJOKqLNQmBbdeKAZgtKBO05l8+b5AlCj3ojGUzpwa
         CA9Q==
X-Gm-Message-State: AOAM531KOWHlGAnHt45JlerDA/T2gETXszSdxfeC7knm1izx9Sxnlurp
	LctQs80yY3DYXBxt3YQWuunOQOtXeBSrt3Ht7YL/VA==
X-Google-Smtp-Source: ABdhPJwL5k8zeWDPprG5Mrub7BhXpdPNFjl1twNR0wyPykMPOKHhl8JhWG8zU9BNykiHZwGZd8sG1UHbIbv8RO4puvk=
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr11898964ejb.493.1599783653707;
 Thu, 10 Sep 2020 17:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-7-keescook@chromium.org> <202009101649.2A0BF95@keescook>
In-Reply-To: <202009101649.2A0BF95@keescook>
From: Jann Horn <jannh@google.com>
Date: Fri, 11 Sep 2020 02:20:27 +0200
Message-ID: <CAG48ez2=8y7jC9vWSPyYNhwASxGrQaewSBczbr02Ri2YnBJwVA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] security/fbfam: Mitigate a fork brute force attack
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, John Wood <john.wood@gmx.com>, 
	Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 11, 2020 at 1:56 AM Kees Cook <keescook@chromium.org> wrote:
> On Thu, Sep 10, 2020 at 01:21:07PM -0700, Kees Cook wrote:
> > From: John Wood <john.wood@gmx.com>
> >
> > In order to mitigate a fork brute force attack it is necessary to kill
> > all the offending tasks. This tasks are all the ones that share the
> > statistical data with the current task (the task that has crashed).
> >
> > Since the attack detection is done in the function fbfam_handle_attack()
> > that is called every time a core dump is triggered, only is needed to
> > kill the others tasks that share the same statistical data, not the
> > current one as this is in the path to be killed.
[...]
> > +     for_each_process(p) {
> > +             if (p == current || p->fbfam_stats != stats)
> > +                     continue;
> > +
> > +             do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_PID);
> > +             pr_warn("fbfam: Offending process with PID %d killed\n",
> > +                     p->pid);
[...]
> > +
> > +             killed += 1;
> > +             if (killed >= to_kill)
> > +                     break;
> > +     }
> > +
> > +     rcu_read_unlock();
>
> Can't newly created processes escape this RCU read lock? I think this
> need alternate locking, or something in the task_alloc hook that will
> block any new process from being created within the stats group.

Good point; the proper way to deal with this would probably be to take
the tasklist_lock in read mode around this loop (with
read_lock(&tasklist_lock) / read_unlock(&tasklist_lock)), which pairs
with the write_lock_irq(&tasklist_lock) in copy_process(). Thanks to
the fatal_signal_pending() check while holding the lock in
copy_process(), that would be race-free - any fork() that has not yet
inserted the new task into the global task list would wait for us to
drop the tasklist_lock, then bail out at the fatal_signal_pending()
check.
