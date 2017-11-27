MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jLZcPZvmeG3=MA=2uYJMqHauvSHAWs0LcrL99N+aWBHww@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com> <CAGXu5jLZcPZvmeG3=MA=2uYJMqHauvSHAWs0LcrL99N+aWBHww@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 15:14:54 -0800
Message-ID: <CA+55aFww4rnd6+HxVVC_-JHJif0-d=61WdD=jbWVWU9Cnri_bQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to
 load 'netdev-%s' modules
To: Kees Cook <keescook@chromium.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 2:59 PM, Kees Cook <keescook@chromium.org> wrote:
>
> I don't disagree that a global should be avoided, but I'm struggling
> to see another option here. We can't break userspace by default so we
> can't restrict cap-less loading by default. But we can allow userspace
> to _choose_ to break itself, especially within a container. This isn't
> uncommon, especially for modules, where we even have the global
> "modules_disabled" sysctl already. The level of granularity of control
> here is the issue, and it's what this series solves.

So there's two "global" here

 - if a container were to choose to break itself, it should damn well
be container-specific, not some global option

   This part seems to be ok in the patch series, since the "global" is
really per-task. So it's not global in the "system-wide" sense.

 - if _one_ request_module() caller were to say "I don't want to be
loaded by a normal user", that doesn't mean that _other_
request_module() cases shouldn't.

   This is the part I'm objecting to, because it means that we can't
enable this stricter policy by default.

And the thing is, the patch series seems to already introduce largely
the better model of just making it site-specific. Introducing that
request_module_cap() thing and then using it for networking is a good
step.

But I also suspect that we _could_ just make the stricter rules
actually be default, if we just fixed the thing up to not be "every
request_module() is the same".

For example, several request_module() calls come from device node
opens, and it makes sense that we can just say: "if you have access to
the device node, then you have the right to request the module".

But that would need to be not a global "request_module()" behavior,
but a behavior that is tied to the particular call-site.

IOW, extend on that request_module_cap() model, and introduce
(perhaps) a "request_module_dev()" call that basically means "the user
opened the device node for the requested module".

Because those kinds of permissions aren't necessarily about
capabilities, but about things like "I'm in the dialout group, I get
to open tty devices and by implication request their modules".

And that _really_ isn't global behavior.  The fact that I might be
able to load a serial; module has *nothing* to do with whether I can
load some other kind of module at all.

That global mode is just wrong.

                Linus
