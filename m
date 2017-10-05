Date: Thu, 5 Oct 2017 09:06:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171005090633.5a6ce840@gandalf.local.home>
In-Reply-To: <20171004212003.28296-21-thgarnie@google.com>
References: <20171004212003.28296-1-thgarnie@google.com>
	<20171004212003.28296-21-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC v3 20/27] x86/ftrace: Adapt function tracing for PIE
 support
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R .
 Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael
 J . Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, Rob Landley <rob@landley.net>, "H . J . Lu" <hjl.tools@gmail.com>, Baoquan He <bhe@redhat.com>, "Jan H .
 =?UTF-8?B?U2Now7ZuaGVycg==?=" <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed,  4 Oct 2017 14:19:56 -0700
Thomas Garnier <thgarnie@google.com> wrote:

> When using -fPIE/PIC with function tracing, the compiler generates a
> call through the GOT (call *__fentry__@GOTPCREL). This instruction
> takes 6 bytes instead of 5 on the usual relative call.
> 
> With this change, function tracing supports 6 bytes on traceable
> function and can still replace relative calls on the ftrace assembly
> functions.
> 
> Position Independent Executable (PIE) support will allow to extended the
> KASLR randomization range below the -2G memory limit.

Question: This 6 bytes is only the initial call that gcc creates. When
function tracing is enabled, the calls are back to the normal call to
the ftrace trampoline?

-- Steve
