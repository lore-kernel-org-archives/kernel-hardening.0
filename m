MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <708003731.69563.1511905898471@ichabod.co-bxl> <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Nov 2017 16:17:05 -0800
Message-ID: <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Geo Kozey <geokozey@mailfence.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 3:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So a patch that avoids breaking existing users, but also doesn't
> actually improve anything for existing users, simply shouldn't be part
> of the mainline kernel.

Just to clarify: maybe it ends up being truly impossible to make the
default be more restrictive. The default certainly won't be the most
restrictive option.

But at the same time, if people can't even be bothered to try to
improve the general case, and only do things that you have to opt in
for, it really isn't much of an improvement. We had this whole
"opt-in" discussion for another thread entirely, and it basically
didn't improve anything for anybody for the better half of a decade.

Hardening that only works for special cases isn't hardening at all. It
will just mean that 99+% of all kernel developers won't see the
fallout at all.

Yes, something like Android may be 99% of the devices, but it's a very
small portion of the core developer base because the hardware is all
locked down, and it's an even smaller portion of the usage patterns.

So I can see some people say "We can use this for android and protect
the 99%". But if it then is basically invisible to the rest of the
user base, it means that all those servers etc aren't getting the kind
of protection they should have.

Just to take that DCCP thing as an example: being a module wasn't what
made it vulnerable. It would have been vulnerable compiled in too.
What made it vulnerable was that the DCCP code simply isn't widely
enough used and tested, and basically barely on life support. And it
was available much too widely despite that.

So all this is about is to make for a smaller attack surface.

But if it turns out that we can make the attack surface smaller by
simply white-listing a few modules that we know are actively used and
feel better about the quality of, that makes for a much smaller attack
surface _too_. And it does so in general, without having to set some
flag that 99% of all MIS people won't even really know about.

So that's why I want people to look at a different approach. Yes, the
opt-in model means that by default nothing changes. That protects
against the whole "oops, we don't break user space". But it has a huge
downside.

The model that I am a proponent of is to take a softer approach
initially: don't forbid module loading (because that breaks users),
but instead _warn_ about non-root module loading. And then we can
start fixing the cases that we find.

See? This is *exactly* the same thing that the user-mode access thing
was about. Hardening people need to get over their "hard rules"
mindset. We don't kill processes or forbid them from doing things that
might be bad. We start by warning about them, to see what "might be
bad" cases are actually normal, and not actually bad at all. And then
we use that information to guide our notion of what should actually
trigger a stronger response.

                   Linus
