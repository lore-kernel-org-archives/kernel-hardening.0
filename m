Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160616153339.xvlsnhksqmkeusn4@treble>
References: <cover.1466036668.git.luto@kernel.org> <24279d4009c821de64109055665429fad2a7bff7.1466036668.git.luto@kernel.org>
 <20160616153339.xvlsnhksqmkeusn4@treble>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Jun 2016 10:39:43 -0700
Message-ID: <CALCETrXRONH1K1zAWAFN--Lsza+5bkgtmcMrgAY_nvT-e21C3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 04/13] mm: Track NR_KERNEL_STACK in pages instead of
 number of stacks
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 8:33 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> On Wed, Jun 15, 2016 at 05:28:26PM -0700, Andy Lutomirski wrote:
>> Currently, NR_KERNEL_STACK tracks the number of kernel stacks in a
>> zone.  This only makes sense if each kernel stack exists entirely in
>> one zone, and allowing vmapped stacks could break this assumption.
>>
>> It turns out that the code for tracking kernel stack allocations in
>> units of pages is slightly simpler, so just switch to counting
>> pages.
>>
>> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>  fs/proc/meminfo.c | 2 +-
>>  kernel/fork.c     | 3 ++-
>>  mm/page_alloc.c   | 3 +--
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> You missed another usage of NR_KERNEL_STACK in drivers/base/node.c.

Thanks.

The real reason I cc'd you was so you could look at
rewind_stack_do_exit and the sneaky trick I did in no_context in the
last patch, though.  :)  Both survive objtool, but I figured I'd check
with objtool's author as well.  If there was a taint bit I could set
saying "kernel is hosed -- don't try to apply live patches any more",
I'd have extra confidence.

--Andy
