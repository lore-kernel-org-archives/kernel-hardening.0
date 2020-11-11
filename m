Return-Path: <SRS0=FFTV=ER=lists.openwall.com=kernel-hardening-return-20380-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9ACC388F7
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Nov 2020 00:23:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BFBA42068D
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Nov 2020 00:11:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="c/DfvdBQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFBA42068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20380-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26238 invoked by uid 550); 11 Nov 2020 00:11:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26194 invoked from network); 11 Nov 2020 00:11:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6S6LSZiFwfcqGCAPmfa/DXBPMISRp5gpYhUJpZjld+c=;
        b=c/DfvdBQlcC9l5g/4cJWDrGJF7KgxmW+S3hrraO/wDVnOt/U8B8MOwT1Cmw8HgZD01
         Gl+ndoc/5FczRR/pQu4898kek0eUB/mNb3KGXOCibqiBKCiAgjuqZUYz9RU3WMWkLT4S
         3cX+6K6nlWd91UfS5TDtUkLPYMr5iBhui8gzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6S6LSZiFwfcqGCAPmfa/DXBPMISRp5gpYhUJpZjld+c=;
        b=jrSU+YqrimCcLD/8X/q5nq8qhPzZK4om0DWF3xVk6LEGQu+rFvij5FqjZMDoqNXhTe
         X21A/OdNQ5NFSPa0/RoKpEtXUKPpXCOLRoLNSsyogBO7ZZBBpVLlVzppcRaCByeU9gwS
         iPNjdtdGQPZ6mEVTP3YWGnKkZApPMTl2w1jCR5RkOgi/r2hTiqlqWaGnLsMavjrC8Cwv
         Cc8xBSyROkFliTHNxttbaMS4jT+/2YM9zZCpQJm55rUm8JL6IOMtoSfeAcWAz3CDiI17
         80QD0URIRIFu6z59cLhfFYlsRgHzmz7hkaS2OFNfq+fA86LngN33hbLfYqjPnFrDT9+e
         O9cg==
X-Gm-Message-State: AOAM533+Pw9gjMG4UW27aS3sEox7NLCJ0Xk2yhG5r1e51SV0fMRej5wb
	7+8Q2XQDcRGNMwMZu4IU9jJiSA==
X-Google-Smtp-Source: ABdhPJx+OuE0OiWhF/pMYmebpHJMo5oS/J3KKadNTvCX+lapOy0QZhJX608cxzwxz4funovaROci5w==
X-Received: by 2002:a63:381:: with SMTP id 123mr20091728pgd.112.1605053452016;
        Tue, 10 Nov 2020 16:10:52 -0800 (PST)
Date: Tue, 10 Nov 2020 16:10:49 -0800
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2 0/8] Fork brute force attack mitigation
Message-ID: <202011101422.460E046B@keescook>
References: <20201025134540.3770-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201025134540.3770-1-john.wood@gmx.com>

On Sun, Oct 25, 2020 at 02:45:32PM +0100, John Wood wrote:
> Attacks against vulnerable userspace applications with the purpose to break
> ASLR or bypass canaries traditionaly use some level of brute force with the
> help of the fork system call. This is possible since when creating a new
> process using fork its memory contents are the same as those of the parent
> process (the process that called the fork system call). So, the attacker
> can test the memory infinite times to find the correct memory values or the
> correct memory addresses without worrying about crashing the application.
> 
> Based on the above scenario it would be nice to have this detected and
> mitigated, and this is the goal of this patch serie.

Thanks for preparing the v2! I spent some time looking at this today,
and I really like how it has been rearranged into an LSM. This feels
much more natural.

Various notes:

The locking isn't right; it'll trip with CONFIG_PROVE_LOCKING=y.
Here's the giant splat:


