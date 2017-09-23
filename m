Date: Sat, 23 Sep 2017 11:28:33 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170923182833.GA542@zzz.localdomain>
References: <20170921185239.88398-1-ebiggers3@gmail.com>
 <20170922053314.wryoupq2vgrel24c@gmail.com>
 <20170922170724.GA103935@gmail.com>
 <20170923101733.kyq2avp6om2d2s3n@gmail.com>
 <20170923112932.yd7tmoh5kyyazv2t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170923112932.yd7tmoh5kyyazv2t@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: Simplify fpu__activate_fpstate_read()
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 23, 2017 at 01:29:32PM +0200, Ingo Molnar wrote:
> > > > 
> > > > Ok - could you please rebase these to to tip:master that is at:
> > > > 
> > > > 	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master
> > > > 
> > > > In particular this has a WIP.x86/fpu branch with FPU fixes+changes queued up but 
> > > > not merged upstream (yet), which conflict with these changes. I'd like to merge 
> > > > them all together.
> > > > 
> > > 
> > > Working on it, but there is a problem with current tip.  PTRACE_GETREGSET is
> > > causing the following warning:
> > 
> > Yes, the warning should be harmless, and I fixed it locally earlier today - does 
> > the patch below solve it for you as well?
> 
> Note that this fix is now part of tip:master as well, so if you re-test -tip you 
> should get all the latest fixes as well (including yours!).
> 

No issues so far with the latest tip/master (commit e7c6e3675331).

Eric
