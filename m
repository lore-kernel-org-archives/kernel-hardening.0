MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJXOf_aCfvY0PQ7ESwH2r9pXrPr3XoMJ4-EQzGa3y=n0A@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <CAGXu5jLZcPZvmeG3=MA=2uYJMqHauvSHAWs0LcrL99N+aWBHww@mail.gmail.com>
 <CA+55aFww4rnd6+HxVVC_-JHJif0-d=61WdD=jbWVWU9Cnri_bQ@mail.gmail.com> <CAGXu5jJXOf_aCfvY0PQ7ESwH2r9pXrPr3XoMJ4-EQzGa3y=n0A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 15:35:17 -0800
Message-ID: <CA+55aFxP6F0r2FJw6kzBz--9u9uHmKT47JMGi1cmHuieD3Kxkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to
 load 'netdev-%s' modules
To: Kees Cook <keescook@chromium.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 3:19 PM, Kees Cook <keescook@chromium.org> wrote:
>
> What about exporting this entirely to userspace, giving it as much
> context as possible? i.e. inform modprobe about the user doing it,
> maybe the subsystem, etc?

Yeah, except for the fact that we don't trust user-mode?

We used to do that exact thing. It was a nasty disaster, and caused
version skew and other horrible problems.

So no. Th e"let's just let user mode sort it out" doesn't work. User
mode doesn't sort anything out, it just makes it worse.

It's not some made-up example when I say that user-mode has decided
that kernel requests have to be completely serialized, and recusive
invocations will just hang.

So no. We do not go down that particular rat-hole. It's just a bigger
chance of getting things wrong.

                Linus
