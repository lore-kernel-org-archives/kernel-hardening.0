Date: Sun, 12 Feb 2017 13:19:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <176AF453-1CEF-4AF3-8A5F-B8AFE16A16CD@gmail.com>
Message-ID: <alpine.DEB.2.20.1702121319230.3734@nanos>
References: <201702111956.gS0EVcvY%fengguang.wu@intel.com> <alpine.DEB.2.20.1702112118120.3734@nanos> <176AF453-1CEF-4AF3-8A5F-B8AFE16A16CD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v5] fork: free vmapped stacks in cache when cpus are
 offline
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 12 Feb 2017, Hoeun Ryu wrote:
> 
> > On Feb 12, 2017, at 5:19 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> >> On Sat, 11 Feb 2017, kbuild test robot wrote:
> >> 
> >> Hi Hoeun,
> >> 
> >> [auto build test ERROR on linus/master]
> >> [also build test ERROR on v4.10-rc7 next-20170210]
> >> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >> 
> >> url:    https://github.com/0day-ci/linux/commits/Hoeun-Ryu/fork-free-vmapped-stacks-in-cache-when-cpus-are-offline/20170211-183401
> >> config: ia64-allmodconfig (attached as .config)
> >> compiler: ia64-linux-gcc (GCC) 6.2.0
> >> reproduce:
> >>        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
> >>        chmod +x ~/bin/make.cross
> >>        # save the attached .config to linux build tree
> >>        make.cross ARCH=ia64 
> >> 
> >> All errors (new ones prefixed by >>):
> >> 
> >>   kernel/fork.c: In function 'fork_init':
> >>>> kernel/fork.c:483:2: error: implicit declaration of function 'vm_stack_cache_init' [-Werror=implicit-function-declaration]
> >>     vm_stack_cache_init();
> >>     ^~~~~~~~~~~~~~~~~~~
> > 
> > Right. This needs to move to a different place as that part is nested inside
> > 
> > #ifndef CONFIG_ARCH_THREAD_STACK_ALLOCATOR
> > 
> > That's an horrible ifdef maze in that file.
> > 
> 
> I think we should rollback to v4. Do you agree?

Sigh. Yes.
