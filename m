MIME-Version: 1.0
In-Reply-To: <20180309105940.22hd2uy2mv7wahzb@imgtec.com>
References: <20180308173949.GA19305@embeddedgus> <20180309105940.22hd2uy2mv7wahzb@imgtec.com>
From: Emil Velikov <emil.l.velikov@gmail.com>
Date: Fri, 9 Mar 2018 11:02:24 +0000
Message-ID: <CACvgo5278SmXfV0jfrMu=Ba6gf7rRXzNduNX+D270fGUFQcZdQ@mail.gmail.com>
Subject: Re: [PATCH] video: fbdev: via: remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Eric Engestrom <eric.engestrom@imgtec.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, linux-fbdev <linux-fbdev@vger.kernel.org>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 9 March 2018 at 10:59, Eric Engestrom <eric.engestrom@imgtec.com> wrote:
> On Thursday, 2018-03-08 11:39:49 -0600, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wvla, remove VLA usage.
>>
>> Also, fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>
> Sorry for my reply on v1, I missed that Emil already replied to another
> post of the same patch (side note on that, making use of `-vX` and
> `--in-reply-to` helps track the evolution of patches)
>
> This looks good to me:
> Reviewed-by: Eric Engestrom <eric.engestrom@imgtec.com>
>
Same here
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>

-Emil