[    8.205146] brute: Fork brute force attack detected
[    8.206821] 
[    8.207317] =====================================================
[    8.209392] WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
[    8.211852] 5.10.0-rc3 #2 Not tainted
[    8.213215] -----------------------------------------------------
[    8.215213] runc/2505 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[    8.217387] ffffffff97206098 (tasklist_lock){.+.+}-{2:2}, at: brute_task_fatal_signal.cold+0x49/0xe0
[    8.219554] 
[    8.219554] and this task is already holding:
[    8.220891] ffff9a6a10eb8318 (&stats->lock){+.-.}-{2:2}, at: brute_task_fatal_signal+0x97/0x210
[    8.222856] which would create a new lock dependency:
[    8.223943]  (&stats->lock){+.-.}-{2:2} -> (tasklist_lock){.+.+}-{2:2}
[    8.225360] 
[    8.225360] but this new dependency connects a SOFTIRQ-irq-safe lock:
[    8.227081]  (&stats->lock){+.-.}-{2:2}
[    8.227084] 
[    8.227084] ... which became SOFTIRQ-irq-safe at:
[    8.228732]   lock_acquire+0x13f/0x3f0
[    8.229381]   _raw_spin_lock+0x2c/0x40
[    8.230024]   brute_task_free+0x22/0x90
[    8.230619]   security_task_free+0x22/0x50
[    8.231260]   __put_task_struct+0x58/0x140
[    8.231924]   rcu_core+0x2bb/0x620
[    8.232492]   __do_softirq+0x156/0x4d9
[    8.233080]   asm_call_irq_on_stack+0x12/0x20
[    8.233759]   do_softirq_own_stack+0x5b/0x70
[    8.234425]   irq_exit_rcu+0x9f/0xe0
[    8.235221]   sysvec_apic_timer_interrupt+0x43/0xa0
[    8.235976]   asm_sysvec_apic_timer_interrupt+0x12/0x20
[    8.236794]   _raw_write_unlock_irq+0x2c/0x40
[    8.237465]   copy_process+0x15e6/0x1cb0
[    8.237966]   kernel_clone+0x9b/0x3f0
[    8.238413]   kernel_thread+0x55/0x70
[    8.238861]   call_usermodehelper_exec_work+0x77/0xb0
[    8.239466]   process_one_work+0x23e/0x580
[    8.239969]   worker_thread+0x55/0x3c0
[    8.240425]   kthread+0x141/0x160
[    8.240833]   ret_from_fork+0x22/0x30
[    8.241276] 
[    8.241276] to a SOFTIRQ-irq-unsafe lock:
[    8.241939]  (tasklist_lock){.+.+}-{2:2}
[    8.241940] 
[    8.241940] ... which became SOFTIRQ-irq-unsafe at:
[    8.243180] ...
[    8.243182]   lock_acquire+0x13f/0x3f0
[    8.243853]   _raw_read_lock+0x5d/0x70
[    8.244307]   do_wait+0xd2/0x2e0
[    8.244706]   kernel_wait+0x49/0x90
[    8.245126]   call_usermodehelper_exec_work+0x61/0xb0
[    8.245748]   process_one_work+0x23e/0x580
[    8.246238]   worker_thread+0x55/0x3c0
[    8.246685]   kthread+0x141/0x160
[    8.247086]   ret_from_fork+0x22/0x30
[    8.247522] 
[    8.247522] other info that might help us debug this:
[    8.247522] 
[    8.248480]  Possible interrupt unsafe locking scenario:
[    8.248480] 
[    8.249289]        CPU0                    CPU1
[    8.249839]        ----                    ----
[    8.250386]   lock(tasklist_lock);
[    8.250811]                                local_irq_disable();
[    8.251525]                                lock(&stats->lock);
[    8.252227]                                lock(tasklist_lock);
[    8.252938]   <Interrupt>
[    8.253249]     lock(&stats->lock);
[    8.253663] 
[    8.253663]  *** DEADLOCK ***
[    8.253663] 
[    8.254362] 1 lock held by runc/2505:
[    8.254800]  #0: ffff9a6a10eb8318 (&stats->lock){+.-.}-{2:2}, at: brute_task_fatal_signal+0x97/0x210
[    8.255872] 
[    8.255872] the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
[    8.256931] -> (&stats->lock){+.-.}-{2:2} {
[    8.257432]    HARDIRQ-ON-W at:
[    8.257809]                     lock_acquire+0x13f/0x3f0
[    8.258442]                     _raw_spin_lock+0x2c/0x40
[    8.259069]                     brute_task_free+0x22/0x90
[    8.259710]                     security_task_free+0x22/0x50
[    8.260384]                     __put_task_struct+0x58/0x140
[    8.261078]                     rcu_core+0x2bb/0x620
[    8.261677]                     __do_softirq+0x156/0x4d9
[    8.262304]                     asm_call_irq_on_stack+0x12/0x20
[    8.263010]                     do_softirq_own_stack+0x5b/0x70
[    8.263699]                     irq_exit_rcu+0x9f/0xe0
[    8.264315]                     sysvec_apic_timer_interrupt+0x43/0xa0
[    8.265085]                     asm_sysvec_apic_timer_interrupt+0x12/0x20
[    8.265886]                     _raw_write_unlock_irq+0x2c/0x40
[    8.266580]                     copy_process+0x15e6/0x1cb0
[    8.267218]                     kernel_clone+0x9b/0x3f0
[    8.267832]                     kernel_thread+0x55/0x70
[    8.268444]                     call_usermodehelper_exec_work+0x77/0xb0
[    8.269234]                     process_one_work+0x23e/0x580
[    8.269912]                     worker_thread+0x55/0x3c0
[    8.270546]                     kthread+0x141/0x160
[    8.271144]                     ret_from_fork+0x22/0x30
[    8.271771]    IN-SOFTIRQ-W at:
[    8.272146]                     lock_acquire+0x13f/0x3f0
[    8.272780]                     _raw_spin_lock+0x2c/0x40
[    8.273398]                     brute_task_free+0x22/0x90
[    8.274022]                     security_task_free+0x22/0x50
[    8.274690]                     __put_task_struct+0x58/0x140
[    8.275358]                     rcu_core+0x2bb/0x620
[    8.275937]                     __do_softirq+0x156/0x4d9
[    8.276559]                     asm_call_irq_on_stack+0x12/0x20
[    8.277262]                     do_softirq_own_stack+0x5b/0x70
[    8.277948]                     irq_exit_rcu+0x9f/0xe0
[    8.278561]                     sysvec_apic_timer_interrupt+0x43/0xa0
[    8.279324]                     asm_sysvec_apic_timer_interrupt+0x12/0x20
[    8.280121]                     _raw_write_unlock_irq+0x2c/0x40
[    8.280845]                     copy_process+0x15e6/0x1cb0
[    8.281491]                     kernel_clone+0x9b/0x3f0
[    8.282117]                     kernel_thread+0x55/0x70
[    8.282734]                     call_usermodehelper_exec_work+0x77/0xb0
[    8.283514]                     process_one_work+0x23e/0x580
[    8.284181]                     worker_thread+0x55/0x3c0
[    8.284802]                     kthread+0x141/0x160
[    8.285381]                     ret_from_fork+0x22/0x30
[    8.285998]    INITIAL USE at:
[    8.286365]                    lock_acquire+0x13f/0x3f0
[    8.286975]                    _raw_spin_lock_irqsave+0x3b/0x60
[    8.287665]                    brute_share_stats+0x17/0x70
[    8.288311]                    brute_task_alloc+0x65/0x70
[    8.288948]                    security_task_alloc+0x44/0xd0
[    8.289605]                    copy_process+0x789/0x1cb0
[    8.290223]                    kernel_clone+0x9b/0x3f0
[    8.290819]                    kernel_thread+0x55/0x70
[    8.291421]                    rest_init+0x21/0x258
[    8.291995]                    start_kernel+0x566/0x587
[    8.292611]                    secondary_startup_64_no_verify+0xc2/0xcb
[    8.293384]  }
[    8.293586]  ... key      at: [<ffffffff984ce3a0>] __key.0+0x0/0x10
[    8.294324]  ... acquired at:
[    8.294679]    lock_acquire+0x13f/0x3f0
[    8.295133]    _raw_read_lock+0x5d/0x70
[    8.295589]    brute_task_fatal_signal.cold+0x49/0xe0
[    8.296185]    security_task_fatal_signal+0x22/0x30
[    8.296772]    get_signal+0x3e0/0xcf0
[    8.297212]    arch_do_signal+0x30/0x880
[    8.297682]    exit_to_user_mode_prepare+0xfc/0x170
[    8.298263]    syscall_exit_to_user_mode+0x38/0x240
[    8.298844]    entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    8.299464] 
[    8.299648] 
[    8.299648] the dependencies between the lock to be acquired
[    8.299648]  and SOFTIRQ-irq-unsafe lock:
[    8.300969] -> (tasklist_lock){.+.+}-{2:2} {
[    8.301481]    HARDIRQ-ON-R at:
[    8.301857]                     lock_acquire+0x13f/0x3f0
[    8.302482]                     _raw_read_lock+0x5d/0x70
[    8.303110]                     do_wait+0xd2/0x2e0
[    8.303677]                     kernel_wait+0x49/0x90
[    8.304266]                     call_usermodehelper_exec_work+0x61/0xb0
[    8.305038]                     process_one_work+0x23e/0x580
[    8.305700]                     worker_thread+0x55/0x3c0
[    8.306320]                     kthread+0x141/0x160
[    8.306895]                     ret_from_fork+0x22/0x30
[    8.307506]    SOFTIRQ-ON-R at:
[    8.307880]                     lock_acquire+0x13f/0x3f0
[    8.308505]                     _raw_read_lock+0x5d/0x70
[    8.309125]                     do_wait+0xd2/0x2e0
[    8.309689]                     kernel_wait+0x49/0x90
[    8.310272]                     call_usermodehelper_exec_work+0x61/0xb0
[    8.311044]                     process_one_work+0x23e/0x580
[    8.311709]                     worker_thread+0x55/0x3c0
[    8.312335]                     kthread+0x141/0x160
[    8.312910]                     ret_from_fork+0x22/0x30
[    8.313529]    INITIAL USE at:
[    8.313897]                    lock_acquire+0x13f/0x3f0
[    8.314515]                    _raw_write_lock_irq+0x34/0x50
[    8.315187]                    copy_process+0x11d5/0x1cb0
[    8.315834]                    kernel_clone+0x9b/0x3f0
[    8.316446]                    kernel_thread+0x55/0x70
[    8.317057]                    rest_init+0x21/0x258
[    8.317636]                    start_kernel+0x566/0x587
[    8.318250]                    secondary_startup_64_no_verify+0xc2/0xcb
[    8.319033]    INITIAL READ USE at:
[    8.319452]                         lock_acquire+0x13f/0x3f0
[    8.320117]                         _raw_read_lock+0x5d/0x70
[    8.320777]                         do_wait+0xd2/0x2e0
[    8.321387]                         kernel_wait+0x49/0x90
[    8.322031]                         call_usermodehelper_exec_work+0x61/0xb0
[    8.322852]                         process_one_work+0x23e/0x580
[    8.323557]                         worker_thread+0x55/0x3c0
[    8.324220]                         kthread+0x141/0x160
[    8.324837]                         ret_from_fork+0x22/0x30
[    8.325490]  }
[    8.325694]  ... key      at: [<ffffffff97206098>] tasklist_lock+0x18/0x40
[    8.326509]  ... acquired at:
[    8.326871]    lock_acquire+0x13f/0x3f0
[    8.327330]    _raw_read_lock+0x5d/0x70
[    8.327790]    brute_task_fatal_signal.cold+0x49/0xe0
[    8.328392]    security_task_fatal_signal+0x22/0x30
[    8.328958]    get_signal+0x3e0/0xcf0
[    8.329388]    arch_do_signal+0x30/0x880
[    8.329855]    exit_to_user_mode_prepare+0xfc/0x170
[    8.330434]    syscall_exit_to_user_mode+0x38/0x240
[    8.331010]    entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    8.331622] 
[    8.331801] 
[    8.331801] stack backtrace:
[    8.332322] CPU: 2 PID: 2505 Comm: runc Not tainted 5.10.0-rc3 #2
[    8.333037] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[    8.334088] Call Trace:
[    8.334385]  dump_stack+0x77/0x97
[    8.334779]  check_irq_usage.cold+0x279/0x2ec
[    8.335292]  ? check_noncircular+0x75/0x110
[    8.335783]  __lock_acquire+0x12e0/0x2590
[    8.336256]  lock_acquire+0x13f/0x3f0
[    8.336696]  ? brute_task_fatal_signal.cold+0x49/0xe0
[    8.337284]  _raw_read_lock+0x5d/0x70
[    8.337721]  ? brute_task_fatal_signal.cold+0x49/0xe0
[    8.338315]  brute_task_fatal_signal.cold+0x49/0xe0
[    8.338885]  security_task_fatal_signal+0x22/0x30
[    8.339435]  get_signal+0x3e0/0xcf0
[    8.339849]  arch_do_signal+0x30/0x880
[    8.340290]  ? rcu_read_lock_sched_held+0x3f/0x70
[    8.340853]  ? kfree+0x25d/0x2c0
[    8.341241]  exit_to_user_mode_prepare+0xfc/0x170
[    8.341796]  syscall_exit_to_user_mode+0x38/0x240
[    8.342350]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    8.342945] RIP: 0033:0x461923
[    8.343310] Code: 24 20 c3 cc cc cc cc 48 8b 7c 24 08 8b 74 24 10 8b 54 24 14 4c 8b 54 24 18 4c 8b 44 24 20 44 8b 4c 24 28 b8 ca 00 00 00 0f 05 <89> 44 24 30 c3 cc cc cc cc cc cc cc cc 8b 7c 24 08 48 8b 74 24 10
[    8.345488] RSP: 002b:00007fd62affcda8 EFLAGS: 00000286 ORIG_RAX: 00000000000000ca
[    8.346385] RAX: fffffffffffffe00 RBX: 000000c000032e00 RCX: 0000000000461923
[    8.347225] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000b3b898
[    8.348071] RBP: 00007fd62affcdf0 R08: 0000000000000000 R09: 0000000000000000
[    8.349006] R10: 0000000000000000 R11: 0000000000000286 R12: 000000c000001680
[    8.349838] R13: 00007ffd85b25fcf R14: 00007ffd85b260d0 R15: 00007fd62affcfc0

