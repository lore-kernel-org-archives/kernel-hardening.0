Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Tue, 02 Aug 2016 02:47:59 +0200
Message-ID: <6309751.RADTnUFYN6@vostro.rjw.lan>
In-Reply-To: <6770834.oEI2u9Z85J@vostro.rjw.lan>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <6770834.oEI2u9Z85J@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [PATCH v1 0/2] x86/power/64: Make KASLR memory randomization compatible with hibernation
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Pavel Machek <pavel@ucw.cz>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tuesday, August 02, 2016 01:48:13 AM Rafael J. Wysocki wrote:
> On Monday, August 01, 2016 10:07:58 AM Thomas Garnier wrote:
> > ***Background:
> > KASLR memory randomization for x86_64 was added when KASLR did not support hibernation. Now that it does, some changes are needed.
> > 
> > ***Problems that needed solving:
> > Hibernation was failing on reboot with a GP fault when CONFIG_RANDOMIZE_MEMORY was enabled. Two issues were identified.
> > 
> > The original fault was due to a wrong physical address assigned to cr3. The problem was introduced with __PAGE_OFFSET becoming a global variable when randomized. The fix uses a define to use the glbobal or immediate value based on config settings.
> > 
> > The second isssue was that the temporary page table mapping did not support virtual addresses not aligned on PGD level. KASLR memory randomization will generated a random address aligned on PUD level. The fix correctly calculates the offset on all levels of the temporary page table.
> > 
> > ***Parts:
> >  - 01/02: Support unaligned addresses (second issue)
> >  - 02/02: Fix __PAGE_OFFSET usage on assembly (first issue)
> 
> Thanks a lot for taking care of this!
> 
> Patch [2/2] looks good to me, but I'd to the [1/2] differently (more details
> will follow).

Well, I got this the other way around, sorry.

I've just sent an ACK for the [1/2] and an alternative patch for the [2/2].

Thanks,
Rafael
