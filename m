Date: Fri, 10 Feb 2017 15:41:30 +0100
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20170210144130.GP10893@dhcp22.suse.cz>
References: <1486715554-12772-1-git-send-email-hoeun.ryu@gmail.com>
 <20170210120524.GI10893@dhcp22.suse.cz>
 <CABeRdtrqpmJtEnqawruAo-hW1yZG_wB6TGL95=knP0cBmDKZ+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeRdtrqpmJtEnqawruAo-hW1yZG_wB6TGL95=knP0cBmDKZ+Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri 10-02-17 23:31:41, Hoeun Ryu wrote:
> On Fri, Feb 10, 2017 at 9:05 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Fri 10-02-17 17:32:07, Hoeun Ryu wrote:
[...]
> >>  static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
> >> @@ -456,6 +474,11 @@ void __init fork_init(void)
> >>       for (i = 0; i < UCOUNT_COUNTS; i++) {
> >>               init_user_ns.ucount_max[i] = max_threads/2;
> >>       }
> >> +
> >> +#ifdef CONFIG_VMAP_STACK
> >> +     cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "vm_stack_cache",
> >> +                       NULL, free_vm_stack_cache);
> >> +#endif
> >
> > I am not familiar the new hotplug infrastructure so I might be missing
> > something. CPUHP_AP_ONLINE_DYN will allocate a state which is has only
> > 30 slots available. The name also suggests this will be called on an
> > online event. Why doesn't this have its own state like other users. The
> > name should also reflect offline event CPUHP_STACK_CACHE_DEAD or
> > something like that.
> 
> I'll define CPUHP_VMSTACK_CACHE_DEAD before CPUHP_BP_PREPARE_DYN in
> cpuhotplug.h.
> Do you think the change is made in a separate patch or not ?

I think it should be in a single patch. I am not sure what are the rules
to define a new state though. Let's CC Thomas.
-- 
Michal Hocko
SUSE Labs
