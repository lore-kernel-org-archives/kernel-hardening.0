Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <517AF6A5.7070507@zytor.com>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
	<1367003005-5560-5-git-send-email-keescook@chromium.org>
	<517AF6A5.7070507@zytor.com>
Date: Mon, 29 Apr 2013 12:15:53 -0700
Message-ID: <CAGXu5jLS+71p20qB-8x_A1SJuqQN+q17-B50FqFtHc4T2YVHGA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 4/6] x86: kaslr: select random base offset
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 26, 2013 at 2:50 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/26/2013 12:03 PM, Kees Cook wrote:
>> +
>> +static unsigned long get_random_long(void)
>> +{
>> +     if (has_cpuflag(X86_FEATURE_RDRAND)) {
>> +             unsigned long random;
>> +
>> +             debug_putstr("KASLR using RDRAND...\n");
>> +             if (rdrand(&random))
>> +                     return random;
>> +     }
>> +
>> +     if (has_cpuflag(X86_FEATURE_TSC)) {
>> +             uint32_t raw;
>> +             unsigned long timer;
>> +
>> +             debug_putstr("KASLR using RDTSC...\n");
>> +             rdtscl(raw);
>> +
>> +             /* Repeat the low bits of rdtsc. */
>> +             timer = raw & 0xffff;
>> +             timer |= (timer << 16);
>> +#ifdef CONFIG_X86_64
>> +             timer |= (timer << 32) | (timer << 48);
>> +#endif
>> +
>
> This seems like a very odd thing to do.  If you want to scramble bits,
> it would make more sense to do a multiply -- or much better, a
> *circular* multiply -- with a large constant.

Well, my thought here was that the entropy is only being used in a
very narrow band (since it's truncated by alignment on the low end and
physical memory on the high end), so I didn't want to "dilute" the
already bad entropy any more. Instead, I just repeated it. If a
circular multiply would serve the same purpose, I can do that. Do you
have any examples of that?

>
>> +             return timer;
>> +     }
>> +
>> +     debug_putstr("KASLR found no entropy source...\n");
>> +     return 0;
>> +}
>>
>
> It might be safe to assume that anything old enough to lack RDTSC
> (basically a 486) will have an 8254, and reading back the 8254 counter
> register.

Ah, good idea. I've added this now, which seems to work if I force the
TSC check to fail:

#define I8254_PORT_CONTROL      0x43
#define I8254_PORT_COUNTER0     0x40
#define I8254_CMD_READBACK      0xC0
#define I8254_SELECT_COUNTER0   0x02
#define I8254_STATUS_NOTREADY   0x40
static inline u16 i8254(void)
{
        u16 status, timer;

        do {
                outb(I8254_PORT_CONTROL,
                     I8254_CMD_READBACK | I8254_SELECT_COUNTER0);
                status = inb(I8254_PORT_COUNTER0);
                timer  = inb(I8254_PORT_COUNTER0);
                timer |= inb(I8254_PORT_COUNTER0) << 8;
        } while (status & I8254_STATUS_NOTREADY);

        return timer;
}

Thanks,

-Kees

--
Kees Cook
Chrome OS Security
