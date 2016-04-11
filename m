Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <570B59A5.3090904@arm.com>
References: <20160406194404.GA11150@www.outflux.net>
	<570B59A5.3090904@arm.com>
Date: Mon, 11 Apr 2016 11:03:01 -0700
Message-ID: <CAGXu5jKU=+ZokCcMHwGT0GxHZ5G4RaLhdFrADxw2BxEHyfNF7g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: James Morse <james.morse@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 11, 2016 at 1:00 AM, James Morse <james.morse@arm.com> wrote:
> Hi Kees,
>
> On 06/04/16 20:44, Kees Cook wrote:
>> When building with both CONFIG_HIBERNATION and CONFIG_RANDOMIZE_BASE,
>> one or the other must be chosen at boot-time. Until now, hibernation
>> was selected when no choice was made on the command line.
>>
>> To make the security benefits of kASLR more widely available to end
>> users (since the use of hibernation is becoming more rare and kASLR,
>> already available on x86, will be available on arm64 and MIPS soon),
>> this changes the default to preferring kASLR over hibernation. Users
>> wanting hibernation can turn off kASLR by adding "nokaslr" to the kernel
>> command line.
>
> While hibernate isn't yet merged for arm64, it does work with kASLR in v4.6-rc*,
> it would be a shame to have to choose at boot time, (but that's my problem to
> fix if/when its merged).

Ah, interesting, so they work together on arm64? (i.e. you've actually
tested a boot loader that provides the seed for kASLR to operate?)

>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>> index fca9254280ee..be5041354b1e 100644
>> --- a/kernel/power/hibernate.c
>> +++ b/kernel/power/hibernate.c
>> @@ -1159,6 +1164,13 @@ static int __init kaslr_nohibernate_setup(char *str)
>>       return nohibernate_setup(str);
>>  }
>>
>> +static int __init nokaslr_hibernate_setup(char *str)
>> +{
>> +     noresume = 0;
>> +     nohibernate = 0;
>> +     return 1;
>> +}
>> +
>>  static int __init page_poison_nohibernate_setup(char *str)
>>  {
>>  #ifdef CONFIG_PAGE_POISONING_ZERO
>> @@ -1183,4 +1195,5 @@ __setup("resumewait", resumewait_setup);
>>  __setup("resumedelay=", resumedelay_setup);
>>  __setup("nohibernate", nohibernate_setup);
>>  __setup("kaslr", kaslr_nohibernate_setup);
>> +__setup("nokaslr", nokaslr_hibernate_setup);
>
> So one or the other option has to be specified at boot?

No, this patch was just flipping the default from hibernate to kASLR
if "kaslr" wasn't on the command line.

> The kASLR patches for arm64 in v4.6-rc1 enable kASLR at boot if you chose to
> select it at compile time. I guess this patch is preparation for doing the same
> on x86?

That was the goal, yes. A better approach would be to have hibernate
on x86 work with kASLR, but I likely won't have time to learn the
details on hibernation and debug it for a while.

> I didn't hit this kaslr_nohibernate_setup() call during testing because of the
> on by default behaviour. Is it worth exposing this via Kconfig? Something like:
> ARCH_RANDOMIZE_BASE_DEFAULT_ON ?

Maybe RANDOMIZE_BASE_DEFAULT (default to y) and if x86 && hibernation,
select =n. and use that for selecting it?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
