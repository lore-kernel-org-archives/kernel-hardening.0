From: Geo Kozey <geokozey@mailfence.com>
Message-ID: <1100603534.56586.1511871419952@ichabod.co-bxl>
In-Reply-To: <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com> <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com> <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com> <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Nov 2017 13:16:59 +0100 (CET)
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Sent: Mon Nov 27 23:04:58 CET 2017
> To: Djalal Harouni <tixxdz@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Luis R. Rodriguez <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, David S. Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
> Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to load 'netdev-%s' modules
> 
> 
> On Mon, Nov 27, 2017 at 1:41 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
> >
> > However, we are trying hard to abstract some semantics that are easy
> > to grasp, we are mutating capabilities and seccomp to have an
> > abstracted "yes/no" options for our endusers.
> 
> Yes.
> 
> Sadly, it looks like we actually do have users that just expect to
> load modules dynamically without any capabilities at all.
> 
> So we can't actually disallow it by default at all, which imho makes
> this security option essentially useless.
> 
> A security option that people can't use without breaking their system
> is pointless.
> 
> We saw that with SELinux - people ended up just disabling it for
> _years_, simply because it ended up breaking so much in practice. And
> yes, it got fixed eventually, but at an incredibly high maintenance
> cost of all the crazy rules databases.
> 
> > Alright, but I guess we are stuck, is there something better on how we
> > can do this or describe this ?
> 
> So I wonder if we can perhaps look at the places that actually do
> "requerst_module()", and start filtering them on that basis.
> 
> Some of them will already have checked for capabilities.
> 
> Others clearly expect to juist work even _without_ capabilities (ie
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
> 
> Because that "mode" flag defaulting to off will just mean that the
> default case will remain the existing unsafe one, and that's bad.
> 
> Opt-in really doesn't work. We've done it.
> 
> Global flags for varied behavior really doesn't work. We've done that
> too. Different cases want different behavior, the global flag is just
> fundamentally broken.
> 
>               Linus
> ----------------------------------------

The only reason this is off by default is kernel rule No 1. Most of new security features are off or WARN_ON because of it otherwise bad things happen on mailinglists :) .

It seems to me that you demand an impossible job here. Don't break userspace and don't disable by default. It can't happen due to years of technical debt. I mean everyone prefers default-on but we can choose best alternative instead of maintaining status quo.

Userspace can be configured in a way which is compatible with those changes being on the same as it can be configured to work with selinux. That means on distro level or sysadmin level it's a valuable tool. It's better than nothing and it's better than using some out-of-tree patches instead. Switching one sysctl would make their life easier.

There is demand for kernel hardening stuff and default-off behavior is good compromise between breaking changes and nothing at all. The kernel has very diverse users group with different needs and capabilities so there is no one size fits all. Targeting all of them will often end in nothing useful to anyone.

Yours sincerely

G. K.
