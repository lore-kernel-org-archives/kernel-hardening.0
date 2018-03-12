From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] video: fbdev: via: remove VLA usage
Date: Mon, 12 Mar 2018 17:04:25 +0100
Message-id: <7211546.mLmn3tHjVa@amdc3058>
In-reply-to: 
	<CACvgo5278SmXfV0jfrMu=Ba6gf7rRXzNduNX+D270fGUFQcZdQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset="us-ascii"
References: <20180308173949.GA19305@embeddedgus>
	<CGME20180309110234epcas1p2c64b608487008f178d25609e962ecc74@epcas1p2.samsung.com>
	<CACvgo5278SmXfV0jfrMu=Ba6gf7rRXzNduNX+D270fGUFQcZdQ@mail.gmail.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Emil Velikov <emil.l.velikov@gmail.com>, Eric Engestrom <eric.engestrom@imgtec.com>, Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, linux-fbdev <linux-fbdev@vger.kernel.org>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Friday, March 09, 2018 11:02:24 AM Emil Velikov wrote:
> On 9 March 2018 at 10:59, Eric Engestrom <eric.engestrom@imgtec.com> wrote:
> > On Thursday, 2018-03-08 11:39:49 -0600, Gustavo A. R. Silva wrote:
> >> In preparation to enabling -Wvla, remove VLA usage.
> >>
> >> Also, fixed as part of the directive to remove all VLAs from
> >> the kernel: https://lkml.org/lkml/2018/3/7/621
> >>
> >> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> >
> > Sorry for my reply on v1, I missed that Emil already replied to another
> > post of the same patch (side note on that, making use of `-vX` and
> > `--in-reply-to` helps track the evolution of patches)
> >
> > This looks good to me:
> > Reviewed-by: Eric Engestrom <eric.engestrom@imgtec.com>
> >
> Same here
> Reviewed-by: Emil Velikov <emil.velikov@collabora.com>

Patch queued for 4.17, thanks.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
