Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5655F059.4010801@zytor.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
	<CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
	<5655F059.4010801@zytor.com>
Date: Wed, 25 Nov 2015 10:54:08 -0800
Message-ID: <CAGXu5jJiB8prW=Mf1qVow+2PfpK7YP4K916f6+GGnBhgDq9iCw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathias Krause <minipli@googlemail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 25, 2015 at 9:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/25/15 01:13, Mathias Krause wrote:
>>
>> While having that annotation makes perfect sense, not only from a
>> security perspective but also from a micro-optimization point of view
>> (much like the already existing __read_mostly annotation), it has its
>> drawbacks. Violating the "r/o after init" rule by writing to such
>> annotated variables from non-init code goes unnoticed as far as it
>> concerns the toolchain. Neither the compiler nor the linker will flag
>> that incorrect use. It'll just trap at runtime and that's bad.
>>
>> I myself had some educating experience seeing my machine triple fault
>> when resuming from a S3 sleep. The root cause was a variable that was
>> annotated __read_only but that was (unnecessarily) modified during CPU
>> bring-up phase. Debugging that kind of problems is sort of a PITA, you
>> could imagine.
>>
>> So, prior extending the usage of the __read_only annotation some
>> toolchain support is needed. Maybe a gcc plugin that'll warn/error on
>> code that writes to such a variable but is not __init itself. The
>> initify and checker plugins from the PaX patch might be worth to look
>> at for that purpose, as they're doing similar things already. Adding
>> such a check to sparse might be worth it, too.
>> A modpost check probably won't work as it's unable to tell if it's a
>> legitimate access (r/o) or a violation (/w access). So the gcc plugin
>> is the way to go, IMHO.
>>
>
> We should not wait for compile-time support, that doesn't make any
> sense.  What would be useful would be a way to override this on the
> command line -- that way, if disabling RO or RO-after-init memory makes
> something work, we have an instant diagnosis.

Seems easiest to have an arg just skip calling mark_rodata_ro(). I can add that.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
