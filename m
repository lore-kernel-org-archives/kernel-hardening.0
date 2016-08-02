Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160802081438.GE9601@gmail.com>
References: <1469635196-122447-1-git-send-email-thgarnie@google.com>
 <CAJcbSZHZa0tk29i08xKwRuSA0hSQJ7ec3+-1W3zQ5pibC19v_Q@mail.gmail.com> <20160802081438.GE9601@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 2 Aug 2016 07:24:38 -0700
Message-ID: <CAJcbSZFLuz2OBOrhpgdtUFUdy9uvLf_GAv9VVz7ZZc_DJtak5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/mm: Enable KASLR for vmemmap memory region (x86_64)
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 1:14 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> On Wed, Jul 27, 2016 at 8:59 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> > Add vmemmap in the list of randomized memory regions.
>> >
>> > The vmemmap region holds a representation of the physical memory (through
>> > a struct page array). An attacker could use this region to disclose the
>> > kernel memory layout (walking the page linked list).
>> >
>> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > ---
>> > Missing patch didn't pick-up by the tip bot on KASLR memory randomization.
>> > Resending after rebase on tip and tests as discussed with Ingo.
>> > Based on tip 4bcc8cf6ab5932cbb2511c8e18065e61b069f21c
>>
>> Ingo: Any comment? Can you integrate it on tip?
>>
>> > ---
>> >  arch/x86/include/asm/kaslr.h            |  1 +
>> >  arch/x86/include/asm/pgtable_64_types.h |  4 +++-
>> >  arch/x86/mm/kaslr.c                     | 24 +++++++++++++++++++++++-
>> >  3 files changed, 27 insertions(+), 2 deletions(-)
>
> After the merge window is over. There's no bad effect from the lack of this patch,
> other than lower level of randomization of kernel virtual addresses, right?
>

That's right, this change just enables randomization for vmemmap.

> Thanks,
>
>         Ingo