I think it should be possible to using existing task locking semantics
to manage the statistics, but I'll need to take a closer look.

> Other implementations
> ---------------------
> 
> The public version of grsecurity, as a summary, is based on the idea of
> delay the fork system call if a child died due to a fatal error. This has
> some issues:
> 
> 1.- Bad practices: Add delays to the kernel is, in general, a bad idea.
> 
> 2.- Weak points: This protection can be bypassed using two different
>     methods since it acts only when the fork is called after a child has
>     crashed.
> 
>     2.1.- Bypass 1: So, it would still be possible for an attacker to fork
>           a big amount of children (in the order of thousands), then probe
>           all of them, and finally wait the protection time before repeat
>           the steps.
> 
>     2.2.- Bypass 2: This method is based on the idea that the protection
>           doesn't act if the parent crashes. So, it would still be possible
>           for an attacker to fork a process and probe itself. Then, fork
>           the child process and probe itself again. This way, these steps
>           can be repeated infinite times without any mitigation.

It's good to clarify what the expected behaviors should be; however,
while working with the resulting system, it wasn't clear what the threat
model was for this defense. I think we need two things: clear
descriptions of what is expected to be detected (and what is not), and a
set of self-tests that can be used to validate those expectations.

Also, what, specifically, does "fatal error" cover? Is it strictly fatal
signals? (i.e. "error" might refer to exit code, for example.)

