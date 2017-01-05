Reply-To: kernel-hardening@lists.openwall.com
References: <20170104221630.831-1-thgarnie@google.com>
 <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
 <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
From: Arjan van de Ven <arjan@linux.intel.com>
Message-ID: <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com>
Date: Thu, 5 Jan 2017 10:58:00 -0800
MIME-Version: 1.0
In-Reply-To: <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 1/5/2017 9:54 AM, Thomas Garnier wrote:

>
> That's my goal too. I started by doing a RO remap and got couple
> problems with hibernation. I can try again for the next iteration or
> delay it for another patch. I also need to look at KVM GDT usage, I am
> not familiar with it yet.

don't we write to the GDT as part of the TLS segment stuff for glibc ?
