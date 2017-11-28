MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFww4rnd6+HxVVC_-JHJif0-d=61WdD=jbWVWU9Cnri_bQ@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <CAGXu5jLZcPZvmeG3=MA=2uYJMqHauvSHAWs0LcrL99N+aWBHww@mail.gmail.com> <CA+55aFww4rnd6+HxVVC_-JHJif0-d=61WdD=jbWVWU9Cnri_bQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Nov 2017 17:23:33 -0800
Message-ID: <CAGXu5j+mfEXzbsxFwkv8W_sS1RdxwxNp+HnN+bfHabFXmf49FA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to
 load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 3:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 27, 2017 at 2:59 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> I don't disagree that a global should be avoided, but I'm struggling
>> to see another option here. We can't break userspace by default so we
>> can't restrict cap-less loading by default. But we can allow userspace
>> to _choose_ to break itself, especially within a container. This isn't
>> uncommon, especially for modules, where we even have the global
>> "modules_disabled" sysctl already. The level of granularity of control
>> here is the issue, and it's what this series solves.
>
> So there's two "global" here
>
>  - if a container were to choose to break itself, it should damn well
> be container-specific, not some global option
>
>    This part seems to be ok in the patch series, since the "global" is
> really per-task. So it's not global in the "system-wide" sense.

Right, though in the case of init, it could flip that toggle for
itself and it would then effectively be system-wide.

>  - if _one_ request_module() caller were to say "I don't want to be
> loaded by a normal user", that doesn't mean that _other_
> request_module() cases shouldn't.
>
>    This is the part I'm objecting to, because it means that we can't
> enable this stricter policy by default.

Okay, I see what you mean here. You want to clearly distinguish
between unprivileged and privileged-only. I'm unconvinced that's going
to change much, as the bulk of the exposed request_module() users are
already expecting to be unprivileged (and that's why they were all
converted to requiring a named prefix).

> And the thing is, the patch series seems to already introduce largely
> the better model of just making it site-specific. Introducing that
> request_module_cap() thing and then using it for networking is a good
> step.
>
> But I also suspect that we _could_ just make the stricter rules
> actually be default, if we just fixed the thing up to not be "every
> request_module() is the same".

When doing some of the older module name prefix work, I did consider
introducing a new request_module() API that included the prefix name
as an explicit argument (instead of embedding it in the format
string). We could easily start there, and then have "plain"
request_module() require privs. But we'll still need a way to say
"admin doesn't want unpriv module auto-loading".

> For example, several request_module() calls come from device node
> opens, and it makes sense that we can just say: "if you have access to
> the device node, then you have the right to request the module".

Many of these callers are using network interfaces to do this work, so
there isn't as clean a permission model associated with those like
there might be with a filesystem open(). But that doesn't matter (see
below).

> But that would need to be not a global "request_module()" behavior,
> but a behavior that is tied to the particular call-site.
>
> IOW, extend on that request_module_cap() model, and introduce
> (perhaps) a "request_module_dev()" call that basically means "the user
> opened the device node for the requested module".
>
> Because those kinds of permissions aren't necessarily about
> capabilities, but about things like "I'm in the dialout group, I get
> to open tty devices and by implication request their modules".

This really doesn't address the main concern that is the problem:
whitelisting vs blacklisting. In your example, the dialout group gives
access to specific ttys or serial ports, etc, but an admin may want a
way to make sure the users don't load some buggy line discipline. Now,
that admin could blacklist all those modules one at a time, but new
stuff might get introduced, it doesn't handle other subsystems, etc.

We need to provide a way to whitelist autoloaded modules. The
demonstrated need (to whitelist _no_ modules, addressed by this
series) provides that level of control on a task basis (effectively
making it container-specific).

> And that _really_ isn't global behavior.  The fact that I might be
> able to load a serial; module has *nothing* to do with whether I can
> load some other kind of module at all.
>
> That global mode is just wrong.

If the per-task thing stays and the global sysctl goes, that would be
fine by me. That still gives admins a way to control the autoload
behavior, assuming their init knows how to set the flag. The global
sysctl, in my mind, is really more of a way for an admin to do this
after the fact without rebooting, etc. But I don't have a strong
opinion about the global sysctl.

-Kees

-- 
Kees Cook
Pixel Security
