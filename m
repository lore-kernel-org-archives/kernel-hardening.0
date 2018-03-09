MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5j+k6SkGP19EYxOAvwy+uzvkJ664_Lj_Rz5t8a6Fi60+JQ@mail.gmail.com>
References: <1520576470-20628-1-git-send-email-me@tobin.cc>
 <877eqli0f0.fsf@anholt.net> <CAGXu5j+k6SkGP19EYxOAvwy+uzvkJ664_Lj_Rz5t8a6Fi60+JQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Mar 2018 10:44:21 -0800
Message-ID: <CA+55aFzTa25jMx7B-NZ-nSbVV9Ee-UNpFungZNu8P=eKjJU=+A@mail.gmail.com>
Subject: Re: [PATCH] staging: vchiq_arm: Clear VLA warning
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Eric Anholt <eric@anholt.net>, "Tobin C. Harding" <me@tobin.cc>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stefan Wahren <stefan.wahren@i2se.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 10:35 AM, Kees Cook <keescook@chromium.org> wrote:
>
> I think you mean ARRAY_SIZE(service_data) ? In that case, yeah, it
> seems like a raw "64" for the array size can be used instead.

I think 64 is much too big anyway. That's 768 bytes of stack data that
is used to check stuff deep in some transfer call chain.

So that code is broken from a stack usage model anyway. If it's just a
"random big number", then cut it down in size.

I don't know. The code was imported in 2013, and has seen very little
change since. I'm not sure how many users it has. But while changing
this, just do the stack size limitation at the same time.

              Linus
