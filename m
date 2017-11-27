MIME-Version: 1.0
In-Reply-To: <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 27 Nov 2017 22:41:31 +0100
Message-ID: <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to
 load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

On Mon, Nov 27, 2017 at 7:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 27, 2017 at 9:18 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> This uses the new request_module_cap() facility to directly propagate
>> CAP_NET_ADMIN capability and the 'netdev' module prefix to the
>> capability subsystem as it was suggested.
>
> This is the kind of complexity that I wonder if it's worth it at all.
>
> Nobody sane actually uses those stupid capability bits. Have you ever
> actually seen it used in real life?

Yes they are complicated even for developers, and normal users do not
understand them, however yes every sandbox and container is exposing
them to endusers directly, they are documented!  so yes CAP_SYS_MODULE
is exposed but it does not cover autoloading.

However, we are trying hard to abstract some semantics that are easy
to grasp, we are mutating capabilities and seccomp to have an
abstracted "yes/no" options for our endusers.

Now, if you are referring to kernel code, the networking subsystem is
using them and I don't want to break any assumption here. There is
still the request_module(), the request_module_cap() was suggested so
networking code later won't have to do the checks on its own, and
maybe it can be consistent in the long term. The phonet sockets even
needs CAP_SYS_ADMIN...


>
> They were a mistake, and we should never have done them - another case
> of security people who think that complexity == security, when in
> reality nobody actually wants the complexity or is willing to set it
> up and manage it.

Alright, but I guess we are stuck, is there something better on how we
can do this or describe this ?


Please note in these patches, the mode is specifically described as:

* allowed: for backward compatibility  (I would have done without it)
* privileged: which includes capabilities (backward compatibility too)
or we can add what ever in the future
* disabled: even for privileged.

So I would have preferred if it is something like "yes/no" but...
However in userspace we will try hard to hide this complexity and the
capability bits.

Now I can see that the code comments and doc refer to privileged with
capabilities a lot, where we can maybe update that doc and code to
less state that privileged means capabilities ? Suggestions ?

Thanks!

>                    Linus


-- 
tixxdz
