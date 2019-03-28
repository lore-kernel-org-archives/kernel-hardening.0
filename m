Date: Thu, 28 Mar 2019 17:26:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190328162641.GC19441@redhat.com>
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
 <20190328023432.GA93275@google.com>
 <CAG48ez2bbSYpNHcC4oucx_AG=5y4K5pZfSOfN3mxGadJGpHuQQ@mail.gmail.com>
 <20190328143738.GA261521@google.com>
 <CAG48ez1-3dLvzQoxxoUzTUq8dc1wwvwPBBxX_X9FWMscWTS-FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1-3dLvzQoxxoUzTUq8dc1wwvwPBBxX_X9FWMscWTS-FQ@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/28, Jann Horn wrote:
>
> Since we're just talking about RCU stuff now, adding Paul McKenney to
> the thread.

Since you added Paul let me add more confusion to this thread ;)

There were some concerns about the lack of barriers in put_pid(), but I can't
find that old discussion and I forgot the result of that discussion...

Paul, could you confirm that this code

	CPU_0		CPU_1

	X = 1;		if (READ_ONCE(Y))
	mb();			X = 2;
	Y = 1;		BUG_ON(X != 2);


is correct? I think it is, control dependency pairs with mb(), right?

If not, then put_pid() needs atomic_read_acquire() as it was proposed in that
discussion.

Oleg.
