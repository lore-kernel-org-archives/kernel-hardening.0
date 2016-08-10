Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2016 09:50:15 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <2010434.TyoHiO9eal@vostro.rjw.lan>
Message-ID: <alpine.LNX.2.00.1608100948560.22028@cbobk.fhfr.pm>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <alpine.LNX.2.00.1608092119260.22028@cbobk.fhfr.pm> <CAJZ5v0hWRH0zVjNDH6cjNn8kSSXSW0qc-aQZ8p_5EVS3cajcQA@mail.gmail.com> <2010434.TyoHiO9eal@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Garnier <thgarnie@google.com>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 10 Aug 2016, Rafael J. Wysocki wrote:

> For the lack of better ideas, below is a patch to try.
> 
> It avoids the possible issue with the restore kernel's identity mapping overlap
> with restore_jump_address by creating special super-simple page tables just
> for the final jump to the image kernel.
> 
> It is on top of the $subject patch.  My test box still works with this applied,
> but then it worked without it as well.
> 
> If it doesn't help, the identity mapping created by set_up_temporary_mappings()
> is still not adequate for some reason most likely and we'll need to find out
> why.

Unfortunately, still with $subject patch + this one, triple fault and 
reboot after reading the hibernation image.

Due to being slightly out of ideas currently, I'll play a little bit more 
with the relocation offsets to see whether that makes any difference.

-- 
Jiri Kosina
SUSE Labs
