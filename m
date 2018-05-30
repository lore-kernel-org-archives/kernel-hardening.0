Date: Wed, 30 May 2018 11:46:02 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/4] arm64/mm: migrate swapper_pg_dir
Message-ID: <20180530094602.GB25193@kroah.com>
References: <20180530091259.9386-1-yaojun8558363@gmail.com>
 <20180530091259.9386-2-yaojun8558363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530091259.9386-2-yaojun8558363@gmail.com>
To: YaoJun <yaojun8558363@gmail.com>
Cc: kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, mark.rutland@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 30, 2018 at 05:12:56PM +0800, YaoJun wrote:
> Introduce __pa_swapper_pg_dir to save physical address
> of swapper_pg_dir. And pass it as an argument to
> __enable_mmu().
> 
> Signed-off-by: YaoJun <yaojun8558363@gmail.com>

This is better, but your subject line is still identical for all 4
patches (which doesn't make sense as they do different things), and I
think you need to put a space in your name somewhere, right?

thanks,

greg k-h
