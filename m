Subject: Re: [PATCH] video: fbdev: via: remove VLA usage
References: <20180308173949.GA19305@embeddedgus>
 <20180309105940.22hd2uy2mv7wahzb@imgtec.com>
 <CACvgo5278SmXfV0jfrMu=Ba6gf7rRXzNduNX+D270fGUFQcZdQ@mail.gmail.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <8e3b270d-b615-e58c-fd6e-f677e7e892e8@embeddedor.com>
Date: Mon, 12 Mar 2018 22:29:27 -0500
MIME-Version: 1.0
In-Reply-To: <CACvgo5278SmXfV0jfrMu=Ba6gf7rRXzNduNX+D270fGUFQcZdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Emil Velikov <emil.l.velikov@gmail.com>, Eric Engestrom <eric.engestrom@imgtec.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, linux-fbdev <linux-fbdev@vger.kernel.org>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/09/2018 05:02 AM, Emil Velikov wrote:
> On 9 March 2018 at 10:59, Eric Engestrom <eric.engestrom@imgtec.com> wrote:
>> On Thursday, 2018-03-08 11:39:49 -0600, Gustavo A. R. Silva wrote:
>>> In preparation to enabling -Wvla, remove VLA usage.
>>>
>>> Also, fixed as part of the directive to remove all VLAs from
>>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>>
>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>
>> Sorry for my reply on v1, I missed that Emil already replied to another
>> post of the same patch (side note on that, making use of `-vX` and
>> `--in-reply-to` helps track the evolution of patches)
>>

Yep. I know. It is just that some people prefer vX in a new thread. 
Anyway, I will take this into account for the next time.

>> This looks good to me:
>> Reviewed-by: Eric Engestrom <eric.engestrom@imgtec.com>
>>
> Same here
> Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
> 
> -Emil
> 

Thanks for reviewing it, guys.
-- 
Gustavo A. R. Silva
