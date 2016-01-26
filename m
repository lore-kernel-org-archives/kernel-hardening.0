Reply-To: kernel-hardening@lists.openwall.com
References: <1453740953-18109-1-git-send-email-labbott@fedoraproject.org>
 <1453740953-18109-2-git-send-email-labbott@fedoraproject.org>
 <CAHz2CGXuUHYHX7KhxGjYtWrKOoxK=2Rz2N-Q0CBR9UWtrYi2Jw@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56A7D648.8020806@redhat.com>
Date: Tue, 26 Jan 2016 12:25:44 -0800
MIME-Version: 1.0
In-Reply-To: <CAHz2CGXuUHYHX7KhxGjYtWrKOoxK=2Rz2N-Q0CBR9UWtrYi2Jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH 1/3] mm/debug-pagealloc.c: Split out page poisoning
 from debug page_alloc
To: Jianyu Zhan <nasa4836@gmail.com>, Laura Abbott <labbott@fedoraproject.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/25/2016 10:26 PM, Jianyu Zhan wrote:
> On Tue, Jan 26, 2016 at 12:55 AM, Laura Abbott
> <labbott@fedoraproject.org> wrote:
>> +static bool __page_poisoning_enabled __read_mostly;
>> +static bool want_page_poisoning __read_mostly =
>> +       !IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC);
>> +
>
>
> I would say this patch is nice with regard to decoupling
> CONFIG_DEBUG_PAGEALLOC and CONFIG_PAGE_POISONING.
>
> But  since when we enable CONFIG_DEBUG_PAGEALLOC,
> CONFIG_PAGE_POISONING will be selected.
>
> So it would be better to make page_poison.c totally
> CONFIG_DEBUG_PAGEALLOC agnostic,  in case we latter have
> more PAGE_POISONING users(currently only DEBUG_PAGEALLOC ). How about like this:
>
> +static bool want_page_poisoning __read_mostly =
> +       !IS_ENABLED(CONFIG_PAGE_POISONING );
>
> Or just let it default to 'true',  since we only compile this
> page_poison.c when we enable CONFIG_PAGE_POISONING.
>

This patch was just supposed to be the refactor and keep the existing
behavior. There are no Kconfig changes here and the existing behavior
is to poison if !ARCH_SUPPORTS_DEBUG_PAGEALLOC so I think keeping
what I have is appropriate for this particular patch. This can be
updated in another series if appropriate.

Thanks,
Laura
  
>
> Thanks,
> Jianyu Zhan
>
