Subject: Re: [PATCH 1/1] stackleak: Register the 'stackleak_cleanup' pass
 before the 'mach' pass
From: Alexander Popov <alex.popov@linux.com>
References: <1543583987-27948-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jJ7LmHRJJxtH2HD4XEu5hPLtAe=koJbaCmqF9qoSw=sVw@mail.gmail.com>
 <CAGXu5jKcRLcAg7r-E-9LMjK0YisLJp2TVYoiBwE+4ctYzi5wkg@mail.gmail.com>
 <e1259720-423c-c1ca-1fe5-b9ef89ad19a3@linux.com>
Message-ID: <34da3699-4d25-5d61-4bd1-f4a29ce32743@linux.com>
Date: Thu, 6 Dec 2018 18:10:31 +0300
MIME-Version: 1.0
In-Reply-To: <e1259720-423c-c1ca-1fe5-b9ef89ad19a3@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, Florian Weimer <fweimer@redhat.com>, Richard Sandiford <richard.sandiford@arm.com>, Segher Boessenkool <segher@kernel.crashing.org>, amonakov@ispras.ru, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Emese Revfy <re.emese@gmail.com>, Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, gcc@gcc.gnu.org, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 03.12.2018 21:25, Alexander Popov wrote:
> But I think it's better to register the 'stackleak_cleanup' pass just one pass
> earlier -- before the '*free_cfg' pass. I'll double check it for different
> versions of gcc on all supported architectures and return with a new patch.

I've tested this idea for gcc-5,6,7,8 on x86_64, x86_32, and arm64.
I'll send the patch soon.

Best regards,
Alexander
