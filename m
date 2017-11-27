MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 14:04:58 -0800
Message-ID: <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to
 load 'netdev-%s' modules
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 1:41 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>
> However, we are trying hard to abstract some semantics that are easy
> to grasp, we are mutating capabilities and seccomp to have an
> abstracted "yes/no" options for our endusers.

Yes.

Sadly, it looks like we actually do have users that just expect to
load modules dynamically without any capabilities at all.

So we can't actually disallow it by default at all, which imho makes
this security option essentially useless.

A security option that people can't use without breaking their system
is pointless.

We saw that with SELinux - people ended up just disabling it for
_years_, simply because it ended up breaking so much in practice. And
yes, it got fixed eventually, but at an incredibly high maintenance
cost of all the crazy rules databases.

> Alright, but I guess we are stuck, is there something better on how we
> can do this or describe this ?

So I wonder if we can perhaps look at the places that actually do
"requerst_module()", and start filtering them on that basis.

Some of them will already have checked for capabilities.

Others clearly expect to juist work even _without_ capabilities (ie
the bluetoothd case).

So the whole "let's add a global config option" model is broken. There
is no possible global rule. It will break things, which in turn mean
that people won't turn it on (and we can't turn it on by default),
which in turn makes this pointless.

In other words, I really think that anything that just adds a mode
flag cannot work.

So instead of having one "modules_autoload_mode" thing, maybe the
individual requerst_module() cases need to simply be audited.

Put another way: I think the part of your patch series that does that
"request_module_cap()" and makes the netdev modules use it is a good
addition.

It's the "mode" part I really don't agree with, because apparently we
really need to default it to permissive.

So how about instead:

 - add that "request_module_cap()" and make the networking code that
already uses CAP_ADMIN_NET use it.

 - make "request_module()" itself default to being
"request_module_cap(CAP_SYS_MODULE,..)"

 - make sure that when the capability check fails, we print an error
message, and then for the ones that trigger, we will audit them and
see if it's ok.

Because that "mode" flag defaulting to off will just mean that the
default case will remain the existing unsafe one, and that's bad.

Opt-in really doesn't work. We've done it.

Global flags for varied behavior really doesn't work. We've done that
too. Different cases want different behavior, the global flag is just
fundamentally broken.

              Linus
