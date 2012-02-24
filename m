Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Sat, 25 Feb 2012 00:14:43 +0200
MIME-Version: 1.0
Reply-to: pageexec@freemail.hu
Message-ID: <4F4819E3.23795.217CF269@pageexec.freemail.hu>
In-reply-to: <CAEXv5_jEW6EA6nOd6pMJbh6PTd=+piHqzNA8Fb+gt2VGroba0A@mail.gmail.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>, <20120224183726.GB23284@kroah.com>, <CAEXv5_jEW6EA6nOd6pMJbh6PTd=+piHqzNA8Fb+gt2VGroba0A@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Greg KH <gregkh@linuxfoundation.org>, David Windsor <dwindsor@gmail.com>
Cc: Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>, Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 24 Feb 2012 at 14:04, David Windsor wrote:

> Suggestions on recovering from an overflow here?

do what PaX does? :)

1. saturate the refcount
2. report the event (pax_report_refcount_overflow)
3. kill the triggering userland process (this may be optional but it's a good measure
   if you have stuff like grsecurity's lockout feature)

> 2. Detect the overflow before it happens, don't increment the counter,
> issue a warning but no BUG.
> This could also lead to some "undefined" behavior in subsystems.

it's called a memory leak :).
