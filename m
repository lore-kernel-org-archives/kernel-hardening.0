Date: Tue, 26 Jun 2018 11:21:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 21/27] x86/ftrace: Adapt function tracing for PIE
 support
Message-ID: <20180626112110.647ff8db@gandalf.local.home>
In-Reply-To: <20180625224014.134829-22-thgarnie@google.com>
References: <20180625224014.134829-1-thgarnie@google.com>
	<20180625224014.134829-22-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@google.com>
Cc: kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, James Hogan <jhogan@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, nixiaoming <nixiaoming@huawei.com>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 25 Jun 2018 15:39:09 -0700
Thomas Garnier <thgarnie@google.com> wrote:

> When using PIE with function tracing, the compiler generates a
> call through the GOT (call *__fentry__@GOTPCREL). This instruction
> takes 6-bytes instead of 5-bytes with a relative call.
> 
> If PIE is enabled, replace the 6th byte of the GOT call by a 1-byte nop
> so ftrace can handle the previous 5-bytes as before.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Thanks for doing it this way.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
