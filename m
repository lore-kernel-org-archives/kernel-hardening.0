MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <20180411010412.18006-1-labbott@redhat.com>
References: <20180411010412.18006-1-labbott@redhat.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 11 Apr 2018 10:45:32 +0200
Message-ID: <CAK8P3a36rXwCj9Z_m_th62BvvMc7X3rYqbQPr3ti_8=Pn=e5Xw@mail.gmail.com>
Subject: Re: [PATCHv2] misc: tifm: Remove VLA
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alex Dubov <oakad@yahoo.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 11, 2018 at 3:04 AM, Laura Abbott <labbott@redhat.com> wrote:
> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> turn on -Wvla. The single VLA can either take a value of 2 or 4 so switch
> to the upper bound.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Thanks for the new version,

Acked-by: Arnd Bergmann <arnd@arndb.de>
