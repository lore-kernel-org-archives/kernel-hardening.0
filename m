Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrU4bcLyBJDVOPCW_MobQVGPiHRP+KfZMGu8YQJHnmjYeQ@mail.gmail.com>
References: <cover.1466036668.git.luto@kernel.org> <24279d4009c821de64109055665429fad2a7bff7.1466036668.git.luto@kernel.org>
 <20160616111053.GA13143@esperanza> <CALCETrU4bcLyBJDVOPCW_MobQVGPiHRP+KfZMGu8YQJHnmjYeQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Jun 2016 12:20:14 -0700
Message-ID: <CALCETrVJP4XO-QLtdMK4Dx_zTFZKKHwe+jGXvoo+ZP=NVSLdBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 04/13] mm: Track NR_KERNEL_STACK in pages instead of
 number of stacks
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 10:21 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jun 16, 2016 at 4:10 AM, Vladimir Davydov
> <vdavydov@virtuozzo.com> wrote:
>> On Wed, Jun 15, 2016 at 05:28:26PM -0700, Andy Lutomirski wrote:
>> ...
>>> @@ -225,7 +225,8 @@ static void account_kernel_stack(struct thread_info *ti, int account)
>>>  {
>>>       struct zone *zone = page_zone(virt_to_page(ti));
>>>
>>> -     mod_zone_page_state(zone, NR_KERNEL_STACK, account);
>>> +     mod_zone_page_state(zone, NR_KERNEL_STACK,
>>> +                         THREAD_SIZE / PAGE_SIZE * account);
>>
>> It won't work if THREAD_SIZE < PAGE_SIZE. Is there an arch with such a
>> thread size, anyway? If no, we should probably drop thread_info_cache.
>
> On a quick grep, I can't find any.  I'll add a BUILD_BUG_ON for now.

Correction.  frv has 16KiB pages and 8KiB stacks.  I'll rework it to
count NR_KERNEL_STACK in KiB.  Sigh.

--Andy

>
> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
