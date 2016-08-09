Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <20160809070232.GA3767@nazgul.tnic>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <20160808134001.GC29757@nazgul.tnic>
 <CAJZ5v0hE7ND5y-q+o-M9ck05VFDKWkBYJ-=3C2ZRn_aw5o4y+Q@mail.gmail.com> <20160809070232.GA3767@nazgul.tnic>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 9 Aug 2016 13:47:34 +0200
Message-ID: <CAJZ5v0iBMt6=39Rdm3gN606bB+6Ctv7a_XPaKScMcnFuhucRwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: Borislav Petkov <bp@suse.de>, Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 9, 2016 at 9:02 AM, Borislav Petkov <bp@suse.de> wrote:
> On Mon, Aug 08, 2016 at 03:54:48PM +0200, Rafael J. Wysocki wrote:
>> That should be the only one on top of plain 4.8-rc1.
>>
>> If it doesn't help, we need more work to do. :-)
>
> Yes, we do.
>
> The machine triple-faults *after* reading up the hibernation image.
> It hits 100%, then tries to switch to the boot kernel and BOOM, BIOS
> screen.
>
> I'm attaching the .config in case you want to reproduce it. The machine
> is an IVB thinkpad x230.

Yes, I'm going to try to reproduce it.

I'm wondering what the difference between your .config and the Thomas'
.config is, as he has CONFIG_RANDOMIZE_MEMORY=y set too.

Thomas, can you attach your .config, please?

Thanks,
Rafael
