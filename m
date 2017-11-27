MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com> <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Nov 2017 14:59:08 -0800
Message-ID: <CAGXu5jLZcPZvmeG3=MA=2uYJMqHauvSHAWs0LcrL99N+aWBHww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to
 load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 2:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 27, 2017 at 1:41 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>>
>> However, we are trying hard to abstract some semantics that are easy
>> to grasp, we are mutating capabilities and seccomp to have an
>> abstracted "yes/no" options for our endusers.
>
> Yes.
>
> Sadly, it looks like we actually do have users that just expect to
> load modules dynamically without any capabilities at all.
>
> So we can't actually disallow it by default at all, which imho makes
> this security option essentially useless.

The good news here is that this series comes with an expected user:
systemd, for which I suspect this will option will get wider and wider
use.

> A security option that people can't use without breaking their system
> is pointless.

Another bit of good news is that systems _depending_ cap-less module
loading are uncommon enough that many system builders can enable this
protection and nothing will break. (Even you thought it was rare
enough that we could just make this default-enabled.)

Besides, distros understand that they have to keep an eye out for
these things since the kernel has a long history of not allowing
default-enabled protections that change userspace behavior, etc.

> So I wonder if we can perhaps look at the places that actually do
> "requerst_module()", and start filtering them on that basis.
>
> Some of them will already have checked for capabilities.
>
> Others clearly expect to just work even _without_ capabilities (ie
> the bluetoothd case).
>
> So the whole "let's add a global config option" model is broken. There
> is no possible global rule. It will break things, which in turn mean
> that people won't turn it on (and we can't turn it on by default),
> which in turn makes this pointless.
>
> In other words, I really think that anything that just adds a mode
> flag cannot work.
>
> So instead of having one "modules_autoload_mode" thing, maybe the
> individual requerst_module() cases need to simply be audited.
>
> Put another way: I think the part of your patch series that does that
> "request_module_cap()" and makes the netdev modules use it is a good
> addition.
>
> It's the "mode" part I really don't agree with, because apparently we
> really need to default it to permissive.
>
> So how about instead:
>
>  - add that "request_module_cap()" and make the networking code that
> already uses CAP_ADMIN_NET use it.
>
>  - make "request_module()" itself default to being
> "request_module_cap(CAP_SYS_MODULE,..)"
>
>  - make sure that when the capability check fails, we print an error
> message, and then for the ones that trigger, we will audit them and
> see if it's ok.

The issue isn't "is it always okay to cap-less-load this module?" it's
"should the kernel's attack surface be allowed to grown by an
unprivileged user?" Nearly all the request_module() sites have already
been audited and adjusted to avoid _arbitrary_ module loading (usually
by adding module prefixes: netdev-, crypto-, etc), and that greatly
helped reduce the ability for a unprivileged user to load a
known-buggy module, but there will remain many subsystems that
continue to expect to grow the kernel's features on demand within
their subsystem, and sometimes those modules will have bugs that an
unprivileged user can exploit (this history of this happening is quite
real; it's not a theoretical concern). This is especially problematic
for distro kernels where they build tons of modules.

There isn't a way for an admin to say "I only want root to be able to
load modules". They can't delete all the "unused" kernel modules,
because maybe root will want the module, they can't change module file
permissions because the modules are read with init's permissions (and
it would be terrible to repeatedly change all the file perms each time
a new kernel got installed), modules can only be blacklisted (not
whitelisted) in /etc/modprobe.d/, etc.

> Because that "mode" flag defaulting to off will just mean that the
> default case will remain the existing unsafe one, and that's bad.
>
> Opt-in really doesn't work. We've done it.
>
> Global flags for varied behavior really doesn't work. We've done that
> too. Different cases want different behavior, the global flag is just
> fundamentally broken.

I don't disagree that a global should be avoided, but I'm struggling
to see another option here. We can't break userspace by default so we
can't restrict cap-less loading by default. But we can allow userspace
to _choose_ to break itself, especially within a container. This isn't
uncommon, especially for modules, where we even have the global
"modules_disabled" sysctl already. The level of granularity of control
here is the issue, and it's what this series solves.

The options I see for module loading control are:
1) monolithic kernel (no modules)
2) modular kernel that flips on modules_disabled after boot (no
modules after boot)
3) modular kernel that allows per-subsystem unpriv module loading (all
modules loadable)

There is a demand for something between 2 and 3 where only root can
load modules. (And as pointed out in the series, this is _especially_
true for containers where the admin may want to leave module loading
alone in the init namespace, but stop any module loading in the
container.)

-Kees

-- 
Kees Cook
Pixel Security
