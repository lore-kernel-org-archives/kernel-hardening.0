Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAMuHMdWVGaetgcc4yxNjodkUNPaDxq2Q2JMLr_AUkb0f65YB5w@mail.gmail.com>
References: <20160406194404.GA11150@www.outflux.net>
	<570B59A5.3090904@arm.com>
	<CAGXu5jKU=+ZokCcMHwGT0GxHZ5G4RaLhdFrADxw2BxEHyfNF7g@mail.gmail.com>
	<CAMuHMdWVGaetgcc4yxNjodkUNPaDxq2Q2JMLr_AUkb0f65YB5w@mail.gmail.com>
Date: Mon, 11 Apr 2016 11:47:14 -0700
Message-ID: <CAGXu5jLYA2tOEEk0ov6nU8d3k2pFZ8cY2jiB_pZthhzkagcz=A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Morse <james.morse@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 11, 2016 at 11:21 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Apr 11, 2016 at 8:03 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Apr 11, 2016 at 1:00 AM, James Morse <james.morse@arm.com> wrote:
>>> On 06/04/16 20:44, Kees Cook wrote:
>>>> When building with both CONFIG_HIBERNATION and CONFIG_RANDOMIZE_BASE,
>>>> one or the other must be chosen at boot-time. Until now, hibernation
>>>> was selected when no choice was made on the command line.
>>>>
>>>> To make the security benefits of kASLR more widely available to end
>>>> users (since the use of hibernation is becoming more rare and kASLR,
>>>> already available on x86, will be available on arm64 and MIPS soon),
>>>> this changes the default to preferring kASLR over hibernation. Users
>>>> wanting hibernation can turn off kASLR by adding "nokaslr" to the kernel
>>>> command line.
>>>
>>> While hibernate isn't yet merged for arm64, it does work with kASLR in v4.6-rc*,
>>> it would be a shame to have to choose at boot time, (but that's my problem to
>>> fix if/when its merged).
>>
>> Ah, interesting, so they work together on arm64? (i.e. you've actually
>> tested a boot loader that provides the seed for kASLR to operate?)
>
> Probably the PS3 people can provide us with a good tool to generate a
> seed that makes hibernation work all the time ;-)
>
> https://xkcd.com/221/

:)

http://assets.amuniversal.com/321a39e06d6401301d80001dd8b71c47

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
