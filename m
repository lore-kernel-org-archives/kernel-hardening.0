Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20160623143126.GA16664@redhat.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com> <20160623143126.GA16664@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Jun 2016 09:30:52 -0700
Message-ID: <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 7:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I didn't see the patches yet, quite possibly I misunderstood... But no,
> I don't this we can do this (if we are not going to move ti->flags to
> task_struct at least).

Argh. Yes, ti->flags is used by others. Everything else should be
thread-synchronous, but there's ti->flags.

(And if we get scheduled, the thread-synchronous things will matter, of course):

> Yes, but the problem is that a zombie thread can do its last schedule
> before it is reaped.

Worse, the wait sequence will definitely look at it.

But that does bring up another possibility: do it at wait() time, when
we do release_thread(). That's when we *used* to synchronously free
it, before we did the lockless RCU walks.

At that point, it has been removed from all the thread lists. So the
only way to find it is through the RCU walks. Do any of *those* touch
ti->flags? I'm not seeing it, and it sounds fixable if any do.

If we could release the thread stack in release_thread(), that would be good.

Andy - I bet you can at least test it.

            Linus
