References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jKmOn7E04Y8pR9Tgn7usJYMhqWe9x929ZwEnu21MG=mZw@mail.gmail.com>
 <0c1950e9-626d-c7b8-5551-fcc233501025@linux.com>
 <fb67be6f-3691-0aef-fbc6-4e1093ddb8da@linux.com>
 <CAGXu5j+OSzYx61-NN8XcBAVvMpCrPc2TFN66esK+-gFQtp_5pg@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <9e6d74cf-ac51-463e-feae-b2df0e5fb85e@linux.com>
Date: Sat, 20 Jan 2018 13:13:26 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+OSzYx61-NN8XcBAVvMpCrPc2TFN66esK+-gFQtp_5pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v7 0/6] Introduce the STACKLEAK feature and a test for
 it
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 19.01.2018 00:13, Kees Cook wrote:
> On Thu, Jan 18, 2018 at 5:09 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> So I don't think that (1) without (2) is actually a good feature. I would
>> propose to refrain from separating the stack erasing and the lowest_stack tracking.
> 
> How about an option to clear the _entire_ stack, then, when the plugin
> isn't available? That gives us a range of options and provides an easy
> way to compare the performance of the tracking. i.e. can compare off,
> full, and smart.

Yes, I should try it. I'll return with the results of the performance tests.
We'll discuss them; if full stack erasing is not too slow, I'll introduce it in
the 8'th version of the patch series.

Thanks!

Best regards,
Alexander
