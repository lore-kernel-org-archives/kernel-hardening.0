From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v15 5/7] doc: self-protection: Add information about STACKLEAK feature
Date: Fri, 17 Aug 2018 01:17:02 +0300
Message-Id: <1534457824-7211-6-git-send-email-alex.popov@linux.com>
In-Reply-To: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
References: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Add information about STACKLEAK feature to the "Memory poisoning"
section of self-protection.rst.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 Documentation/security/self-protection.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/security/self-protection.rst b/Documentation/security/self-protection.rst
index e1ca698..f584fb7 100644
--- a/Documentation/security/self-protection.rst
+++ b/Documentation/security/self-protection.rst
@@ -302,11 +302,11 @@ sure structure holes are cleared.
 Memory poisoning
 ----------------
 
-When releasing memory, it is best to poison the contents (clear stack on
-syscall return, wipe heap memory on a free), to avoid reuse attacks that
-rely on the old contents of memory. This frustrates many uninitialized
-variable attacks, stack content exposures, heap content exposures, and
-use-after-free attacks.
+When releasing memory, it is best to poison the contents, to avoid reuse
+attacks that rely on the old contents of memory. E.g., clear stack on a
+syscall return (``CONFIG_GCC_PLUGIN_STACKLEAK``), wipe heap memory on a
+free. This frustrates many uninitialized variable attacks, stack content
+exposures, heap content exposures, and use-after-free attacks.
 
 Destination tracking
 --------------------
-- 
2.7.4
