MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com> <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Nov 2017 12:20:32 -0800
Message-ID: <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Djalal Harouni <tixxdz@gmail.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 12:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 28, 2017 at 12:08 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> Linus, are you okay with this series if the global sysctl gets dropped?
>
> So really, it's not the "global sysctl" as much as the "global
> request_module()" that annoys me.
>
> I'll happily take the request_module_cap() part and the thing that
> makes networking use that.
>
> But the flag that we have to default to off because it breaks every
> single box otherwise? No. It doesn't  matter if it's one single global
> or just a "global behavior for request_module() for this process" at
> that point, it's still a pointless security flag that is opt-in.

To be clear: such a flag wouldn't doesn't break every system, but I
understand your concern.

So what's the right path forward for allowing a way to block
autoloading? Separate existing request_module() calls into "must be
privileged" and "can be unpriv" first, then rework the series to deal
with the "unpriv okay" subset?

-Kees

-- 
Kees Cook
Pixel Security
