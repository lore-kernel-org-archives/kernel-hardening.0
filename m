From: Geo Kozey <geokozey@mailfence.com>
Message-ID: <708003731.69563.1511905898471@ichabod.co-bxl>
In-Reply-To: <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com> <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com> <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com> <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com> <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org> <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com> <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com> <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com> <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Nov 2017 22:51:38 +0100 (CET)
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Sent: Tue Nov 28 21:33:22 CET 2017
> To: Kees Cook <keescook@chromium.org>
> Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to load 'netdev-%s' modules

> Because I really am *not* interested in these security flags that are
> off by default and then get turned on by special cases. I think it's
> completely unacceptable to say "we're insecure by default but then you
> can do X and be secure". It doesn't work. It doesn't fix anything.
> 
>                  Linus
> ----------------------------------------

What about "we're insecure by default but you can't do anything to change this"? It describes current situation. For last 20 years linux allowed for insecure behavior and tons of tools were built depending on it. It's recurring theme of kernel security development. I'll be glad if some genius propose perfect idea solving this problem but I'm afraid things go nowhere instead.

Yours sincerely

G. K.
