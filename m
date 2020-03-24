Return-Path: <SRS0=yznj=5J=lists.openwall.com=kernel-hardening-return-18184-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A8DC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:31:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 65B182076F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:31:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ri1Mc8OS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65B182076F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18184-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15725 invoked by uid 550); 24 Mar 2020 16:31:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15685 invoked from network); 24 Mar 2020 16:31:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585067456;
	bh=zN8a8ff6F93rxfbnXtH/OcB/Pb+dW43Yhgo3Ww7vWQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ri1Mc8OSEm6cogEpBO9hMkaeRhw+6K3o1kbrSlsDZvoC1oDtJ66RRAd2oZcCz9/+7
	 ncW1j/AHt+aiuYCn0axZhfZskTLlbffchzCWAGIi8cx/puBhsRiVmJXW7eF3+QT6uz
	 2TWkycg6hCS+tNpkoVgHuQyEGoThdUGY6yjTqB7o=
Date: Tue, 24 Mar 2020 17:30:54 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 04/21] timers: Use hlist_unhashed() instead of
 open-coding in timer_pending()
Message-ID: <20200324163054.GA2518746@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-5-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-5-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:26PM +0000, Will Deacon wrote:
> timer_pending() open-codes a version of hlist_unhashed() to check
> whether or not the 'timer' parameter has been queued in the timer wheel.
> KCSAN detects this as a racy operation and explodes at us:
> 
>   | BUG: KCSAN: data-race in del_timer / detach_if_pending
>   |
>   | write to 0xffff88808697d870 of 8 bytes by task 10 on cpu 0:
>   |  __hlist_del include/linux/list.h:764 [inline]
>   |  detach_timer kernel/time/timer.c:815 [inline]
>   |  detach_if_pending+0xcd/0x2d0 kernel/time/timer.c:832
>   |  try_to_del_timer_sync+0x60/0xb0 kernel/time/timer.c:1226
>   |  del_timer_sync+0x6b/0xa0 kernel/time/timer.c:1365
>   |  schedule_timeout+0x2d2/0x6e0 kernel/time/timer.c:1896
>   |  rcu_gp_fqs_loop+0x37c/0x580 kernel/rcu/tree.c:1639
>   |  rcu_gp_kthread+0x143/0x230 kernel/rcu/tree.c:1799
>   |  kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
>   |  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
>   |
>   | read to 0xffff88808697d870 of 8 bytes by task 12060 on cpu 1:
>   |  del_timer+0x3b/0xb0 kernel/time/timer.c:1198
>   |  sk_stop_timer+0x25/0x60 net/core/sock.c:2845
>   |  inet_csk_clear_xmit_timers+0x69/0xa0 net/ipv4/inet_connection_sock.c:523
>   |  tcp_clear_xmit_timers include/net/tcp.h:606 [inline]
>   |  tcp_v4_destroy_sock+0xa3/0x3f0 net/ipv4/tcp_ipv4.c:2096
>   |  inet_csk_destroy_sock+0xf4/0x250 net/ipv4/inet_connection_sock.c:836
>   |  tcp_close+0x6f3/0x970 net/ipv4/tcp.c:2497
>   |  inet_release+0x86/0x100 net/ipv4/af_inet.c:427
>   |  __sock_release+0x85/0x160 net/socket.c:590
>   |  sock_close+0x24/0x30 net/socket.c:1268
>   |  __fput+0x1e1/0x520 fs/file_table.c:280
>   |  ____fput+0x1f/0x30 fs/file_table.c:313
>   |  task_work_run+0xf6/0x130 kernel/task_work.c:113
>   |  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>   |  exit_to_usermode_loop+0x2b4/0x2c0 arch/x86/entry/common.c:163
> 
> Replace the explicit 'pprev' pointer comparison in timer_pending() with
> a call to hlist_unhashed() and initialise the 'expires' timer field
> explicitly in do_init_timer() so that the compiler doesn't emit bogus
> 'maybe used uninitialised' warnings now that it cannot reason statically
> about the result of timer_pending().
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
