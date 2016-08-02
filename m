Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <2005875.PA9bTzjxie@vostro.rjw.lan>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
 <1470071280-78706-2-git-send-email-thgarnie@google.com> <2005875.PA9bTzjxie@vostro.rjw.lan>
From: Yinghai Lu <yinghai@kernel.org>
Date: Tue, 2 Aug 2016 11:01:50 -0700
Message-ID: <CAE9FiQU2+Omiy9SUWDOvaE3gjVvJjMcVk_h4E8bHeg-vym-2KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/2] x86/power/64: Support unaligned addresses for
 temporary mapping
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 1, 2016 at 5:36 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, August 01, 2016 10:07:59 AM Thomas Garnier wrote:
>> Correctly setup the temporary mapping for hibernation. Previous
>> implementation assumed the address was aligned on the PGD level. With
>> KASLR memory randomization enabled, the address is randomized on the PUD
>> level. This change supports unaligned address up to PMD.
>
> This code is shared with kexec AFAICS, so it likely is better to push it
> through tip rather than through the PM tree.

Only calling path via arch/x86/power/hibernate_64.c have
   kernel_mapping = true;
other two paths: arch/x86/boot/compressed/pagetable.c and
arch/x86/kernel/machine_kexec_64.c
all have kernel_mapping as false.

maybe that path need simplified kernel_physical_mapping_init() instead?

Thanks

Yinghai
