MIME-Version: 1.0
In-Reply-To: <543a0a74122172acae549329b35964f402da8b77.1520660422.git.gustavo@embeddedor.com>
References: <cover.1520660422.git.gustavo@embeddedor.com> <543a0a74122172acae549329b35964f402da8b77.1520660422.git.gustavo@embeddedor.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 12 Mar 2018 12:14:04 +0100
Message-ID: <CAJKOXPc3ELO9sX0Xp391D2_3uDHK91snzHDn6FmDrJ6dt3E_Zg@mail.gmail.com>
Subject: Re: [PATCH 2/2] rtc: s5m: Remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-samsung-soc@vger.kernel.org, linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 7:27 AM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> In preparation to enabling -Wvla, remove VLAs and replace them
> with fixed-length arrays instead.
>
> From a security viewpoint, the use of Variable Length Arrays can be
> a vector for stack overflow attacks. Also, in general, as the code
> evolves it is easy to lose track of how big a VLA can get. Thus, we
> can end up having segfaults that are hard to debug.
>
> Also, fixed as part of the directive to remove all VLAs from
> the kernel: https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/rtc/rtc-s5m.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)


Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
