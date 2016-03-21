Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160317084911.GA3995@osiris>
References: <20160310173144.GA25532@www.outflux.net>
	<56E9B860.2060802@de.ibm.com>
	<20160317084911.GA3995@osiris>
Date: Mon, 21 Mar 2016 12:33:39 -0700
Message-ID: <CAGXu5j+HYN5JvBfrU-gfbuVyh_Zd=MpoqqPrG69z2MTh14tqAA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] s390: disable postinit-readonly for now
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 17, 2016 at 1:49 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Wed, Mar 16, 2016 at 08:47:44PM +0100, Christian Borntraeger wrote:
>> On 03/10/2016 06:31 PM, Kees Cook wrote:
>> > This is a temporary fix to let lkdtm run again on s390, though it'll
>> > still fail the ro_after_init tests. Until rodata and ro_after_init
>> > sections can be split on s390, disable special handling of ro_after_init.
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > ---
>> > for -next ...
>>
>> Given that the other patches are already merged in linus master via Ingo,
>> do you want this to go via Ingo as well?
>
> Let's route this via the s390 tree. I will add another patch to get rid of
> the bogus "This architecture does not have kernel memory protection."
> message printed to the console, just like parisc.

Yeah, we need to identify the 4 cases we have:

1- no memory protection
2- .rodata is ro after init (implements mark_rodata_ro(), can do
__ro_after_init)
3- .rodata is ro before init only and has no __ro_after_init
4- .rodata is ro before init and implements mark_rodata_ro() for __ro_after_init

What I have it reporting is misleading; I wrote it with ARM in mind
("1" without correct CONFIGs), rather than s390 and parisc ("3").

-Kees

>
>> > ---
>> >  arch/s390/include/asm/cache.h | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/arch/s390/include/asm/cache.h b/arch/s390/include/asm/cache.h
>> > index 4d7ccac5fd1d..22da3b34c655 100644
>> > --- a/arch/s390/include/asm/cache.h
>> > +++ b/arch/s390/include/asm/cache.h
>> > @@ -15,4 +15,7 @@
>> >
>> >  #define __read_mostly __attribute__((__section__(".data..read_mostly")))
>> >
>> > +/* Read-only memory is marked before mark_rodata_ro() is called. */
>> > +#define __ro_after_init __read_mostly
>> > +
>



-- 
Kees Cook
Chrome OS & Brillo Security
