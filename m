MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <708003731.69563.1511905898471@ichabod.co-bxl>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com> <708003731.69563.1511905898471@ichabod.co-bxl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Nov 2017 15:51:59 -0800
Message-ID: <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Geo Kozey <geokozey@mailfence.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 1:51 PM, Geo Kozey <geokozey@mailfence.com> wrote:
>
> What about "we're insecure by default but you can't do anything to change this"? It describes current situation.

Go away, and don't send me patches until you have dug your head out of
whatever hole you have put it in..

If this is the kind of shit-headed responses I get from the
"hardening" list, then I don't want to have anything to do with you
guys.

Seriously.

I sent out a long explanation of what's wrong with the hardening
people last week. It made the news. If you still don't understand,
you're simply not worth working with.

If you cannot help improve kernel security for the default case, and
you can't even be bothered to try, and only want to fix some special
case that doesn't then improve anything at all for most people, I
really _really_ suggest you go play in your own sandbox.

Because clearly, if you're not interested in improving things for
anybody else, why the hell should you care about the upstream kernel
anyway?

That's what this boils down to: if you send me patches, you had better
strive to improve security for everybody, not just for some little
locked-down special case.

We're not grsecurity. We never have been. We're not interested in the
crazy people. We're interested in the kind of security that is
generally applicable.

To the mainline kernel, not breaking existing users matters, but it
also matters that the patches make sense for everybody, because
otherwise, why be mainline?

So a patch that avoids breaking existing users, but also doesn't
actually improve anything for existing users, simply shouldn't be part
of the mainline kernel.

Comprende?

                    Linus
