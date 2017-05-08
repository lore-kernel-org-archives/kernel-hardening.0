Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 8 May 2017 09:52:09 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170508075209.7aluvpwildw325rf@gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170508073352.caqe3fqf7nuxypgi@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address limit before returning
 to user-mode
To: Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>


* Ingo Molnar <mingo@kernel.org> wrote:

> ... and even a relatively simple static analysis tool ought to be able to see 
> through that.
> 
> I'd even suggest we do it not like Sparse builds are done today, but in a more 
> integrated fashion: do static analysis as part of a typical kernel defconfig 
> build and not tolerate warnings but go for a 'zero warnings' policy like Linus 
> uses for modconfig builds.
> 
> _That_ solution I'd feel very, very good about - it would be so much better than 
> any runtime checks...

So the problem I have with Sparse is that it is very spammy. For example:

	make C=1 kernel/sched/

... produces:

    kernel/sched/core.c:792:6: warning: symbol 'sched_set_stop_task' was not declared. Should it be static?
    kernel/sched/core.c:1298:5: warning: symbol 'migrate_swap' was not declared. Should it be static?
    kernel/sched/core.c:3648:35: warning: symbol 'preempt_schedule_irq' was not declared. Should it be static?
    ./include/linux/uaccess.h:166:18: warning: incorrect type in argument 1 (different modifiers)
    ./include/linux/uaccess.h:166:18:    expected void *<noident>
    ./include/linux/uaccess.h:166:18:    got void const *from
    ./include/linux/uaccess.h:166:18: warning: incorrect type in argument 1 (different modifiers)
    ./include/linux/uaccess.h:166:18:    expected void *<noident>
    ./include/linux/uaccess.h:166:18:    got void const *from
    ./include/linux/uaccess.h:166:18: warning: incorrect type in argument 1 (different modifiers)
    ./include/linux/uaccess.h:166:18:    expected void *<noident>
    ./include/linux/uaccess.h:166:18:    got void const *from
    ./include/linux/uaccess.h:166:18: warning: incorrect type in argument 1 (different modifiers)
    ./include/linux/uaccess.h:166:18:    expected void *<noident>
    ./include/linux/uaccess.h:166:18:    got void const *from
    kernel/sched/clock.c:80:19: warning: symbol 'sched_clock_running' was not declared. Should it be static?
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    kernel/sched/cputime.c:335:33: warning: context imbalance in 'thread_group_cputime' - different lock contexts for basic block
    kernel/sched/fair.c:54:14: warning: symbol 'normalized_sysctl_sched_latency' was not declared. Should it be static?
    kernel/sched/fair.c:75:14: warning: symbol 'normalized_sysctl_sched_min_granularity' was not declared. Should it be static?
    kernel/sched/fair.c:98:14: warning: symbol 'normalized_sysctl_sched_wakeup_granularity' was not declared. Should it be static?
    kernel/sched/fair.c:132:14: warning: symbol 'capacity_margin' was not declared. Should it be static?
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/fair.c:4688:35: error: marked inline, but without a definition
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/fair.c:5817:19: error: cannot dereference this type
    kernel/sched/fair.c:5817:19: error: cannot dereference this type
    kernel/sched/fair.c:5817:19: error: internal error: bad type in derived(11)
    kernel/sched/fair.c:5817:19: error: cannot dereference this type
    kernel/sched/fair.c:5817:19: error: incompatible types in comparison expression (different base types)
    kernel/sched/fair.c:5817:19: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/rt.c:635:6: warning: symbol 'sched_rt_bandwidth_account' was not declared. Should it be static?
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: internal error: bad type in derived(11)
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    kernel/sched/sched.h:1988:16: error: incompatible types in comparison expression (different base types)
    kernel/sched/sched.h:1988:16: error: cannot dereference this type
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    ./include/linux/sched/cputime.h:83:14: warning: expression using sizeof bool
    kernel/sched/topology.c:499:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:499:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:499:28:    got struct sched_domain **<noident>
    kernel/sched/topology.c:534:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:534:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:534:28:    got struct sched_domain **<noident>
    kernel/sched/topology.c:554:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:554:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:554:28:    got struct sched_group_capacity **<noident>
    kernel/sched/topology.c:594:36: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:594:36:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:594:36:    got struct sched_domain **<noident>
    kernel/sched/topology.c:601:24: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:601:24:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:601:24:    got struct sched_group **<noident>
    kernel/sched/topology.c:602:31: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:602:31:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:602:31:    got struct sched_group_capacity **<noident>
    kernel/sched/topology.c:1330:39: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1330:39:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1330:39:    got struct sched_domain **<noident>
    kernel/sched/topology.c:1333:40: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1333:40:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1333:40:    got struct sched_domain **<noident>
    kernel/sched/topology.c:1337:40: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1337:40:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1337:40:    got struct sched_domain_shared **<noident>
    kernel/sched/topology.c:1339:40: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1339:40:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1339:40:    got struct sched_group **<noident>
    kernel/sched/topology.c:1341:40: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1341:40:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1341:40:    got struct sched_group_capacity **<noident>
    kernel/sched/topology.c:1343:32: warning: incorrect type in argument 1 (different address spaces)
    kernel/sched/topology.c:1343:32:    expected void [noderef] <asn:3>*__pdata
    kernel/sched/topology.c:1343:32:    got struct sched_domain **[noderef] sd
    kernel/sched/topology.c:1345:32: warning: incorrect type in argument 1 (different address spaces)
    kernel/sched/topology.c:1345:32:    expected void [noderef] <asn:3>*__pdata
    kernel/sched/topology.c:1345:32:    got struct sched_domain_shared **[noderef] sds
    kernel/sched/topology.c:1347:32: warning: incorrect type in argument 1 (different address spaces)
    kernel/sched/topology.c:1347:32:    expected void [noderef] <asn:3>*__pdata
    kernel/sched/topology.c:1347:32:    got struct sched_group **[noderef] sg
    kernel/sched/topology.c:1349:32: warning: incorrect type in argument 1 (different address spaces)
    kernel/sched/topology.c:1349:32:    expected void [noderef] <asn:3>*__pdata
    kernel/sched/topology.c:1349:32:    got struct sched_group_capacity **[noderef] sgc
    kernel/sched/topology.c:1261:25: warning: incorrect type in assignment (different address spaces)
    kernel/sched/topology.c:1261:25:    expected struct sched_domain **[noderef] sd
    kernel/sched/topology.c:1261:25:    got struct sched_domain *[noderef] <asn:3>*<noident>
    kernel/sched/topology.c:1265:26: warning: incorrect type in assignment (different address spaces)
    kernel/sched/topology.c:1265:26:    expected struct sched_domain_shared **[noderef] sds
    kernel/sched/topology.c:1265:26:    got struct sched_domain_shared *[noderef] <asn:3>*<noident>
    kernel/sched/topology.c:1269:25: warning: incorrect type in assignment (different address spaces)
    kernel/sched/topology.c:1269:25:    expected struct sched_group **[noderef] sg
    kernel/sched/topology.c:1269:25:    got struct sched_group *[noderef] <asn:3>*<noident>
    kernel/sched/topology.c:1273:26: warning: incorrect type in assignment (different address spaces)
    kernel/sched/topology.c:1273:26:    expected struct sched_group_capacity **[noderef] sgc
    kernel/sched/topology.c:1273:26:    got struct sched_group_capacity *[noderef] <asn:3>*<noident>
    kernel/sched/topology.c:1288:26: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1288:26:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1288:26:    got struct sched_domain **<noident>
    kernel/sched/topology.c:1295:26: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1295:26:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1295:26:    got struct sched_domain_shared **<noident>
    kernel/sched/topology.c:1304:26: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1304:26:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1304:26:    got struct sched_group **<noident>
    kernel/sched/topology.c:1311:26: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1311:26:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1311:26:    got struct sched_group_capacity **<noident>
    kernel/sched/topology.c:759:30: warning: incorrect type in argument 1 (different address spaces)
    kernel/sched/topology.c:759:30:    expected void [noderef] <asn:3>*__pdata
    kernel/sched/topology.c:759:30:    got struct sched_domain **[noderef] sd
    kernel/sched/topology.c:776:15: warning: incorrect type in assignment (different address spaces)
    kernel/sched/topology.c:776:15:    expected struct sched_domain **[noderef] sd
    kernel/sched/topology.c:776:15:    got struct sched_domain *[noderef] <asn:3>*<noident>
    kernel/sched/topology.c:794:9: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:794:9:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:794:9:    got struct sched_domain **<noident>
    kernel/sched/topology.c:795:10: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:795:10:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:795:10:    got struct sched_domain **<noident>
    kernel/sched/topology.c:797:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:797:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:797:28:    got struct sched_domain_shared **<noident>
    kernel/sched/topology.c:798:18: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:798:18:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:798:18:    got struct sched_domain_shared **<noident>
    kernel/sched/topology.c:800:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:800:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:800:28:    got struct sched_group **<noident>
    kernel/sched/topology.c:801:18: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:801:18:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:801:18:    got struct sched_group **<noident>
    kernel/sched/topology.c:803:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:803:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:803:28:    got struct sched_group_capacity **<noident>
    kernel/sched/topology.c:804:18: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:804:18:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:804:18:    got struct sched_group_capacity **<noident>
    kernel/sched/topology.c:848:36: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:848:36:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:848:36:    got struct sched_domain **<noident>
    kernel/sched/topology.c:954:31: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:954:31:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:954:31:    got struct sched_domain_shared **<noident>
    kernel/sched/topology.c:1354:21: warning: symbol 'build_sched_domain' was not declared. Should it be static?
    kernel/sched/topology.c:1409:34: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1409:34:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1409:34:    got struct sched_domain **<noident>
    kernel/sched/topology.c:1419:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1419:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1419:28:    got struct sched_domain **<noident>
    kernel/sched/topology.c:1436:28: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1436:28:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1436:28:    got struct sched_domain **<noident>
    kernel/sched/topology.c:1446:23: warning: incorrect type in initializer (different address spaces)
    kernel/sched/topology.c:1446:23:    expected void const [noderef] <asn:3>*__vpp_verify
    kernel/sched/topology.c:1446:23:    got struct sched_domain **<noident>
    kernel/sched/topology.c:759:29: warning: dereference of noderef expression
    kernel/sched/topology.c:777:14: warning: dereference of noderef expression
    kernel/sched/topology.c:1262:22: warning: dereference of noderef expression
    kernel/sched/topology.c:1266:22: warning: dereference of noderef expression
    kernel/sched/topology.c:1270:22: warning: dereference of noderef expression
    kernel/sched/topology.c:1274:22: warning: dereference of noderef expression
    kernel/sched/topology.c:1329:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1336:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1338:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1340:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1343:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1344:17: warning: dereference of noderef expression
    kernel/sched/topology.c:1345:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1346:17: warning: dereference of noderef expression
    kernel/sched/topology.c:1347:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1348:17: warning: dereference of noderef expression
    kernel/sched/topology.c:1349:29: warning: dereference of noderef expression
    kernel/sched/topology.c:1350:17: warning: dereference of noderef expression

... it's just not usable in that form for a regular maintenance flow.

So what would be more useful is to add a specific Sparse check that only checks 
KERNEL_DS, to add it as a regular (.config driven) build option and make sure the 
kernel build has zero warnings.

>From that point on we can declare that this kind of bug won't occur anymore, if 
the Sparse implementation of the check is correct.

But there's a (big) problem with that development model: Sparse is not part of the 
kernel tree and adding a feature to it while making the kernel depend on that 
brand new feature is a logistical nightmare. The overhead is quite similar to 
adding new features to a compiler - it happens at a glacial pace and is only done 
for major features really, at considerable expense. I don't think this is an 
adequate model for 'extended syntax checking' of the kernel, especially when it 
comes to correctness that has such obvious security impact.

Thanks,

	Ingo
