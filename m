Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 22:22:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20160624202254.GA30695@redhat.com>
References: <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com> <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com> <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com> <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com> <20160623170352.GA17372@redhat.com> <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com> <20160623185221.GA17983@redhat.com> <20160624140558.GA20208@dhcp22.suse.cz> <20160624150637.GD20203@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160624150637.GD20203@dhcp22.suse.cz>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages
	(x86, core)
To: Michal Hocko <mhocko@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/24, Michal Hocko wrote:
>
> On Fri 24-06-16 16:05:58, Michal Hocko wrote:
> > On Thu 23-06-16 20:52:21, Oleg Nesterov wrote:
> > >
> > > But I agree, this is fixable (and in fact I still hope TIF_MEMDIE will die,
> > > at least in its current form).
> >
> > We can move the flag to the task_struct.

Well, I actually meant that to me its usage doesn't look really
right and we need to change this logic. But this is off-topic.

> Here is the patch.

Can't comment, but note that it was decided to move ti->flags into
task_struct, so the patch is "off-topic" too ;)

> @@ -1856,6 +1856,8 @@ struct task_struct {
>  	unsigned long	task_state_change;
>  #endif
>  	int pagefault_disabled;
> +	/* oom victim - give it access to memory reserves */
> +	atomic_t	memdie;

Yet another oom member. And these atomic_add_unless's look a bit
strange, it seems that you could add "bool memdie" and use xchg()
with the same effect?

Oleg.
