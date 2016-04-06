Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <20160406215638.GA25539@gmail.com>
References: <20160406194404.GA11150@www.outflux.net>
	<CAJZ5v0ieAd3WSiytzcdtD=eueLPk_SM1KgrqZXHBa6+bwK=KnQ@mail.gmail.com>
	<20160406215638.GA25539@gmail.com>
Date: Thu, 7 Apr 2016 00:04:59 +0200
Message-ID: <CAJZ5v0ir8PwyC2b1R0DaE+O5dH0cZUtrzTHxM4OAPxMY9hmNXA@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: Ingo Molnar <mingo@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 11:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Rafael J. Wysocki <rafael@kernel.org> wrote:
>
>> On Wed, Apr 6, 2016 at 9:44 PM, Kees Cook <keescook@chromium.org> wrote:
>> > When building with both CONFIG_HIBERNATION and CONFIG_RANDOMIZE_BASE,
>> > one or the other must be chosen at boot-time. Until now, hibernation
>> > was selected when no choice was made on the command line.
>> >
>> > To make the security benefits of kASLR more widely available to end
>> > users (since the use of hibernation is becoming more rare and kASLR,
>> > already available on x86, will be available on arm64 and MIPS soon),
>> > this changes the default to preferring kASLR over hibernation. Users
>> > wanting hibernation can turn off kASLR by adding "nokaslr" to the kernel
>> > command line.
>> >
>> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> Or do you want me to apply it?
>
> I don't think this is a good idea, as it turns off emergency hibernation of
> laptops - many desktop distros support it by default.

Right, I forgot about this one.

Thanks,
Rafael
