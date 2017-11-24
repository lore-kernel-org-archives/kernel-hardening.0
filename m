MIME-Version: 1.0
In-Reply-To: <20171124055935.GB17858@eros>
References: <1511414131.12425.14.camel@gmail.com> <20171124055935.GB17858@eros>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Fri, 24 Nov 2017 12:51:34 +0530
Message-ID: <CAPDLWs8+cXShyCt_AH3WgSnn6-cEgGRjJookfqWZ-Lq1Jt72_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 2/2] scripts: leaking_addresses: help screen updates
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 24, 2017 at 11:29 AM, Tobin C. Harding <me@tobin.cc> wrote:

> Neither of these patches applies to my tree. Are you editing the diff's
> by hand? I noticed the patches don't end with the version signature, like this:
>
> ----
> 2.7.4

I cloned your tree from here: https://github.com/tcharding/linux/tree/leaks
is that right?

One thing i can think of: i have to copy across the script to a
cloud-based 32-bit system, work on it there, copy it back to your tree
on my laptop manually, then i do the 'git diff -r' and basically
copy-paste that. Is this causing issues?

thanks, Kaiwan.

> thanks,
> Tobin.
