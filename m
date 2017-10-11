From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 11 Oct 2017 13:30:21 -0700
Message-Id: <20171011203027.11248-22-thgarnie@google.com>
In-Reply-To: <20171011203027.11248-1-thgarnie@google.com>
References: <20171011203027.11248-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1 21/27] x86/mm/dump_pagetables: Fix address markers index on x86_64
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The address_markers_idx enum is not aligned with the table when EFI is
enabled. Add an EFI_VA_END_NR entry in this case.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/mm/dump_pagetables.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 5e3ac6fe6c9e..8691a57da63e 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -52,12 +52,15 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
-#ifdef CONFIG_KASAN
+# ifdef CONFIG_KASAN
 	KASAN_SHADOW_START_NR,
 	KASAN_SHADOW_END_NR,
-#endif
+# endif
 # ifdef CONFIG_X86_ESPFIX64
 	ESPFIX_START_NR,
+# endif
+# ifdef CONFIG_EFI
+	EFI_VA_END_NR,
 # endif
 	HIGH_KERNEL_NR,
 	MODULES_VADDR_NR,
-- 
2.15.0.rc0.271.g36b669edcc-goog
