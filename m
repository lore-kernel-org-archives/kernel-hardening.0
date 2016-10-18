Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 18 Oct 2016 14:34:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161018133439.GE15639@leverpostej>
References: <20161018060950.GM19531@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161018060950.GM19531@linaro.org>
Subject: Re: [kernel-hardening] [RFC] module: add 'module_ronx=off' boot
 cmdline parameter to disable ro/nx module mappings
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Oct 18, 2016 at 03:09:51PM +0900, AKASHI Takahiro wrote:
> As making CONFIG_DEBUG_RODATA mandatory is a good idea, so will be
> for CONFIG_SET_MODULE_RONX.

I completely agree, given most distros ship a large number of drivers as
modules...

> This patch adds a command line parameter, "module_ronx=," in order to
> make this configuration always on in the future, but still allowing for
> disabling read-only module mappings at boot time as "rodata=" does.
> 
> I have, however, some concerns on this prototype:
> (1) should we use a separate parameter like "module_ronx=," or
>     unify it with "rodata="?

I think this should be merged with "rodata=".

> (2) should we keep NX permission set even if module_ronx=off?

I think we should; for arm64 we set NX for kernel mappings even with
rodata=off, and I think we should be consistent.

Thanks,
Mark.
