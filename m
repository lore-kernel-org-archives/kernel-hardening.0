Date: Wed, 28 Nov 2018 16:34:37 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] x86/fpu: XRSTOR is expected to raise #GP
Message-ID: <20181128153436.rftr3kfocxn2kcwo@linutronix.de>
References: <20181126172706.184008-1-jannh@google.com>
 <20181126174945.r2ubrlg2gzwog2ez@linutronix.de>
 <4d4c4f1f-72e3-0182-151e-8bd455ccd143@zytor.com>
 <52276fe27116406eb601a99704459f80@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52276fe27116406eb601a99704459f80@AcuMS.aculab.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'H. Peter Anvin'" <hpa@zytor.com>, Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-11-28 15:27:28 [+0000], David Laight wrote:
> Better still note it in the code.

I'm in favour of adding something to tools/testing/selftests/x86/.

> 	David

Sebastian
