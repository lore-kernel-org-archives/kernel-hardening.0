MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1490866441.10874.44.camel@hellion.org.uk>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-3-git-send-email-keescook@chromium.org> <1490866441.10874.44.camel@hellion.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 30 Mar 2017 09:16:29 -0700
Message-ID: <CAGXu5jLMKA3OwshsQn4yc1eXFwSuD3xbaYY56RY_Uu3TBAWG3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2][PATCH 02/11] lkdtm: add test for
 rare_write() infrastructure
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 30, 2017 at 2:34 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> On Wed, 2017-03-29 at 11:15 -0700, Kees Cook wrote:
>> diff --git a/drivers/misc/lkdtm_perms.c b/drivers/misc/lkdtm_perms.c
>> index c7635a79341f..8fbadfa4cc34 100644
>> --- a/drivers/misc/lkdtm_perms.c
>> +++ b/drivers/misc/lkdtm_perms.c
>> [...]
>> +/* This is marked __wr_rare, so it should ultimately be .rodata. */
>> +static unsigned long wr_rare __wr_rare = 0xAA66AA66;
>> [...]
>> +void lkdtm_WRITE_RARE_WRITE(void)
>> +{
>> +     /* Explicitly cast away "const" for the test. */
>
> wr_rare isn't actually declared const above though? I don't think
> __wr_rare includes a const, apologies if I missed it.

Yeah, good point. I think this was a left-over from an earlier version
where I'd forgotten about that detail.

> OOI, if wr_rare _were_ const then can the compiler optimise the a pair
> of reads spanning the rare_write? i.e. adding const to the declaration
> above to get:
>
>     static const unsigned long wr_rare __wr_rare = 0xAA66AA66;
> x = wr_read;
> rare_write(x, 0xf000baaa);
> y = wr_read;
>
> Is it possible that x == y == 0xaa66aa66 because gcc realises the x and
> y came from the same const location? Have I missed a clobber somewhere
> (I can't actually find a definition of __arch_rare_write_memcpy in this
> series so maybe it's there), or is such code expected to always cast
> away the const first?
>
> I suppose such constructs are rare in practice in the sorts of places
> where rare_write is appropriate, but with aggressive inlining it could
> occur as an unexpected trap for the unwary perhaps.

Right, __wr_rare is actually marked as .data..ro_after_init, which gcc
effectively ignores (thinking it's part of .data), but the linker
script later movies this section into the read-only portion with
.rodata. As a result, the compiler treats it as writable, but the
storage location is actually read-only.

(And, AIUI, the constify plugin makes things read-only in a similar
way, though I think it's more subtle but still avoids the
const-optimization dangers.)

-Kees

-- 
Kees Cook
Pixel Security
