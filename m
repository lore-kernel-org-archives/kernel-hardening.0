Subject: Re: [PATCH v3 16/27] compiler: Option to add PROVIDE_HIDDEN
 replacement for weak symbols
References: <20180523195421.180248-1-thgarnie@google.com>
 <20180523195421.180248-17-thgarnie@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <92748474-8044-4b55-7529-c982342855ab@infradead.org>
Date: Wed, 23 May 2018 14:16:11 -0700
MIME-Version: 1.0
In-Reply-To: <20180523195421.180248-17-thgarnie@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@siemens.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw@amazon.co.uk>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Jan Beulich <JBeulich@suse.com>, Matthias Kaehlcke <mka@chromium.org>, Baoquan He <bhe@redhat.com>, "=?UTF-8?Q?Jan_H_._Sch=c3=b6nherr?=" <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 05/23/2018 12:54 PM, Thomas Garnier wrote:
> Provide an option to have a PROVIDE_HIDDEN (linker script) entry for
> each weak symbol. This option solve an error in x86_64 where the linker

                                solves

> optimizes pie generate code to be non-pie because --emit-relocs was used

                generated

> instead of -pie (to reduce dynamic relocations).
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  init/Kconfig            |  7 +++++++
>  scripts/link-vmlinux.sh | 14 ++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 0fc3a58d9f2f..2866cca86b4a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1954,6 +1954,13 @@ config ASN1
>  	  inform it as to what tags are to be expected in a stream and what
>  	  functions to call on what tags.
>  
> +config WEAK_PROVIDE_HIDDEN
> +	bool
> +	help
> +	  Generate linker script PROVIDE_HIDDEN entries for all weak symbols. It
> +	  allows to prevent non-pie code being replaced by the linker if the

	                    non-PIE

> +	  emit-relocs option is used instead of pie (useful for x86_64 pie).

	                                        PIE                    PIE).

> +


-- 
~Randy