> 
> This implementation
> -------------------
> 
> The main idea behind this implementation is to improve the existing ones
> focusing on the weak points annotated before. The solution for the first
> bypass method is to detect a fast crash rate instead of only one simple
> crash. For the second bypass method the solution is to detect both the
> crash of parent and child processes. Moreover, as a mitigation method it is
> better to kill all the offending tasks involve in the attack instead of use
> delays.
> 
> So, the solution to the two bypass methods previously commented is to use
> some statistical data shared across all the processes that can have the
> same memory contents. Or in other words, a statistical data shared between
> all the fork hierarchy processes after an execve system call.

Hm, is this already tracked in some other way? i.e. the family hierarchy
of the mm struct? They're only shared on clone, but get totally copied on
fork(). Should that be the place where this is tracked instead? (i.e. I
could fork and totally rearrange my VMAs.)

> 
> The purpose of these statistics is to compute the application crash period
> in order to detect an attack. This crash period is the time between the
> execve system call and the first fault or the time between two consecutives
> faults, but this has a drawback. If an application crashes once quickly
> from the execve system call or crashes twice in a short period of time for
> some reason, a false positive attack will be triggered. To avoid this
> scenario the shared statistical data holds a list of the i last crashes
> timestamps and the application crash period is computed as follows:
> 
> crash_period = (n_last_timestamp - n_minus_i_timestamp) / i;
> 
> This ways, the size of the last crashes timestamps list allows to fine
> tuning the detection sensibility.

