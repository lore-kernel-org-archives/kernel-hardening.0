Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 29 Jun 2011 22:25:05 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110629182505.GC14873@openwall.com>
References: <20110626183321.GA3867@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626183321.GA3867@albatros>
Subject: Re: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sun, Jun 26, 2011 at 10:33:21PM +0400, Vasiliy Kulikov wrote:
> PaXTeam said there is almost nothing I can do with userspace NX.
> Currently it is implemented as a "stack can be X unless GNU_STACK is
> enabled" instead of secure by default policy.  It's impossible to fix it
> not breaking the compatibility with old apps.  So, I'm skipping NOEXEC
> options.

Please do break compatibility with a handful of old apps - but as a
non-default option (which we're likely to make the default on Owl, just
like we had non-executable stack by default with 2.4.x-ow kernels).

With OpenVZ, it needs to be configurable per-container.

This is an important security hardening feature for us to have, so
please proceed to implement it sooner rather than later.

I'm sorry that I haven't reviewed the rest of your message yet (and am
in fact a bit late with this comment as well...)

Thanks,

Alexander
