Date: Tue, 29 May 2018 12:53:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] migrate swapper_pg_dir
Message-ID: <20180529105312.GA24918@kroah.com>
References: <20180529043741.27790-1-yaojun8558363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529043741.27790-1-yaojun8558363@gmail.com>
To: YaoJun <yaojun8558363@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 29, 2018 at 12:37:41PM +0800, YaoJun wrote:
> Currently, __enable_mmu() uses swapper_pg_dir directly.
> To migrate swapper_pg_dir, we need to pass it as an
> argument to __enable_mmu(). At the same time,
> __pa_swapper_pg_dir is introduced to save physical
> address of swapper_pg_dir. By changing its value, we
> can migrate swapper_pg_dir.
> 
> ---
>  arch/arm64/include/asm/mmu_context.h |  4 +---
>  arch/arm64/include/asm/pgtable.h     |  1 +
>  arch/arm64/kernel/cpufeature.c       |  2 +-
>  arch/arm64/kernel/head.S             | 10 ++++++----
>  arch/arm64/kernel/hibernate.c        |  2 +-
>  arch/arm64/kernel/sleep.S            |  2 ++
>  arch/arm64/mm/kasan_init.c           |  4 ++--
>  arch/arm64/mm/mmu.c                  |  8 ++++++--
>  8 files changed, 20 insertions(+), 13 deletions(-)


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch does not have a Signed-off-by: line.  Please read the
  kernel file, Documentation/SubmittingPatches and resend it after
  adding that line.  Note, the line needs to be in the body of the
  email, before the patch, not at the bottom of the patch or in the
  email signature.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

- You did not use your real name.  Signed-off-by: and From: has to have
  a real name associated with it.  Use whatever you sign legal documents
  with, no anonymous patches are allowed.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
