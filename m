Return-Path: <SRS0=QZ13=4J=lists.openwall.com=kernel-hardening-return-17876-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EB3C35656
	for <kernel-hardening@archiver.kernel.org>; Fri, 21 Feb 2020 16:51:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4CC4F208C4
	for <kernel-hardening@archiver.kernel.org>; Fri, 21 Feb 2020 16:51:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K1shmBu8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CC4F208C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17876-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29886 invoked by uid 550); 21 Feb 2020 16:51:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29863 invoked from network); 21 Feb 2020 16:51:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1582303850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4h82rv0PoKdnsyNmTUn/xy7ivRxE79f7MGtv9RQvsxs=;
	b=K1shmBu8+u1/EsmCeJcLOaIF0aoRRyv11djXs6M4qTDQnYzkGX9nfNXZ9iN8RNF2H0Geqx
	rhLBJHFP4V21MftI7Z0FB/e2f+X8aWlloY8W5R8ppMf7/Ef+syM8Q0q/5B1X78Y5bOVIDf
	dKba6K/A0nDhzTG3K4b5gihJ92t+a3Q=
X-MC-Unique: NEfudibLOf2BUHT9bNEyZQ-1
Date: Fri, 21 Feb 2020 17:50:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Solar Designer <solar@openwall.com>
Subject: Re: [PATCH 7/7] proc: Ensure we see the exit of each process tid
 exactly once
Message-ID: <20200221165036.GB16646@redhat.com>
References: <20200212200335.GO23230@ZenIV.linux.org.uk>
 <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
 <20200212203833.GQ23230@ZenIV.linux.org.uk>
 <20200212204124.GR23230@ZenIV.linux.org.uk>
 <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
 <87lfp7h422.fsf@x220.int.ebiederm.org>
 <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
 <87pnejf6fz.fsf@x220.int.ebiederm.org>
 <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
 <87r1yp7zhc.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1yp7zhc.fsf_-_@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

On 02/20, Eric W. Biederman wrote:
>
> +void exchange_tids(struct task_struct *ntask, struct task_struct *otask)
> +{
> +	/* pid_links[PIDTYPE_PID].next is always NULL */
> +	struct pid *npid = READ_ONCE(ntask->thread_pid);
> +	struct pid *opid = READ_ONCE(otask->thread_pid);
> +
> +	rcu_assign_pointer(opid->tasks[PIDTYPE_PID].first, &ntask->pid_links[PIDTYPE_PID]);
> +	rcu_assign_pointer(npid->tasks[PIDTYPE_PID].first, &otask->pid_links[PIDTYPE_PID]);
> +	rcu_assign_pointer(ntask->thread_pid, opid);
> +	rcu_assign_pointer(otask->thread_pid, npid);

this breaks has_group_leader_pid()...

proc_pid_readdir() can miss a process doing mt-exec but this looks fixable,
just we need to update ntask->thread_pid before updating ->first.

The more problematic case is __exit_signal() which does
		
		if (unlikely(has_group_leader_pid(tsk)))
			posix_cpu_timers_exit_group(tsk);

Oleg.

