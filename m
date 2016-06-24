Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 16:05:58 +0200
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20160624140558.GA20208@dhcp22.suse.cz>
References: <cover.1466466093.git.luto@kernel.org>
 <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com>
 <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com>
 <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <20160623185221.GA17983@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160623185221.GA17983@redhat.com>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu 23-06-16 20:52:21, Oleg Nesterov wrote:
> On 06/23, Linus Torvalds wrote:
> >
> > On Thu, Jun 23, 2016 at 10:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > Let me quote my previous email ;)
> > >
> > >         And we can't free/nullify it when the parent/debuger reaps a zombie,
> > >         say, mark_oom_victim() expects that get_task_struct() protects
> > >         thread_info as well.
> > >
> > > probably we can fix all such users though...
> >
> > TIF_MEMDIE is indeed a potential problem, but I don't think
> > mark_oom_victim() is actually problematic.
> >
> > mark_oom_victim() is called with either "current",
> 
> This is no longer true in -mm tree.
> 
> But I agree, this is fixable (and in fact I still hope TIF_MEMDIE will die,
> at least in its current form).

We can move the flag to the task_struct. There are still some bits left
there. This would be trivial so that the oom usage doesn't stay in the
way.
-- 
Michal Hocko
SUSE Labs