Instead of a list, can't the rate just be calculated on an on-going
basis?

> When this crash period falls under a certain threshold there is a clear
> signal that something malicious is happening. Once detected, the mitigation
> only kills the processes that share the same statistical data and so, all
> the tasks that can have the same memory contents. This way, an attack is
> rejected.

Here's where I think the threat model needs some more work. The above
describes what I think is a less common situation. I expect the common
attack to hold still with a single value, and let the fork/exec spin
until the value lines up. (i.e. a fork is required.)

Here are the threat scenarios that come to mind for me:

1- launching (fork/exec) a setuid process repeatedly until you get a
   desirable memory layout (e.g. what Stack Clash[1] did).

2- connecting to an exec()ing network daemon (e.g. xinetd) repeatedly
   until you get a desirable memory layout (e.g. what CTFs do for simple
   network service[2]).

3- launching processes _without_ exec (e.g. Android Zygote[3]), and
   exposing state to attack a sibling.

4- connecting to a fork()ing network daemon (e.g. apache) repeatedly
   until you expose the previously-shared memory layout of all the other
   children (e.g. kind of related to HeartBleed[3], though that was a
   direct exposure not a crasher).

In each case, a privilege boundary is being crossed (setuid in the first,
priv-changes in the 2nd, and network-to-local in the latter two), so I
suspect that kind of detail will need to play a part in the design to
help avoid false positives.

