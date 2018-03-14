Date: Wed, 14 Mar 2018 11:35:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 21/27] x86/ftrace: Adapt function tracing for PIE
 support
Message-ID: <20180314103537.GR4043@hirez.programming.kicks-ass.net>
References: <20180313205945.245105-1-thgarnie@google.com>
 <20180313205945.245105-22-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313205945.245105-22-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Philippe Ombredanne <pombredanne@nexb.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Ashish Kalra <ashish@bluestacks.com>, Kyle McMartin <kyle@redhat.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Lukas Wunner <lukas@wunner.de>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Jiri Slaby <jslaby@suse.cz>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Jan H =?iso-8859-1?Q?=2E_Sch=F6nherr?= <jschoenh@amazon.de>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 13, 2018 at 01:59:39PM -0700, Thomas Garnier wrote:
> +	/*
> +	 * If PIE is not enabled or no GOT call was found, default to the
> +	 * original approach to code modification.
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_PIE)
> +	    || probe_kernel_read(replaced, (void *)ip, sizeof(replaced))
> +	    || memcmp(replaced, got_call_preinsn, sizeof(got_call_preinsn)))
> +		return ftrace_modify_code_direct(ip, old_code, new_code);

The predominant kernel style is to place the operators at the end of the
previous line, not first on the new line.
