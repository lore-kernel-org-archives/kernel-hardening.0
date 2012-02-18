Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120217233908.GA24047@dztty>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net> <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros> <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros> <20120217233908.GA24047@dztty>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 17 Feb 2012 17:44:57 -0800
Message-ID: <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>, pageexec@freemail.hu, spender@grsecurity.net, gregkh@linuxfoundation.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 17, 2012 at 3:39 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> 2) what to do with architectures-loosers?
> There is lib/atomic64.c but with a static hashed array of raw_spinlocks.

Even leaving aside performance impact of atomic64_t (and probably
in most cases the performance of kref is not important at all), it is
unfortunate to bloat the size from 4 bytes to 8 bytes.

It seems much better to have some out-of-line code for overflow
checking rather than increasing the size of every data structure
that embeds a kref.

Greg, I'm not sure why you're opposed to adding this checking...
it's pretty clear that buggy error paths that forget to do a put are
pretty common and will continue to be common in new code, and
making them harder to exploit seems pretty sane to me.

What's the downside?

 - R.