Regardless, when I tested this series, 1 and 3 isn't detected, since
they pass through an execve(), and I think that needs to be covered as
well.

[1] https://www.qualys.com/2017/06/19/stack-clash/stack-clash.txt
[2] https://github.com/BSidesPDX/CTF-2017/blob/master/pwn/200-leek/src/leek.service
[3] https://link.springer.com/article/10.1007/s10207-018-00425-8
[4] https://heartbleed.com/

> 
> 1.- Per system enabling: This feature can be enabled at build time using
>     the CONFIG_SECURITY_FORK_BRUTE option or using the visual config
>     application under the following menu:
> 
>     Security options ---> Fork brute force attack detection and mitigation

(there is a built-in boot time disabling too, by changing the lsm=
bootparam)

> 
> 2.- Per process enabling/disabling: To allow that specific applications can
>     turn off or turn on the detection and mitigation of a fork brute force
>     attack when required, there are two new prctls.
> 
>     prctl(PR_SECURITY_FORK_BRUTE_ENABLE, 0, 0, 0, 0)
>     prctl(PR_SECURITY_FORK_BRUTE_DISABLE, 0, 0, 0, 0)

How do you see this being used?

> 3.- Fine tuning: To customize the detection's sensibility there are two new
>     sysctl attributes that allow to set the last crashes timestamps list
>     size and the application crash period threshold (in milliseconds). Both
>     are accessible through the following files respectively.
> 
>     /proc/sys/kernel/brute/timestamps_list_size
>     /proc/sys/kernel/brute/crash_period_threshold
> 
>     The list size allows to avoid false positives due to crashes unrelated
>     with a real attack. The period threshold sets the time limit to detect
>     an attack. And, since a fork brute force attack will be detected if the
>     application crash period falls under this threshold, the higher this
>     value, the more sensitive the detection will be.

I wonder if these will be needed as we narrow in on the specific threat
model (i.e. there will be enough additional signal to obviate this
tuning).

And in testing I found another false positive that I haven't fully
diagnosed. I found that at boot, with Docker installed, "runc" would
immediately trip the mitigation. With some debugging added, I looks like
runc had several forked processes that got SIGKILLed in quick succession,
and then the entire group got killed by Brute. I haven't narrowed down
what runc is doing here, but it makes me wonder if there might need
to be an exception for user-space delivered signals, as opposed to
kernel-delivered signals...

Thanks again for the work! I'm liking the idea of getting a solid
protection for this. It's been a long-standing hole in upstream. :)

-Kees

-- 
Kees Cook
