Subject: Re: [PATCH RFC v8 0/6] Introduce the STACKLEAK feature and a test for
 it
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
 <791341f5-4347-ba38-0710-93551a45ec38@linux.com>
 <CAGXu5jJ+dWjtjJ88ziOoyTJnSxbjdvEJd5LGY9nxWxHpVR6pug@mail.gmail.com>
 <20180221100545.GB16426@pd.tnic>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <6d76b04a-d3d4-cb73-18bc-1840766ee82a@linux.com>
Date: Wed, 21 Feb 2018 18:09:12 +0300
MIME-Version: 1.0
In-Reply-To: <20180221100545.GB16426@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>, Mohamed Ghannam <simo.ghannam@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 21.02.2018 13:05, Borislav Petkov wrote:
> On Tue, Feb 20, 2018 at 03:17:21PM -0800, Kees Cook wrote:
>> On Tue, Feb 20, 2018 at 2:29 AM, Alexander Popov <alex.popov@linux.com> wrote:
>>> On 16.02.2018 21:10, Alexander Popov wrote:
>>>> This is the 8th version of the patch series introducing STACKLEAK to the
>>>> mainline kernel. I've made some minor improvements while waiting for the
>>>> next review by x86 maintainers.
>>
>> If we can borrow some of luto or tglx's time, I think that'd be best:
> 
> Btw, someone just noticed: why hasn't this patchset ever been sent to
> lkml for a wider review?

Thanks for that notice.

I just realized that I'm resending this patch series to people who I chose
approximately 8 month ago, when I started to work on STACKLEAK.

I'll use scripts/get_maintainer.pl for the next version.

Best regards,
Alexander
