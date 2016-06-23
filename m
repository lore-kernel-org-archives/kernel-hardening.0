Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Jun 2016 18:22:17 -0700
Message-ID: <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2016 at 9:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jun 20, 2016 at 4:43 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>
>> On my laptop, this adds about 1.5=C2=B5s of overhead to task creation,
>> which seems to be mainly caused by vmalloc inefficiently allocating
>> individual pages even when a higher-order page is available on the
>> freelist.
>
> I really think that problem needs to be fixed before this should be merge=
d.
>
> The easy fix may be to just have a very limited re-use of these stacks
> in generic code, rather than try to do anything fancy with multi-page
> allocations. Just a few of these allocations held in reserve (perhaps
> make the allocations percpu to avoid new locks).

I implemented a percpu cache, and it's useless.

When a task goes away, one reference is held until the next RCU grace
period so that task_struct can be used under RCU (look for
delayed_put_task_struct).  This means that free_task gets called in
giant batches under heavy clone() load, which is the only time that
any of this matters, which means that only get to refill the cache
once per RCU batch, which means that there's very little benefit.

Once thread_info stops living in the stack, we could, in principle,
exempt the stack itself from RCU protection, thus saving a bit of
memory under load and making the cache work.  I've started working on
(optionally, per-arch) getting rid of on-stack thread_info, but that's
not ready yet.

FWIW, the same issue quite possibly hurts non-vmap-stack performance
as well, as it makes it much less likely that a cache-hot stack gets
immediately reused under heavy fork load.

So may I skip this for now?  I think that the performance hit is
unlikely to matter on most workloads, and I also expect the speedup
from not using higher-order allocations to be a decent win on some
workloads.

--Andy
