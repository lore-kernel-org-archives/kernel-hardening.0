Date: Thu, 28 Mar 2019 10:39:58 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190328143958.GB261521@google.com>
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
 <20190328023432.GA93275@google.com>
 <20190328142619.GA19441@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328142619.GA19441@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 28, 2019 at 03:26:19PM +0100, Oleg Nesterov wrote:
> On 03/27, Joel Fernandes wrote:
> >
> > Also, based on Kees comment, I think it appears to me that get_pid and
> > put_pid can race in this way in the original code right?
> >
> > get_pid			put_pid
> >
> > 			atomic_dec_and_test returns 1
> > atomic_inc
> > 			kfree
> >
> > deref pid /* boom */
> > -------------------------------------------------
> >
> > I think get_pid needs to call atomic_inc_not_zero()
> 
> No.
> 
> get_pid() should only be used if you already have a reference or you do
> something like
> 
> 	rcu_read_lock();
> 	pid = find_vpid();
> 	get_pid();
> 	rcu_read_lock();
> 
> in this case we rely on call_rcu(delayed_put_pid) which drops the initial
> reference.
> 
> If put_pid() sees pid->count == 1, then a) nobody else has a reference and
> b) nobody else can find this pid on rcu-protected lists, so it is safe to
> free it.

I agree. Check my reply to Jann, I already replied to him about this. thanks!
