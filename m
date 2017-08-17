Date: Thu, 17 Aug 2017 16:30:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CAGXu5jKu6JWC6hw4BYGPA+qatMdd-SiaO2LiJy6XnAfjbU+1Rw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1708171621410.2271@nanos>
References: <CAGXu5jKu6JWC6hw4BYGPA+qatMdd-SiaO2LiJy6XnAfjbU+1Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: refactoring timers to avoid init_timer*()
To: Kees Cook <keescook@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 16 Aug 2017, Kees Cook wrote:
> In the process I noticed that we already have
> scripts/coccinelle/api/setup_timer.cocci to detect existing cases of:
> 
> init_timer(t);
> t->function = func;
> t->data = data;
> 
> And replace it with: setup_timer(t, func, data);
> 
> Another pattern was:
> 
> t->expires = when;
> add_timer(t);
> 
> Which can be replaced with mod_timer(t, when);
> 
> So, I've created scripts/coccinelle/api/mod_timer.cocci for the
> latter, and done a few passes with manual review. The current result
> doesn't fully eliminate init_timer() yet, but it gets much closer. I
> just wanted to be sure that this whole clean-up would actually be
> welcome before I try to nail down the last many cases.

I think it's worth the trouble, but rather than having a gazillion of
commits with the same changelog, we should do that based on a cocci script
right before the next rc1 in one go and be done with it.

That will cover most of the init_timer() cases and we can fixup the
remaining few oddballs manually after that.

I just noticed that we have the same pattern with hrtimer_init(). I had a
stab on adding hrtimer_setup() and friends which takes a function argument
and converted the bulk with coccinelle.

    82 files changed, 186 insertions(+), 210 deletions(-)

We can do that in the same sweep as the init_timer() one and then you can
do the canary magic on hrtimers as well.

Thanks,

	tglx
