Date: Mon, 4 Jun 2018 16:16:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 21/27] x86/ftrace: Adapt function tracing for PIE
 support
Message-ID: <20180604161612.6d48d8d2@gandalf.local.home>
In-Reply-To: <20180529221625.33541-22-thgarnie@google.com>
References: <20180529221625.33541-1-thgarnie@google.com>
	<20180529221625.33541-22-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@google.com>
Cc: kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Francis Deslauriers <francis.deslauriers@efficios.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Guenter Roeck <linux@roeck-us.net>, nixiaoming <nixiaoming@huawei.com>, James Hogan <jhogan@kernel.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 29 May 2018 15:15:22 -0700
Thomas Garnier <thgarnie@google.com> wrote:

> When using -fPIE/PIC with function tracing, the compiler generates a
> call through the GOT (call *__fentry__@GOTPCREL). This instruction
> takes 6 bytes instead of 5 on the usual relative call.
> 
> If PIE is enabled, replace the 6th byte of the GOT call by a 1-byte nop
> so ftrace can handle the previous 5-bytes as before.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range 0xffffffff80000000.

I thought you were going to write a update to recordmcount.c to handle
this at compile time?

-- Steve

> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>
