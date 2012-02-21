Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Feb 2012 18:56:53 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120221145653.GA22597@openwall.com>
References: <20120210020658.GA17709@dztty> <20120210143616.GA6100@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210143616.GA6100@albatros>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2012 at 06:36:17PM +0400, Vasiliy Kulikov wrote:
> [1] http://grsecurity.net/~spender/dev_patches/distros_should_sponsor_me_for_doing_their_jobs.patch

In order to provide its security, this relies on atomic64_t actually
being 64-bit and on atomic64_inc_return() returning a 64-bit value - but
one or both of these requirements appear to be violated for some archs.

In fact, per a quick grep it appears that atomic64_inc_return() exists
for a subset of the archs only.

The patch still looks OK to apply for distros that only care about a
handful of archs, where this is fully 64-bit.  Correct?

Are there any other known issues with this patch (or approach)?

A newer revision of it maybe (e.g. what's merged in grsecurity patch)?
I am just guessing.

Should there be a different revision of the patch for mainline?  Perhaps
it'd have to use a spinlock at least on archs lacking 64-bit atomics.

Alexander
