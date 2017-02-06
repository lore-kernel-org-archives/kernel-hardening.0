MIME-Version: 1.0
In-Reply-To: <20170206153047.GA14434@kroah.com>
References: <CAEXv5_ivEPDJSaJwmx+oLiUYRZsAa9ZPWH6oWZy-Rkoa3ZHRZg@mail.gmail.com>
 <20170206151341.GA13383@kroah.com> <CAEXv5_g4zLSJCrfPWUe85UdyOo1WDGdw2LLXOkcjbf5kf4VnTw@mail.gmail.com>
 <20170206153047.GA14434@kroah.com>
From: David Windsor <dwindsor@gmail.com>
Date: Mon, 6 Feb 2017 11:02:56 -0500
Message-ID: <CAEXv5_iD0k-mxqOgT9W_mf1_Xo46qePFXvTX2wd32xG0gPzSUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: HARDENED_ATOMIC documentation
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Why not put the documentation right into the kernel tree?  That way it
> is always up to date with the code (well, hopefully), it will get built
> and hosted all over the internet at different sites (including
> kernel.org) and is much easier to search and people can modify easier.
>

Fair enough, I'll re-submit as a patch against something in
Documentation/.  It doesn't appear that there's currently a good
landing spot for this, as Documentation/security/self-protection.txt
already looks fairly crowded.  Individual KSPP sub-project details
would impossibly complicate this file.  Maybe a kspp/ or
self-protection/ sub-directory with files for individual KSPP
features?

> And again, you are sending html email which the mailing list rejects so
> no one on it is seeing your messages :(
>

Sorry.  This should be fixed now.

>
> thanks,
>
> greg k-h
