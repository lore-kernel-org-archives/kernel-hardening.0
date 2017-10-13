References: <1507157703-14972-1-git-send-email-alex.popov@linux.com>
 <1507157703-14972-2-git-send-email-alex.popov@linux.com>
 <20171005072751.lhf7kamzfw4sdhbo@gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <ac934200-74e0-3e0d-fd14-dff64197c03a@linux.com>
Date: Fri, 13 Oct 2017 20:03:59 +0300
MIME-Version: 1.0
In-Reply-To: <20171005072751.lhf7kamzfw4sdhbo@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v4 1/3] gcc-plugins: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
To: Ingo Molnar <mingo@kernel.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirski <luto@amacapital.net>, x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Ingo,

On 05.10.2017 10:27, Ingo Molnar wrote:
> - The GCC plugin adds instrumentation in form of extra 'track_stack()' and
>   'check_alloca()' calls. Could you please provide a frequency analysis of the
>   impact of this: x86-64 defconfig vmlinux size before/after the patch, and the
>   number of instrumentation function calls inserted, compared to the number of
>   functions?

Size of vmlinux (x86_64_defconfig):
 file size:
  - STACKLEAK disabled: 35014784 bytes
  - STACKLEAK enabled: 35044952 bytes (+0.086%)
 .text section size (calculated by size utility):
  - STACKLEAK disabled: 10752983
  - STACKLEAK enabled: 11062221 (+2.876%)

The readelf utility shows 45602 functions in vmlinux.

The STACKLEAK gcc plugin inserted 36 check_alloca() calls and 1265 track_stack()
calls (42274 calls are inserted during GIMPLE pass and 41009 calls are deleted
during RTL pass). So 2.853% of functions are instrumented.

I will add this information to the cover letter of the 5'th version, which I'm
currently preparing.

Best regards,
Alexander
