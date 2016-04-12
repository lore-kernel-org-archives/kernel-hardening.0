Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <570D358A.2080109@arm.com>
Date: Tue, 12 Apr 2016 18:51:06 +0100
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <20160406194404.GA11150@www.outflux.net>	<570B59A5.3090904@arm.com> <CAGXu5jKU=+ZokCcMHwGT0GxHZ5G4RaLhdFrADxw2BxEHyfNF7g@mail.gmail.com>
In-Reply-To: <CAGXu5jKU=+ZokCcMHwGT0GxHZ5G4RaLhdFrADxw2BxEHyfNF7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/04/16 19:03, Kees Cook wrote:
> On Mon, Apr 11, 2016 at 1:00 AM, James Morse <james.morse@arm.com> wrote:
>> On 06/04/16 20:44, Kees Cook wrote:
>>> When building with both CONFIG_HIBERNATION and CONFIG_RANDOMIZE_BASE,
>>> one or the other must be chosen at boot-time. Until now, hibernation
>>> was selected when no choice was made on the command line.
>>>
>>> To make the security benefits of kASLR more widely available to end
>>> users (since the use of hibernation is becoming more rare and kASLR,
>>> already available on x86, will be available on arm64 and MIPS soon),
>>> this changes the default to preferring kASLR over hibernation. Users
>>> wanting hibernation can turn off kASLR by adding "nokaslr" to the kernel
>>> command line.
>>
>> While hibernate isn't yet merged for arm64, it does work with kASLR in v4.6-rc*,
>> it would be a shame to have to choose at boot time, (but that's my problem to
>> fix if/when its merged).
> 
> Ah, interesting, so they work together on arm64? (i.e. you've actually
> tested a boot loader that provides the seed for kASLR to operate?)

Almost: due to a lack of firmware support I hacked the efi stub to read a 'seed'
from a system counter.

To check it works I printed the address of 'panic' out during boot:
> [    0.353712] DEBUG: &panic == ffffff960819a4e8

Then hibernated, and powered the board back on, the resume kernel gives:
> [    0.353528] DEBUG: &panic == ffffff840819a4e8

But after it has restored the hibernate image, I can dig in /proc/kallsyms to
see the original value:
> root@localhost:~# cat /proc/kallsyms  | grep "T panic"
> ffffff960819a4e8 T panic


> Maybe RANDOMIZE_BASE_DEFAULT (default to y) and if x86 && hibernation,
> select =n. and use that for selecting it?

Looks good to me.


Thanks,

James
