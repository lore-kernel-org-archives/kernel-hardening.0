Date: Fri, 7 Apr 2017 15:12:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20170407151249.b1d45218ad2f71bdc2c8f992@linux-foundation.org>
In-Reply-To: <CAGXu5jJ49PZx9T=hTNcFK8sjxLCdp_KBpiFzKLCt1jwj2Q7+3Q@mail.gmail.com>
References: <20170406033550.32525-1-ewk@edkovsky.org>
	<CAGXu5jJ49PZx9T=hTNcFK8sjxLCdp_KBpiFzKLCt1jwj2Q7+3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 0/2] provide check for ro_after_init memory sections
To: Kees Cook <keescook@chromium.org>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Eddie Kovsky <ewk@edkovsky.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 7 Apr 2017 14:53:23 -0700 Kees Cook <keescook@chromium.org> wrote:

> > Eddie Kovsky (2):
> >   module: verify address is read-only
> >   extable: verify address is read-only
> >
> >  include/linux/kernel.h |  2 ++
> >  include/linux/module.h | 12 ++++++++++++
> >  kernel/extable.c       | 29 +++++++++++++++++++++++++++
> >  kernel/module.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 96 insertions(+)
> 
> Andrew, do you have these in your mailbox (it went to lkml), or should
> I resend them directly to you? Since they depend on the
> __start_ro_after_init naming fixes in -mm, it seemed like it'd be best
> to carry these two patches there. If so, please consider them both:
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> (And, from the thread on the module patch, Jessica has Acked that one too.)

Well I grabbed them, but the patches don't actually do anything - they
add interfaces with no users.  What's the plan here?
