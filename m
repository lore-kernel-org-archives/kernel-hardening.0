Date: Sun, 25 Feb 2018 18:26:31 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 2/4] leaking_addresses: simplify path skipping
Message-ID: <20180226012631.qff25qjngubxy4ia@cisco>
References: <1519008649-15782-1-git-send-email-me@tobin.cc>
 <1519008649-15782-3-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519008649-15782-3-git-send-email-me@tobin.cc>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tobin,

On Mon, Feb 19, 2018 at 01:50:47PM +1100, Tobin C. Harding wrote:
> -# Do not parse these files under any subdirectory.
> -my @skip_parse_files_any = ('0',
> -			    '1',
> -			    '2',
> -			    'pagemap',
> -			    'events',
> -			    'access',
> -			    'registers',
> -			    'snapshot_raw',
> -			    'trace_pipe_raw',
> -			    'ptmx',
> -			    'trace_pipe');

It might be worth adding 'syscall' here; the pointers listed are user
pointers, and negative syscall args will show up like kernel pointers,
e.g. I get this output, which is spurious:

/proc/31808/syscall: 0 0x3 0x55b107a38180 0x2000 0xffffffffffffffb0 0x55b107a302d0 0x55b107a38180 0x7fffa313b8e8 0x7ff098560d11

Cheers,

Tycho
