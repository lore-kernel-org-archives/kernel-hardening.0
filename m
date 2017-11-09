MIME-Version: 1.0
In-Reply-To: <CAGXu5jKnv_mP1hGEe5FbLV_mYknCknZJjo=-Po0mjnWJSV7+_Q@mail.gmail.com>
References: <20171108223020.24487-1-linux@rasmusvillemoes.dk> <CAGXu5jKnv_mP1hGEe5FbLV_mYknCknZJjo=-Po0mjnWJSV7+_Q@mail.gmail.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Thu, 9 Nov 2017 15:08:39 +0100
Message-ID: <CAKwiHFjqiK3HM2ZK-HUvKeGtbMdvGf6JQYF+SREZnDtaBqOJ2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC 0/6] some compile- and run-time format checking
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 9 November 2017 at 02:11, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Nov 8, 2017 at 2:30 PM, Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
>>
>> Rasmus Villemoes (6):
>>   plugins: implement format_template attribute
>>   compiler.h: add __format_template
>
> Could you split these two off and send separately? This seems like a
> fine thing to get in now.

Will do.

> Probably the second patch should be split up
> between adding __format_template, and additions of its usage.

Yeah.

> Do you have any good ways to find and extract all the dynamic format strings
> we need to mark?

IIRC, I just did a git grep for designated initializers where the RHS
was a string literal containing a % char. Not sure that counts as a
good way :)

Doing that now finds stuff like
drivers/scsi/hisi_sas/hisi_sas_v2_hw.c, where the .msg member cannot
be annotated with a single template. Maybe one can work around that by
replacing .msg with an anon union of msg_onebit/msg_multibit, with
each their own template; I don't know if that will work, or if it will
be deemed too much churn (it doesn't provide that much safety, since
it would then just rely on accessing the right union member). Maybe
the run-time checking is best for that case.

Rasmus
