Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 17 Jan 2017 08:52:52 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170117075252.GA29579@kroah.com>
References: <CAPDLWs8g5CRTDwDuuLuuGh8K30Py_kGkjVfuT++Q09rT6XaQ=A@mail.gmail.com>
 <CAGXu5j+oOJoJ3JFzEpv4jNeCLu95-QVfYQ8mP-M-waqyvoDDRg@mail.gmail.com>
 <CAPDLWs_DwbB7ZJJ55W8Hz6vnNGDPVvbSw__+1qh42jjNrcCQYA@mail.gmail.com>
 <CAGXu5jJqo99Vheuod5DPobzBpGMz7zw_CHvG4iNuOU87x-REFA@mail.gmail.com>
 <CAPDLWs8dMyk3CGpt49w0Nyd59ZDDOSMz87vkm5k7NkObAZNzog@mail.gmail.com>
 <20170112073746.GA23596@kroah.com>
 <CAPDLWs_aUbt3Vdg1avkoSq_Gpr19TQ2hhrhA1G6-THAXUP07jQ@mail.gmail.com>
 <CAPDLWs_82o5cQ24=pSO6hT8KtQHkNGz5S-gUf5e647QUX+t2QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDLWs_82o5cQ24=pSO6hT8KtQHkNGz5S-gUf5e647QUX+t2QA@mail.gmail.com>
Subject: Re: [kernel-hardening] New to KSPP, would like to contribute
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 17, 2017 at 01:08:14PM +0530, Kaiwan N Billimoria wrote:
> ---
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 28484b3..b524eda 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3511,7 +3511,7 @@ void __init buffer_init(void)
>   bh_cachep = kmem_cache_create("buffer_head",
>   sizeof(struct buffer_head), 0,
>   (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
> - SLAB_MEM_SPREAD),
> + SLAB_MEM_SPREAD|SLAB_NO_SANITIZE),
>   NULL);

Something went wrong here, your patch is totally corrupted with tabs
turned into spaces :(
