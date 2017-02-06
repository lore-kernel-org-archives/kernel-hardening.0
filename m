MIME-Version: 1.0
In-Reply-To: <20170206135135.6f7d6d14@lwn.net>
References: <CAEXv5_ivEPDJSaJwmx+oLiUYRZsAa9ZPWH6oWZy-Rkoa3ZHRZg@mail.gmail.com>
 <20170206151341.GA13383@kroah.com> <CAEXv5_g4zLSJCrfPWUe85UdyOo1WDGdw2LLXOkcjbf5kf4VnTw@mail.gmail.com>
 <20170206153047.GA14434@kroah.com> <CAEXv5_iD0k-mxqOgT9W_mf1_Xo46qePFXvTX2wd32xG0gPzSUw@mail.gmail.com>
 <20170206160945.GB4190@leverpostej> <CAGXu5jKA-J0WcpMGbxVBC9nC5JK7oCRopQs7rYftv5f=BzQriQ@mail.gmail.com>
 <CAEXv5_hK4aPt1-K8ueSm9ye4AF-FzLDFNW8fMN_K3kYyqcuJtQ@mail.gmail.com> <20170206135135.6f7d6d14@lwn.net>
From: David Windsor <dwindsor@gmail.com>
Date: Mon, 6 Feb 2017 16:05:49 -0500
Message-ID: <CAEXv5_gnnD0ez-_odAdowXUXNdA9F6XJ9OoT55CXoFUk4yDVyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: HARDENED_ATOMIC documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 6, 2017 at 3:51 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Mon, 6 Feb 2017 15:36:10 -0500
> David Windsor <dwindsor@gmail.com> wrote:
>
>> Understood.  I'll take the API reference I just created on kernsec.org
>> and move its contents to Documentation/core-api/refcount_ops.rst.
>> Then, update Documentation/security/self-protection.txt with some
>> language about this feature's justification, etc. and point to
>> refcount_ops.rst.
>
> This all sounds good, but the low-level API documentation is best done as
> kerneldoc comments with the actual definitions of the functions.  You can
> then use the appropriate directives to pull it into the RST documentation.
>
> Details in Documentation/doc-guide/ if you need them.
>

Even better.

Objections, anyone?

> Thanks,
>
> jon
