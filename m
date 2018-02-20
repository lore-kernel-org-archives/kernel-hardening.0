Subject: Re: [PATCH RFC v8 0/6] Introduce the STACKLEAK feature and a test for
 it
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <791341f5-4347-ba38-0710-93551a45ec38@linux.com>
Date: Tue, 20 Feb 2018 13:29:02 +0300
MIME-Version: 1.0
In-Reply-To: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org, Mohamed Ghannam <simo.ghannam@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 16.02.2018 21:10, Alexander Popov wrote:
> This is the 8th version of the patch series introducing STACKLEAK to the
> mainline kernel. I've made some minor improvements while waiting for the
> next review by x86 maintainers.
> 
> STACKLEAK is a security feature developed by Grsecurity/PaX (kudos to them),
> which:
>  - reduces the information that can be revealed through kernel stack leak bugs;
>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>  - introduces some runtime checks for kernel stack overflow detection.

Hello! I've just tested STACKLEAK against the recent CVE-2017-17712 exploit:
http://openwall.com/lists/oss-security/2018/02/20/1

This vulnerability is a race condition in raw_sendmsg() in net/ipv4/raw.c. It
leads to uninitialized stack pointer usage which can be used for a local
privilege escalation.

CVE-2017-17712 was discovered and fixed by Mohamed Ghannam (kudos to him!). He
also provided a stable PoC exploit for it.

With STACKLEAK, the uninitialized stack pointer is set to STACKLEAK_POISON
(-0xBEEF) and points to the unused hole in the virtual memory map. That blocks
the stack spraying needed for CVE-2017-17712 exploit (similar to CVE-2010-2963).

Best regards,
Alexander
