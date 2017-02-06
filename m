MIME-Version: 1.0
In-Reply-To: <CAGXu5jKA-J0WcpMGbxVBC9nC5JK7oCRopQs7rYftv5f=BzQriQ@mail.gmail.com>
References: <CAEXv5_ivEPDJSaJwmx+oLiUYRZsAa9ZPWH6oWZy-Rkoa3ZHRZg@mail.gmail.com>
 <20170206151341.GA13383@kroah.com> <CAEXv5_g4zLSJCrfPWUe85UdyOo1WDGdw2LLXOkcjbf5kf4VnTw@mail.gmail.com>
 <20170206153047.GA14434@kroah.com> <CAEXv5_iD0k-mxqOgT9W_mf1_Xo46qePFXvTX2wd32xG0gPzSUw@mail.gmail.com>
 <20170206160945.GB4190@leverpostej> <CAGXu5jKA-J0WcpMGbxVBC9nC5JK7oCRopQs7rYftv5f=BzQriQ@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Date: Mon, 6 Feb 2017 15:36:10 -0500
Message-ID: <CAEXv5_hK4aPt1-K8ueSm9ye4AF-FzLDFNW8fMN_K3kYyqcuJtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: HARDENED_ATOMIC documentation
To: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 6, 2017 at 3:08 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Feb 6, 2017 at 8:09 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> On Mon, Feb 06, 2017 at 11:02:56AM -0500, David Windsor wrote:
>>> > Why not put the documentation right into the kernel tree?  That way it
>>> > is always up to date with the code (well, hopefully), it will get built
>>> > and hosted all over the internet at different sites (including
>>> > kernel.org) and is much easier to search and people can modify easier.
>>> >
>>>
>>> Fair enough, I'll re-submit as a patch against something in
>>> Documentation/.  It doesn't appear that there's currently a good
>>> landing spot for this, as Documentation/security/self-protection.txt
>>> already looks fairly crowded.  Individual KSPP sub-project details
>>> would impossibly complicate this file.  Maybe a kspp/ or
>>> self-protection/ sub-directory with files for individual KSPP
>>> features?
>>
>> It would be better to mirror our documentation of atomics; i.e. place
>> this in Documentation/core-api/refcount_ops.rst.
>
> Yeah, this is likely the best place. (And since it's not strictly
> "hardened atomic" any more: it's just "safe refcounting".)
>
>> Developers don't care if this is part of KSPP, they care about the API.
>
> Right. I think changes could be made to
> Documentation/security/self-protection.txt to point to the
> refcount_ops.rst file, though, since security folks would like
> pointers from that doc to the refcount API.
>

Understood.  I'll take the API reference I just created on kernsec.org
and move its contents to Documentation/core-api/refcount_ops.rst.
Then, update Documentation/security/self-protection.txt with some
language about this feature's justification, etc. and point to
refcount_ops.rst.

Thanks!

> -Kees
>
> --
> Kees Cook
> Pixel Security
