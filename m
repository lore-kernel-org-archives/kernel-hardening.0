Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFzXYTOBxRW7mCub9Wt8F5KzhFZRkx_XFZFg2coN+66PjQ@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com> <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net> <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
 <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
 <CA+55aFwJ1=pyr9fP_UzDjnyX2qJ4mpxg_DTTiOJTv9PFW4dHgg@mail.gmail.com>
 <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
 <CALCETrUh0s8zV0S=Si4V_RB1dEUx6n2RtALC-+VJhGMEBqPTzA@mail.gmail.com> <CA+55aFzXYTOBxRW7mCub9Wt8F5KzhFZRkx_XFZFg2coN+66PjQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Jun 2016 11:36:44 -0700
Message-ID: <CALCETrVX289Lu6i78U0JquW2euqNCnRjrzHRc99hMAPX0FjMiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 10:56 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 24, 2016 at 10:47 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> FWIW, your patch is much more lenient than my approach.
>
> I hate big flag-days - they cause so much pain for everybody. The
> people who get it to work and can test it, can't test all the other
> cases (whether they be drivers or other architectures), so I'd much
> rather implement something that allows a gradual per-architecture
> change from having the thread_info on the stack into having the
> thread_info in the task_struct.
>
> Bit "let's just change everything at once" patches are fine (and, in
> fact, preferable) when you can test everything in one go. So something
> that can be statically verified (ie "patch makes no semantic
> difference, but changes calling convention or naming, so if it
> compiles it is fine") I much prefer just getting the pain over and
> done with rather than some lingering thing.
>
> But when it's something where "oops, I broke every other architecture,
> and I can't even test it", I'd much rather do it in a way where each
> architecture can move over to the new model one by one.

Agreed.

To clarify, though: I wasn't planning on changing all arches at once.
 I'm just saying that, for arches that switch over, they get a single
core definition of thread_info.  That way, when someone (probably
named Peter) decides down the road to move, say, thread_info::cpu into
task_struct proper to optimize cache line layout, they won't need to
do it for every architecture.

Also, I want to give people an incentive to finally move their crap
out of struct thread_info and into struct thread_struct.

--Andy
