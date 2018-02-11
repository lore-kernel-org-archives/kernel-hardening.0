Subject: Re: [PATCH RFC v7 0/6] Introduce the STACKLEAK feature and a test for
 it
References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jKmOn7E04Y8pR9Tgn7usJYMhqWe9x929ZwEnu21MG=mZw@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <c3cfdd5a-e69d-3e18-487e-4d1ea5b8f700@linux.com>
Date: Mon, 12 Feb 2018 00:34:55 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKmOn7E04Y8pR9Tgn7usJYMhqWe9x929ZwEnu21MG=mZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

On 15.01.2018 22:59, Kees Cook wrote:
> On Fri, Jan 12, 2018 at 6:19 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> This is the 7th version of the patch series introducing STACKLEAK to the
>> mainline kernel. STACKLEAK is a security feature developed by Grsecurity/PaX
>> (kudos to them), which:
>>  - reduces the information that can be revealed through kernel stack leak bugs;
>>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>  - introduces some runtime checks for kernel stack overflow detection.
> 
> I think this is really looking good.

Hello! May I ask whether dear x86 maintainers think so too?

Best regards,
Alexander
